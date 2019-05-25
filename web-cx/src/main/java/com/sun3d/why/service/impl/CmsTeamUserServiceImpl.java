package com.sun3d.why.service.impl;

import com.sun3d.why.dao.CmsTeamUserMapper;
import com.sun3d.why.model.CmsApplyJoinTeam;
import com.sun3d.why.model.CmsTeamUser;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsApplyJoinTeamService;
import com.sun3d.why.service.CmsTeamUserService;
import com.sun3d.why.service.CmsTerminalUserService;
import com.sun3d.why.service.CmsUserMessageService;
import com.sun3d.why.util.*;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <p>
 * 团队会员服务层实现类
 * 事务管理层
 * 需要用到事务的功能都在此编写
 * <p/>
 * Created by cj on 2015/4/24.
 */
@Service
@Transactional
public class CmsTeamUserServiceImpl implements CmsTeamUserService {

    /**
     * 自动注入数据操作层dao实例
     */
    @Autowired
    private CmsTeamUserMapper cmsTeamUserMapper;

    @Autowired
    private CmsTerminalUserService terminalUserService;

    @Autowired
    private CmsApplyJoinTeamService applyJoinTeamService;

    @Autowired
    private CmsUserMessageService userMessageService;

    //log4j日志
    private Logger logger = Logger.getLogger(CmsTeamUserServiceImpl.class);

    /**
     * 根据条件查询团体信息列表
     * @param record 团体信息
     * @param page 分页信息
     * @param sysUser 用户信息
     * @return
     */
    @Override
    public List<CmsTeamUser> queryCmsTeamUserByCondition(CmsTeamUser record, Pagination page,SysUser sysUser) {
        List<CmsTeamUser> list = null;
        Map<String,Object> map = new HashMap<String, Object>();
        try {
       //  if(sysUser != null && StringUtils.isNotBlank(sysUser.getUserDeptPath())){
        //        map.put("tDept", "%" + sysUser.getUserDeptPath() + "%");
         //   }
            //添加根据团队会员名称模糊查询条件
            if (StringUtils.isNotBlank(record.getTuserName())) {
                map.put("tuserName", record.getTuserName());
            }
            if (StringUtils.isNotBlank(record.getTuserCounty())) {
                map.put("tuserCounty", "%" + record.getTuserCounty() + "%");
            }
            if (StringUtils.isNotBlank(record.getTuserTeamType())) {
                map.put("tuserTeamType",  record.getTuserTeamType());
            }
            if (record.getTuserIsDisplay() != null && !record.getTuserIsDisplay().equals("")) {
                map.put("tuserIsDisplay",  record.getTuserIsDisplay());
            }
            if (record.getTuserIsVenue() != null && !record.getTuserIsVenue().equals("")) {
                map.put("tuserIsVenue",  record.getTuserIsVenue());
            }
            if (record.getTuserIsActiviey() != null && !record.getTuserIsActiviey().equals("")) {
                map.put("tuserIsActiviey",  record.getTuserIsActiviey());
            }
            //如果含有exclude 代表不包含给定条件的ID
            if(StringUtils.isNotBlank(record.getTuserId())){
                if(record.getTuserId().contains("exclude")){
                    map.put("tuserIdExclude",record.getTuserId().replace("exclude",""));
                }else{
                    map.put("tuserId",record.getTuserId());
                }
            }
            
            String userId=record.getUserId();
            
            if(StringUtils.isNotBlank(userId))
            {
            	  map.put("applyIsState", 1);
                  map.put("applyCheckState", Constant.APPLY_ALREADY_PASS);
                  map.put("tuserIsDisplay",1);
                  map.put("tuserIsActiviey", 1);
                  if(StringUtils.isNotBlank(userId)){
                      map.put("userId", userId);
                  }
                  
                  //获得符合条件的总条数，这里需放在设置分页功能的前面执行，为列表页面分页功能提供
                  //分页
                  if (page != null && page.getFirstResult() != null && page.getRows() != null) {
                      map.put("firstResult", page.getFirstResult());
                      map.put("rows", page.getRows());

                      int total = cmsTeamUserMapper.queryMyManagerTeamUserCount(map);
                      //设置分页的总条数来获取总页数
                      page.setTotal(total);
                  }
                  
                  list = cmsTeamUserMapper.queryMyManagerTeamUser(map);
            }
            else{
            	  //获得符合条件的总条数，这里需放在设置分页功能的前面执行，为列表页面分页功能提供
                //分页
                if (page != null && page.getFirstResult() != null && page.getRows() != null) {
                    map.put("firstResult", page.getFirstResult());
                    map.put("rows", page.getRows());

                    int total = cmsTeamUserMapper.queryCmsTeamUserCountByCondition(map);
                    //设置分页的总条数来获取总页数
                    page.setTotal(total);
                }

                list = cmsTeamUserMapper.queryCmsTeamUserByCondition(map);
            }
            
          
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("查询团体用户信息出错!",e);
        }
        return list;
    }

    /**
     * 返回根据条件查询的记录总数
     * @param map 查询条件组成的MAP
     * @return
     */
    @Override
    public int queryCmsTeamUserCountByCondition(Map<String,Object> map) {

        return cmsTeamUserMapper.queryCmsTeamUserCountByCondition(map);
    }

    /**
     * 根据团队会员主键id查询模块信息
     *
     * @param tuserId String 团队会员主键id
     * @return CmsTeamUser 团队会员模型
     */
    @Override
    @Transactional(readOnly = true)
    public CmsTeamUser queryTeamUserById(String tuserId) {

        return cmsTeamUserMapper.queryCmsTeamUserById(tuserId);
    }

    /**
     * 新增一条团队会员信息记录
     *
     * @param record CmsTeamUser 团队会员模型
     * @param tagIds String  标签
     * @param sysUser SysUser  用户信息
     * @return int 执行结果 1：成功 0：失败
     */
    @Override
    public int addCmsTeamUser(CmsTeamUser record,String tagIds,SysUser sysUser) {
        int status = 0;
        try {
            //添加团体时，默认赋值
            record.setTuserId(UUIDUtils.createUUId());
            //record.settCreateUser(sysUser.getUserId());
            record.settUpdateUser(sysUser.getUserId());
            record.settUpdateTime(new Date());
            record.settCreateTime(new Date());
            record.settCreateUser(sysUser.getUserId());
            record.setTuserIsVenue(Constant.NORMAL);
            record.setTuserIsActiviey(Constant.NORMAL);
            //添加用户路径
            record.settDept(sysUser.getUserDeptPath());

            status = cmsTeamUserMapper.addCmsTeamUser(record);
            /*if (StringUtils.isNotBlank(tagIds)) {
                cmsTagRelateService.saveTagRelate(tagIds, record.getTuserId(), 4);
            }*/
            if (status > 0){
                CmsApplyJoinTeam applyJoinTeam = new CmsApplyJoinTeam();
                applyJoinTeam.setTuserId(record.getTuserId());
                applyJoinTeam.setUserId(record.getUserId());
                applyJoinTeam.setApplyCheckState(Constant.APPLY_ALREADY_PASS);
                applyJoinTeam.setApplyCheckTime(new Date());
                applyJoinTeam.setApplyIsState(1);
                applyJoinTeam.setApplyCreateUser(sysUser.getUserId());
                applyJoinTeam.setApplyUpdateUser(sysUser.getUserId());
                applyJoinTeamService.addApplyJoinTeam(applyJoinTeam, null);
            }
        } catch (Exception e) {
            logger.error("添加团体用户时出错",e);
        }
        return status;
    }

    /**
     * 根据团队会员主键id来更新模块信息
     *
     * @param record CmsTeamUser 模块模型
     * @param tagIds String  标签
     * @param sysUser SysUser  用户信息
     * @return int 执行结果 1：成功 0：失败
     */
    @Override
    public int editCmsTeamUser(CmsTeamUser record,String tagIds,SysUser sysUser) {
        int status = 0;
        try {
            //根据团体ID查询团体信息
            CmsTeamUser cmsTeamUser = cmsTeamUserMapper.queryCmsTeamUserById(record.getTuserId());
            record.settCreateTime(cmsTeamUser.gettCreateTime());
            record.setTuserIsVenue(cmsTeamUser.getTuserIsVenue());
            record.setTuserIsActiviey(cmsTeamUser.getTuserIsActiviey());

            //修改团体时，默认赋值
            record.settUpdateTime(new Date());
            record.settUpdateUser(sysUser.getUserId());
            record.settDept(cmsTeamUser.gettDept());

            //2015-05-28 这次改动确保省市区不会变化
            /*record.setTuserProvince(cmsTeamUser.getTuserProvince());
            record.setTuserCity(cmsTeamUser.getTuserCity());
            record.setTuserCounty(cmsTeamUser.getTuserCounty());*/
            status = cmsTeamUserMapper.editCmsTeamUser(record);
            /*if (StringUtils.isNotBlank(tagIds)) {
                cmsTagRelateService.saveTagRelate(tagIds, record.getTuserId(), 4);
            }*/
            if(status > 0){
                if(StringUtils.isNotBlank(record.getApplyId())){
                    CmsApplyJoinTeam applyJoinTeam = new CmsApplyJoinTeam();
                    applyJoinTeam.setUserId(record.getUserId());
                    applyJoinTeam.setApplyId(record.getApplyId());
                    applyJoinTeamService.editApplyJoinTeamById(applyJoinTeam);
                }else{
                    CmsApplyJoinTeam applyJoinTeam = new CmsApplyJoinTeam();
                    applyJoinTeam.setTuserId(record.getTuserId());
                    applyJoinTeam.setUserId(record.getUserId());
                    applyJoinTeam.setApplyCheckState(Constant.APPLY_ALREADY_PASS);
                    applyJoinTeam.setApplyCheckTime(new Date());
                    applyJoinTeam.setApplyIsState(1);
                    applyJoinTeam.setApplyCreateUser(sysUser.getUserId());
                    applyJoinTeam.setApplyUpdateUser(sysUser.getUserId());
                    applyJoinTeamService.addApplyJoinTeam(applyJoinTeam, null);
                }
            }
        } catch (Exception e) {
            logger.error("修改团体用户时出错",e);
        }
        return status;
    }

    /**
     * 根据团队会员主键id来更新模块信息，逻辑删除团体信息
     * @param record CmsTeamUser 模块模型
     * @param sysUser SysUser  用户信息
     * @return
     */
    @Override
    public int deleteCmsTeamUser(CmsTeamUser record, SysUser sysUser) {
        int status = 0;
        try {
            //修改团体时，默认赋值
            record.settUpdateTime(new Date());
            record.settUpdateUser(sysUser.getUserId());
            status = cmsTeamUserMapper.editCmsTeamUser(record);
        } catch (Exception e) {
           logger.error("逻辑删除团体用户时出错",e);
        }
        return status;
    }


    /**
     * 本周热门文化团体
     *
     * @return Integer
     */
    @Override
    public int countWeekHotTeamUser(Map<String,Object> map) {

        return cmsTeamUserMapper.countWeekHotTeamUser(map);
    }

    /**
     * 本周热门文化团体
     *
     * @param page
     * @return 返回(不含text类型)的字段列表信息
     */
    @Override
    public List<CmsTeamUser> queryWeekHotTeamUser(String areaCode,Pagination page) {
        List<CmsTeamUser> list = null;
        Map<String,Object> map = new HashMap<String, Object>();
        try {
            //添加根据团队会员名称模糊查询条件
            if (areaCode != null && !areaCode.equals("")) {
                map.put("tuserCounty", "%" + areaCode + "%");
            }
            map.put("tuserIsDisplay",Constant.NORMAL);

            page.setTotal(countWeekHotTeamUser(map));
            page.setRows(page.getRows());

            map.put("firstResult",page.getFirstResult());
            map.put("rows",page.getRows());
            list = cmsTeamUserMapper.queryWeekHotTeamUser(map);
        } catch (Exception e) {
            logger.error("查询本周热门团体出错",e);
        }
        return list;
    }

    /**
     * 前端2.0团体收藏列表
     * @param user 会员对象
     * @param tuserName 团体名称
     * @param pageApp
     * @return 团体对象集合
     */
    @Override
    public List<CmsTeamUser> queryCollectTeamUser(CmsTerminalUser user, Pagination page, String tuserName, PaginationApp pageApp) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("userId", user.getUserId());
        map.put("type", Constant.COLLECT_TEAMUSER);
        if(StringUtils.isNotBlank(tuserName)){
            map.put("tuserName", "%"+tuserName+"%");
        }
        //网页分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            page.setTotal(queryCollectTeamUserCount(map));
        }
        //app分页
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        return cmsTeamUserMapper.queryCollectTeamUser(map);
    }

    /**
     * 前端2.0团体收藏个数
     * @param map
     * @return
     */
    @Override
    public int queryCollectTeamUserCount(Map<String, Object> map){
        return cmsTeamUserMapper.queryCollectTeamUserCount(map);
    }

    /**
     * 前端2.0团体首页
     * @param user 团体对象
     * @param page 分页对象
     * @param pageApp
     * @return 团体对象集合
     */
    @Override
    public List<CmsTeamUser> queryFrontTeamUserByCondition(CmsTeamUser user, String tagId, Pagination page, PaginationApp pageApp) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("tuserIsDisplay", Constant.NORMAL);
        if(user != null){
            if(StringUtils.isNotBlank(user.getTuserCounty())){
                map.put("tuserCounty", "%"+user.getTuserCounty()+"%");
            }
            if(StringUtils.isNotBlank(user.getTuserName())){
                map.put("tuserName", "%"+user.getTuserName()+"%");
            }
        }

        if(StringUtils.isNotBlank(tagId)){
            map.put("tagId", "%"+tagId+",%");
        }
        //网页分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());

            int total = cmsTeamUserMapper.queryFrontTeamUserCountByCondition(map);
            //设置分页的总条数来获取总页数
            page.setTotal(total);
        }
        //app分页
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        return cmsTeamUserMapper.queryFrontTeamUserByCondition(map);
    }

    /**
     * 前端2.0团体首页
     * @param user 团体对象
     * @param page 分页对象
     * @return 团体对象集合
     */
    @Override
    public List<CmsTeamUser> queryFrontTeamUserListByCondition(CmsTeamUser user,Integer sortType, Pagination page,PaginationApp pageApp) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("tuserIsDisplay", Constant.NORMAL);
        if(sortType != null){
            map.put("sortType", sortType);
        }
        if(user != null){
            if(StringUtils.isNotBlank(user.getTuserName())){
                map.put("tuserName", "%"+user.getTuserName()+"%");
            }
            if(StringUtils.isNotBlank(user.getTuserCrowdTag())){
                map.put("tuserCrowdTag", "%"+user.getTuserCrowdTag()+",%");
            }
            if(StringUtils.isNotBlank(user.getTuserPropertyTag())){
                map.put("tuserPropertyTag", "%"+user.getTuserPropertyTag()+",%");
            }
            if(StringUtils.isNotBlank(user.getTuserSiteTag())){
                map.put("tuserSiteTag", "%"+user.getTuserSiteTag()+",%");
            }
            if(StringUtils.isNotBlank(user.getTuserCounty())){
                map.put("tuserCounty", "%"+user.getTuserCounty()+"%");
            }
            if(StringUtils.isNotBlank(user.getTuserLocationDict())){
                map.put("tuserLocationDict", user.getTuserLocationDict());
            }
        }
        //网页分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());

            int total = cmsTeamUserMapper.queryFrontTeamUserListCountByCondition(map);
            //设置分页的总条数来获取总页数
            page.setTotal(total);
        }
         //app分页
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
            int total = cmsTeamUserMapper.queryFrontTeamUserListCountByCondition(map);
            //设置分页的总条数来获取总页数
            pageApp.setTotal(total);
        }
        return cmsTeamUserMapper.queryFrontTeamUserListByCondition(map);
    }

    /**
     * 前端2.0 我管理的团体
     * @param team
     * @param pageApp
     * @return 团体列表
     */
    @Override
    public List<CmsTeamUser> queryMyManagerTeamUser(CmsApplyJoinTeam team, Pagination page, PaginationApp pageApp) {
        Map<String, Object> map = new HashMap<String, Object>();
        if(team.getApplyCheckState() != null){
            map.put("applyCheckState", team.getApplyCheckState());
        }
        if(team.getApplyIsState() != null){
            map.put("applyIsState", team.getApplyIsState());
        }
        if(StringUtils.isNotBlank(team.getUserId())){
            map.put("userId", team.getUserId());
        }
        if(StringUtils.isNotBlank(team.getTuserId())){
            map.put("tuserId", team.getTuserId());
        }
        //网页分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());

            int total = cmsTeamUserMapper.queryMyManagerTeamUserCount(map);
            //设置分页的总条数来获取总页数
            page.setTotal(total);
        }
        //app分页
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        return cmsTeamUserMapper.queryMyManagerTeamUser(map);
    }

    /**
     * 判断团体用户还是普通用户
     * @param applyJoinTeam
     * @return
     */
    @Override
    public int queryMyManagerTeamUserCount(CmsApplyJoinTeam applyJoinTeam,Integer tuserUserType,Integer tuserIsDisplay){
        Map<String, Object> map = new HashMap<String, Object>();
        if(applyJoinTeam.getApplyCheckState() != null){
            map.put("applyCheckState", applyJoinTeam.getApplyCheckState());
        }
        if(StringUtils.isNotBlank(applyJoinTeam.getUserId())){
            map.put("userId", applyJoinTeam.getUserId());
        }
        if (tuserUserType != null){
        	map.put("tuserUserType", tuserUserType);
        }
        if (tuserIsDisplay != null){
        	map.put("tuserIsDisplay", tuserIsDisplay);
        }
        return cmsTeamUserMapper.queryMyManagerTeamUserCount(map);
    }

    /**
     * 前端2.0 团体预定活动室时，我管理的团体
     * @param userId
     * @return 团体列表
     */
    @Override
    public List<CmsTeamUser> queryTeamUserList(String userId){
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("applyIsState", 1);
        map.put("applyCheckState", Constant.APPLY_ALREADY_PASS);
        map.put("tuserIsDisplay",1);
        map.put("tuserIsActiviey", 1);
        if(StringUtils.isNotBlank(userId)){
            map.put("userId", userId);
        }
        return cmsTeamUserMapper.queryMyManagerTeamUser(map);
    }

    /**
     * 前端2.0编辑团体信息
     * @param teamUser
     * @return
     */
    @Override
    public String editFrontTeamUser(CmsTeamUser teamUser){
        try{
            if(teamUser != null){
                int count = cmsTeamUserMapper.editCmsTeamUser(teamUser);
                if(count > 0){
                    return Constant.RESULT_STR_SUCCESS;
                }
            }
        }catch (Exception e){
            logger.info("editFrontTeamUser error",e);
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_FAILURE;
    }

    /**
     * 前端2.0查询团体详情中的推荐团体
     * @param teamUser
     * @param page
     * @return
     */
    @Override
    public List<CmsTeamUser> queryRecommentTeamUser(CmsTeamUser teamUser, Pagination page){
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("tuserIsDisplay", Constant.NORMAL);
        if(StringUtils.isNotBlank(teamUser.getTuserId())){
            map.put("tuserId", teamUser.getTuserId());
        }
        if(StringUtils.isNotBlank(teamUser.getTuserCounty())){
            map.put("tuserCounty", teamUser.getTuserCounty());
        }
        if(StringUtils.isNotBlank(teamUser.getTuserTeamType())){
            map.put("tuserTeamType", teamUser.getTuserTeamType());
        }
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
        }
        List<CmsTeamUser> list = cmsTeamUserMapper.queryRecommentTeamUser(map);
        if(CollectionUtils.isNotEmpty(list)){
            return list;
        }else{
            map.remove("tuserCounty");
            return cmsTeamUserMapper.queryRecommentTeamUser(map);
        }
    }

    /**
     * 我管理的团体-->拒绝加入
     * @param applyJoinTeam
     * @return
     */
    @Override
    public String refuseApplyJoinTeam(CmsApplyJoinTeam applyJoinTeam){
        try{
            int count = applyJoinTeamService.editApplyJoinTeamById(applyJoinTeam);
            if(count > 0){
                CmsApplyJoinTeam cmsApplyJoinTeam = applyJoinTeamService.queryApplyJoinTeamById(applyJoinTeam.getApplyId());
                CmsTerminalUser terminalUser = terminalUserService.queryTerminalUserById(cmsApplyJoinTeam.getUserId());
                CmsTeamUser teamUser = cmsTeamUserMapper.queryCmsTeamUserById(cmsApplyJoinTeam.getTuserId());
                // 发站内信
                Map<String, Object> map = new HashMap<String, Object>();
                map.put("userName", terminalUser.getUserName());
                map.put("teamName", teamUser.getTuserName());
                userMessageService.sendSystemMessage(Constant.TEAM_JOIN_FAIL, map, cmsApplyJoinTeam.getUserId());
                return Constant.RESULT_STR_SUCCESS;
            }
        }catch (Exception e){
            logger.info("refuseApplyJoinTeam error" +e);
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_FAILURE;
    }

    /**
     * 我管理的团体-->通过审核
     * @param applyJoinTeam
     * @return
     */
    @Override
    public String checkApplyJoinTeamPass(CmsApplyJoinTeam applyJoinTeam){
        try{
            int count = applyJoinTeamService.editApplyJoinTeamById(applyJoinTeam);
            if(count > 0){
                CmsApplyJoinTeam cmsApplyJoinTeam = applyJoinTeamService.queryApplyJoinTeamById(applyJoinTeam.getApplyId());
                CmsTerminalUser terminalUser = terminalUserService.queryTerminalUserById(cmsApplyJoinTeam.getUserId());
                CmsTeamUser teamUser = cmsTeamUserMapper.queryCmsTeamUserById(cmsApplyJoinTeam.getTuserId());
                if(!CommonUtil.isMobile(terminalUser.getUserMobileNo())){
                    return  Constant.RESULT_STR_FAILURE;
                }
                sendSms(terminalUser.getUserMobileNo(), terminalUser.getUserName(), teamUser.getTuserName(), Constant.TEAM_JOIN_SUC_SMS);
                return Constant.RESULT_STR_SUCCESS;
            }
        }catch (Exception e){
            logger.info("checkApplyJoinTeamPass error" +e);
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_FAILURE;
    }

    /**
     * 我管理的团体-->退出团体
     * @param applyJoinTeam
     * @return
     */
    @Override
    public String quitApplyJoinTeam(CmsApplyJoinTeam applyJoinTeam){
        try{
            int count = applyJoinTeamService.editApplyJoinTeamById(applyJoinTeam);
            if(count > 0){
                CmsApplyJoinTeam cmsApplyJoinTeam = applyJoinTeamService.queryApplyJoinTeamById(applyJoinTeam.getApplyId());
                CmsTerminalUser terminalUser = terminalUserService.queryTerminalUserById(cmsApplyJoinTeam.getUserId());
                CmsTeamUser teamUser = cmsTeamUserMapper.queryCmsTeamUserById(cmsApplyJoinTeam.getTuserId());
                // 发站内信
                Map<String, Object> map = new HashMap<String, Object>();
                map.put("userName", terminalUser.getUserName());
                map.put("teamName", teamUser.getTuserName());
                userMessageService.sendSystemMessage(Constant.TEAM_QUIT, map, cmsApplyJoinTeam.getUserId());
                if(!CommonUtil.isMobile(terminalUser.getUserMobileNo())){
                    return Constant.RESULT_STR_FAILURE;
                }
                sendSms(terminalUser.getUserMobileNo(), terminalUser.getUserName(), teamUser.getTuserName(), Constant.TEAM_QUIT);
                return Constant.RESULT_STR_SUCCESS;
            }
        }catch (Exception e){
            logger.info("quitApplyJoinTeam error" +e);
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_FAILURE;
    }

    // 发短信
    private void sendSms(final String userMobileNo,final String userName,final String tuserName, final String type){
        Runnable runnable=new Runnable() {
            @Override
            public void run() {
                Map<String, Object> map = new HashMap<String, Object>();
                map.put("userName", userName);
                map.put("teamName", tuserName);
                String smsContent = userMessageService.getSmsTemplate(type, map);
                //String smsContent = "您的文化云用户已注册成功，密码 123456789 请登录修改密码！";
                terminalUserService.sendSmsMessage(userMobileNo, smsContent);
            }
        };
        Thread thread=new Thread(runnable);
        thread.start();
    }


    /**
     * 各个区域团体数量
     * @param map
     * @return
     */
    public  List<Map> queryTeamCountByArea(Map map) {
        map.put("tuserIsDisplay",Constant.NORMAL);
        return cmsTeamUserMapper.queryTeamCountByArea(map);
    }

    /**
     * app根据团体id获取团体详情
     * @param teamUserId
     * @return
     */
    @Override
    public CmsTeamUser queryAppTeamUserById(String teamUserId) {
        Map<String,Object> map=new HashMap<String, Object>();
        map.put("tuserIsDisplay",Constant.NORMAL);
        if(StringUtils.isNotBlank(teamUserId)){
            map.put("teamUserId",teamUserId);
        }
        return cmsTeamUserMapper.queryAppTeamUserById(map);
    }

    @Override
    public int editAppTeamUserById(CmsTeamUser teamUser) {
        return cmsTeamUserMapper.editAppTeamUserById(teamUser);
    }
}
