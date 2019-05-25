package com.culturecloud.filter;

import javax.ws.rs.ext.Provider;

import com.sun.jersey.spi.container.ContainerRequest;
import com.sun.jersey.spi.container.ContainerResponse;
import com.sun.jersey.spi.container.ContainerResponseFilter;
import com.culturecloud.bean.BaseView;

/**
 * 对正常返回数据包装类
 * 
 * @author zhangchenxi
 * @since 2015-04-22
 * @version 1.0
 */
@Provider
public class ResponseFilter implements ContainerResponseFilter {
	@Override
	public ContainerResponse filter(ContainerRequest request,
			ContainerResponse response) {
		Throwable throwable = response.getMappedThrowable();

		if (throwable == null) {

			BaseView baseView = new BaseView();

			Object o = response.getEntity();

			baseView.setStatus("1");

			baseView.setData(o);
		
//			JSONValue jsonValue;
//			try {
//				jsonValue = JSONMapper.toJSON(baseView);
//				String jsonStr = jsonValue.render(true);
//				byte[] parames=GZipUtil.gZip(jsonStr.getBytes());
				response.setEntity(baseView);
//				System.out.println("result==="+jsonStr);
//			} catch (MapperException e) {
//				// TODO Auto-generated catch block
//				e.printStackTrace();
//			}

			
		}
		return response;

	}
}
