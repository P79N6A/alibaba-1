package com.culturecloud.server;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.beans.factory.support.BeanDefinitionBuilder;
import org.springframework.beans.factory.support.BeanDefinitionRegistry;
import org.springframework.beans.factory.support.DefaultListableBeanFactory;
import org.springframework.context.support.AbstractApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.culturecloud.utils.Constants;
import com.culturecloud.utils.PpsConfig;
import com.sun.jersey.api.core.PackagesResourceConfig;
import com.sun.jersey.api.core.ResourceConfig;
import com.sun.jersey.spi.container.WebApplication;
import com.sxiic.SpringWebApplicationImpl;

public enum AppContext {

	INSTANCE;
	
	/**
	 * jersey的WebApplication对象
	 */
	private WebApplication wa;
	/**
	 * jersey的ResourceConfig对象
	 */
	private ResourceConfig rc;

	public WebApplication getWa() {
		return wa;
	}

	public ResourceConfig getRc() {
		return rc;
	}
	private AbstractApplicationContext appContext;
	
	private AppContext() {

		this.appContext = new ClassPathXmlApplicationContext("spring.xml");

	}

	public AbstractApplicationContext getAppContext() {
		return appContext;
	}
	
	/**
	 * 初始化jersey，把jersey的resource资源交给spring管理
	 */
	public void initJerseySpring(){
		// 自定义jersey的webapplication实现类
		wa = new SpringWebApplicationImpl();
		// jersey原始实现
		//wa = WebApplicationFactory.createWebApplication();
		// jersey 资源包路径
		rc = new PackagesResourceConfig(
				PpsConfig.getString("resourcepackage"));
		final Map<String, Object> config = new HashMap<String, Object>();
		// jersey 请求相应转json格式配置
		config.put(Constants.POJOMAPPER, true);
		// jersey 响应处理类
		config.put(ResourceConfig.PROPERTY_CONTAINER_RESPONSE_FILTERS,
				PpsConfig.getString("responsefilter"));
		// jersey 请求处理类
		config.put(ResourceConfig.PROPERTY_CONTAINER_REQUEST_FILTERS,
				PpsConfig.getString("requestfilter"));
		// jersey 初始话配置项
		rc.setPropertiesAndFeatures(config);
		// 将spring上下文对象传给jersey
		((SpringWebApplicationImpl)wa).setAppContext(appContext);
		
		wa.initiate(rc);
		// jersey资源类注册为spring的bean,让spring接管jersey资源
		RegisterBeans(rc);
	}
	/**
	 * 注册resource资源为spring的bean
	 */
	public void RegisterBeans(ResourceConfig rc){

		@SuppressWarnings("rawtypes")
		Set resClasssSet=rc.getRootResourceClasses();
		@SuppressWarnings("unchecked")
		Iterator<Class<?>> it = resClasssSet.iterator();  
		while (it.hasNext()) {  
			Class<?> type = it.next();  
			// 如果是jersey的resource资源
			if (ResourceConfig.isRootResourceClass(type)) {
               // rc.getClasses().add(type);
				BeanDefinitionRegistry beanDefinitionRegistry = (DefaultListableBeanFactory)appContext .getBeanFactory();

				BeanDefinitionBuilder beanDefinitionBuilder = BeanDefinitionBuilder
						.genericBeanDefinition(type);
				// 获取BeanDefinition
				BeanDefinition beanDefinition = beanDefinitionBuilder
						.getBeanDefinition();
				// 注册成为bean
				beanDefinitionRegistry.registerBeanDefinition(type.getSimpleName(), beanDefinition);

            }  
		} 
	}
}
