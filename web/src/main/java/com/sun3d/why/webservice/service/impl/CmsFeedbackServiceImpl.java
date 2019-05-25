package com.sun3d.why.webservice.service.impl;

import com.sun3d.why.dao.CmsFeedbackMapper;
import com.sun3d.why.model.CmsFeedback;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.webservice.service.CmsFeedbackService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional
public class CmsFeedbackServiceImpl implements CmsFeedbackService {
 @Autowired
private CmsFeedbackMapper cmsFeedbackMapper;
    @Override
    public int insertFeedInformation(CmsFeedback cmsFeedback) {
         cmsFeedback.setFeedBackId(UUIDUtils.createUUId());
         cmsFeedback.setFeedTime(new Date());
        return cmsFeedbackMapper.insertFeedInformation(cmsFeedback);
    }

    /**
     * app获取用户反馈列表
     * @param userId 用户id
     * @param pageApp 分页对象
     * @return
     */
    @Override
    public String queryAppFeedInformationListById(String userId, PaginationApp pageApp) {
         Map<String,Object> map=new HashMap<String, Object>();
        if(userId!=null && StringUtils.isNotBlank(userId)){
            map.put("userId",userId);
        }
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        List<CmsFeedback> feedBackList=cmsFeedbackMapper.queryAppFeedInformationListById(map);
        return null;
    }

    /**
     * 根据反馈对象进行查询
     * @param cmsFeedback 反馈对象
     * @param page 分页对象
     * @return
     */
    @Override
    public List<CmsFeedback> queryFeedInformationByContent(CmsFeedback cmsFeedback, Pagination page) {

         Map<String, Object> map = new HashMap<String, Object>();
        //反馈内容
        if (cmsFeedback != null && StringUtils.isNotBlank(cmsFeedback.getFeedContent())) {
            map.put("feedcontent", "%" + cmsFeedback.getFeedContent() + "%");
        }
        /*//字典编码
        if (sysDict != null && StringUtils.isNotBlank(sysDict.getDictCode())) {
            map.put("dictCode", "%"+sysDict.getDictCode() + "%");
        }*/
        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
        }
        int total = cmsFeedbackMapper.queryFeedInformationByCount(map);
        //设置分页的总条数来获取总页数
        page.setTotal(total);
        return cmsFeedbackMapper.queryFeedInformationByContent(map);
    }
}