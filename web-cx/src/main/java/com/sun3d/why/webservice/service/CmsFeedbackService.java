package com.sun3d.why.webservice.service;

import com.sun3d.why.model.CmsFeedback;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.PaginationApp;

import java.util.List;

/**
 * Created by Administrator on 2015/7/16.
 */
public interface CmsFeedbackService {
  //  int insertFeedInformation(String userId, String content);

    /**
     * 反馈对象进行查询
     * @param cmsFeedback
     * @param page
     * @return
     */
    List<CmsFeedback> queryFeedInformationByContent(CmsFeedback cmsFeedback, Pagination page);

    /**
     * 用户反馈信息
     * @param cmsFeedback
     * @return
     */
    int insertFeedInformation(CmsFeedback cmsFeedback);

    /**
     * app获取用户反馈列表
     * @param userId 用户id
     * @param pageApp 分页对象
     * @return
     */
    public String queryAppFeedInformationListById(String userId, PaginationApp pageApp);
}
