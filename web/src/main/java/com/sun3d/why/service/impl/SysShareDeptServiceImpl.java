package com.sun3d.why.service.impl;

import com.sun3d.why.dao.SysShareDeptMapper;
import com.sun3d.why.model.SysShareDept;
import com.sun3d.why.service.SysShareDeptService;
import com.sun3d.why.util.Pagination;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional
public class SysShareDeptServiceImpl implements SysShareDeptService {

    @Autowired
    private SysShareDeptMapper sysShareDeptMapper;

    /**
     * 删除分享信息
     * @param shareId
     * @return
     */
    public  int deleteByShareId(String shareId) {
        return sysShareDeptMapper.deleteByShareId(shareId);
    }

    /**
     * 添加部门分享信息
     * @param record
     * @return
     */
    public int addSysShareDept(SysShareDept record) {
        return sysShareDeptMapper.addSysShareDept(record);
    }

    /**
     * 根据shareId查询 分享的信息
     * @param shareId
     * @return
     */
    public SysShareDept querySysShareDeptByShareId(String shareId) {
        return sysShareDeptMapper.querySysShareDeptByShareId(shareId);
    }
    
    /**
     * 根据条件查询 分享的信息
     * @param record
     * @return
     */
	public List<SysShareDept> queryShareDeptByCondition(SysShareDept record) {
		Map map = new HashMap<>();
		map.put("sourceDeptId",record.getSourceDeptid());
        map.put("targetDeptId",record.getTargetDeptid());
		return sysShareDeptMapper.queryShareDeptByCondition(map);
	}

    /**
     * 根据分享主键修改分享表
     * @param record
     * @return
     */
    public int editBySysShareDept(SysShareDept record) {
        return sysShareDeptMapper.editBySysShareDept(record);
    }


    /**
     * 根据部门id 查询该部门的被分享信息
     * @param targetDeptId
     * @return
     */
    public List<SysShareDept> queryShareDeptByTargetDeptId(String targetDeptId) {
        Map map = new HashMap<>();
        map.put("isShare",1);
        map.put("targetDeptId",targetDeptId);
        return sysShareDeptMapper.queryShareDeptByTargetDeptId(map);
    }
    
    /**
     * 根据部门id 查询该部门的分享信息
     * @param sourceDeptId
     * @param page
     * @return
     */
    public List<SysShareDept> queryShareDeptBySourceDeptId(String sourceDeptId,Pagination page) {
        Map map = new HashMap<>();
        map.put("isShare",1);
        map.put("sourceDeptId",sourceDeptId);
        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
        }
        int total = sysShareDeptMapper.queryShareDeptByCount(map);
        //设置分页的总条数来获取总页数
        page.setTotal(total);
        return sysShareDeptMapper.queryShareDeptByCondition(map);
    }

}