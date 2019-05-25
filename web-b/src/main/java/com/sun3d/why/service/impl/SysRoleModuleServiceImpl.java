package com.sun3d.why.service.impl;

import com.sun3d.why.dao.SysRoleModuleMapper;
import com.sun3d.why.model.SysRoleModule;
import com.sun3d.why.service.SysRoleModuleService;
import com.sun3d.why.util.Constant;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class SysRoleModuleServiceImpl implements SysRoleModuleService {

    @Autowired
    private SysRoleModuleMapper roleModuleMapper;

    private Logger logger = LoggerFactory.getLogger(SysRoleModuleServiceImpl.class);

    /**
     * 新增角色权限关联表
     *
     * @param roleId
     * @param moduleArr
     * @return success 添加成功, failure 添加失败
     */
    @Override
    public String saveRoleModule(String roleId, String[] moduleArr) {
        try {

            if (StringUtils.isNotBlank(roleId) && moduleArr != null && moduleArr.length > 0) {
                roleModuleMapper.deleteRoleModuleByRoleId(roleId);

                for (String moduleId : moduleArr) {
                    if (StringUtils.isNotBlank(moduleId)) {
                        SysRoleModule record = new SysRoleModule();
                        record.setModuleId(moduleId);
                        record.setRoleId(roleId);
                        roleModuleMapper.addRoleModule(record);
                    }
                }

                return Constant.RESULT_STR_SUCCESS;
            }
        } catch (Exception e) {
            logger.info("saveRoleModule", e);
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_FAILURE;
    }
}
