package com.sun3d.why.controller.yket;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sun3d.why.common.ProjectConst;
import com.sun3d.why.common.Result;
import com.sun3d.why.enumeration.LikeEnum;
import com.sun3d.why.enumeration.RSKeyEnum;
import com.sun3d.why.exception.UserReadableException;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.bean.yket.YketLikeKey;
import com.sun3d.why.service.LikeService;

@Controller
@RequestMapping("/common")
public class LikeController {

	@Autowired
	LikeService likeService;

	@Autowired
	HttpSession session;
	
	@ExceptionHandler(UserReadableException.class)
	@ResponseBody
	public Result handleUserReadableException(HttpServletRequest request, UserReadableException e) {
		return Result.Error().setVal(RSKeyEnum.msg, e.getMessage());
	}
	
	@RequestMapping(value = "/like", method = RequestMethod.POST)
	@ResponseBody
	public Result like(String userId, String objectId, String likeType) {
		CmsTerminalUser user = (CmsTerminalUser) session.getAttribute(ProjectConst.FRONT_SESSION_KEY);
		if(user==null && StringUtils.isEmpty(userId)){
			return  Result.Unlogin();
		}
		YketLikeKey record = new YketLikeKey();
		record.setLikeType(LikeEnum.valueOf(likeType).getIndex());
		record.setObjectId(objectId);
		record.setUserId(user!=null?user.getUserId():userId);
		return this.likeService.like(record);
	}

}
