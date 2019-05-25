package com.sun3d.why.jms.client;

import com.sun3d.why.jms.model.JmsResult;
import com.sun3d.why.model.CmsRoomBook;
import com.sun3d.why.model.extmodel.ActiveMQConfig;
import com.sun3d.why.service.CacheConstant;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.SpringContextUtil;
import com.sun3d.why.util.UUIDUtils;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;
import org.apache.activemq.ActiveMQConnectionFactory;
import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;

import javax.jms.*;
import java.text.SimpleDateFormat;
import java.util.Date;

@Deprecated
public class ActivityRoomBookClient implements MessageListener {

    private Logger logger = Logger.getLogger(ActivityRoomBookClient.class);
    //预定活动
    //cmsRoomBook  提交的需要预定的座位信息
    //cacheService 操作内存对像的service
    public JmsResult bookActivityRoom(CmsRoomBook cmsRoomBook, CacheService cacheService) {
        JmsResult jmsResult = new JmsResult();
        //生成Redis KEY值前缀
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        String resultPrefix = "result_" + sdf.format(new Date()) + "_";
        //获取Spring上下文
        ApplicationContext applicationContext = SpringContextUtil.getContext();
        //获取MQ配置信息
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
            session = connection.createSession(Boolean.FALSE, Session.AUTO_ACKNOWLEDGE);
            //*****************************----------------生产者创建-------------
            // 创建生产者Destination，必须在ActiveMq的Queues进行配置
            producerDestination = session.createQueue(CacheConstant.ACTIVITY_ROOM_PERFORM_PREFIX + cmsRoomBook.getRoomId());
            // 创建生产者
            producer = session.createProducer(producerDestination);
            // 设置不持久化
            producer.setDeliveryMode(DeliveryMode.PERSISTENT);
            //*****************************----------------消费者创建-------------
            // 创建用于接收响应信息的消费者消息目的地
            consumerDestination = session.createTemporaryQueue();
            // 创建消费者
            consumer = session.createConsumer(consumerDestination);
            // 设置消费者消息监听(代表用当前的onMessage方法监听Server端的响应消息)
            consumer.setMessageListener(this);
            //*****************************----------------预定消息创建-------------
            //避免重复，生成唯一的ID值
            cmsRoomBook.setsId(UUIDUtils.createUUId());
            // 设置消息文本  每个预定请求唯一的 userId 每个对象唯一的主键
            JSONObject json = JSONObject.fromObject(cmsRoomBook);
            TextMessage message = session.createTextMessage();
            message.setText(json.toString());
            message.setJMSCorrelationID(cmsRoomBook.getsId());
            //*****************************----------------设置Server端响应消息的目的地-------------
            // 设置响应参数
            message.setJMSReplyTo(consumerDestination);
            //*****************************----------------发送消息给Server端-------------
            // 发送消息
            producer.send(message);
            int i = 50;
            //监听消费者是否 返回消费信息
            while(true){
                String rs = cacheService.getValueByKey(resultPrefix + cmsRoomBook.getRoomId() + "_" +cmsRoomBook.getsId());
                if(Constant.RESULT_STR_SUCCESS.equals(rs)){
                    JmsResult result = new JmsResult();
                    result.setSuccess(true);
                    result.setMessage("预定成功!");
                    result.setSysId(cmsRoomBook.getSysId());
                    result.setSysNo(cmsRoomBook.getSysNo());
                    cacheService.deleteValueByKey(resultPrefix + cmsRoomBook.getRoomId() + "_" +cmsRoomBook.getsId());
                    return result;
                } else if (rs != null && !"".equals(rs)) {
                    JmsResult result = new JmsResult();
                    result.setSuccess(false);
                    result.setMessage(rs);
                    cacheService.deleteValueByKey(resultPrefix + cmsRoomBook.getRoomId() + "_" +cmsRoomBook.getsId());
                    return result;
                }
                if (i <= 0) {
                    JmsResult result = new JmsResult();
                    result.setSuccess(false);
                    result.setMessage("请求超时,请重试!");
                    cacheService.deleteValueByKey(resultPrefix + cmsRoomBook.getRoomId() + "_" +cmsRoomBook.getsId());
                    cacheService.saveQueueName(CacheConstant.ACTIVITY_ROOM_QUEUES, cmsRoomBook.getRoomId() + "_N");
                    return result;
                }
                i --;

                logger.info("卖票等待中...." + i);
                Thread.sleep(200);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            jmsResult.setSuccess(false);
            jmsResult.setMessage("服务器异常,预定失败!");
            logger.error(ex.toString());
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
                jmsResult.setMessage("服务器异常,预定失败!");
                logger.error(ignore.toString());
            }
        }
        return jmsResult;
    }

    // 接收 ActivityRoomBookServer 对象返回的信息
    public void onMessage(Message message) {
        JmsResult result = null;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        String resultPrefix = "result_" + sdf.format(new Date()) + "_";
        try {
            if (message instanceof TextMessage) {
                //获得消息文本
                TextMessage textMessage = (TextMessage) message;

                JSONObject resultJson = (JSONObject) JSONSerializer.toJSON(textMessage.getText());
                result = (JmsResult) resultJson.toBean(resultJson, JmsResult.class);
                ApplicationContext context = SpringContextUtil.getContext();
                CacheService  cacheService = (CacheService)context.getBean("cacheService");
                if(result.getSuccess()) {
                    cacheService.setResultValue(resultPrefix + result.getRoomId() + "_" + result.getSid(), Constant.RESULT_STR_SUCCESS);
                } else {
                    cacheService.setResultValue(resultPrefix + result.getRoomId() + "_" + result.getSid(), result.getMessage());
                }
            }
        } catch (JMSException e) {
            e.printStackTrace();
            ApplicationContext context = SpringContextUtil.getContext();
            CacheService cacheService = (CacheService) context.getBean("cacheService");
            cacheService.setResultValue(resultPrefix + result.getRoomId() + "_" + result.getSid(), e.toString());
        }
    }

}
