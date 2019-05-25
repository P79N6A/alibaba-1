package com.sun3d.why.service.impl;

import com.sun3d.why.dao.SysModuleMapper;
import com.sun3d.why.model.SysModule;
import com.sun3d.why.service.SysModuleService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.UUIDUtils;
import org.apache.commons.collections.CollectionUtils;
import org.apache.log4j.Logger;
import org.jdom2.Document;
import org.jdom2.Element;
import org.jdom2.input.SAXBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

/**
 * 模块服务层实现类
 * 事务管理层
 * 需要用到事务的功能都在此编写
 *
 * Created by wangfan on 2015/4/22.
 */
@Service
@Transactional
public class SysModuleServiceImpl implements SysModuleService {

    /**
     * 自动注入数据操作层dao实例
     */
    @Autowired
    private SysModuleMapper sysModuleMapper;

    private Logger logger = Logger.getLogger(SysModuleServiceImpl.class);

    /**
     *根据角色id查询权限
     * @param roleId
     * @return 权限列表信息
     */
    @Override
    public List<SysModule> queryModuleByRoleId(String roleId){
        return sysModuleMapper.queryModuleByRoleId(roleId);
    }

    /**
     * 查询所有权限
     * @param moduleState
     * @return 权限列表信息
     */
    @Override
    public List<SysModule> queryModuleByModuleState(Integer moduleState){
        return sysModuleMapper.queryModuleByModuleState(moduleState);
    }

    /**
     * 登录是需要调用此借口，用于屏蔽掉非关联权限
     *
     * @param userId String
     * @return List<SysModule>
     */
    @Override
    public List<SysModule> selectModuleByUserId(String userId){
        return sysModuleMapper.selectModuleByUserId(userId);
    }

    @Override
    public String initModule(String userId){
        SAXBuilder bui = new SAXBuilder();
        Document doc = null;
        int sort=0;
        try{
            doc = bui.build(SysModuleServiceImpl.class.getResourceAsStream("/initModule.xml"));
            Element element=null;
            Element root = doc.getRootElement();
            List<Element> list = root.getChildren();
            if(CollectionUtils.isNotEmpty(list)){
                Date date = new Date();
                for (int i = 0; i < list.size(); i++) {
                    element = list.get(i);
                    // 父节点
                    String name = element.getAttributeValue("name");
                    String url = element.getAttributeValue("url");
                    String modelId = "";
                    sort = sort + 1;
                    String parentId = addOrEditModule(userId,date,name,url,modelId, "0",sort);

                    // 子节点
                    List<Element> son =element.getChildren();
                    for (int j = 0; j < son.size(); j++) {
                        sort = sort + 1;
                        Element e = son.get(j);
                        String methodName = e.getAttributeValue("methodName");
                        String url1 = e.getAttributeValue("url");
                        addOrEditModule(userId,date,methodName,url1,modelId,parentId,sort);
                    }
                }
            }
            return Constant.RESULT_STR_SUCCESS;
        }catch (Exception e){
            logger.error("initModule error", e);
            return Constant.RESULT_STR_FAILURE;
        }
    }

    private String addOrEditModule(String userId,Date date,String moduleName,String url,String moduleId,String parentModuleId,int sort){
        SysModule module = new SysModule();
        module.setModuleId(moduleId);
        module.setModuleName(moduleName);
        module.setModuleUrl(url);
        module.setModuleParentId(parentModuleId);
        module.setModuleState(1);
        module.setModuleCreateTime(date);
        module.setModuleCreateUser(userId);
        module.setModuleUpdateTime(date);
        module.setModuleUpdateUser(userId);
        module.setModuleSort(sort);

        if("0".equals(parentModuleId)){
            SysModule sysModule = sysModuleMapper.queryParentModuleByUrl(url);
            if(sysModule != null){ // 大于0更新，否则新增
                module.setModuleId(sysModule.getModuleId());
                sysModuleMapper.editModuleById(module);
            }else{
                module.setModuleId(UUIDUtils.createUUId());
                sysModuleMapper.addModule(module);
            }
        }else{
            SysModule sysModule = sysModuleMapper.queryChildModuleByUrl(url);
            if(sysModule != null){ // 大于0更新，否则新增
                module.setModuleId(sysModule.getModuleId());
                module.setModuleParentId(sysModule.getModuleParentId());
                sysModuleMapper.editModuleById(module);
            }else{
                module.setModuleId(UUIDUtils.createUUId());
                sysModuleMapper.addModule(module);
            }
        }
        return module.getModuleId();
    }
}
