package com.sun3d.why.jms.server;

import com.sun3d.why.jms.model.JmsResult;
import com.sun3d.why.model.CmsRoomBook;
import com.sun3d.why.model.extmodel.ActiveMQConfig;
import com.sun3d.why.service.CacheConstant;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.SpringContextUtil;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;
import org.apache.activemq.ActiveMQConnectionFactory;
import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.jms.*;
import javax.servlet.ServletContextEvent;

@Deprecated
public class ActivityRoomBookServer implements MessageListener {

    private Logger logger = Logger.getLogger(ActivityRoomBookServer.class);

    public ActivityRoomBookServer(ServletContextEvent event,String queueName) {
        WebApplicationContext context = WebApplicationContextUtils.getRequiredWebApplicationContext(event.getServletContext());
        ConnectionFactory connectionFactory = null;
        Connection connection = null;
        Session session = null;
        MessageProducer producer = null;
        Destination consumerDestination = null;
        MessageConsumer consumer = null;
//        CacheService cacheService = null;
        //注入Service
        ActiveMQConfig activeMQConfig = (ActiveMQConfig)context.getBean("activeMQConfig");
        try {
//            cacheService = (CacheService) context.getBean("cacheService");
            // 连接工厂
            connectionFactory = new ActiveMQConnectionFactory(activeMQConfig.getUserName(), activeMQConfig.getUserPwd(), activeMQConfig.getActiveMqFailover());
            // 连接对象
            connection = connectionFactory.createConnection();
            // 启动
            connection.start();
            // 获取操作连接
            session = connection.createSession(Boolean.FALSE, Session.AUTO_ACKNOWLEDGE);
            // 创建消费者Destination
            consumerDestination = session.createQueue(CacheConstant.ACTIVITY_ROOM_PERFORM_PREFIX + queueName);
            // 创建消费者
            consumer = session.createConsumer(consumerDestination);
            // 设置消费者消息监听
            consumer.setMessageListener(this);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //接收ActivityRoomBookServerClient 发送的消息
    public void onMessage(Message message) {
        ConnectionFactory connectionFactory = null;
        Connection connection = null;
        Session session = null;
        MessageProducer producer = null;
        Destination consumerDestination = null;
        MessageConsumer consumer = null;
        ApplicationContext applicationContext = SpringContextUtil.getContext();
        CacheService cacheService = (CacheService) applicationContext.getBean("cacheService");
        JmsResult result = new JmsResult();
        try {
            ActiveMQConfig activeMQConfig = (ActiveMQConfig)applicationContext.getBean("activeMQConfig");
            // 连接工厂
            connectionFactory = new ActiveMQConnectionFactory(activeMQConfig.getUserName(), activeMQConfig.getUserPwd(),activeMQConfig.getActiveMqFailover());
            // 连接对象
            connection = connectionFactory.createConnection();
            // 启动
            connection.start();
            // 获取操作连接
            session = connection.createSession(Boolean.FALSE, Session.AUTO_ACKNOWLEDGE);
            //*****************************----------------判断消息类型，根据生产者端代码进行判断------------
            if (message instanceof TextMessage) {
                //获得消息文本
                TextMessage textMessage = (TextMessage) message;
                String messageText = textMessage.getText();
                //将消息文本转换为对象
                JSONObject json = (JSONObject) JSONSerializer.toJSON(messageText);
                CmsRoomBook ticket = (CmsRoomBook) json.toBean(json, CmsRoomBook.class);
                //*****************************----------------用户控制KEY值的唯一性------------
                result.setRoomId(ticket.getRoomId());
                result.setSid(ticket.getsId());
                result.setSysId(ticket.getSysId());
                result.setSysNo(ticket.getSysNo());
                String rs = cacheService.bookVenueRoom(ticket.getRoomId(), ticket.getBookId());
                if (!Constant.RESULT_STR_SUCCESS.equals(rs)) {
                    result.setMessage(rs);
                    result.setSuccess(false);
                } else {
                    result.setMessage("活动室预定成功!");
                    result.setSuccess(true);
                }

                JSONObject resultJson = JSONObject.fromObject(result);
                // 创建响应文本对象
                TextMessage responseMessage = session.createTextMessage();
                //设置响应文本
                responseMessage.setText(resultJson.toString());
                //设置响应参数
                responseMessage.setJMSCorrelationID(message.getJMSCorrelationID());
                // 创建生产者
                producer = session.createProducer(null);
                // 设置不持久化
                producer.setDeliveryMode(DeliveryMode.PERSISTENT);
                // 发送响应消息
                producer.send(message.getJMSReplyTo(), responseMessage);
            }
        } catch (JMSException e) {
            //Handle the exception appropriately
            e.printStackTrace();
            logger.error(e.toString());
            try {
                //获得消息文本
                TextMessage textMessage = (TextMessage) message;
                String messageText = textMessage.getText();
                //将消息文本转换为对象
                JSONObject json = (JSONObject) JSONSerializer.toJSON(messageText);
                CmsRoomBook ticket = (CmsRoomBook) json.toBean(json, CmsRoomBook.class);
                result.setSid(ticket.getsId());
                result.setRoomId(ticket.getRoomId());
                // 创建响应文本对象
                TextMessage responseMessage = session.createTextMessage();
                result.setSuccess(false);
                result.setMessage("服务器异常，预定失败!");
                JSONObject resultJson = JSONObject.fromObject(result);
                //设置响应文本
                responseMessage.setText(resultJson.toString());
                //设置响应参数
                responseMessage.setJMSCorrelationID(message.getJMSCorrelationID());
                // 创建生产者
                producer = session.createProducer(null);
                // 设置不持久化
                producer.setDeliveryMode(DeliveryMode.PERSISTENT);
                // 发送响应消息
                producer.send(message.getJMSReplyTo(), responseMessage);
            } catch (Exception ex) {
                ex.printStackTrace();
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
                }
            }

        }
    }

}
