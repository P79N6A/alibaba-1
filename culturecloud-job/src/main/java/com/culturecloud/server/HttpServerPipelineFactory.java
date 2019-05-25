package com.culturecloud.server;

import static org.jboss.netty.channel.Channels.pipeline;

import java.util.Iterator;
import java.util.Set;

import org.jboss.netty.channel.ChannelPipeline;
import org.jboss.netty.channel.ChannelPipelineFactory;
import org.jboss.netty.handler.codec.http.HttpRequestDecoder;
import org.jboss.netty.handler.codec.http.HttpResponseEncoder;
import org.jboss.netty.handler.stream.ChunkedWriteHandler;
import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.beans.factory.support.BeanDefinitionBuilder;
import org.springframework.beans.factory.support.BeanDefinitionRegistry;
import org.springframework.beans.factory.support.DefaultListableBeanFactory;
import org.springframework.context.support.AbstractApplicationContext;

import com.sun.jersey.api.core.ResourceConfig;

public class HttpServerPipelineFactory implements ChannelPipelineFactory {

	public ChannelPipeline getPipeline() throws Exception {
		ChannelPipeline pipeline = pipeline();

		pipeline.addLast("decoder", new HttpRequestDecoder());
		pipeline.addLast("encoder", new HttpResponseEncoder());
		pipeline.addLast("chunkedWriter", new ChunkedWriteHandler());

		NettyHandlerContainerProvider provider = new NettyHandlerContainerProvider();

		pipeline.addLast("handler", provider.createContainer(
				NettyHandlerContainer.class, AppContext.INSTANCE.getRc(),
				AppContext.INSTANCE.getWa()));
		return pipeline;
	}

	/**
	 * 注册resource资源为spring的bean
	 */
	private void RegisterBeans(ResourceConfig rc) {
		AbstractApplicationContext springContext = AppContext.INSTANCE
				.getAppContext();
		Set resClasssSet = rc.getRootResourceClasses();
		Iterator<Class<?>> it = resClasssSet.iterator();
		while (it.hasNext()) {
			Class<?> type = it.next();
			if (ResourceConfig.isRootResourceClass(type)) {
				// rc.getClasses().add(type);
				BeanDefinitionRegistry beanDefinitionRegistry = (DefaultListableBeanFactory) springContext
						.getBeanFactory();

				BeanDefinitionBuilder beanDefinitionBuilder = BeanDefinitionBuilder
						.genericBeanDefinition(type);
				// get the BeanDefinition
				BeanDefinition beanDefinition = beanDefinitionBuilder
						.getBeanDefinition();
				// register the bean
				beanDefinitionRegistry.registerBeanDefinition(
						type.getSimpleName(), beanDefinition);

			}
		}
		/*
		 * String[] names =
		 * BeanFactoryUtils.beanNamesIncludingAncestors(springContext);
		 * 
		 * for (String name : names) { Class<?> type =
		 * ClassUtils.getUserClass(springContext.getType(name)); if
		 * (ResourceConfig.isProviderClass(type)) { rc.getClasses().add(type); }
		 * else if (ResourceConfig.isRootResourceClass(type)) {
		 * rc.getClasses().add(type); } }
		 */

	}
}
