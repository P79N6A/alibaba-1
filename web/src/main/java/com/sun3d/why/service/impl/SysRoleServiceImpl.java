package com.sun3d.why.service.impl;

import com.sun3d.why.dao.SysRoleMapper;
import com.sun3d.why.model.SysRole;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.SysRoleService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional
public class SysRoleServiceImpl implements SysRoleService {

    @Autowired
    private SysRoleMapper roleMapper;

    private Logger logger = Logger.getLogger(SysRoleServiceImpl.class);

    @Override
    public List<SysRole> queryRoleByUserId(String userId) {
        return roleMapper.queryRoleByUserId(userId);
    }

    /**
     * 角色列表首页
     *
     * @param role 角色信息
     * @return List<SysRole> 角色列表
     */
    @Override
    public List<SysRole> queryRoleByCondition(SysRole role, Pagination page) {
        Map<String, Object> map = new HashMap<String, Object>();
        if (role != null && StringUtils.isNotBlank(role.getRoleName())) {
            map.put("roleName", "%" + role.getRoleName() + "%");
        }

        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
        }
        map.put("roleState", Constant.NORMAL);
        int total = roleMapper.queryRoleCountByCondition(map);
        //设置分页的总条数来获取总页数
        page.setTotal(total);
        return roleMapper.queryRoleByCondition(map);
    }

    /**
     * 后台新增角色
     *
     * @param role 角色信息
     * @return failure 添加失败 ,success 添加成功
     */
    public String addRole(SysRole role, SysUser user) {
        try {
            if (role != null && user != null) {
                //1.验证非删除状态下的角色不可重复
                if (StringUtils.isNotBlank(role.getRoleName())) {
                    boolean exists = this.queryRoleNameIsExists(role.getRoleName().trim());
                    if (exists) {
                        return Constant.RESULT_STR_REPEAT;
                    }
                }
                Map<String, Object> map = new HashMap<String, Object>();
                map.put("roleState", Constant.NORMAL);
                int count = roleMapper.queryRoleCountByCondition(map);
                role.setRoleId(UUIDUtils.createUUId());
                role.setRoleSort(count + 1);
                role.setRoleState(Constant.NORMAL);
                // 用户为系统登陆用户
                role.setRoleCreateUser(user.getUserId());
                role.setRoleCreateTime(new Date());
                role.setRoleUpdateUser(user.getUserId());
                role.setRoleUpdateTime(new Date());
                roleMapper.addRole(role);
            }
        } catch (Exception e) {
            logger.info("addRole error" + e);
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_SUCCESS;
    }

    /**
     * 验证角色名称不可重复
     *
     * @param roleName 角色名称
     * @return true 重复,false 不重复
     */
    @Override
    public boolean queryRoleNameIsExists(String roleName) {
        if (StringUtils.isNotBlank(roleName)) {
            return roleMapper.queryRoleNameIsExists(roleName) > 0;
        }
        return false;
    }

    /**
     * 修改活动信息状态为已删除
     *
     * @param roleId 主键
     * @return false 修改失败,true 修改成功
     */
    @Override
    public boolean updateRoleStateStatus(String roleId) {
        if (StringUtils.isNotBlank(roleId)) {
            SysRole role = new SysRole();
            role.setRoleState(Constant.DELETE);
            role.setRoleId(roleId);
            return roleMapper.editRole(role) > 0;
        }
        return false;
    }

    /**
     * 根据角色id查询角色对象
     *
     * @param roleId 角色id
     * @return 角色对象
     */
    public SysRole queryRoleById(String roleId) {
        return roleMapper.queryRoleById(roleId);
    }

    /**
     * 后台更新角色
     *
     * @param role 角色信息
     * @param user 用户信息
     * @return failure 更新失败 ,success 更新成功
     */
    public String editRole(SysRole role, SysUser user) {
        try {
            if (role != null) {
                if (StringUtils.isNotBlank(role.getRoleId())) {
                    SysRole sysRole = roleMapper.queryRoleById(role.getRoleId());
                    // 当前角色名称没有更新
                    if (sysRole != null && StringUtils.isNotBlank(role.getRoleName()) && !sysRole.getRoleName().equals(role.getRoleName())) {
                        boolean exists = this.queryRoleNameIsExists(role.getRoleName().trim());
                        if (exists) {
                            return Constant.RESULT_STR_REPEAT;
                        }
                    }
                    role.setRoleUpdateTime(new Date());
                    role.setRoleUpdateUser(user.getUserId());
                    int count = roleMapper.editRole(role);
                    if (count > 0) {
                        return Constant.RESULT_STR_SUCCESS;
                    }
                }
            }
        } catch (Exception e) {
            logger.info("editRole error" + e);
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_FAILURE;
    }

    /**
     * 得到所有角色
     *
     * @return List<SysRole>
     */
    public List<SysRole> queryRoleByConditionOrderRoleSort() {
        return roleMapper.queryRoleByConditionOrderRoleSort();
    }
}
