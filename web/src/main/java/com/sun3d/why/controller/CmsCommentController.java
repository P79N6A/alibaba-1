package com.sun3d.why.controller;

import com.sun3d.why.dao.CmsSensitiveWordsMapper;
import com.sun3d.why.model.CmsComment;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsCommentService;
import com.sun3d.why.util.CmsSensitive;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;

@RequestMapping("/comment")
@Controller
public class CmsCommentController {
    private Logger logger = LoggerFactory.getLogger(CmsCommentController.class);

    @Autowired
    private CmsCommentService commentService;
    @Autowired
    private HttpSession session;

    @Autowired
    private CmsSensitiveWordsMapper cmsSensitiveWordsMapper;


    /**
     * 前端2.0 添加评论
     *
     * @param comment
     * @param
     * @return
     */
    @RequestMapping(value = "/addComment", method = {RequestMethod.POST})
    @ResponseBody
    public String addComment(CmsComment comment) {
        try {
            CmsTerminalUser user = (CmsTerminalUser) session.getAttribute("terminalUser");
            if (user != null) {
                String sensitiveWords = CmsSensitive.sensitiveWords(comment, cmsSensitiveWordsMapper);
                if (StringUtils.isNotBlank(sensitiveWords) && sensitiveWords.equals("sensitiveWordsExist")) {
                    return Constant.SensitiveWords_EXIST;
                }
                comment.setCommentUserId(user.getUserId());
                return commentService.addComment(comment);
            }
        } catch (Exception e) {
            logger.error("addComment error {}", e);
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_FAILURE;
    }


    //前台场馆详情显示评论列表
    @RequestMapping(value = "/commentList")
    @ResponseBody
    public List<CmsComment> commentList(CmsComment cmsComment, Pagination page) {
        //评论列表
        cmsComment.setCommentState(1);
        List<CmsComment> commentList = commentService.queryCmsCommentByCondition(cmsComment, page);
        return commentList;
    }



    /**
     * 跳转到评论管理的首页面
     *
     * @param comment CmsComment 评论对象
     * @param page   Pagination 分页功能类
     * @return ModelAndView 页面及参数
     */
    @RequestMapping(value = "/commentIndex")
    public ModelAndView commentIndex(CmsComment comment, Pagination page) {
        ModelAndView model = new ModelAndView();
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            List<CmsComment> commentList = commentService.queryCommentByCondition(comment, page,sysUser);
            model.setViewName("admin/comment/commentIndex");
            model.addObject("commentList", commentList);
            model.addObject("page", page);
            model.addObject("comment", comment);
        }catch (Exception e){
            logger.info("commentIndex error" + e);
        }
        return model;
    }


    //commentType 评论类型
    //评论的对象的id
    //评论内容
     //评论人id
     //success:成功  failure:失败

/*
    */
/**
     * 新增评论
     * @param comment 
     * @return
     *//*

    @RequestMapping(value = "/addComment", method = RequestMethod.POST)
    @ResponseBody
    public String addComment(CmsComment comment,CmsSensitiveWords cmsSensitiveWords) {
        try {
            return commentService.addComment(comment);
        } catch (Exception e) {
            logger.info("addComment error" + e);
        }
        return Constant.RESULT_STR_FAILURE;
    }
*/

    /**
     * 删除评论
     * @param commentId 评论id
     * @return
     */
    @RequestMapping(value = "/deleteComment", method = RequestMethod.POST)
    @ResponseBody
    public String deleteComment(String commentId) {
        try {
            if (StringUtils.isNotBlank(commentId)) {
                commentService.deleteCommentById(commentId);
                return Constant.RESULT_STR_SUCCESS;
            }
        } catch (Exception e) {
            logger.info("deleteComment error" + e);
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_FAILURE;
    }

    /**
     * 场馆评论3.0 列表
     *
     * @param comment CmsComment 评论对象
     * @param page   Pagination 分页功能类
     * @return ModelAndView 页面及参数
     */
    @RequestMapping(value = "/commentVenueIndex")
    public ModelAndView commentVenueIndex(CmsComment comment, Pagination page) {
        ModelAndView model = new ModelAndView();
        try {
            comment.setCommentType(Constant.TYPE_VENUE);
            List<CmsComment> commentList = commentService.queryCmsCommentByCondition(comment, page);
            model.setViewName("admin/venue/commentVenueIndex");
            model.addObject("commentList", commentList);
            model.addObject("page", page);
            model.addObject("comment", comment);
        }catch (Exception e){
            logger.info("commentVenueIndex error" + e);
        }
        return model;
    }

    /**
     * 场馆评论3.0 置顶
     * @param commentId
     * @return
     */
    @RequestMapping(value = "/commentTopTrue.do", method = RequestMethod.POST)
    @ResponseBody
    public String commentTopTrue(String commentId) {
        try {
            if (StringUtils.isNotBlank(commentId)) {
                CmsComment comment = new CmsComment();
                comment.setCommentId(commentId);
                comment.setCommentIsTop(Constant.COMMENT_TOP_TRUE);
                comment.setCommentTopTime(new Date());
                commentService.editCommentTopState(comment);
                return Constant.RESULT_STR_SUCCESS;
            }
        } catch (Exception e) {
            logger.info("commentTopTrue error" + e);
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_FAILURE;
    }

    /**
     * 场馆评论3.0 取消置顶
     * @param commentId
     * @return
     */
    @RequestMapping(value = "/commentTopFalse.do", method = RequestMethod.POST)
    @ResponseBody
    public String commentTopFalse(String commentId) {
        try {
            if (StringUtils.isNotBlank(commentId)) {
                CmsComment comment = new CmsComment();
                comment.setCommentId(commentId);
                comment.setCommentIsTop(Constant.COMMENT_TOP_FALSE);
                comment.setCommentTopTime(new Date());
                commentService.editCommentTopState(comment);
                return Constant.RESULT_STR_SUCCESS;
            }
        } catch (Exception e) {
            logger.info("commentTopFalse error" + e);
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_FAILURE;
    }

    /**
     * 场馆评论3.0 列表
     *
     * @param commentId
     * @return ModelAndView 页面及参数
     */
    @RequestMapping(value = "/viewComment")
    public ModelAndView viewComment(String commentId) {
        ModelAndView model = new ModelAndView();
        try {
            CmsComment comment = commentService.queryCommentById(commentId);
            model.setViewName("admin/comment/viewComment");
            model.addObject("comment", comment);
        }catch (Exception e){
            logger.info("viewComment error" + e);
        }
        return model;
    }

    /**
     * 评论3.0 已评论个数
     * @return
     */
    @RequestMapping(value = "/queryCommentCount.do", method = RequestMethod.POST)
    @ResponseBody
    public int queryCommentCount(CmsComment comment) {
        /*CmsComment comment = new CmsComment();
        comment.setCommentRkId(cmsActivity.getActivityId());
        comment.setCommentType(Constant.TYPE_ACTIVITY);*/
        return commentService.queryCommentCountByCondition(comment);
    }
}
