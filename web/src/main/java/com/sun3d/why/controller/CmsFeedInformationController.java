package com.sun3d.why.controller;

import com.sun3d.why.dao.CmsFeedbackReplyMapper;
import com.sun3d.why.model.CmsFeedback;
import com.sun3d.why.model.CmsFeedbackReply;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.StringUtils;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.webservice.service.CmsFeedbackService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;

/**
 * 用户反馈信息
 * Created by Administrator on 2015/7/30.
 */
@Controller
@RequestMapping(value = "/feedInformation")
public class CmsFeedInformationController {
    private Logger logger = LoggerFactory.getLogger(CmsFeedInformationController.class);
    @Autowired
    private CmsFeedbackService cmsFeedbackService;

    @Autowired
    private CmsFeedbackReplyMapper feedbackReplyMapper;

    @Autowired
    private HttpSession session;
    /**
     * 进入用户反馈列表
     * @param page 分页对象
     * @cmsFeedback 反馈对象
     */
    @RequestMapping("/feedIndex")
    public String feedIndex(Pagination page, Model model,String content,String listType) {
    	CmsFeedback cmsFeedback = new CmsFeedback();
    	if(content!=null){
    		cmsFeedback.setFeedContent(content);
    	}
        List<CmsFeedback> feedbackList=cmsFeedbackService.queryFeedInformationByContent(cmsFeedback,page);
        model.addAttribute("feedbackList", feedbackList);
        model.addAttribute("page", page);
        model.addAttribute("content", content);
        model.addAttribute("listType", listType);
        return "admin/feedBack/feed_index";
    }


    /**
     * 进入回复用户反馈页面
     * @para feedBackId 用户反馈的id
     * @authours hucheng
     * @date 2016/2/16
     * @content add
     * */
    @RequestMapping(value="/toFeedBack")
   public ModelAndView toFeedBack(String feedBackId,String type){
        ModelAndView model = new ModelAndView();
        model.addObject("feedBackId",feedBackId);
        if(StringUtils.isNotNull(feedBackId)){
            CmsFeedbackReply cmsFeedbackReply = feedbackReplyMapper.queryFeedbackReplyByFeedBackId(feedBackId);
            if(cmsFeedbackReply != null){
                model.addObject("replyContent",cmsFeedbackReply.getReplyContent());
            }
        }
        if("1".equals(type)){
            model.setViewName("admin/feedBack/feedBackPage");
        }else{
            model.setViewName("admin/feedBack/feedBackDetail");
        }

        return model;
    }

    /**
     * 添加用户反馈回复
     * @para CmsFeedbackReply
     * @authours hucheng
     * @date 2016/2/16
     * @content add
     * */
    @RequestMapping(value="/feedBackReply")
    @ResponseBody
    public String saveFeedBackReply(CmsFeedbackReply cmsFeedbackReply){
        SysUser sysUser = (SysUser) session.getAttribute("user");
        if(sysUser != null){
            cmsFeedbackReply.setReplyId(UUIDUtils.createUUId());
            cmsFeedbackReply.setReplyTime(new Date());
            cmsFeedbackReply.setUserId(sysUser.getUserId());
        }
       int count = feedbackReplyMapper.addFeedbackReply(cmsFeedbackReply);
        if(count >0){
            return Constant.RESULT_STR_SUCCESS;
        }else{
            return Constant.RESULT_STR_FAILURE;
        }

    }
}
