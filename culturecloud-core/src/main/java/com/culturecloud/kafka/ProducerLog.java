/**
 * 
 */
package com.culturecloud.kafka;

import kafka.producer.KeyedMessage;

/**************************************
 * @Description：（请用一简短的话描述业务功能。）
 * @author Zhangchenxi
 * @since 2016年1月5日
 * @version 1.0
 **************************************/

public class ProducerLog {

	
	public static void sendlog(String msg)
	{
//		KeyedMessage<String, String> data = new KeyedMessage<String, String>(ProducerTopicName.SXZHLOG, 1 + "", msg);
//		ProducerProper.getProducer().send(data);
	
		KeyedMessage<String, String> data = new KeyedMessage<String, String>(ProducerTopicName.SXZHLOG,Math.random()*10 + "", msg);
		ProducerProper.getProducer().send(data);

		//ProducerProper.closeProducer();
	}
	
}
