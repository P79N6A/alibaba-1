package com.sun3d.why.dao;

import com.sun3d.why.model.CmsTerminalUser;

import java.util.List;
import java.util.Map;

public interface CmsTerminalUserMapper {

    /**
     * 根据用户名称获取该用户的用户ID
     * @param userName
     * @return String userId
     * @author cj
     */
    public String getTerminalUserId(String userName);

    /**
     * 根据第三方用户ID获取文化云系统用户ID
     * @param sysId
     * @return String sysId
     * @author cj
     */
    public String getTerminalUserIdBySysId(String sysId);

    /**
     * 根据手机号获取该用户的用户ID
     * @param userMobileNo
     * @return String userId
     * @author qww
     */
    String getTerminalUserIdByMobileNo(String userMobileNo);

    /**
     * 查询符合条件的会员的条数
     * @param map
     * @return 总条数
     */
    int queryTerminalUserCountByCondition(Map<String, Object> map);

    /**
     * 查询符合条件的会员
     * @param map
     * @return 会员对象的集合
     */
    List<CmsTerminalUser> queryTerminalUserByCondition(Map<String, Object> map);

    /**
     * 验证会员名称不可重复
     * @param map
     * @return 0 不存在 1存在
     */
    int queryTerminalUserIsExists(Map<String, Object> map);

    /**
     * 新增用户
     * @param user
     * @return
     */
    int addTerminalUser(CmsTerminalUser user);

    /**
     * 根据id查询会员对象
     * @param userId
     * @return 会员对象
     */
    CmsTerminalUser queryTerminalUserById(String userId);

    /**
     * 根据id更新会员
     * @param user
     * @return
     */
    int editTerminalUserById(CmsTerminalUser user);

    /**
     * 后端2.0 某个团体下的成员列表
     * @param map
     * @return 会员对象列表
     */
    List<CmsTerminalUser> queryTeamTerminalUserByTuserId(Map<String, Object> map);

    /**
     * 后端2.0某个团体下成员查看
     * @param applyId
     * @return
     */
    CmsTerminalUser queryTeamTerminalUserByApplyId(String applyId);

    /**
     * 后端2.0 某个团体下的成员条数
     * @param map
     * @return
     */
    int queryTeamTerminalUserCountByTuserId(Map<String, Object> map);

    /**
     * 前端2.0 根据用户名和密码查询用户
     * @param map
     * @return 会员对象
     */
    CmsTerminalUser queryTerminalByMobileOrPwd(Map<String, Object> map);

    /**
     * 前端2.0我管理的团体-消息审核
     * @param map
     * @return
     */
    List<CmsTerminalUser> queryCheckTerminalUser(Map<String, Object> map);

    /**
     * 后端2.0根据省市区查询管理员用户
     * @param map
     * @return 会员对象集合
     */
    List<CmsTerminalUser> queryTerminalUserByArea(Map<String, Object> map);

    /**
     * 前端2.0我管理的团体-消息审核个数
     * @param map
     * @return
     */
    int queryCheckTerminalUserCount(Map<String, Object> map);

    /**
     * 前端2.0 团体详情 管理人
     * @param tuserId
     * @return
     */
    String queryUserNickNameByTuserId(String tuserId);

    List<CmsTerminalUser> getCmsTerminalUserList(Map<String, Object> params);
    CmsTerminalUser getCmsTerminalUserByMobile(String userMobileNo);

    /**
     * app根据code查询用户对象
     *
     * @param mobileNum
     * @param code
     * @return
     */
    CmsTerminalUser queryTerminalUserByCode(String code,String mobileNum);

    /**
     * 根据openid 查询user
     * queryByOpenId
     */
    CmsTerminalUser queryByOpenId(Map<String,Object> params);

    /**
     * app验证手机号码
     * @param map
     * @return
     */
    CmsTerminalUser terminalUserMobileExists(Map<String, Object> map);


    CmsTerminalUser queryFrontTerminalUser(Map<String, Object> map);





    /**
     * app根据用户id编辑图片url
     * @param map
     * @return
     */
    //int editAppTerminalUserById(CmsTerminalUser terminalUser);

    /**
     * app根据用户名与密码获取用户对象
     * @param map
     * @return
     */
    CmsTerminalUser queryAppTerminalUserByCondition(Map<String, Object> map);

    int queryByIp(Map<String,Object> params);

    /**
     * 用户根据电话查询用户信息
     * @param param
     * @return
     */
    CmsTerminalUser queryTerminalUserByMobile(Map<String, Object> param);

    CmsTerminalUser queryByWebOpenId(Map<String,Object> params);


    CmsTerminalUser webLogin(Map<String, Object> map);


    /**
     * 查询该用户是否绑定第三方账号
     * @param openId 第三方登陆返回的operid
     * @return
     */
    public int queryTerminalCountById(String openId,Integer userIsDisable);

    /**
     * app根据operId查询
     * @param params
     * @return
     */
  	public CmsTerminalUser queryTerminalUserListById(Map<String, Object> params);

    /**
     * 验证用户名是否存在
     * @param user
     * @return
     */
    int terminalUserIsExistByName(CmsTerminalUser user);

    /**
     * app
     * @param operId
     * @param userIsActivate
     * @return
     */
  public   CmsTerminalUser bindingOperIdById(String operId, Integer userIsActivate);



    /** 公共接口方法 **/

    /**
     * 判断用户能否登录
     * @param user
     * @return
     */
    public CmsTerminalUser checkUserLogin(CmsTerminalUser user);


    public  CmsTerminalUser queryUserByMobile(String userMobileNo);

    /*微信通过微信网站登录后保存openId*/
    public  CmsTerminalUser queryByWxOpenId(String wxOpenId);


    public  CmsTerminalUser publicLogin(CmsTerminalUser user);
    
    public List<CmsTerminalUser> queryTerminalUserbehaviorAnalysis( Map<String, Object> map);
    
    int queryTerminalUserbehaviorAnalysisCount( Map<String, Object> map);
    
    public int queryWXRegister( Map<String, Object> map);
    public int querySysRegister( Map<String, Object> map);
    public int queryAllRegister( Map<String, Object> map);
    
    List<CmsTerminalUser> queryAllTerminalUser();
    int editTerminalUserAesToMd5(CmsTerminalUser user);
}