package com.sun3d.why.webservice.api.util;

/**
 * Created by chenjie on 2016/2/29.
 */
public class TerminalUserConstant {

    /**
     * 用户来源【文化上海云】
     */
    public final static Integer SOURCE_CODE_SHANGHAI = 0;

    /**
     * 用户来源【文化嘉定云】
     */
    public final static Integer SOURCE_CODE_JIADING = 1;

    /**
     * 文化云渠道注册用户信息【插入用户信息】
     */
    public final static Integer INSERT_USER_INFO = 101;

    /**
     * 保存第三方用户登录【插入用户信息】
     */
    public final static Integer INSERT_THIRD_LOGIN = 102;

    /**
     * 修改基本信息【修改用户信息】
     */
    public final static Integer UPDATE_USER_INFO = 201;

    /**
     * 修改用户密码【修改用户信息】
     */
    public final static Integer UPDATE_USER_PASSWORD = 202;

    /**
     * 激活用户【修改用户信息】
     */
    public final static Integer UPDATE_USER_ACTIVE = 203;

    /**
     * 冻结用户【修改用户信息】
     */
    public final static Integer UPDATE_USER_FREEZE = 204;

    /**
     * 激活用户评论功能【修改用户信息】
     */
    public final static Integer UPDATE_USER_COMMENT_ACTIVE = 205;

    /**
     * 冻结用户评论功能【修改用户信息】
     */
    public final static Integer UPDATE_USER_COMMENT_DISABLE = 206;

    /**
     * 冻结用户评论功能【修改用户信息】
     */
    public final static Integer UPDATE_USER_MOBILE_NO = 207;

    /**
     * 逻辑删除用户【删除用户信息】
     */
    public final static Integer DELETE_USER_LOGIC = 301;

    /**
     * 物理删除用户【删除用户信息】
     */
    public final static Integer DELETE_USER_PHYSICAL = 302;
}
