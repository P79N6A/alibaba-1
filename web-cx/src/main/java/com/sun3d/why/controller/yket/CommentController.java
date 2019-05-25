package com.sun3d.why.controller.yket;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sun3d.why.common.ProjectConst;
import com.sun3d.why.common.Result;
import com.sun3d.why.enumeration.CommentCheckStatusEnum;
import com.sun3d.why.enumeration.CommentTypeEnum;
import com.sun3d.why.enumeration.RSKeyEnum;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.bean.yket.YketComment;
import com.sun3d.why.model.vo.yket.CommentListVo;
import com.sun3d.why.service.CommentService;
import com.sun3d.why.util.EmojiFilter;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.webservice.api.service.CmsApiTerminalUserService;

@Controller
@RequestMapping("/common")
public class CommentController {

	
	@Autowired
	private CommentService commentService;

	@Autowired
	private HttpSession session ;
	
	@Autowired
	CmsApiTerminalUserService userService; 
	
	@RequestMapping(value="/comment",method=RequestMethod.POST)
	@ResponseBody
	public Result comment(String commentType,String objectId,String commentImgUrls,String content,String userId){
		CmsTerminalUser user = (CmsTerminalUser) session.getAttribute(ProjectConst.FRONT_SESSION_KEY);
		if(user==null && StringUtils.isEmpty(userId)){
			return  Result.Unlogin();
		}
		YketComment comment= new YketComment();
		comment.setCheckStatus(CommentCheckStatusEnum.PASS.getIndex());
		comment.setCommentId(UUIDUtils.createUUId());
		try{
			comment.setCommentType(CommentTypeEnum.valueOf(commentType).getIndex());
		}catch(Exception e){
			e.printStackTrace();
		 return	Result.Error().setVal(RSKeyEnum.msg, "评论类别不存在");
		}
		
		if(!StringUtils.isEmpty(content) &&  StringUtils.isEmpty(EmojiFilter.filterEmoji(content))
				|| content.length()!=EmojiFilter.filterEmoji(content).length() ){
			 return	Result.Error().setVal(RSKeyEnum.msg, "评论内容不能有特殊字符呦 !");
		}
		comment.setCommentImgUrls(commentImgUrls);
		comment.setContent(EmojiFilter.filterEmoji(content));
		comment.setObjectId(objectId);
		comment.setUserId(user!=null? user.getUserId():userId);
		//'0  不置顶  1 置顶'
		comment.setTopFlag((byte)0);
		comment.setCreateTime(new Date());
		comment.setUpdateTime(new Date());
		return  this.commentService.comment(comment).setVal(RSKeyEnum.data, userService.webLogin(userId));
		
	}
	@RequestMapping(value="/login",method=RequestMethod.GET)
	@ResponseBody
	public Result login(CmsTerminalUser user){
		if(user==null){
			user= new CmsTerminalUser();
			user.setUserId("001");	
		}
		session.setAttribute(ProjectConst.FRONT_SESSION_KEY, user);
		return Result.Ok().setVal(RSKeyEnum.data,user);
	}
	
 
	 
	@Deprecated
	public List<YketComment> commentList(YketComment comment,Integer firstResult,Integer rows){
		List<YketComment> list = null;
    	try {
			list = this.commentService.queryCommentByCondition(comment,firstResult,rows);
		} catch (Exception e) {
			e.printStackTrace();
		}
        return list;
	}
	
	@RequestMapping(value="/commentList",method=RequestMethod.POST)
	@ResponseBody
	public Result commentList4Front(String commentType,String objectId,
			Integer firstResult, Integer rows){
		List<CommentListVo> list = null;
    	try {
			list = this.commentService.queryCommentByCondition(commentType,objectId,firstResult,rows);
		} catch (Exception e) {
			e.printStackTrace();
		}
        return Result.Ok().setVal(RSKeyEnum.data,list);
	}
 }
