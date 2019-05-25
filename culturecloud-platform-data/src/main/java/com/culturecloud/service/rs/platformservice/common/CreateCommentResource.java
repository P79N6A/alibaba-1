package com.culturecloud.service.rs.platformservice.common;

import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.springframework.stereotype.Component;

import com.culturecloud.annotations.SysBusinessLog;

@Component
@Path("/manager")
public class CreateCommentResource {

	@POST
	@Path("/createcomment")
	@SysBusinessLog(remark="制造评论")
	@Produces(MediaType.APPLICATION_JSON)
	public void CreateComment()
	{
		
	}
}
