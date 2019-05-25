package com.sun3d.why.dao;

import com.sun3d.why.model.CmsTeamUser;

import java.util.List;
import java.util.Map;

/**
 * 团队会员管理的数据操作层，这里直接对应的sqlmaps文件夹下面的mapping文件映射，由Mybatis Generator自动生成
 * 如果不想用自动生成的方法，可以自定义添加方法实现，这里的dao文件对应sqlmaps下面的xml文件
 * 方法名称对应Mybatis文件中的id
 *
 * @author wangfan 2015/04/23
 */
public interface CmsTeamUserMapper {


    List<CmsTeamUser> queryCmsTeamUserByCondition(Map<String,Object> map);

    int queryCmsTeamUserCountByCondition(Map<String,Object> map);

    /**
     * 根据团队会员主键id查询模块信息
     *
     * @param tuserId String 团队会员主键id
     * @return CmsTeamUser 团队会员模型
     */
    CmsTeamUser queryCmsTeamUserById(String tuserId);

    /**
     * 新增一条团队会员信息记录，该方法判断模型对象中不为空的属性
     *
     * @param record CmsTeamUser 团队会员模型
     * @return int 执行结果 1：成功 0：失败
     */
    int addCmsTeamUser(CmsTeamUser record);

    /**
     * 根据团队会员主键id来更新模块信息，只更新不为空的属性字段
     *
     * @param record CmsTeamUser 模块模型
     * @return int 执行结果 1：成功 0：失败
     */
    int editCmsTeamUser(CmsTeamUser record);

    // 本周热门文化团体
    List<CmsTeamUser> queryWeekHotTeamUser(Map<String,Object> map);

    int countWeekHotTeamUser(Map<String,Object> map);

    /**
     * 前端2.0团体收藏列表
     * @param map
     * @return 团体对象列表
     */
    List<CmsTeamUser> queryCollectTeamUser(Map<String, Object> map);

    /**
     * 前端2.0团体收藏个数
     * @param map
     * @return
     */
    int queryCollectTeamUserCount(Map<String, Object> map);

    /**
     * 前端2.0团体首页
     * @param map
     * @return 团体对象集合
     */
    List<CmsTeamUser> queryFrontTeamUserByCondition(Map<String, Object> map);

    /**
     * 前端2.0团体首页团体个数
     * @param map
     * @return 团体对象集合
     */
    int queryFrontTeamUserCountByCondition(Map<String, Object> map);

    /**
     * 前端2.0团体列表
     * @param map
     * @return 团体对象集合
     */
    List<CmsTeamUser> queryFrontTeamUserListByCondition(Map<String, Object> map);

    /**
     * 前端2.0团体列表团体个数
     * @param map
     * @return 团体对象集合
     */
    int queryFrontTeamUserListCountByCondition(Map<String, Object> map);

    /**
     * 前端2.0 我管理的团体
     * @param map
     * @return 团体列表
     */
    List<CmsTeamUser> queryMyManagerTeamUser(Map<String, Object> map);

    /**
     * 前端2.0 我管理的团体个数
     * @param map
     * @return
     */
   int queryMyManagerTeamUserCount(Map<String, Object> map);

     /**
      * 前端2.0查询团体详情中的推荐团体
      * @param map
     * @return
     */
   List<CmsTeamUser> queryRecommentTeamUser(Map<String, Object>  map);

    /**
     * 各个区域团体数量
     * @param map
     * @return
     */
    public  List<Map> queryTeamCountByArea(Map map);

    /**
     * app根据团体id获取团体详情
     * @param map
     *
     */
    CmsTeamUser queryAppTeamUserById(Map<String, Object>  map);

    /**
     * app根据团体id编辑用户图片
     * @param teamUser
     * @return
     */
    int editAppTeamUserById(CmsTeamUser teamUser);

    /**
     * app根据用户id查询团体信息
     * @param map
     * @return
     */
    List<CmsTeamUser> queryAppTeamUserList(Map<String, Object> map);


}