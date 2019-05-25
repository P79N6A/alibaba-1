package com.culturecloud.server;

import static org.jboss.netty.handler.codec.http.HttpHeaders.is100ContinueExpected;
import static org.jboss.netty.handler.codec.http.HttpResponseStatus.CONTINUE;
import static org.jboss.netty.handler.codec.http.HttpVersion.HTTP_1_1;

import java.io.IOException;
import java.io.OutputStream;
import java.net.URI;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.jboss.netty.buffer.ChannelBuffer;
import org.jboss.netty.buffer.ChannelBufferInputStream;
import org.jboss.netty.buffer.ChannelBufferOutputStream;
import org.jboss.netty.buffer.ChannelBuffers;
import org.jboss.netty.channel.Channel;
import org.jboss.netty.channel.ChannelFutureListener;
import org.jboss.netty.channel.ChannelHandlerContext;
import org.jboss.netty.channel.ChannelPipelineCoverage;
import org.jboss.netty.channel.MessageEvent;
import org.jboss.netty.channel.SimpleChannelUpstreamHandler;
import org.jboss.netty.handler.codec.http.DefaultHttpResponse;
import org.jboss.netty.handler.codec.http.HttpChunk;
import org.jboss.netty.handler.codec.http.HttpHeaders;
import org.jboss.netty.handler.codec.http.HttpRequest;
import org.jboss.netty.handler.codec.http.HttpResponse;
import org.jboss.netty.handler.codec.http.HttpResponseStatus;
import org.jboss.netty.handler.codec.http.HttpVersion;
import org.jboss.netty.util.CharsetUtil;

import com.culturecloud.utils.Constants;
import com.sun.jersey.api.core.ResourceConfig;
import com.sun.jersey.core.header.InBoundHeaders;
import com.sun.jersey.spi.container.ContainerRequest;
import com.sun.jersey.spi.container.ContainerResponse;
import com.sun.jersey.spi.container.ContainerResponseWriter;
import com.sun.jersey.spi.container.WebApplication;

/**
 * @author Carl Bystr�m
 */
@ChannelPipelineCoverage("all")
public class NettyHandlerContainer extends SimpleChannelUpstreamHandler
{
	

	private WebApplication application;
	private String baseUri;
	
	private boolean readingChunks;
	/** Buffer that stores the response content */
	private final StringBuilder buf = new StringBuilder();	
	 
	private String methodName;
	private URI basedUri=null;
	private URI requestUri=null;
	private InBoundHeaders iHeaders=null;
	private ChannelBuffer buffer=null;

	public NettyHandlerContainer(WebApplication application, ResourceConfig resourceConfig)
	{
		this.application = application;
		this.baseUri = (String)resourceConfig.getProperty(Constants.PROPERTY_BASE_URI);
	}

	private final static class Writer implements ContainerResponseWriter
	{
		private final Channel channel;
		private HttpResponse response;

		private Writer(Channel channel)
		{
			this.channel = channel;
		}

		public OutputStream writeStatusAndHeaders(long contentLength, ContainerResponse cResponse) throws IOException
		{
			response = new DefaultHttpResponse(HttpVersion.HTTP_1_0, HttpResponseStatus.valueOf(cResponse.getStatus()));

			for (Map.Entry<String, List<Object>> e : cResponse.getHttpHeaders().entrySet())
			{
				List<String> values = new ArrayList<String>();
				for (Object v : e.getValue())
					values.add(ContainerResponse.getHeaderValue(v));
				response.setHeader(e.getKey(), values);
			}

			ChannelBuffer buffer = ChannelBuffers.dynamicBuffer();
			response.setContent(buffer);
			return new ChannelBufferOutputStream(buffer);
		}

		public void finish() throws IOException
		{
			// Streaming is not supported. Entire response will be written downstream once finish() is called.
			channel.write(response).addListener(ChannelFutureListener.CLOSE);
		}
	}

	@Override
	public void messageReceived(ChannelHandlerContext context, MessageEvent e) throws Exception
	{
		if (!readingChunks) {

			HttpRequest request = (HttpRequest) e.getMessage();
			methodName = request.getMethod().getName();
			String base = getBaseUri(request);
			basedUri = new URI(base);
			requestUri = new URI(base.substring(0, base.length() - 1) + request.getUri());
			iHeaders =getHeaders(request);
			if (is100ContinueExpected(request)) {
				send100Continue(e);
			}

			buf.setLength(0);

			if (request.isChunked()) {
				readingChunks = true;
			} else {
				
				// servlet 封装
/*				HttpTunnelingServlet tunServlet = new HttpTunnelingServlet();
				ServletConfiguration  config = new ServletConfiguration(tunServlet);
				FilterChain imp = new FilterChainImpl(config);
 
				HttpServletRequest servRequ  = new  HttpServletRequestImpl(request, (FilterChainImpl) imp);

				servRequ.setAttribute("111", "dddd");
				System.out.println(servRequ.getAttribute("111"));*/

				final ContainerRequest cRequest = new ContainerRequest(
						application,
						methodName,
						basedUri,
						requestUri,
						iHeaders,
						new ChannelBufferInputStream(request.getContent())
					);

				application.handleRequest(cRequest, new Writer(e.getChannel()));
			}
		} else {
			HttpChunk chunk = (HttpChunk) e.getMessage();
			if (chunk.isLast()) {
				readingChunks = false;
	
				final ContainerRequest cRequest = new ContainerRequest(
						application,
						methodName,
						basedUri,
						requestUri,
						iHeaders,
						new ChannelBufferInputStream(buffer)
					);
				application.handleRequest(cRequest, new Writer(e.getChannel()));
				
				buf.setLength(0);
			} else {
				buf.append(chunk.getContent().toString(CharsetUtil.UTF_8));
				buffer = chunk.getContent();			
			}
		}

	}
	
	private void send100Continue(MessageEvent e) {
		HttpResponse response = new DefaultHttpResponse(HTTP_1_1, CONTINUE);
		e.getChannel().write(response);
	}

	private String getBaseUri(HttpRequest request)
	{
		if (baseUri != null)
		{
			return baseUri;
		}

		return "http://" + request.getHeader(HttpHeaders.Names.HOST) + "/";
	}

	private InBoundHeaders getHeaders(HttpRequest request)
	{
		InBoundHeaders headers = new InBoundHeaders();

		for (String name : request.getHeaderNames())
		{
			headers.put(name, request.getHeaders(name));
		}

		return headers;
	}
}
