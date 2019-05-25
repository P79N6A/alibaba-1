/**
 * 
 */
package com.culturecloud.threadpool;

import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;


public class ThreadPoolFactory {

	private static volatile ThreadPoolExecutor threadPoolExecutor;
	
	
	/** 获取线程池对象
	 * 
	 * ThreadPoolExecutor(核心池、最大线程数、线程存活时间、任务缓存队列、任务拒绝策略)
	 * 
	 * */
	public static ThreadPoolExecutor getThreadPoolExecutor()
	{
		if(threadPoolExecutor==null)
		{
			synchronized (ThreadPoolFactory.class) {
				if(threadPoolExecutor==null)
				{
					threadPoolExecutor = new ThreadPoolExecutor(3,5,3,
							TimeUnit.SECONDS, new LinkedBlockingQueue<Runnable>(),
							new ThreadPoolExecutor.DiscardOldestPolicy());				}
			}
		}
		return threadPoolExecutor;
	}
	
}
