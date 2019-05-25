package com.sun3d.why.service;

import com.sun3d.why.model.CmsApplyJoinTeam;
import com.sun3d.why.model.CmsTeamUser;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.PaginationApp;

import java.util.List;
import java.util.Map;

/**
 * <p>
 * 团队用户管理服务层service接口
 * <p/>
 * Created by cj on 2015/4/23.
 */
public interface CmsTeamUserService {

    /**
     * 根据条件查询团体信息列表
     * @param record 团体信息
     * @param page 分页信息
     * @param sysUser 用户信息
     * @return
     */
    List<CmsTeamUser> queryCmsTeamUserByCondition(CmsTeamUser record, Pagination page,SysUser sysUser);

    /**
     * 返回根据条件查询的记录总数
     * @param map 查询条件组成的MAP
     * @return
     */
    int queryCmsTeamUserCountByCondition(Map<String,Object> map);

    /**
     * 根据团队会员主键id查询模块信息
     *
     * @param tuserId String 团队会员主键id
     * @return CmsTeamUser 团队会员模型
     */
    CmsTeamUser queryTeamUserById(String tuserId);

    /**
     * 新增一条团队会员信息记录
     *
     * @param record CmsTeamUser 团队会员模型
     * @param tagIds String  标签
     * @param sysUser SysUser  用户信息
     * @return int 执行结果 1：成功 0：失败
     */
    int addCmsTeamUser(CmsTeamUser record,String tagIds,SysUser sysUser);

    /**
     * 根据团队会员主键id来更新模块信息
     *
     * @param record CmsTeamUser 模块模型
     * @param tagIds String  标签
     * @param sysUser SysUser  用户信息
     * @return int 执行结果 1：成功 0：失败
     */
    int editCmsTeamUser(CmsTeamUser record,String tagIds,SysUser sysUser);

    /**
     * 根据团队会员主键id来更新模块信息，逻辑删除团体信息
     *
     * @param record CmsTeamUser 模块模型
     * @param sysUser SysUser  用户信息
     * @return int 执行结果 1：成功 0：失败
     */
    int deleteCmsTeamUser(CmsTeamUser record,SysUser sysUser);

    /**本周热门文化团体
     *
     * @return 活动总条数
     */
    int countWeekHotTeamUser(Map<String,Object> map);

    /**
     *本周热门文化团体
     *
     * @param page
     * @return 返回(不含text类型)的字段列表信息
     */
    List<CmsTeamUser> queryWeekHotTeamUser(String area,Pagination page);

    /**
     * 前端2.0团体收藏列表
     * @param user 会员对象
     * @param tuserName 团体名称
     * @param pageApp
     * @return 团体对象集合
     */
    List<CmsTeamUser> queryCollectTeamUser(CmsTerminalUser user, Pagination page, String tuserName, PaginationApp pageApp);

    /**
     * 前端2.0团体收藏个数
     * @param map
     * @return
     */
    int queryCollectTeamUserCount(Map<String, Object> map);

    /**
     * 前端2.0团体首页
     * @param user 团体对象
     * @param page 分页对象
     * @param pageApp
     * @return 团体对象集合
     */
    List<CmsTeamUser> queryFrontTeamUserByCondition(CmsTeamUser user, String tagId, Pagination page, PaginationApp pageApp);

    /**
     * 前端2.0团体列表
     * @param user 团体对象
     * @param page 分页对象
     * @return 团体对象集合
     */
    List<CmsTeamUser> queryFrontTeamUserListByCondition(CmsTeamUser user,Integer sortType, Pagination page,PaginationApp pageApp);

    /**
     * 前端2.0 我管理的团体
     * @param team 团体对象
     * @param page 分页对象
     * @param pageApp
     * @return 团体列表
     */
    List<CmsTeamUser> queryMyManagerTeamUser(CmsApplyJoinTeam team, Pagination page, PaginationApp pageApp);

    /**
     * 判断团体用户还是普通用户
     * @param applyJoinTeam
     * @return
     */
    int queryMyManagerTeamUserCount(CmsApplyJoinTeam applyJoinTeam,Integer tuserUserType,Integer tuserIsDisplay);

    /**
     * 前端2.0 团体预定活动室时，我管理的团体
     * @param userId
     * @return 团体列表
     */
    List<CmsTeamUser> queryTeamUserList(String userId);

    /**
     * 前端2.0编辑团体信息
      * @param teamUser
     * @return
     */
    String editFrontTeamUser(CmsTeamUser teamUser);

    /**
     * 前端2.0查询团体详情中的推荐团体
     * @param teamUser
     * @param page
     * @return
     */
    List<CmsTeamUser> queryRecommentTeamUser(CmsTeamUser teamUser, Pagination page);

    /**
     * 我管理的团体-->通过审核
     * @param applyJoinTeam
     * @return
     */
    String checkApplyJoinTeamPass(CmsApplyJoinTeam applyJoinTeam);

    /**
     * 我管理的团体-->拒绝加入
     * @param applyJoinTeam
     * @return
     */
    String refuseApplyJoinTeam(CmsApplyJoinTeam applyJoinTeam);

    /**
     * 我管理的团体-->退出团体
     * @param applyJoinTeam
     * @return
     */
    String quitApplyJoinTeam(CmsApplyJoinTeam applyJoinTeam);

    /**
     * //将各个区域团体数量插入至统计表中
     * @param map
     * @return
     */
    List<Map> queryTeamCountByArea(Map map);

    /**
     * app根据团体id查找团体详情
     * @param teamUserId
     * @return
     */
    CmsTeamUser queryAppTeamUserById(String teamUserId);

    /**
     * app根据团体id编辑团体图片
     * @param teamUser
     * @return
     */
    int editAppTeamUserById(CmsTeamUser teamUser);


}
