/**
 * 
 */
package com.culturecloud.kafka;

import java.util.Properties;

import kafka.javaapi.producer.Producer;
import kafka.producer.ProducerConfig;

/**************************************
 * @Description：KAFKA-PRODUCER配置
 * @author Zhangchenxi
 * @since 2016年1月5日
 * @version 1.0
 **************************************/

public class ProducerProper {

	private static ProducerProper producerProper;
	
	private static ProducerConfig config;
	
	private static  Producer<String, String> producer;
	
	private ProducerProper()
	{//182.92.77.217
		 Properties props = new Properties();
	     //props.put("metadata.broker.list", "192.168.1.181:9092");
		 props.put("metadata.broker.list", PpsConfig.getString("metadata.broker.list"));
	     props.put("serializer.class", "kafka.serializer.StringEncoder");
	     props.put("request.required.acks", "1");
	     props.put("partitioner.class", "com.culturecloud.kafka.JasonPartitioner");
	     config = new ProducerConfig(props);
	     producer = new Producer<String, String>(config); 
	}
	
	
	
	public static synchronized Producer<String, String> getProducer()
	{
		if(producerProper==null)
		{
			producerProper=new ProducerProper();
		}
	     return producer;
	}
	
	public static synchronized void closeProducer()
	{
		producer.close();
	}
	
	
}
