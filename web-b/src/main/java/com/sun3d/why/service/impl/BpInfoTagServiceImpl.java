package com.sun3d.why.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sun3d.why.dao.BpInfoTagMapper;
import com.sun3d.why.model.BpInfo;
import com.sun3d.why.model.BpInfoTag;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.BpInfoTagService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;

@Service
public class BpInfoTagServiceImpl implements BpInfoTagService {

	@Autowired
	private BpInfoTagMapper bpInfoTagMapper;

	@Override
	public List<BpInfoTag> queryTagList(Pagination page, BpInfoTag bpInfoTag) {
		// 定义一个map，存放分页数据作为分页参数
		Map<String, Object> pageMap = new HashMap<>();
		if (StringUtils.isNotBlank(bpInfoTag.getModule())) {
			pageMap.put("module", bpInfoTag.getModule());
		}
		if (page != null && page.getFirstResult() != null && page.getRows() != null) {
			// 查询出总数
			int total = bpInfoTagMapper.queryTotal(pageMap);
			// 当前页码
			pageMap.put("firstResult", page.getFirstResult());
			// 每页条数
			pageMap.put("rows", page.getRows());
			page.setTotal(total);
		}
		// 搜索条件——名称
		pageMap.put("tagName", bpInfoTag.getTagName());
		// 根据分页条件查找出当前页数据
		List<BpInfoTag> list = bpInfoTagMapper.queryListByMap(pageMap);
		return list;
	}

	@Override
	public void delInfo(String tagId, SysUser loginUser) {
		BpInfoTag bpInfoTag = new BpInfoTag();
		if (tagId != null && tagId != "") {
			// 删除父标签
			bpInfoTag.setTagId(tagId);
			bpInfoTag.setTagUpdateUser(loginUser.getUserId());
			bpInfoTag.setTagUpdateTime(new Date());
			// "2"表示已删除
			bpInfoTag.setTagState(2);
			bpInfoTagMapper.updateByPrimaryKeySelective(bpInfoTag);
			// 删除子标签
			List<BpInfoTag> childList = bpInfoTagMapper.queryChildTagByParentId(tagId);
			for (BpInfoTag childTag : childList) {
				childTag.setTagUpdateUser(loginUser.getUserId());
				childTag.setTagUpdateTime(new Date());
				// "2"表示已删除
				childTag.setTagState(2);
				bpInfoTagMapper.updateByPrimaryKeySelective(childTag);
			}
		}

	}

	@Override
	public BpInfoTag selectTagById(String tagId) {
		BpInfoTag bpInfoTag = null;
		if (tagId != "" && tagId != "") {
			bpInfoTag = bpInfoTagMapper.selectByPrimaryKey(tagId);
		}
		return bpInfoTag;
	}

	@Override
	public String addAndEditTag(BpInfoTag bpInfoTag, SysUser sysUser) {
		int count = 0;
		bpInfoTag.setTagUpdateUser(sysUser.getUserId());
		bpInfoTag.setTagUpdateTime(new Date());
		// 数据库区分""和null，所以要设置null
		if (bpInfoTag.getTagParentId() == "") {
			bpInfoTag.setTagParentId(null);
		}
		if (StringUtils.isBlank(bpInfoTag.getTagId())) {
			bpInfoTag.setTagId(UUIDUtils.createUUId());
			bpInfoTag.setTagCreateTime(new Date());
			bpInfoTag.setTagCreateUser(sysUser.getUserId());
			bpInfoTag.setTagState(1);
			if (bpInfoTag.getTagParentId() == null) {
				bpInfoTag.setTagAmount(0);
			}
			count = bpInfoTagMapper.insertSelective(bpInfoTag);
		} else {
			count = bpInfoTagMapper.updateByPrimaryKeySelective(bpInfoTag);
		}
		if (count > 0) {
			return Constant.RESULT_STR_SUCCESS;
		} else {
			return Constant.RESULT_STR_FAILURE;
		}
	}

	@Override
	public List<BpInfoTag> queryPTagByStatus() {
		Map<String, Object> paraMap = new HashMap<String, Object>();
		paraMap.put("tagState", Constant.NORMAL);
		return bpInfoTagMapper.queryPTagByStatus(paraMap);
	}

	@Override
	public List<BpInfoTag> queryChildTag(String parentId) {
		List<BpInfoTag> list = bpInfoTagMapper.queryListByParentId(parentId);
		return list;
	}

	@Override
	public List<BpInfoTag> queryChildTagByMobule(String module) {
		return bpInfoTagMapper.queryChildTagByCode(module);
	}

	@Override
	public List<BpInfoTag> queryChildTagByTagCode(String tagCode) {
		return bpInfoTagMapper.queryChildTagByTagCode(tagCode);
	}

	@Override
	public List<BpInfoTag> queryTagsByModule(String module) {
		return bpInfoTagMapper.queryTagsByModule(module);
	}
}
