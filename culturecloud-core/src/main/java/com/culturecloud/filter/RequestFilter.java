/**   
 * @Title: RequestFilter.java 
 * @Package com.dbcsoft.shopping.core.aop 
 * @Description: TODO(用简洁的语句描述该文件做什么) 
 * @author A18ccms A18ccms_gmail_com   
 * @date 2015年3月12日 下午4:28:00 
 * @version V1.0   
 */
package com.culturecloud.filter;

import com.sun.jersey.spi.container.ContainerRequest;
import com.sun.jersey.spi.container.ContainerRequestFilter;

/**************************************
 * @Description：系统抽象过滤器
  * @author zhangchenxi
 * @since 2015-04-22
 * @version 1.0
 **************************************/
public abstract class RequestFilter implements ContainerRequestFilter {

	/**
	 * 
	 * @description 抽象过滤器方法,主要交由具体实现类根据自身的业务来进行实现。
	 * 
	 * @see
	 * com.sun.jersey.spi.container.ContainerRequestFilter#filter(com.sun.jersey
	 * .spi.container.ContainerRequest)
	 * 
	 * @author Arthur
	 * 
	 * @since 2015年3月12日 下午4:28:00
	 * 
	 * @version
	 */
	@Override
	public abstract ContainerRequest filter(ContainerRequest request);

}
