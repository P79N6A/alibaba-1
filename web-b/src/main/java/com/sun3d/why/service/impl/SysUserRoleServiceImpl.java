package com.sun3d.why.service.impl;

import com.sun3d.why.dao.SysUserRoleMapper;
import com.sun3d.why.model.SysUserRole;
import com.sun3d.why.service.SysUserRoleService;
import com.sun3d.why.util.Constant;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class SysUserRoleServiceImpl implements SysUserRoleService {

    @Autowired
    private SysUserRoleMapper userRoleMapper;

    private Logger logger = Logger.getLogger(SysUserRoleServiceImpl.class);

    public String saveUserRole(String userId, String[] roleArr) {
        try {
            if (StringUtils.isNotBlank(userId) && roleArr != null && roleArr.length > 0) {
                //删除该userId的全部数据，在添加
                userRoleMapper.deleteUserRoleByUserId(userId);
                for (String roleId : roleArr) {
                    if (StringUtils.isNotBlank(roleId)) {
                        SysUserRole record = new SysUserRole();
                        record.setRoleId(roleId);
                        record.setUserId(userId);
                        userRoleMapper.addUserRole(record);
                    }
                }
                return Constant.RESULT_STR_SUCCESS;
            }
        } catch (Exception e) {
            logger.error("saveUserRole error", e);
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_FAILURE;
    }
}
