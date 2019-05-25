package com.culturecloud.service.rs.platformservice.exceptionwapper;

import javax.ws.rs.HeaderParam;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.Status;
import javax.ws.rs.ext.ExceptionMapper;
import javax.ws.rs.ext.Provider;

import org.apache.log4j.Logger;

import com.culturecloud.bean.BaseView;
import com.culturecloud.exception.BaseException;
import com.sun.jersey.api.ConflictException;
import com.sun.jersey.api.NotFoundException;

/**
 * 统一异常处理器,在这个类里面我们处理了我们定义的unchecked
 * exception异常，还处理了系统未知的exception(包括未知的unchecked exception和checked
 * exception)。我们的处理方式是
 * ：a、记录异常日志；b、向客户端抛一个标准的http错误状态码和错误消息，由客户端对错误信息进行自行处理，值得说明的是
 * ，这种处理方式是REST所提倡的，它恰当的使用了HTTP标准状态码；
 * 
 * @author zhangchenxi
 * @since 2015-04-22
 * @version 1.0
 */
@Provider
public class ExceptionMapperSupport implements ExceptionMapper<Exception> {
	private static final Logger LOGGER = Logger
			.getLogger(ExceptionMapperSupport.class);

	//private static final String CONTEXT_ATTRIBUTE = WebApplicationContext.ROOT_WEB_APPLICATION_CONTEXT_ATTRIBUTE;
	@HeaderParam("nickName")String nikeString;
	/**
	 * 异常处理
	 * 
	 * @param exception
	 * @return 异常处理后的Response对象
	 */
	public Response toResponse(Exception exception) {
		String message = "INTERNAL_SERVER_ERROR";
		Status statusCode = Status.INTERNAL_SERVER_ERROR;
		//System.out.println("Access URL: " + request.getContextPath());
		// 处理unchecked exception
		if (exception instanceof BaseException) {
			BaseException baseException = (BaseException) exception;
			message = baseException.getCode();
			statusCode = Status.BAD_REQUEST;
		} else if (exception instanceof NotFoundException) {
			message = "REQUEST_NOT_FOUND";
			statusCode = Status.NOT_FOUND;
		} else if (exception instanceof ConflictException) {
			message = "ConflictException";
			statusCode = Status.CONFLICT;
		}
		
		// checked exception和unchecked exception均被记录在日志里
		//LOGGER.info("============客户端访问路径: http://" + request.getRemoteHost()+":"+ request.getLocalPort() + request.getRequestURI()+"====================");
		//LOGGER.error(ExceptionUtils.getStackTrace(exception));
		
		BaseView baseView = new BaseView();
		baseView.setStatus("0");
		//baseView.setMsg(ExceptionUtils.getMessage(exception));
		BaseView.MsgObject msgData = baseView.getInnerMsg();
		msgData.setErrcode("10800");
		msgData.setErrmsg(exception.getMessage());
		baseView.setMsg(msgData);
		
		return Response.ok().type(MediaType.APPLICATION_JSON).entity(baseView)
				.build();
	}
}
