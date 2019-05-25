package com.sun3d.why.service;

import com.sun3d.why.model.CmsApplyJoinTeam;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.PaginationApp;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

public interface CmsTerminalUserService {


    /**
     * 根据用户名称获取该用户的用户ID
     * @param userName
     * @return String userId
     * @author cj
     */
    public String getTerminalUserId(String userName);

    /**
     * 根据手机号获取该用户的用户ID
     * @param userMobileNo
     * @return String userId
     * @author qww
     */
    String getTerminalUserIdByMobileNo(String userMobileNo);

    /**
     * 根据第三方用户ID获取文化云系统用户ID
     * @param sysId
     * @return String sysId
     * @author cj
     */
    public String getTerminalUserIdBySysId(String sysId);

    /**
     * 查询会员列表
     * @param user 会员对象
     * @param page 分页
     * @return 会员对象集合
     */
    List<CmsTerminalUser> queryTerminalUserByCondition(CmsTerminalUser user, Pagination page);

    /**
     * 查询符合条件的会员条数
     * @param map
     * @return 符合条件的会员条数
     */
    int queryTerminalUserIsExists(Map<String, Object> map);

    /**
     * 新增会员
     * @param user
     * @return success:成功 failure:失败 repeat:重复 mobileRepeat:手机重复
     */
    String addTerminalUser(CmsTerminalUser user);

    /**
     * 验证用户名或手机号是否存在
     * @param terminalUser
     * @return
     */
    boolean terminalUserIsExists(CmsTerminalUser terminalUser);

    /**
     * 根据id查询会员对象
     * @param userId
     * @return 会员对象
     */
    CmsTerminalUser queryTerminalUserById(String userId);

    /**
     * 根据id更新会员
     * @param user
     * @return success:成功 failure:失败 repeat:重复 mobileRepeat:手机重复
     */
    String editTerminalUserById(CmsTerminalUser user);

    /**
     * 后端2.0 某个团体下的成员列表
     * @param applyJoinTeam
     * @param userName
     * @return 会员对象列表
     */
    List<CmsTerminalUser> queryTeamTerminalUserByTuserId(CmsApplyJoinTeam applyJoinTeam,String userName, Pagination page);

    /**
     * 后端2.0某个团体下成员查看
     * @param applyId
     * @return
     */
    CmsTerminalUser queryTeamTerminalUserByApplyId(String applyId);

    /**
     * 更新会员
     * @param user
     * @return
     */
    int updateTerminalUserById(CmsTerminalUser user);

    /**
     * 新增会员(前端)
     * @param user
     * @return
     */
    int insertTerminalUser(CmsTerminalUser user);

    /**
     * 激活或冻结
     * @param userId
     * @param userIsDisable
     * @return
     */
    boolean editTerminalUserDisableById(String userId,int userIsDisable);

    /**
     * 禁止评论
     * @param userId
     * @return
     */
    boolean disableTerminalUserComment(String userId, int commentStatus);

    /**
     * 前端2.0会员登陆
     * @param user
     * @param session
     * @return
     */
    String terminalLogin(CmsTerminalUser user, HttpSession session);

    String webLogin(CmsTerminalUser user, HttpSession session);

    /**
     * 前端2.0我管理的团体-消息审核
     * @param team
     * @param page
     * @param pageApp
     * @return
     */
    List<CmsTerminalUser> queryCheckTerminalUser(CmsApplyJoinTeam team, Pagination page, PaginationApp pageApp);

    /**
     * 前端2.0我管理的团体-消息审核个数
     * @param map
     * @return
     */
    int queryCheckTerminalUserCount(Map<String, Object> map);

    /**
     * 后端2.0根据省市区查询管理员用户
     * @param terminalUser
     * @return 会员对象集合
     */
    List<CmsTerminalUser> queryTerminalUserByArea(CmsTerminalUser terminalUser);

    /**
     * 前端2.0 团体详情 管理人
     * @param tuserId
     * @return
     */
    String queryUserNickNameByTuserId(String tuserId);

    public List<CmsTerminalUser> getCmsTerminalUserList(Map<String,Object> params);

    CmsTerminalUser getCmsTerminalUserByMobile(String userMobileNo);

    /**
     * 发送注册码 验证手机信息
     */
    Map<String,Object> sendSmsCode(String userMobileNo,String userName,String userPwd,Integer userSex,HttpServletRequest request) throws ParseException;
    Map<String,Object> sendSmsCode(String userMobileNo) throws ParseException;
    /**
     *保存用户信息
     * @param user 用户信息
     * @param code 短信码
     * @return
     */
    String saveUser(CmsTerminalUser user, String code,HttpSession session);

    String saveRegUser(CmsTerminalUser user, String code,HttpSession session);

    String modifyInfoSendCode(String userId,String userMobileNo) throws ParseException;


    CmsTerminalUser queryByOpenId(Map<String,Object> params);

    CmsTerminalUser queryByWebOpenId(Map<String,Object> params);

    /**
     * 发短信
     * @param userMobileNo
     * @param smsContent
     * @return
     */
    String sendSmsMessage(String userMobileNo,String smsContent);

    /**
     * 完成注册信息
     * @param userId 用户id
     * @param userMobileNo 用户手机
     * @return
     */
    public Map<String,Object> completeInfoSendCode(String userId, String userMobileNo) throws ParseException;

    public Map<String,Object> completeInfoSendCode2(String userId, final String userMobileNo) throws ParseException ;


    /**
     * 根据手机号码查询是否有数据
     * @param userMobile
     * @return
     */
    CmsTerminalUser terminalUserMobileExists(String userMobile);


    CmsTerminalUser queryFrontTerminalUser(Map<String,Object> map);



   // int editAppTerminalUserById(CmsTerminalUser terminalUser);



    /**
     * app根据用户名与密码获取用户对象
     * @param user 用户对象
     * @return
     */
    CmsTerminalUser queryAppTerminalUserByCondition(CmsTerminalUser user);

    Map<String,Object> sendForgetSmsCode(String userMobileNo) throws ParseException;

    Map<String,Object> sendForgetSmsCode(String userMobileNo,String from,HttpSession session) throws ParseException;

    int queryByIp(Map<String,Object> params);

    public String testAddTerminalUser(CmsTerminalUser user);

    /*微信通过微信网站登录后保存openId*/
    public  CmsTerminalUser queryByWxOpenId(String wxOpenId);

    public  CmsTerminalUser publicLogin(CmsTerminalUser user);

    Integer editUserByReaderCard(Map<String,Object> params);

    CmsTerminalUser queryUserByReaderCard(String readerCard);
}
