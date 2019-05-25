package com.sun3d.why.webservice.service.impl;

import com.sun3d.why.dao.CmsActivityVoteMapper;
import com.sun3d.why.model.CmsActivityVote;
import com.sun3d.why.model.extmodel.NestedUrl;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.webservice.service.UserActivityVoteAppService;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by wangkun on 2016/2/25.
 */
@Service
@Transactional
public class UserActivityVoteAppServiceImpl implements UserActivityVoteAppService {
    @Autowired
    private NestedUrl nestedUrl;
    @Autowired
    private CmsActivityVoteMapper cmsActivityVoteMapper;
    @Autowired
    private StaticServer staticServer;
    /**
     * app查询活动投票信息
     * @param activityId 活动id
     * @return
     */
    @Override
    public String queryAppUserVoteById(String activityId) {
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        Map<String,Object> map=new HashMap<String, Object>();
        if(activityId!=null&& StringUtils.isNotBlank(activityId)){
            map.put("activityId",activityId);
        }
        List<CmsActivityVote> voteList=cmsActivityVoteMapper.queryAppUserVoteById(map);
        if(CollectionUtils.isNotEmpty(voteList)){
            for(CmsActivityVote votes:voteList){
                Map<String, Object> mapVote = new HashMap<String, Object>();
                String voteCoverImgUrl = "";
                if (StringUtils.isNotBlank(votes.getVoteCoverImgUrl())) {
                    voteCoverImgUrl = staticServer.getStaticServerUrl() + votes.getVoteCoverImgUrl();
                }
                mapVote.put("voteCoverImgUrl", voteCoverImgUrl);
                mapVote.put("voteCount",votes.getTotals()>0?votes.getTotals():0);
                mapVote.put("voteAddress",nestedUrl.getNestedUrl()+"frontVote/detail.do?dataId="+votes.getVoteId());
                mapVote.put("voteTitel",votes.getVoteTitel()!=null?votes.getVoteTitel():"");
                mapVote.put("voteDescribe",votes.getVoteDescribe()!=null?votes.getVoteDescribe():"");
                mapVote.put("voteContent",votes.getVoteContent()!=null?votes.getVoteContent():"");
                mapVote.put("voteId",votes.getVoteId()!=null?votes.getVoteId():"");
                listMap.add(mapVote);
            }
        }

        // 查询总数
        int count = cmsActivityVoteMapper.queryAppUserVoteCountById(map);
        return JSONResponse.toAppResultObject(0, listMap, count);
    }

    /**
     * app查询活动投票列表
     * @param activityId 活动id
     * @param pageApp     分页对象
     * @return
     */
    @Override
    public String queryAppActivityVoteById(String activityId, PaginationApp pageApp) {
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        Map<String, Object> map = new HashMap<String, Object>();
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        if(activityId!=null && StringUtils.isNotBlank(activityId)){
            map.put("activityId",activityId);
        }
        List<CmsActivityVote> voteList=cmsActivityVoteMapper.queryVoteList(map);
        for(CmsActivityVote votes:voteList){
            Map<String, Object> mapVote = new HashMap<String, Object>();
            String voteCoverImgUrl = "";
            if (StringUtils.isNotBlank(votes.getVoteCoverImgUrl())) {
                voteCoverImgUrl = staticServer.getStaticServerUrl() + votes.getVoteCoverImgUrl();
            }
            mapVote.put("voteCoverImgUrl", voteCoverImgUrl);
            mapVote.put("voteTitel",votes.getVoteTitel()!=null?votes.getVoteTitel():"");
            mapVote.put("voteDescribe",votes.getVoteDescribe()!=null?votes.getVoteDescribe():"");
            mapVote.put("voteAddress",nestedUrl.getNestedUrl()+"frontVote/detail.do?dataId="+votes.getVoteId());
            listMap.add(mapVote);
        }
        return  JSONResponse.toAppResultFormat(0, listMap);
    }
}
