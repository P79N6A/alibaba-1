package com.culturecloud.service.rs.platformservice.exceptionwapper;

import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.ext.ExceptionMapper;
import javax.ws.rs.ext.Provider;

import org.apache.commons.lang.exception.ExceptionUtils;
import org.apache.log4j.Logger;

import com.culturecloud.bean.BaseView;
import com.culturecloud.exception.BizException;
import com.sdicons.json.model.JSONValue;

/**
 * 业务异常类包装
 * 
 * @author zhangchenxi
 * @since 2015-04-22
 * @version 1.0
 */
@Provider
public class BizExceptionWrapper implements ExceptionMapper<BizException> {
	private static final Logger log = Logger.getLogger(BizExceptionWrapper.class);
	
//	@Context
//	private HttpServletRequest request;
	/**
	 * 异常处理
	 * 
	 * @param exception
	 * @return 异常处理后的Response对象
	 */
	public Response toResponse(BizException exception) {
//		log.info("============客户端访问路径: http://" + request.getRemoteHost()+":"+ request.getLocalPort() + request.getRequestURI()+"====================");
		log.info(ExceptionUtils.getStackTrace(exception));
		BaseView baseView = new BaseView();

		baseView.setStatus("0");
		if(exception instanceof BizException){
			BizException ex = (BizException)exception;
		
			BaseView.MsgObject msgData = baseView.getInnerMsg(ex.getExceptionCode(),ex.getMessage());
			baseView.setMsg(msgData);
		}
		JSONValue jsonValue;
//		byte[] parames=null;
//		try {
//			jsonValue = JSONMapper.toJSON(baseView);
//			String jsonStr = jsonValue.render(true);
//			parames=GZipUtil.gZip(jsonStr.getBytes());
//
//			System.out.println("result==="+jsonStr);
//		} catch (MapperException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
		return Response.ok().type(MediaType.APPLICATION_JSON).entity(baseView).build();
	}
}
