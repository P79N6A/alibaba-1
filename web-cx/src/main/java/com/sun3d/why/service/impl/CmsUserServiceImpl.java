package com.sun3d.why.service.impl;

import com.sun3d.why.dao.*;
import com.sun3d.why.model.*;
import com.sun3d.why.model.extmodel.AreaData;
import com.sun3d.why.service.CmsUserService;
import com.sun3d.why.util.DateUtils;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.MD5Util;
import com.sun3d.why.util.UUIDUtils;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpSession;
import java.util.*;

/**
 * Created by yujinbing on 2015/4/27.
 */
@Service
@Transactional(rollbackFor = Exception.class)
public class CmsUserServiceImpl implements CmsUserService {

    private Logger logger = LoggerFactory.getLogger(CmsUserServiceImpl.class);

    @Autowired
    private SysUserMapper sysUserMapper;

    @Autowired
    private SysDeptMapper sysDeptMapper;

    @Autowired
    private CmsVenueMapper cmsVenueMapper;

    @Autowired
    private SysModuleMapper sysModuleMapper;

    @Autowired
    private CmsVenueSysUserRelevanceMapper cmsVenueSysUserRelevanceMapper;

    @Autowired
    private HttpSession session;
    
    @Override
    public int deleteSysUserByUserId(String userId) {
        return this.sysUserMapper.deleteSysUserByUserId(userId);
    }

    @Override
    public int addSysUser(SysUser record) {
        return this.sysUserMapper.addSysUser(record);
    }


    @Override
    public SysUser querySysUserByUserId(String userId) {
        return this.sysUserMapper.querySysUserByUserId(userId);
    }


    @Override
    public int editBySysUser(SysUser record) {
        return this.sysUserMapper.editBySysUser(record);
    }


    //得到未被分配的区级管理员信息
    @Override
    public List<SysUser> getNotAssignedUsers(SysUser loginUser) {
        String userDeptPath = loginUser.getUserDeptPath();
        Map map = new HashMap();
        map.put("userDeptPath", userDeptPath);
        map.put("userDeptPathLike", userDeptPath + "%");
        map.put("userIsAssign", 1);
        map.put("userState", 1);
        map.put("userIsdisplay", 1);
        return this.sysUserMapper.queryNotAssignedUsers(map);
    }

    //分配场馆后 修改用户的userpath
    @Override
    public int updateUserPath(String userId, String newUserPath, SysUser loginUser, CmsVenue cmsVenue) {
    	String venueDept = cmsVenue.getVenueDept();
    	//从场馆部门路径中可以取得所在部门的ID
    	String deptId = venueDept.substring(venueDept.lastIndexOf(".")+1);

    	String[] uids = userId.split("\\,");
    /*	if(uids.length == 1){
    		assginUser = this.sysUserMapper.querySysUserByUserId(uids[0]);
    		deptPath = assginUser.getUserDeptPath();
    	}else{
    		assginUser = this.sysUserMapper.querySysUserByUserId(uids[0]);
    		deptPath = assginUser.getUserDeptPath(); //被分配管理员的部门路径
    		//当被分配的管理员大于一个，可能他们的部门路径不同，此时把管理员当前部门的部门ID通过x代替，
    		//然后重新拼接作为新的部门路径然后赋给场馆变成部门后的对象的部门路径
    		deptPath = deptPath.substring(0, deptPath.lastIndexOf("."))+".x.";
    	}
    */

    		//将场馆 赋值至dept中  场馆需要特殊标识
            SysDept sysDept = new SysDept();
            sysDept.setDeptId(UUIDUtils.createUUId());
            sysDept.setDeptUpdateUser(loginUser.getUserId());
            sysDept.setDeptCreateTime(new Date());
            sysDept.setDeptUpdateTime(new Date());
            sysDept.setDeptCreateUser(loginUser.getUserId());
            sysDept.setDeptState(1);
            sysDept.setDeptParentId(deptId);
            sysDept.setDeptPath(venueDept + sysDept.getDeptId());
            sysDept.setDeptShortName(cmsVenue.getVenueName());
            sysDept.setDeptName(cmsVenue.getVenueName());
            sysDept.setDeptSort(this.sysDeptMapper.countMaxSort() + 1);
            sysDept.setDeptIsFromVenue(1);
            //将新建的场馆 保存至部门中
            this.sysDeptMapper.addSysDept(sysDept);

    		for(String uid:uids){

    			//保存场馆与分配管理员关联表
    			CmsVenueSysUserRelevance cvs = new CmsVenueSysUserRelevance();
    			cvs.setVenueId(cmsVenue.getVenueId());
    			cvs.setUserId(uid);
    			this.cmsVenueSysUserRelevanceMapper.addVenueSysUserRelevance(cvs);

    			SysUser sysUser = this.sysUserMapper.querySysUserByUserId(uid);
    			sysUser.setUserDeptId(sysDept.getDeptId());
    	        sysUser.setUserDeptPath(sysDept.getDeptPath());
    	        sysUser.setUserIsAssign(2);
    	        this.sysUserMapper.editBySysUser(sysUser);

    		}
    		//修改cmsVenue 的deptPath;
    		cmsVenue.setVenueDept(sysDept.getDeptPath());
    		return this.cmsVenueMapper.editVenueById(cmsVenue);


        //得到场馆分配的sysUser
       /* SysUser sysUser = this.sysUserMapper.querySysUserByUserId(userId);

        sysUser.setUserUpdateTime(new Date());
        sysUser.setUserUpdateUser(loginUser.getUserId());
        // 3 代表已经分配了 场馆不能再进行分配

        //将场馆 赋值至dept中  场馆需要特殊标识 不能在
        SysDept sysDept = new SysDept();
        sysDept.setDeptId(UUIDUtils.createUUId());
        sysDept.setDeptUpdateUser(loginUser.getUserId());
        sysDept.setDeptCreateTime(new Date());
        sysDept.setDeptUpdateTime(new Date());
        sysDept.setDeptCreateUser(loginUser.getUserId());
        sysDept.setDeptState(1);
        sysDept.setDeptParentId(sysUser.getUserDeptId());
        sysDept.setDeptPath(sysUser.getUserDeptPath() + "." + sysDept.getDeptId());
        sysDept.setDeptShortName(cmsVenue.getVenueName());
        sysDept.setDeptName(cmsVenue.getVenueName());
        sysDept.setDeptSort(this.sysDeptMapper.countMaxSort() + 1);
        sysDept.setDeptIsFromVenue(1);
        //将新建的场馆 保存至部门中
        this.sysDeptMapper.addSysDept(sysDept);
        //将场馆的depath 赋值给user
        sysUser.setUserDeptId(sysDept.getDeptId());
        sysUser.setUserDeptPath(sysDept.getDeptPath());
        sysUser.setUserIsAssign(2);
        this.sysUserMapper.editBySysUser(sysUser);
        //修改cmsVenue 的path;
        cmsVenue.setVenueDept(sysUser.getUserDeptPath());
        this.cmsVenueMapper.editVenueById(cmsVenue);
        return this.editBySysUser(sysUser);*/
    }

    @Override
    public List<SysUser> querySysUserByCondition(SysUser sysUser) {
        return this.sysUserMapper.querySysUserByCondition(sysUser);
    }

    @Override
    public int queryUserCountByCondition(Map<String, Object> map) {
        return this.sysUserMapper.queryUserCountByCondition(map);
    }

    @Override
    public List<SysUser> querySysUserByMap(Map<String, Object> map) {
        return this.sysUserMapper.querySysUserByMap(map);
    }

    @Override
    public List<SysUser> querySysUserIndex(Map<String, Object> map) {
        List<SysUser> userList = this.sysUserMapper.querySysUserIndex(map);
        List<SysUser> userRsList = new ArrayList<SysUser>();
        for (SysUser sysUser : userList) {
            SysDept sysDept = this.sysDeptMapper.querySysDeptByDeptId(sysUser.getUserDeptId());
            SysUser updateUser = this.sysUserMapper.querySysUserByUserId(sysUser.getUserUpdateUser());
            if (sysDept != null) {
                sysUser.setUserDeptId(sysDept.getDeptName());
            }
            if (updateUser != null) {
                sysUser.setUserUpdateUser(updateUser.getUserAccount());
            }
            userRsList.add(sysUser);
        }
        return userRsList;
    }

    @Override
    public int querySysUserIndexCount(Map<String, Object> map) {
        return this.sysUserMapper.queryUserCountByCondition(map);
    }

    @Override
    public Map<String, SysUser> getUsersInfo(Set<String> set) {
        return null;
    }

    @Override
    public String editSysUserByLoginUser(SysUser user, SysUser loginUser, String birthday, String userProvinceText, String userCityText, String userCountyText) {

        //判断用户是否已经被分配过场馆 如果已经分配场馆 提示不能修改部门信息
        SysUser oldUser = this.sysUserMapper.querySysUserByUserId(user.getUserId());
      //判断帐号是否被注册过
    	if (oldUser != null && StringUtils.isNotBlank(oldUser.getUserAccount())
                && StringUtils.isNotBlank(user.getUserAccount()) && !oldUser.getUserAccount().trim().equals(user.getUserAccount().trim())){
	        Map map = new HashMap();
	        map.put("userAccount", user.getUserAccount());
	        int count = this.sysUserMapper.queryUserCountByCondition(map);
	        if (count > 0) {
	            return "帐号已经被注册";
	        }
    	}
     /*   SysDept oldSysDept = this.sysDeptMapper.querySysDeptByDeptId(oldUser.getUserDeptId());
        if (oldSysDept.getDeptIsFromVenue() == 1 && !user.getUserDeptId().equals(oldUser.getUserDeptId())) {
            return "该用户已经分配了场馆,不能更换部门";
        }*/
        //判断部门是不是场馆  DEPT_IS_FROM_VENUE
        SysDept sysDept = this.sysDeptMapper.querySysDeptByDeptId(user.getUserDeptId());
        //1 代表该部门是从场馆而来
        if (sysDept.getDeptIsFromVenue() == 1) {
           /* Map countMap = new HashMap();
            countMap.put("userDeptId",user.getUserDeptId());
            countMap.put("notUserId",user.getUserId());
            int userCount =  queryUserCountByCondition(countMap);
            if (userCount > 0) {
                return "该场馆已经分配管理员,不能重新进行分配";
            }*/
        }
        //判断用户级别和 所选的部门级数是否一样
        String deptPath = sysDept.getDeptPath();
        if (deptPath != null && StringUtils.isNotBlank(deptPath)) {
            //判断用户级别
            String[] deptNames = {"上海市","重庆市","天津市","北京市"};
            Map map1= new HashMap();
            map1.put("deptNames",deptNames);
            List<SysDept> sysDepts = sysDeptMapper.queryTerritoryByDeptNames(map1);
            
            Integer userManger = deptPath.split("\\.").length;
            if (isInclude(deptPath, sysDepts)) {	//直辖市的逻辑
                if (userManger <= 2) {
                    user.setUserIsManger(2);
                } else  if (userManger == 3) {
                    user.setUserIsManger(3);
                } else {
                    user.setUserIsManger(4);
                }
            } else{		//省级的逻辑
                if (userManger <= 2) {
                    user.setUserIsManger(1);
                } else  if (userManger == 3) {
                    user.setUserIsManger(2);
                } else if (userManger == 4){
                    user.setUserIsManger(3);
                } else {
                    user.setUserIsManger(4);
                }
            }


           /* String[] strJs = deptPath.split("\\.");
            if (strJs != null && strJs.length != 0 && user.getUserIsManger() <= 3) {
                if(sysDept.getDeptIsFromVenue() == 1){
                    return "请正确选择用户级别对应所在的部门";
                }
                if (strJs.length != user.getUserIsManger()) {//省市区级
                    return "请正确选择用户级别对应所在的部门";
                }
            }
            if (strJs != null && strJs.length != 0 && user.getUserIsManger() == 4) {
            	if(sysDept.getDeptIsFromVenue() == 2){
            		return "请正确选择用户级别对应所在的部门";
            	}
                *//*if (strJs.length < user.getUserIsManger() ) {
                    return "请正确选择用户级别对应所在的部门";
                }*//*
            }*/
        }
        user.setUserUpdateUser(loginUser.getUserId());
        user.setUserUpdateTime(new Date());
        user.setUserBirthday(DateUtils.string2Date2(birthday));
        if (user.getUserPassword().length() != 32) {
            user.setUserPassword(MD5Util.toMd5(user.getUserPassword()));
        }
        String userDeptPath = "";
        if (loginUser.getUserDeptPath() != null) {
            userDeptPath = loginUser.getUserDeptPath() + ".";
        }
        if (!StringUtils.isBlank(user.getUserProvince())) {
            user.setUserProvince(user.getUserProvince() + "," + userProvinceText);
        }
        if (!StringUtils.isBlank(user.getUserCity())) {
            user.setUserCity(user.getUserCity() + "," + userCityText);
        }
        if (!StringUtils.isBlank(user.getUserCounty())) {
            user.setUserCounty(user.getUserCounty() + "," + userCountyText);
        } else {
            user.setUserCounty(user.getUserCity());
        }
        //SysDept sysDept = this.sysDeptMapper.querySysDeptByDeptId(user.getUserDeptId());
        if (sysDept != null) {
            user.setUserDeptPath(sysDept.getDeptPath());
        }
        if (user.getUserLabel1()==null) {
        	user.setUserLabel1(0);
        }
        if (user.getUserLabel2()==null) {
        	user.setUserLabel2(0);
        }
        if (user.getUserLabel3()==null) {
        	user.setUserLabel3(0);
        }
        int rs = this.sysUserMapper.editBySysUser(user);
       /* if (sysDept != null) {
            user.setUserDeptId(sysDept.getDeptName());
        }*/
        return "success";
    }

    @Override
    public SysUser loginCheckUser(String userAccount, String userPassword) {
        SysUser sysUser = new SysUser();
        sysUser.setUserPassword(MD5Util.toMd5(userPassword));
        sysUser.setUserAccount(userAccount);
        //启用状态
        sysUser.setUserIsdisplay(1);
        //激活状态
        /*sysUser.setUserState(1);*/
        List<SysUser> userList = this.sysUserMapper.querySysUserByCondition(sysUser);
        SysUser user = null;
        if (userList != null && userList.size() > 0) {
            user = userList.get(0);
            List<SysModule> sysModuleList = sysModuleMapper.selectModuleByUserId(user.getUserId());
            user.setSysModuleList(sysModuleList);
            return  user;
        } else {
            return null;
        }
    }

    public boolean isInclude(String userDeptPath,List<SysDept> sysDepts) {
    	if (sysDepts != null && sysDepts.size() > 0) {
	        for(SysDept sysDept : sysDepts) {
	            if (sysDept.getDeptPath() != null  && userDeptPath.contains(sysDept.getDeptPath())) {
	                return true;
	            }
	        }
    	}
        return false;
    }

    @Override
    public String checkUserCanSave(SysUser user ,SysUser loginUser,String userProvinceText, String userCityText, String userCountyText,String birthday) {
        //判断帐号是否被注册过
        Map map = new HashMap();
        map.put("userAccount", user.getUserAccount());
        int count = this.sysUserMapper.queryUserCountByCondition(map);
        if (count > 0) {
            return "帐号已经被注册";
        }
        //判断部门是不是场馆  DEPT_IS_FROM_VENUE
        SysDept sysDept = this.sysDeptMapper.querySysDeptByDeptId(user.getUserDeptId());
        if (sysDept != null ) {
            //1 代表该部门是从场馆而来
          /*  if (sysDept.getDeptIsFromVenue() == 1) {
                //
                Map countMap = new HashMap();
                countMap.put("userDeptId",user.getUserDeptId());
                int userCount =  queryUserCountByCondition(countMap);
                if (userCount > 0) {
                    return "该场馆已经分配管理员,不能重新进行分配";
                }
            }*/
            String deptPath = sysDept.getDeptPath();
            //判断用户级别
            String[] deptNames = {"上海市","重庆市","天津市","北京市"};
            Map map1= new HashMap();
            map1.put("deptNames",deptNames);
            List<SysDept> sysDepts = sysDeptMapper.queryTerritoryByDeptNames(map1);
            
            Integer userManger = deptPath.split("\\.").length;
            if (isInclude(deptPath, sysDepts)) {	//直辖市的逻辑
                if (userManger <= 2) {
                    user.setUserIsManger(2);
                } else  if (userManger == 3) {
                    user.setUserIsManger(3);
                } else {
                    user.setUserIsManger(4);
                }
            } else{		//省级的逻辑
                if (userManger <= 2) {
                    user.setUserIsManger(1);
                } else  if (userManger == 3) {
                    user.setUserIsManger(2);
                } else if (userManger == 4){
                    user.setUserIsManger(3);
                } else {
                    user.setUserIsManger(4);
                }
            }
        } else {
            return "部门不存在";
        }
       /* //判断用户级别和 所选的部门级数是否一样
        String deptPath = sysDept.getDeptPath();*/
/*
        if (deptPath != null && StringUtils.isNotBlank(deptPath)) {
            String[] strJs = deptPath.split("\\.");
            if (strJs != null && strJs.length != 0 && user.getUserIsManger() <= 3) {
                if(sysDept.getDeptIsFromVenue() == 1){
                    return "请正确选择用户级别对应所在的部门";
                }
                if (strJs.length != user.getUserIsManger()) {//省市区级
                    return "请正确选择用户级别对应所在的部门";
                }
            }
            if (strJs != null && strJs.length != 0 && user.getUserIsManger() == 4) { //场馆级
            	if(sysDept.getDeptIsFromVenue() == 2){
            		return "请正确选择用户级别对应所在的部门";
            	}
                */
/*if (strJs.length < user.getUserIsManger()) {
                    return "请正确选择用户级别对应所在的部门";
                }*//*

            }
        }
*/
        user.getUserDeptId();
        String userPassword = user.getUserPassword();
        user.setUserPassword(MD5Util.toMd5(userPassword));
        user.setUserId(UUIDUtils.createUUId());
        user.setUserUpdateTime(new Date());
        user.setUserUpdateUser(loginUser.getUserId() );
        user.setUserCreateUser(loginUser.getUserId());
        if (loginUser != null) {
            user.setUserUpdateUser(loginUser.getUserId() == null ? "sys" : loginUser.getUserId());
            user.setUserCreateUser(loginUser.getUserId() == null ? "sys" : loginUser.getUserId());
        }
        if (!StringUtils.isBlank(user.getUserProvince())) {
            user.setUserProvince(user.getUserProvince() + "," + userProvinceText);
        }
        if (!StringUtils.isBlank(user.getUserCity())) {
            user.setUserCity(user.getUserCity() + "," + userCityText);
        } else {
            user.setUserCity(user.getUserProvince());
        }
        if (!StringUtils.isBlank(user.getUserCounty())) {
            user.setUserCounty(user.getUserCounty() + "," + userCountyText);
        } else {
            user.setUserCounty(user.getUserCity());
        }
        user.setUserCreateTime(new Date());
        user.setUserState(1);
        user.setUserIsdisplay(1);
        user.setUserIsAssign(1);
        String userDeptPath = "";
        if (loginUser != null && loginUser.getUserDeptPath() != null) {
            userDeptPath = loginUser.getUserDeptPath() + ".";
        }
        if (sysDept != null) {
            user.setUserDeptPath(sysDept.getDeptPath());
        } else {
            user.setUserDeptPath(userDeptPath);
        }

        user.setUserBirthday(DateUtils.string2Date2(birthday));
        //1 代表省级   2 代表市级  3代表区级    4代表场馆级
        if (user.getUserIsManger() == null) {
            user.setUserIsManger(1);
        }
        if (user.getUserLabel1()==null) {
        	user.setUserLabel1(0);
        }
        if (user.getUserLabel2()==null) {
        	user.setUserLabel2(0);
        }
        if (user.getUserLabel3()==null) {
        	user.setUserLabel3(0);
        }
        int rs = this.sysUserMapper.addSysUser(user);
        return  "success";
    }

    @Override
    public String queryAppSysUserById(String userAccount,String userPassword) {
        String json="";
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        Map<String,Object> map=new HashMap<String, Object>();
        if(userAccount!=null && StringUtils.isNotBlank(userAccount)){
            map.put("userAccount",userAccount);
        }
        if (userPassword!=null && StringUtils.isNotBlank(userPassword)){
            map.put("userPassword",userPassword);
        }
        List<SysUser> sysUsers=sysUserMapper.queryAppSysUserById(map);
        if(sysUsers!=null && sysUsers.size()>0){
            SysUser sysUser = new SysUser();
            sysUser = sysUsers.get(0);
            Map<String,Object> userMap = new HashMap<String,Object>();
            userMap.put("deptName", sysUser.getDeptName() != null ? sysUser.getDeptName() : "");
            userMap.put("roleName", sysUser.getRoleName() != null ? sysUser.getRoleName() : "");
            userMap.put("userAccount", sysUser.getUserAccount() != null ? sysUser.getUserAccount() : "");
            userMap.put("userId", sysUser.getUserId() != null ? sysUser.getUserId() : "");
            listMap.add(userMap);
            json= JSONResponse.toAppResultFormat(0, listMap);
        }else {
            json = JSONResponse.toAppResultFormat(12131, "账号或密码错误");
        }
        return json;
    }

    /**
	 * 查询管理员所有的区域信息
	 * @return 管理员区域信息列表
	 */
	@Override
	public List<AreaData> queryUserAllArea() {
		Map<String, Object> map = new HashMap<String, Object>();
        SysUser user = (SysUser)session.getAttribute("user");
        if (user != null){
        	map.put("userDeptPath", user.getUserDeptPath() + "%");
        }
        List<SysUser> userList = sysUserMapper.queryUserAllArea(map);
        if (CollectionUtils.isEmpty(userList)) {
            return null;
        }
        List<AreaData> dataList = new ArrayList<AreaData>();
        for (SysUser sysUser : userList) {
            String area = sysUser.getUserCounty();
            if (StringUtils.isNotBlank(area)) {
                String[] areas = area.split(",");
                AreaData data = new AreaData();
                if (areas.length > 1 && areas[0] != null && areas[1] != null) {
                    data.setId(areas[0]);
                    data.setText(areas[1]);
                    dataList.add(data);
                }
            }
        }
        return dataList;
	}

    /**
     * @根据用户名查找用户信息
     * @para userAccount
     * @return SysUser
     * @authour  hucheng
     * @content add
     * @date  2016/1/20
     * */
    public SysUser querySysUserByUserAccount(String userAccount){

        return sysUserMapper.querySysUserByUserAccount(userAccount);
    }
}
