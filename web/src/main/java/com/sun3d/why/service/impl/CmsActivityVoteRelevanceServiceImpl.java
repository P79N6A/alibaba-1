package com.sun3d.why.service.impl;

import com.sun3d.why.dao.CmsActivityVoteRelevanceMapper;
import com.sun3d.why.model.CmsActivityVoteRelevance;
import com.sun3d.why.service.CmsActivityVoteRelevanceService;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class CmsActivityVoteRelevanceServiceImpl implements CmsActivityVoteRelevanceService {

    //log4j日志
    private Logger logger = Logger.getLogger(CmsActivityVoteRelevanceServiceImpl.class);

    @Autowired
    private CmsActivityVoteRelevanceMapper cmsActivityVoteRelevanceMapper;
    /**
     * 添加投票信息关联表记录
     * @para CmsActivityVoteRelevance
     * @return int 插入结果
     * @authours hucheng
     * @date 2016-2-19
     */
    @Override
   public  int addCmsActivityVoteRelevance(CmsActivityVoteRelevance cmsActivityVoteRelevance){

      return this.cmsActivityVoteRelevanceMapper.addCmsActivityVoteRelevance(cmsActivityVoteRelevance);

    }


    /**
     * 投票统计
     * @para voteId
     * @return list
     * @authours hucheng
     * @date 2016-2-19
     */
    @Override
    public List<CmsActivityVoteRelevance> queryVoteStatistics(String voteId){
        return this.cmsActivityVoteRelevanceMapper.queryVoteStatistics(voteId);

    }
}