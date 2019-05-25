package com.sun3d.why.controller;

import com.sun3d.why.dao.CmsActivityVoteRelevanceMapper;
import com.sun3d.why.model.CmsActivityVote;
import com.sun3d.why.model.CmsActivityVoteRelevance;
import com.sun3d.why.service.CmsActivityVoteService;
import com.sun3d.why.service.CmsUserVoteService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by hucheng on 2016/2/17.
 * 投票管理controller
 */

@Controller
@RequestMapping(value="/vote")
public class CmsActivityVoteController {

    //log4j日志
    private Logger logger = Logger.getLogger(CmsActivityVoteController.class);

    @Autowired
    private CmsActivityVoteService cmsActivityVoteService;

    @Autowired
    private CmsActivityVoteRelevanceMapper cmsActivityVoteRelevanceMapper;

    @Autowired
    private CmsUserVoteService cmsUserVoteService;

    @RequestMapping("/activityVoteIndex")
    public ModelAndView activityVoteIndex(CmsActivityVote cmsActivityVote, Pagination page) {

        ModelAndView model = new ModelAndView();
        List<CmsActivityVote> list = null;
        try{
            list = cmsActivityVoteService.queryActivityVoteByCondition(cmsActivityVote,page);
            model.addObject("list",list);
            model.addObject("cmsActivityVote",cmsActivityVote);
            model.addObject("page", page);
            model.setViewName("admin/activityVote/voteIndex");
        }catch (Exception e){
            logger.error("activityVoteIndex error {}",e);
        }

        return model;
    }


    /**
     * 进入添加投票页面
     * */
    @RequestMapping("/perAddActivityVote")
    public ModelAndView perAddActivityVote( ) {

        ModelAndView model = new ModelAndView();
        model.setViewName("admin/activityVote/addVote");
        return model;
    }


    @RequestMapping(value="/addActivityVote")
    @ResponseBody
    public String addActivityVote(CmsActivityVote cmsActivityVote,String voteContents,String voteImgUrls) {
        try{
            CmsActivityVote vote = cmsActivityVoteService.queryActivityVoteByVoteTitel(cmsActivityVote.getVoteTitel());
            if(null != vote){
                logger.error("addActivityVote repeat!");
                return Constant.RESULT_STR_REPEAT;
            }
            int success = cmsActivityVoteService.addActivityVote(cmsActivityVote,voteContents,voteImgUrls);
            if(success>0){
                return Constant.RESULT_STR_SUCCESS;
            }else{
                return Constant.RESULT_STR_FAILURE;
            }
        }catch (Exception e){
            logger.error("addActivityVote error {}",e);
            return Constant.RESULT_STR_FAILURE;
        }
    }


    @RequestMapping(value="/deleteActivityVote")
    @ResponseBody
    public String deleteActivityVote(CmsActivityVote cmsActivityVote) {
        try{
            if(cmsActivityVote != null){
                int total = cmsUserVoteService.queryCmsUserVoteByVoteIdList(cmsActivityVote.getVoteId());
                if(total >0){
                    logger.error("该记录已经有用户投票了不能删除");
                    return "votingRecords";

                }
                int success = cmsActivityVoteService.deleteActivityVote(cmsActivityVote.getVoteId());
                if(success>0){
                    return Constant.RESULT_STR_SUCCESS;
                }else{
                    return Constant.RESULT_STR_FAILURE;
                }
            }
        }catch (Exception e){
            logger.error("addActivityVote error {}",e);
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_FAILURE;
    }


    /**
     * 进入修改投票页面
     * */
    @RequestMapping("/perEditActivityVote")
    public ModelAndView perEditActivityVote(String voteId ) {
        CmsActivityVote cmsActivityVote = null;
        List<CmsActivityVoteRelevance> list = new ArrayList<>();
        ModelAndView model = new ModelAndView();
        cmsActivityVote = cmsActivityVoteService.queryActivityVoteById(voteId);
        list = cmsActivityVoteRelevanceMapper.queryVoteRelevanceListByVoteId(voteId);
        model.addObject("cmsActivityVote",cmsActivityVote);
        model.addObject("voteRelevanceList",list);
        model.addObject("listSize",list.size());
        model.setViewName("admin/activityVote/editVote");
        return model;
    }


    @RequestMapping(value="/editActivityVote")
    @ResponseBody
    public String editActivityVote(CmsActivityVote cmsActivityVote,String voteContents,String voteImgUrls) {
        try{
            CmsActivityVote vote = cmsActivityVoteService.queryActivityVoteByVoteTitel(cmsActivityVote.getVoteTitel());
            if(null != vote && !cmsActivityVote.getVoteId().equals(vote.getVoteId())){
                logger.error("addActivityVote repeat!");
                return Constant.RESULT_STR_REPEAT;
            }
            int success = cmsActivityVoteService.editCmsActivityVote(cmsActivityVote,voteContents,voteImgUrls);
            if(success>0){
                return Constant.RESULT_STR_SUCCESS;
            }else{
                return Constant.RESULT_STR_FAILURE;
            }
        }catch (Exception e){
            logger.error("addActivityVote error {}",e);
            return Constant.RESULT_STR_FAILURE;
        }
    }


    /**
     * 投票统计
     * @para voteId
     * @return List<CmsActivityVoteRelevance>
     * @authours hucheng
     * @date 2016/2/20
     * @content add
     * */
    @RequestMapping("/voteStatistics")
    public ModelAndView voteStatistics(String voteId,String activityName )throws Exception{
        ModelAndView model = new ModelAndView();
/*        List<CmsActivityVoteRelevance> list = null;
        list = cmsActivityVoteRelevanceMapper.queryVoteStatistics(voteId);*/
        model.addObject("activityName", URLDecoder.decode(activityName, "UTF-8"));
        model.addObject("voteId",voteId);
        model.setViewName("admin/activityVote/voteStatistics");
        return model;
    }

    /**
     * 加载投票统计数据
     * @para voteId
     * @return List<CmsUserVote>
     * @authours hucheng
     * @date 2016/2/20
     * @content add
     * */
    @RequestMapping("/loadVoteStatisticsData")
    @ResponseBody
    public List<CmsActivityVoteRelevance> loadVoteStatisticsData(String voteId ) {

        return cmsActivityVoteRelevanceMapper.queryVoteStatistics(voteId);

    }
}
