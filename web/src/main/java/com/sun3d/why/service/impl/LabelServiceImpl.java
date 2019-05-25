package com.sun3d.why.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.culturecloud.utils.UUIDUtils;
import com.sun3d.why.dao.YketLabelMapper;
import com.sun3d.why.enumeration.LabelTypeEnum;
import com.sun3d.why.model.bean.yket.SysUser;
import com.sun3d.why.model.bean.yket.YketLabel;
import com.sun3d.why.model.vo.yket.YketLabelVo;
import com.sun3d.why.service.LabelService;
import com.sun3d.why.util.Pagination;

@Service
public class LabelServiceImpl implements LabelService {
	@Autowired
	private YketLabelMapper yketLabel;

	@Override
	public int addLabel(YketLabel label, SysUser sysUser) {
		label.setLabelId(UUIDUtils.createUUId());
		label.setCreateDate(new Date());
		label.setCreateUser(sysUser.getUserId());
		label.setUpdateDate(new Date());
		label.setUpdateUser(sysUser.getUserId());
		return yketLabel.insert(label);
	}

	@Override
	public List<YketLabelVo> listLabel(String labelType, Pagination pagination, String labelName) {
		 LabelTypeEnum labelEnum = null;
		try {
			labelEnum = LabelTypeEnum.valueOf(labelType);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("labelType", labelEnum.getIndex());
		if(!StringUtils.isEmpty(labelName)){
			map.put("labelName", labelName);
		}
		// 分页
		if (pagination != null && pagination.getFirstResult() != null && pagination.getRows() != null) {
			map.put("firstResult", pagination.getFirstResult());
			map.put("rows", pagination.getRows());
			pagination.setTotal(this.yketLabel.count(map));
		}
		return yketLabel.listLable(map);
	}

	@Override
	public int updateLabel(YketLabel label, SysUser sysUser) {
		label.setUpdateDate(new Date());
		label.setDeleted(true);
		label.setUpdateUser(sysUser.getUserId());
		return this.yketLabel.updateByPrimaryKey(label);
	}

	@Override
	public int deleteLabel(String labelId, SysUser sysUser) {
		return this.yketLabel.deleteByPrimaryKey(labelId);
	}

	@Override
	public YketLabel getLabelById(String labelId) {
		return yketLabel.selectByPrimaryKey(labelId);
	}

	@Override
	public int saveLabel(String labelType, String labelName, SysUser sysUser) {
		YketLabel label = new YketLabel();
        LabelTypeEnum labelEnum = null;
		labelEnum = LabelTypeEnum.valueOf(labelType);
		label.setLabelId(UUIDUtils.createUUId());
		label.setLabelName(labelName);
		label.setDeleted(false);
		label.setCourseNumber(0);
		label.setSort(0);
		label.setLabelType(labelEnum.getIndex());
		label.setCreateDate(new Date());
		label.setCreateUser(sysUser.getUserId());
		label.setUpdateDate(new Date());
		label.setUpdateUser(sysUser.getUserId());
		return yketLabel.insert(label);
	}

	@Override
	public int queryByLabelName(String labelName , Integer labelType) {
		Map<String, Object> map = new HashMap<String, Object>();
		if(!StringUtils.isEmpty(labelName)){
			map.put("labelName", labelName);
		}
		if(labelType!=null){
			map.put("labelType", labelType);
		}
		return this.yketLabel.queryByLabelName(map);
	}

	@Override
	public int update(String labelId, String labelName, SysUser sysUser) {
		int rs = 0;
		if(!StringUtils.isEmpty(labelId)){
			YketLabel label = this.yketLabel.selectByPrimaryKey(labelId);
			label.setLabelId(labelId);
			label.setUpdateDate(new Date());
			label.setLabelName(labelName);
			label.setUpdateUser(sysUser.getUserId());
			rs = this.yketLabel.updateByPrimaryKeySelective(label);
		}
		return rs;
	}

	@Override
	public String moveUp(String labelId, Integer sort) {
		Map<String ,Object> map = new HashMap<String, Object>();
	 	if (sort != null) {
			map.put("sort", sort);
		}
		List<YketLabel> list = this.yketLabel.moveUp(map);
		if(list==null || list.size()==0){
			return null;
		}
        if(list.size()<2){
        	return null;
		}
        if(list.size()==1){
        	return "error";
        }
        try{
        	YketLabel top= list.get(0);
        	YketLabel second= list.get(1);
			top.setSort(sort-1);
			second.setSort(sort+1);
			this.yketLabel.updateByPrimaryKey(second);
			this.yketLabel.updateByPrimaryKey(top);
			return "ok";
		}catch(Exception e){
			throw new RuntimeException();
		}
	}

	@Override
	public String moveDown(String labelId, Integer sort) {
		Map<String ,Object> map = new HashMap<String, Object>();
		if (sort != null) {
			map.put("sort", sort);
		}
		List<YketLabel> list = this.yketLabel.moveDown(map);
		if(list==null || list.size()==0){
			return null;
		}
        if(list.size()<2){
        	return null;
		}
        if(list.size()==1){
        	return "error";
        }
        try{
        	YketLabel top= list.get(0);
        	YketLabel second= list.get(1);
			top.setSort(sort+1);
			second.setSort(sort-1);
			this.yketLabel.updateByPrimaryKey(second);
			this.yketLabel.updateByPrimaryKey(top);
			return "ok";
		}catch(Exception e){
			throw new RuntimeException();
		}
	}
	
	
	@Override
	public List<YketLabel> listLabelJson(String labelType, Pagination pagination) {
		LabelTypeEnum labelEnum = null;
		try {
			labelEnum = LabelTypeEnum.valueOf(labelType);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("labelType", labelEnum.getIndex());
		// 分页
		if (pagination != null && pagination.getFirstResult() != null && pagination.getRows() != null) {
			map.put("firstResult", pagination.getFirstResult());
			map.put("rows", pagination.getRows());
 		}
		return this.yketLabel.listLableForJson(map);
	}

	@Override
	public List<YketLabel> typeList(Integer labelType) {
		return this.yketLabel.typeList(labelType);
	}
	
 
 
	
	

}
