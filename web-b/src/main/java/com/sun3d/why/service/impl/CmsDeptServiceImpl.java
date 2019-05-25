package com.sun3d.why.service.impl;

import com.sun3d.why.dao.CmsVenueMapper;
import com.sun3d.why.dao.SysDeptMapper;
import com.sun3d.why.model.CmsVenue;
import com.sun3d.why.model.SysDept;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsDeptService;
import com.sun3d.why.util.UUIDUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.net.URLDecoder;
import java.util.*;

/**
 * Created by yujinbing on 2015/4/29.
 */
@Service
@Transactional
public class CmsDeptServiceImpl implements CmsDeptService {

    @Autowired
    private SysDeptMapper sysDeptMapper;

    @Autowired
    private CmsVenueMapper cmsVenueMapper;


    @Override
    public int deleteSysDeptByDeptId(String deptId) {
        return sysDeptMapper.deleteByDeptId(deptId);
    }

    @Override
    public int addSysDept(SysDept record) {
        return sysDeptMapper.addSysDept(record);
    }


    @Override
    public SysDept querySysDeptByDeptId(String deptId) {
        return sysDeptMapper.querySysDeptByDeptId(deptId);
    }


    @Override
    public int editSysDept(SysDept record) {
        return sysDeptMapper.editSysDept(record);
    }

    @Override
    public int countMaxSort() {
        return sysDeptMapper.countMaxSort();
    }
    @Override
    public List<SysDept> querySysDeptByMap(Map map){
       return sysDeptMapper.querySysDeptByMap(map);
    }

    @Override
    public List<SysDept> querySysDeptByCondition(SysDept sysDept) {
        return sysDeptMapper.querySysDeptByCondition(sysDept);
    }

    @Override
    public int queryCountByMap(Map map) {
        return sysDeptMapper.queryCountByMap(map);
    }


    /**
     * 子系统对接，验证场馆名称是否重名
     * @param map
     * @return int
     * @authour hucheng
     * @content add
     * @date 2016/1/18
     */
    public int queryAPICountByMap(Map map) {
        return sysDeptMapper.queryAPICountByMap(map);
    }

    @Override
    public List<SysDept> queryAreaList(String pid, String grade) {
        List<SysDept> list = new ArrayList<SysDept>();
        Map map = new HashMap();
        map.put("deptIsFromVenue", 2);
        // TODO Auto-generated method stub
        if(StringUtils.isNotBlank(grade)&&StringUtils.isBlank(pid)){
            map.put("deptRemark", grade);
        }else if(StringUtils.isNotBlank(pid)){
            map.put("deptParentId", pid);
        }
        list = sysDeptMapper.queryAreaListByMap(map);
        return list;
    }

    @Override
    public Map updateSysDept(String deptId, String deptName,String pId, SysUser loginUser) {
        Map rsMap  = new HashMap();
        SysDept dept = querySysDeptByDeptId(deptId);
        try {
            deptName = URLDecoder.decode(deptName, "utf-8");
        } catch (Exception e) {
            e.printStackTrace();
        }
        // 判断是否有重名的部门
        Map map = new HashMap();
        map.put("deptName",deptName);
        map.put("deptPath", loginUser.getUserDeptPath() + "%");
        int countName = queryCountByMap(map);
        if (countName > 0) {
            rsMap.put("success" ,"N");
            rsMap.put("msg" ,"repeatName");
            return rsMap;
        }
        if (dept == null) {
            dept = new SysDept();
            String uId = UUIDUtils.createUUId();
            SysDept sysDept = new SysDept();
            sysDept.setDeptId(uId);
            sysDept.setDeptState(1);
            sysDept.setDeptName(deptName);
            sysDept.setDeptParentId(pId);
            sysDept.setDeptCreateTime(new Date());
            sysDept.setDeptUpdateTime(new Date());
            sysDept.setDeptUpdateUser(loginUser.getUserId());
            sysDept.setDeptCreateUser(loginUser.getUserId());
            sysDept.setDeptShortName(deptName);
            sysDept.setDeptIsFromVenue(2);
            sysDept.setDeptSort(countMaxSort() + 1);
            String path = "";
            SysDept parentDept = querySysDeptByDeptId(pId);
            if (parentDept != null) {
                path = parentDept.getDeptPath();
                if (path != null && !"".equals(path)) {
                    sysDept.setDeptPath( path + "." + uId);
                } else {
                    sysDept.setDeptPath(uId);
                }
            }
            int count = addSysDept(sysDept);
            if (count == 1) {
                rsMap.put("success","Y");
                rsMap.put("uId",uId);
                return  rsMap;
            } else {
                rsMap.put("success","N");
                rsMap.put("msg","error");
                return  rsMap;
            }
        } else {
            dept.setDeptName(deptName);
            int count = editSysDept(dept);
            /**add by YH 修改从场馆变成的部门时，同事也要修改场馆名称 2015-11-02 begin*/
            Integer deptFromVenue = dept.getDeptIsFromVenue();
            if(1==deptFromVenue){
            	CmsVenue v = cmsVenueMapper.queryVenueByVenueDeptId(dept.getDeptId());
            	v.setVenueName(deptName);
            	cmsVenueMapper.editVenueById(v);
            }
            /**add by YH 修改从场馆变成的部门时，同事也要修改场馆名称 2015-11-02 end*/
            
            if (count == 1) {
                rsMap.put("success","Y");

                return   rsMap;
            } else {
                rsMap.put("success","N");
                return  rsMap;
            }
        }
    }

    @Override
    public SysDept querySysDeptByDeptPath(String deptPath) {
        return sysDeptMapper.querySysDeptByDeptPath(deptPath);
    }

    @Override
    public String querySysDeptIdByDeptName(String deptName) {

        Map<String,Object> map=new HashMap();
        map.put("deptName", deptName);
        return sysDeptMapper.querySysDeptIdByDeptName(map);
    }

}
