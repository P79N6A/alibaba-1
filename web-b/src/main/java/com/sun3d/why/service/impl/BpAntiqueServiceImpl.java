package com.sun3d.why.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.BpAntiqueMapper;
import com.sun3d.why.model.BpAntique;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.BpAntiqueService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;
@Service
@Transactional
public class BpAntiqueServiceImpl implements BpAntiqueService {
    @Autowired
    private BpAntiqueMapper bpAntiqueMapper;

    //log4j日志
    private Logger logger = Logger.getLogger(CmsAntiqueServiceImpl.class);
	
	/**
     * 新增一条的文物记录
     *
     * @param record BpAntique 文物模型
     * @param sysUser 系统用户
     * @return int 成功返回1
     */
	@Override
	public int addBpAntique(BpAntique record, SysUser sysUser) {
		int count = 0;
        try {
            //添加馆藏时，默认赋值
            record.setAntiqueId(UUIDUtils.createUUId());
            record.setAntiqueIsDel(Constant.NORMAL);
            record.setAntiqueCreateTime(new Date());
            record.setAntiqueUpdateTime(new Date());
            record.setAntiqueCreateUser(sysUser.getUserId());
            record.setAntiqueUpdateUser(sysUser.getUserId());
            count = bpAntiqueMapper.addBpAntique(record);
        } catch (Exception e) {
            logger.error("添加文物信息出错!",e);
        }
        return count;
	}
	/**
	 * 根据条件查询文物列表
	 * @param page 分页类
     * @param record BpAntique模型
     * @param sysUser 系统用户
     * @return list 文物列表
	 */
	@Override
	public List<BpAntique> queryBpAntiqueByCondition(Pagination page, BpAntique record, SysUser sysUser) {
		Map<String,Object> map = new HashMap<String, Object>();
        List<BpAntique> list = null;
        if(StringUtils.isNotBlank(record.getSearchKey())){
            map.put("searchKey", record.getSearchKey());
        }
        if(StringUtils.isNotBlank(record.getAntiqueDynasty())){
            map.put("antiqueDynasty", record.getAntiqueDynasty());
        }
        if(StringUtils.isNotBlank(record.getAntiqueType())){
            map.put("antiqueType", record.getAntiqueType());
        }
       // map.put("antiqueIsDel", Integer.valueOf(record.getAntiqueIsDel() == null ? 1 : record.getAntiqueIsDel().intValue()));
        try {
	        int total = bpAntiqueMapper.queryBpAntiqueCountByCondition(map);
	        //设置分页的总条数来获取总页数
	        page.setTotal(total);
	        page.setRows(page.getRows());
	        map.put("firstResult",page.getFirstResult());
	        map.put("rows",page.getRows());
	        list = bpAntiqueMapper.queryBpAntiqueByCondition(map);
        } catch (Exception e) {
            logger.error("查询文物信息出错!",e);
        }
		return list;
	}
	@Override
	public int deleteBpAntique(String antiqueId,SysUser sysUser) {
		int count = 0;
        Map<String,Object> map = new HashMap<String, Object>();
        try {
        	map.put("antiqueId",antiqueId);
        	map.put("antiqueIsDel",Constant.DELETE);//isDel字段设为2代表删除
            map.put("userId",sysUser.getUserId());
            map.put("updateTime",new Date());
            count = bpAntiqueMapper.updateAntiqueDelById(map);
        } catch (Exception e) {
            logger.error("逻辑删除文物信息出错!",e);
        }
        return count;
	}
	@Override
	public int removeBpAntique(String antiqueId,String antiqueIsDel,SysUser sysUser) {
		int count = 0;
        Map<String,Object> map = new HashMap<String, Object>();
        try {
        	map.put("antiqueId",antiqueId);
        	map.put("antiqueIsDel",Integer.valueOf(antiqueIsDel));
            map.put("userId",sysUser.getUserId());
            map.put("updateTime",new Date());
            count = bpAntiqueMapper.updateAntiqueDelById(map);
        } catch (Exception e) {
            logger.error("上下架文物信息出错!",e);
        }
        return count;
	}
	@Override
	public BpAntique queryBpAntiqueById(String antiqueId) {
		return bpAntiqueMapper.queryBpAntiqueById(antiqueId);
	}
	@Override
	public int editbpAntique(BpAntique record, SysUser sysUser) {
		int count = 0;
        try {
        	 record.setAntiqueUpdateTime(new Date());
        	 record.setAntiqueUpdateUser(sysUser.getUserId());
        	 count = bpAntiqueMapper.editBpAntique(record);
        } catch (Exception e) {
            logger.error("修改文物信息出错!",e);
        }
        return count;
	}
	
	

}
