package com.sun3d.why.webservice.service;


import java.text.ParseException;
import java.util.Date;

import org.springframework.web.multipart.MultipartFile;

import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.util.PaginationApp;

public interface TerminalUserAppService {
    /**
     * app绑定第三方账号
     * @param userId 用户id
     * @param openId 第三方登陆返回的openid
     * @param register_type 该账户绑定方式 1 文化云 2 QQ  3 新浪微博 4 微信
     * @return
     */
   public String queryTerminalUserById(String userId, String openId, String register_type);

    /**
     * app根据手机号码查询用户信息
     * @param user 用户对象
     * @param code 验证码
     * @return
     */
    public String queryTerminalUserMobileExist(String code,CmsTerminalUser user);

    /**
     * app用户登录
     * @param user 用户对象
     * @return
     */
    public String terminalLogin(CmsTerminalUser user);

    /**
     * app根据openId获取用户信息
     * @param terminalUser 用户对象
     * @return
     */
    public String queryTerminalUserByOpenId(CmsTerminalUser terminalUser) throws ParseException;

    /**
     * app上传文件根据用户id获取用户信息
     * @param userId 用户id
     * @param teamUserId 团体id
     * @param mulFile 文件流对象
     * @param uploadType   上传类型 1.多文件 2.用户头像 3.团体用户 4.玩家秀
     * @param modelType  模块类型 1.活动 2.个人头像 3.多图片(评论) 4.首页轮播
     * @return
     */
   public  String queryTerminalUserFilesById(String userId,String teamUserId,MultipartFile mulFile,String uploadType, String modelType)throws Exception;

    /**
     * app编辑用户信息
     * @param updateTerminalUser 更新对象
     * @param terminalUser 用户对象
     * @return
     */
    public  String editTerminalUserById(CmsTerminalUser updateTerminalUser,CmsTerminalUser terminalUser) throws ParseException;

    /**
     * app根据用户id获取用户信息
     * @param userId 用户id
     * @return
     */
     CmsTerminalUser queryTerminalUserByUserId(String userId);

    /**
     * app更新用户密码
     * @param updateTerminalUser 更新对象
     * @param password 原密码
     * @param newPassword 新密码
     * @return
     */
     String editTerminalUserPwdById(CmsTerminalUser updateTerminalUser, String password, String newPassword);

  /**
  * 获取用户信息
  * @param userId
  * @return
  */
  public  String queryCmsTerminalUserById(String userId);

 /**
  * app根据电话号码查询用户信息
  * @param userMobileNo 电话号码
  * @param newPassword 新密码
  * @param code 验证码
  * @return
  */
  public String queryTerminalUserByMobile(String userMobileNo,String newPassword,String code);

    /**
     * app根据手机号码获取验证码
     * @param userMobileNo 手机号码
     * @return
     */
  public  String sendTerminUserCode(String userMobileNo);

    /**
     * app根据手机号码查询用户信息
     * @param userMobileNo
     * @return
     */
   public String queryTerminalUserByMobileNo(String userMobileNo);

    /**
     * app绑定手机号码
     * @param userId 用户id
     * @param userMobileNo 手机号码
     * @return
     */
  public String bindingMobileNo(String userId, String userMobileNo);

    /**
     * app绑定手机时验证手机号码与验证码是否一致
     * @param cmsTerminalUser 用户对象
     * @return
     */
   public String queryAppValidateCode(CmsTerminalUser cmsTerminalUser);
   
   /** 3.5.2 app 用户实名认证 发送验证码
     * @param cmsTerminalUser
	 * @param userMobileNo
	 * @return
	 */
   public String sendAuthCode(CmsTerminalUser cmsTerminalUser,String userMobileNo);
   
   /**
    * 3.5.2 用户实名验证
	 * @param userId
	 * @param nickName
	 * @param code
	 * @param idCardNo
	 * @param idCardPhotoUrl
	 * @return
	 */
	public String userAuth(String userId,
			    String nickName,
			    String userTelephone,
			    String code,
			    String idCardNo,
			    String idCardPhotoUrl,
			    String userEmail);
	
	/**
	 * 3.5.2 查询用户积分明细列表
	 * @param pageApp
	 * @param userId
	 * @param beforeDate 某个日期之后的积分
	 * @return
	 */
	public String queryUserIntegralDetail(PaginationApp pageApp, String userId,Date beforeDate);
}
