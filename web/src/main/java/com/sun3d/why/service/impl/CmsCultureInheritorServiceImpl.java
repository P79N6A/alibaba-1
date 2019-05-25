package com.sun3d.why.service.impl;

import com.sun3d.why.dao.CmsCultureInheritorMapper;
import com.sun3d.why.model.CmsCultureInheritor;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsCultureInheritorService;
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
public class CmsCultureInheritorServiceImpl implements CmsCultureInheritorService {

    @Autowired
    private CmsCultureInheritorMapper cultureInheritorMapper;

    private Logger logger = Logger.getLogger(CmsCultureInheritorServiceImpl.class);

    /**
     * 新增非遗传承人
     * @param inheritor
     * @param sysUser
     * @return
     */
    @Override
    public String addCultureInheritor(CmsCultureInheritor inheritor, SysUser sysUser){
        try{
            if(sysUser != null){
                Date date = new Date();
                inheritor.setInheritorId(UUIDUtils.createUUId());
                inheritor.setInheritorCreateTime(date);
                inheritor.setInheritorCreateUser(sysUser.getUserId());
                inheritor.setInheritorUpdateTime(date);
                inheritor.setInheritorUpdateUser(sysUser.getUserId());
                cultureInheritorMapper.addCultureInheritor(inheritor);
                return Constant.RESULT_STR_SUCCESS;
            }
        }catch (Exception e){
            e.printStackTrace();
            logger.info("addCultureInheritor error", e);
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_FAILURE;
    }

    /**
     * 按非遗id查询传承人列表
     * @param inheritor
     * @param page
     * @return
     */
    @Override
    public List<CmsCultureInheritor> queryCultureInheritorByCondition(CmsCultureInheritor inheritor, Pagination page) {
        Map<String, Object> map = new HashMap<String, Object>();
        if(inheritor != null && StringUtils.isNotBlank(inheritor.getCultureId())){
            map.put("cultureId", inheritor.getCultureId());
        }
        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            int total = cultureInheritorMapper.queryCultureInheritorCountByCondition(map);
            page.setTotal(total);
        }
        return cultureInheritorMapper.queryCultureInheritorByCondition(map);
    }

    /**
     * 根据传承人id查询
     * @param inheritorId
     * @return
     */
    @Override
    public CmsCultureInheritor queryCultureInheritorById(String inheritorId) {
        return cultureInheritorMapper.queryCultureInheritorById(inheritorId);
    }

    /**
     * 更新传承人
     * @param inheritor
     * @return
     */
    @Override
    public String editCultureInheritor(CmsCultureInheritor inheritor, SysUser sysUser) {
        try{
            if(sysUser != null){
                inheritor.setInheritorUpdateUser(sysUser.getUserId());
                inheritor.setInheritorUpdateTime(new Date());
                cultureInheritorMapper.editCultureInheritor(inheritor);
                return Constant.RESULT_STR_SUCCESS;
            }
        }catch (Exception e){
            logger.info("editCultureInheritor error", e);
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_FAILURE;
    }

    /**
     * 根据id删除传承人
     * @param inheritorId
     */
    @Override
    public void deleteCultureInheritorById(String inheritorId) {
        cultureInheritorMapper.deleteCultureInheritorById(inheritorId);
    }
}
