/**
 * 
 */
package com.sun3d.why.kafka;

import kafka.producer.KeyedMessage;

/**************************************
 * @Description：（请用一简短的话描述业务功能。）
 * @author Zhangchenxi
 * @since 2016年1月5日
 * @version 1.0
 **************************************/

public class ProducerLog {

	
	public static void sendwhgc(String msg)
	{
		KeyedMessage<String, String> data = new KeyedMessage<String, String>(ProducerTopicName.WHGC,Math.random()*10 + "", msg);
		ProducerProper.getProducer().send(data);
	}
	
	public static void main(String[] args)
	{
//		sendlog("1111");
	}
}
