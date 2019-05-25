package com.sun3d.why.service;

import com.sun3d.why.model.CmsVenue;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.extmodel.AreaData;

import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * 用户管理接口
 * Created by yujinbing on 2015/4/27.
 */
public interface CmsUserService {

    /**
     * 根据用户Id删除用户信息
     * @param userId 用户id
     * @return 1成功  0失败
     */
    int deleteSysUserByUserId(String userId);

    /**
     * 插入用户信息
     * @param record
     * @return 1成功  0失败
     */
    int addSysUser(SysUser record);


    /**
     * 根据用户Id查询用户信息
     * @param userId 用户Id
     * @return 用户对象
     */
    SysUser querySysUserByUserId(String userId);


    /**
     * 根据用户对象Id更新用户信息
     * @param record
     * @return 1成功  0失败
     */
    int editBySysUser(SysUser record);


    /**
     * 根据登录用户信息查询子级未分配场馆用户的信息
     * @param loginUser
     * @return
     */
    List<SysUser> getNotAssignedUsers(SysUser loginUser);

    /**
     * 修改用户的path
     * @param userId 需要修改的用户Id
     * @param newUserPath 新的用户路径
     * @param loginUser 登录的用户
     * @param cmsVenue 场馆
     * @return 1成功  0失败
     */
    int updateUserPath(String userId ,String newUserPath,SysUser loginUser, CmsVenue cmsVenue);

    /**
     * 更加用户条件 查询用户信息
     * @param sysUser
     * @return
     */
    List<SysUser> querySysUserByCondition(SysUser sysUser);

    /**
     * 根据Hashmap的值 查询用户信息
     * @param map
     * @return
     */
    List<SysUser> querySysUserByMap(Map<String, Object> map);

    /**
     * 根据HashMap的值查询满足条件的数量
     * @param map
     * @return
     */
    int queryUserCountByCondition(Map<String, Object> map);

    /**
     * 后台用户列表页面信息查询
     * @param map
     * @return
     */
    public List<SysUser> querySysUserIndex(Map<String, Object> map);

    /**
     * 后台用户信息的总数量
     * @param map
     * @return
     */
    public int querySysUserIndexCount(Map<String, Object> map);

    public Map<String,SysUser> getUsersInfo(Set<String> set);


    /**
     * 修改编辑用户信息
     * @param user
     * @param loginUser
     * @param birthday
     * @param userProvinceText
     * @param userCityText
     * @param userCountyText
     * @return success 成功    其他的为失败
     */
    public String editSysUserByLoginUser(SysUser user, SysUser loginUser, String birthday, String userProvinceText, String userCityText, String userCountyText);

    /**
     * 检查用户是否能登录后台
     * @param userAccount
     * @param userPassword
     * @return null 表示失败
     */
    public SysUser loginCheckUser(String userAccount, String userPassword);

    /**
     * 检查该用户是否能进行创建
     * @param user
     * @param loginUser
     * @param userProvinceText
     * @param userCityText
     * @param userCountyText
     * @param birthday
     * @return success 为成功  其他的为失败
     */
    public String checkUserCanSave(SysUser user ,SysUser loginUser,String userProvinceText, String userCityText, String userCountyText,String birthday);

    /**
     * app根据后台用户id获取相应信息
     * @param userAccount  用户账号
     * @param userPassword 用户密码
     * @return
     */
    String  queryAppSysUserById(String userAccount, String userPassword);
    
    /**
	 * 查询管理员所有的区域信息
	 * @return 管理员区域信息列表
	 */
	List<AreaData> queryUserAllArea();

    /**
     * @根据用户名查找用户信息
     * @para userAccount
     * @return SysUser
     * @authour  hucheng
     * @content add
     * @date  2016/1/20
     * */
    SysUser querySysUserByUserAccount(String userAccount);
    
    /**
     * 检查用户是否能登录后台(SSO,只判断userAccount)
     * @param userAccount
     * @return null 表示失败
     */
    public SysUser loginCheckUserAccount(String userAccount);
}
