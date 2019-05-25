package com.sun3d.why.jms.client;

import com.sun3d.why.jms.model.JmsResult;
import com.sun3d.why.model.extmodel.ActiveMQConfig;
import com.sun3d.why.model.extmodel.BookActivitySeatInfo;
import com.sun3d.why.service.CacheConstant;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.SpringContextUtil;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;
import org.apache.activemq.ActiveMQConnectionFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;

import javax.jms.*;


public class ActivityBookClient implements MessageListener {


    private Logger logger = LoggerFactory.getLogger(ActivityBookClient.class);
/*
/*    *//**//**
     * 连接工厂，JMS用它创建连接
     *//**//*
    private ConnectionFactory connectionFactory = null;

    *//**//**
     * 连接对象，JMS到Provider、Consumer的连接
     *//**//*
    private Connection connection = null;

    *//**//**
     * 一个发送或接收消息的线程
     *//**//*
    private Session session = null;

    *//**//**
     * JMS生产者消息目的地
     *//**//*
    private Destination producerDestination = null;


    *//**//**
     * JMS生产者，用于发送响应消息
     *//**//*
    private MessageProducer producer = null;


    *//**//**
     * JMS消费者消息目的地
     *//**//*
    private Destination consumerDestination = null;

    *//**//**
     * JMS消费者，用于接收请求消息
     *//**//*
    private MessageConsumer consumer = null;*/




    /**
     * 构造函数
     */
/*    public  ActivityBookClient(String queueName) {
        try {
            // ApplicationContext ac1 = WebApplicationContextUtils.getRequiredWebApplicationContext(ServletContext sc);
            //获得
            ApplicationContext applicationContext = SpringContextUtil.getContext();

            ActiveMQConfig activeMQConfig = (ActiveMQConfig) applicationContext.getBean("activeMQConfig");
            // 连接工厂
            ConnectionFactory connectionFactory = new ActiveMQConnectionFactory(activeMQConfig.getUserName(), activeMQConfig.getUserPwd(), activeMQConfig.getMqUrl());
            // 连接对象
            Connection connection = connectionFactory.createConnection();
            // 启动
            connection.start();
            // 获取操作连接
            Session session = connection.createSession(Boolean.FALSE, Session.AUTO_ACKNOWLEDGE);

            // 创建生产者Destination，必须在ActiveMq的Queues进行配置
            Destination producerDestination = session.createQueue(CacheConstant.ACTIVITY_PERFORM_PREFIX + queueName);

            // 创建生产者
            MessageProducer producer = session.createProducer(producerDestination);

            // 设置不持久化
            producer.setDeliveryMode(DeliveryMode.NON_PERSISTENT);

            // 创建用于接收响应信息的消费者消息目的地
            Destination  consumerDestination = session.createTemporaryQueue();
            // 创建消费者
            MessageConsumer consumer = session.createConsumer(consumerDestination);

            // 设置消费者消息监听
            consumer.setMessageListener(this);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }*/

    //预定活动
    public JmsResult bookActivitySeat(BookActivitySeatInfo activitySeatInfo, CacheService cacheService) {
        JmsResult jmsResult = new JmsResult();
        ApplicationContext applicationContext = SpringContextUtil.getContext();

        ActiveMQConfig activeMQConfig = (ActiveMQConfig) applicationContext.getBean("activeMQConfig");
        // 连接工厂
        ConnectionFactory connectionFactory = null;
        // 连接对象
        Connection connection = null;
        // 获取操作连接
        Session session = null;

        // 创建生产者Destination，必须在ActiveMq的Queues进行配置
        Destination producerDestination = null;

        // 创建生产者
        MessageProducer producer = null;


        // 创建用于接收响应信息的消费者消息目的地
        Destination  consumerDestination = null;
        // 创建消费者
        MessageConsumer consumer = null;
        try {
            // 设置消息文本
            // 连接工厂
             connectionFactory = new ActiveMQConnectionFactory(activeMQConfig.getUserName(), activeMQConfig.getUserPwd(), activeMQConfig.getActiveMqFailover());
            // 连接对象
            connection = connectionFactory.createConnection();
            // 启动
            connection.start();
            // 获取操作连接
             session = connection.createSession(Boolean.FALSE, Session.CLIENT_ACKNOWLEDGE);

            // 创建生产者Destination，必须在ActiveMq的Queues进行配置
             producerDestination = session.createQueue(CacheConstant.ACTIVITY_PERFORM_PREFIX + activitySeatInfo.getActivityId());

            // 创建生产者
             producer = session.createProducer(producerDestination);

            // 设置不持久化
             producer.setDeliveryMode(DeliveryMode.PERSISTENT);

            // 创建用于接收响应信息的消费者消息目的地
              consumerDestination = session.createTemporaryQueue();
            // 创建消费者
             consumer = session.createConsumer(consumerDestination);

            // 设置消费者消息监听
            consumer.setMessageListener(this);

            JSONObject json = JSONObject.fromObject(activitySeatInfo);

            TextMessage message = session.createTextMessage();
            message.setText(json.toString());
            // 设置响应参数
            message.setJMSReplyTo(consumerDestination);
            message.setJMSCorrelationID(activitySeatInfo.getsId());

            // 发送消息
            producer.send(message);
            int i = 50;
            while (true) {
                String resultStatus = cacheService.getValueByKey("result_" + activitySeatInfo.getActivityId() + "_" + activitySeatInfo.getsId());
                if (resultStatus != null && Constant.RESULT_STR_SUCCESS.equals(resultStatus)) {
                    JmsResult result = new JmsResult();
                    result.setSuccess(true);
                    String value = cacheService.getValueByKey("activityOderId_" + activitySeatInfo.getsId());
                    result.setMessage(value);
                    cacheService.deleteValueByKey("activityOderId_" + activitySeatInfo.getsId());
                    cacheService.deleteValueByKey("result_" + activitySeatInfo.getActivityId() + "_" + activitySeatInfo.getsId());
                    return result;
                } else if (resultStatus != null && !"".equals(resultStatus)) {
                    JmsResult result = new JmsResult();
                    result.setSuccess(false);
                    result.setMessage(resultStatus);
                    cacheService.deleteValueByKey("result_" + activitySeatInfo.getActivityId() + "_" + activitySeatInfo.getsId());
                    return result;
                }
                if (i <= 0) {
                    JmsResult result = new JmsResult();
                    result.setSuccess(false);
                    result.setMessage("请求超时，请重试");
                    cacheService.deleteValueByKey("result_" + activitySeatInfo.getActivityId() + "_" + activitySeatInfo.getsId());
                    //cacheService.deleteSetComment("activityQueues", activitySeatInfo.getActivityId() + "_N");
                    cacheService.saveQueueName("activityQueues", activitySeatInfo.getActivityId() + "_N");
                    cacheService.saveBookActivitySid(activitySeatInfo.getsId());
                    return result;
                }
                i--;
                logger.info("卖票等待中...." + i);
                Thread.sleep(200);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            jmsResult.setSuccess(false);
            jmsResult.setMessage(ex.toString());
        } finally {
            try {
                if (consumer != null) {
                    consumer.close();
                }
                if (producer != null) {
                    producer.close();
                }
                if (session != null) {
                    session.close();
                }
                if (null != connection) {
                    connection.close();
                }
            } catch (Throwable ignore) {
                ignore.printStackTrace();
                jmsResult.setSuccess(false);
                jmsResult.setMessage("2;" + ignore.toString());
            }
        }
        return jmsResult;
    }


    public void onMessage(Message message) {
        JmsResult result = null;
        try {
            message.acknowledge();
            if (message instanceof TextMessage) {
                //获得消息文本
                TextMessage textMessage = (TextMessage) message;

                JSONObject resultJson = (JSONObject) JSONSerializer.toJSON(textMessage.getText());
                result = (JmsResult) resultJson.toBean(resultJson, JmsResult.class);
                ApplicationContext context = SpringContextUtil.getContext();
                CacheService cacheService = (CacheService) context.getBean("cacheService");
                if (result.getSuccess()) {
                    cacheService.setResultValue("result_" + result.getActivityId() + "_" + result.getSid(), Constant.RESULT_STR_SUCCESS);
                    cacheService.setResultValue("activityOderId_" + result.getSid(), result.getMessage());
                } else {
                    cacheService.setResultValue("result_" + result.getActivityId() + "_" + result.getSid(), result.getMessage());

                }
            }
        } catch (JMSException e) {
            try {
                e.printStackTrace();
                TextMessage textMessage = (TextMessage) message;

                JSONObject resultJson = (JSONObject) JSONSerializer.toJSON(textMessage.getText());
                //ActivityTicketModel result = (ActivityTicketModel) resultJson.toBean(resultJson, ActivityTicketModel.class);
                result = (JmsResult) resultJson.toBean(resultJson, JmsResult.class);
                ApplicationContext context = SpringContextUtil.getContext();
                CacheService cacheService = (CacheService) context.getBean("cacheService");
                cacheService.setResultValue("result_" + result.getActivityId() + "_" + result.getSid(), e.toString());
                cacheService.setResultValue("activityOderId_" + result.getSid(), result.getActivityOrderId());
            } catch (Exception ex) {
                ex.printStackTrace();
                ApplicationContext context = SpringContextUtil.getContext();
                CacheService cacheService = (CacheService) context.getBean("cacheService");
                cacheService.setResultValue("result_" + result.getActivityId() + "_" + result.getSid(), e.toString());
            }
        }
    }

}
