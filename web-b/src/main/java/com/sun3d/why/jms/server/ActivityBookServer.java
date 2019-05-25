package com.sun3d.why.jms.server;

import com.sun3d.why.jms.model.JmsResult;
import com.sun3d.why.model.*;
import com.sun3d.why.model.extmodel.ActiveMQConfig;
import com.sun3d.why.model.extmodel.BookActivitySeatInfo;
import com.sun3d.why.service.*;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.SpringContextUtil;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;
import org.apache.activemq.ActiveMQConnectionFactory;
import org.apache.commons.lang3.StringUtils;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.jms.*;
import javax.servlet.ServletContextEvent;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;


public class ActivityBookServer implements MessageListener {

//    /**
//     * 连接工厂，JMS用它创建连接
//     */
//    private ConnectionFactory connectionFactory = null;
//
//    /**
//     * 连接对象，JMS到Provider、Consumer的连接
//     */
//    private Connection connection = null;
//
//    /**
//     * 一个发送或接收消息的线程
//     */
//    private Session session = null;
//
//    /**
//     * JMS生产者，用于发送响应消息
//     */
//    private MessageProducer producer = null;
//
//    /**
//     * JMS消费者消息目的地
//     */
//    private Destination consumerDestination = null;
//
//    /**
//     * JMS消费者，用于接收请求消息
//     */
//    private MessageConsumer consumer = null;
//
//    private CacheService cacheService = null;
//
//    private CmsActivityOrderService cmsActivityOrderService = null;



    public ActivityBookServer(ServletContextEvent event,String queueName) {
        WebApplicationContext context = WebApplicationContextUtils.getRequiredWebApplicationContext(event.getServletContext());
        ConnectionFactory connectionFactory = null;

        Connection connection = null;

        Session session = null;

        MessageProducer producer = null;

        Destination consumerDestination = null;

        MessageConsumer consumer = null;
        ActiveMQConfig activeMQConfig = (ActiveMQConfig)context.getBean("activeMQConfig");
        try {
           // SingleConnectionFactory singleConnectionFactory = new SingleConnectionFactory()
            // 连接工厂
             connectionFactory = new ActiveMQConnectionFactory(activeMQConfig.getUserName(), activeMQConfig.getUserPwd(), activeMQConfig.getActiveMqFailover());
            // 连接对象
             connection = connectionFactory.createConnection();
            // 启动
            connection.start();
            // 获取操作连接
              session = connection.createSession(Boolean.FALSE, Session.CLIENT_ACKNOWLEDGE);

            // 创建消费者Destination
             consumerDestination = session.createQueue(CacheConstant.ACTIVITY_PERFORM_PREFIX + queueName);

            // 创建消费者
             consumer = session.createConsumer(consumerDestination);
            // 设置消费者消息监听
            consumer.setMessageListener(this);
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    public void onMessage(Message message) {
        JmsResult result = new JmsResult();
        ConnectionFactory connectionFactory = null;

        Connection connection = null;

        Session session = null;

        MessageProducer producer = null;

        Destination consumerDestination = null;

        MessageConsumer consumer = null;
        CacheService cacheService = null;
        ApplicationContext applicationContext = null;
     /*   CmsActivityEventService cmsActivityEventService = null;*/
        try {
            applicationContext = SpringContextUtil.getContext();
            cacheService = (CacheService) applicationContext.getBean("cacheService");
            //CmsActivityOrderService cmsActivityOrderService = (CmsActivityOrderService)applicationContext.getBean("cmsActivityOrderService");
            //cmsActivityEventService = (CmsActivityEventService)applicationContext.getBean("cmsActivityEventService");
            ActiveMQConfig activeMQConfig = (ActiveMQConfig)applicationContext.getBean("activeMQConfig");
            // 连接工厂
            connectionFactory = new ActiveMQConnectionFactory(activeMQConfig.getUserName(), activeMQConfig.getUserPwd(), activeMQConfig.getActiveMqFailover());
            // 连接对象
            connection = connectionFactory.createConnection();
            // 启动
            connection.start();
            // 获取操作连接
            session = connection.createSession(Boolean.FALSE, Session.CLIENT_ACKNOWLEDGE);

            if (message instanceof TextMessage) {
                //获得消息文本
                TextMessage textMessage = (TextMessage) message;
                String messageText = textMessage.getText();
                //将消息文本转换为对象
                JSONObject json = (JSONObject) JSONSerializer.toJSON(messageText);
                
                BookActivitySeatInfo ticket = (BookActivitySeatInfo) json.toBean(json, BookActivitySeatInfo.class);
                //判断请求是否超时 超时不生成订单信息
                String bookStatus  = cacheService.getValueByKey(ticket.getsId());
                //Y代表超时了
                if ("Y".equals(bookStatus)) {
                    result.setSuccess(false);
                    cacheService.deleteValueByKey(ticket.getsId());
                } else {
                    if(ticket==null|| StringUtils.isBlank(ticket.getActivityId())||StringUtils.isBlank(ticket.getUserId())){
                        result.setSuccess(false);
                    } else {
                        //当为预定的时候
                        if (ticket.isBook()) {
                            result = bookActivitySeat(result,ticket);
                        } else {
                            //当为取消预定的时候
                            result = cancelActivitySeat(result,ticket);
                        }
                        result.setActivityId(ticket.getActivityId());
                        result.setUserId(ticket.getUserId());
                        result.setSid(ticket.getsId());
                        result.setSysNo(ticket.getSysNo());
                        result.setSysId(ticket.getSysId());
                    }
                }


/*                // 创建消费者Destination
                consumerDestination = session.createQueue(CacheConstant.ACTIVITY_PERFORM_PREFIX + ticket.getActivityId());

                // 创建消费者
                consumer = session.createConsumer(consumerDestination);
                // 设置消费者消息监听
                consumer.setMessageListener(this);*/

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
                message.acknowledge();
                // 发送响应消息
                producer.send(message.getJMSReplyTo(), responseMessage);
            }
        } catch (JMSException e) {
            e.printStackTrace();
            result.setSuccess(false);
            result.setMessage(e.toString());
            JSONObject resultJson = JSONObject.fromObject(result);
            try {
                // 创建响应文本对象
                TextMessage responseMessage = session.createTextMessage();

                //设置响应文本
                responseMessage.setText(resultJson.toString());

                //设置响应参数
                responseMessage.setJMSCorrelationID(message.getJMSCorrelationID());
                // 创建生产者
                producer = session.createProducer(null);
                // 设置不持久化
                producer.setDeliveryMode(DeliveryMode.NON_PERSISTENT);
                // 发送响应消息
                producer.send(message.getJMSReplyTo(), responseMessage);
                //确认该信息已经被签收
                message.acknowledge();
            } catch (JMSException e1) {
                e1.printStackTrace();
            }


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


    /**
     * 帮助方法
     * @param strs
     * @return
     */
    public String ArrayToString(String [] strs) {
        StringBuffer sb = new StringBuffer();
        for (String str : strs) {
            sb.append(str + ",");
        }
        return sb.toString();
    }


    /**
     * 预定座位时候的处理逻辑
     * @param result
     * @param ticket
     * @return
     */
    public JmsResult bookActivitySeat(JmsResult result,BookActivitySeatInfo ticket) {
        {
            ApplicationContext applicationContext = SpringContextUtil.getContext();
            CacheService cacheService = (CacheService) applicationContext.getBean("cacheService");
            CmsActivityOrderService cmsActivityOrderService = (CmsActivityOrderService)applicationContext.getBean("cmsActivityOrderService");
            CmsActivityEventService cmsActivityEventService = (CmsActivityEventService)applicationContext.getBean("cmsActivityEventService");
            result.setSid(ticket.getsId());
            //判断是否站位被占用
            String rs = cacheService.checkActivitySeatStatus(ticket, ticket.getSeatIds(),ticket.getBookCount(),ticket.getUserId());//cacheService.getValueByKey(ticket.getContentId().toString());
            if (!Constant.RESULT_STR_SUCCESS.equals(rs)) {
                result.setMessage(rs);
                result.setSuccess(false);
            } else {
                CmsActivityOrder cmsActivityOrder = new CmsActivityOrder();
                cmsActivityOrder.setOrderType(ticket.getType());
                cmsActivityOrder.setUserId(ticket.getUserId());
                cmsActivityOrder.setActivityId(ticket.getActivityId());
                cmsActivityOrder.setOrderNumber(ticket.getOrderNumber());
                cmsActivityOrder.setOrderPhoneNo(ticket.getPhone());
                cmsActivityOrder.setOrderName(ticket.getOrderName());
                cmsActivityOrder.setOrderIdentityCard(ticket.getOrderIdentityCard());
                cmsActivityOrder.setOrderPrice(ticket.getPrice());
                //订单是否支付状态(1-未出票 2-已取消 3-已出票 4-已验票 5-已失效 )
                cmsActivityOrder.setOrderPayStatus(Constant.ACTIVITY_ORDER_PAY_STATUS_UNBILLED);
                cmsActivityOrder.setSysId(ticket.getSysId());
                cmsActivityOrder.setSysNo(ticket.getSysNo());
                cmsActivityOrder.setEventId(ticket.getEventId());
                cmsActivityOrder.setEventDateTime(ticket.getEventDateTime());
                if (ticket.getSeatIds() == null || ticket.getSeatIds().length == 0) {
                    cmsActivityOrder.setOrderVotes(ticket.getBookCount());
                } else {
                    cmsActivityOrder.setOrderVotes(ticket.getSeatIds().length);
                    cmsActivityOrder.setOrderSummary(ArrayToString(ticket.getSeatIds()));
                }
                //先修改座位状态 修改成功后再生成订单信息   订单生成失败的话 座位还原 并提示用户
                String trs = "";
                //抢票  无座位
                if (ticket.getSeatIds() == null || ticket.getSeatIds().length == 0) {
                    trs = cacheService.subtractTicketCountById(ticket.getActivityId(),ticket.getEventDateTime(), ticket.getBookCount());
                    if (!"success".equals(trs)) {
                        result.setMessage(trs);
                        result.setSuccess(false);
                    } else {
                        int count = 0;
                        try {
                            String res=cmsActivityOrderService.addActivityOrder(cmsActivityOrder);
                            if(!Constant.RESULT_STR_FAILURE.equals(res)){
                                count=1;
                            }
                        } catch (Exception ex) {
                            ex.printStackTrace();
                            count = 0;
                        }
                        if (count == 0) {
                            result.setMessage("订单生成失败");
                            trs= "订单生成失败";
                            result.setSuccess(false);
                            String type = "N";
                            if (cmsActivityOrder.getOrderSummary() != null && StringUtils.isNotBlank(cmsActivityOrder.getOrderSummary())) {
                                type = "Y";
                            }
                            CmsActivityEvent cmsActivityEvent = cmsActivityEventService.queryByEventId(ticket.getEventId());
                            //座位信息还原
                            cacheService.cancelOrder(cmsActivityOrder.getActivityId(), cmsActivityOrder, cmsActivityEvent, cmsActivityOrder.getOrderSummary(), cmsActivityOrder.getOrderVotes(), null, type);
                        }
                    }
                } else {  //抢票    有座位
                    //座位未被占用时出队后修改 座位状态
                    trs = cacheService.updateSeatStatus(ticket);
                    //座位状态 修改成功后生成订单
                    if (Constant.RESULT_STR_SUCCESS.equals(trs)) {
                        int count = 0;
                        try {
                            String res= cmsActivityOrderService.addActivityOrder(cmsActivityOrder);
                            if(!Constant.RESULT_STR_FAILURE.equals(res)){
                                count=1;
                            }
                        } catch (Exception ex) {
                            ex.printStackTrace();
                            count = 0;
                        }
                        if (count == 0) {
                            result.setMessage("订单生成失败");
                            result.setSuccess(false);
                            trs= "订单生成失败";
                            String type = "N";
                            if (cmsActivityOrder.getOrderSummary() != null && StringUtils.isNotBlank(cmsActivityOrder.getOrderSummary())) {
                                type = "Y";
                            }
                            //座位信息还原
                            CmsActivityEvent cmsActivityEvent = cmsActivityEventService.queryByEventId(ticket.getEventId());
                            cacheService.cancelOrder(cmsActivityOrder.getActivityId(),cmsActivityOrder,cmsActivityEvent,cmsActivityOrder.getOrderSummary(),cmsActivityOrder.getOrderVotes(),null,type);
                        }
                    }
                }
                if (!"success".equals(trs)) {
                    result.setSuccess(false);
                    result.setMessage(trs);
                } else {
                    result.setSuccess(true);
                    result.setMessage(cmsActivityOrder.getActivityOrderId());
                    result.setActivityOrderId(cmsActivityOrder.getActivityOrderId());
                    //修改剩余票数
                    //修改数据库剩余票数
                    CmsActivityEvent cmsActivityEvent  = cmsActivityEventService.queryByEventId(ticket.getEventId());
                    cmsActivityEvent.setAvailableCount(cmsActivityEvent.getAvailableCount() - cmsActivityOrder.getOrderVotes());
                    cmsActivityEventService.editByActivityEvent(cmsActivityEvent);
                }
            }
        }
        return result;
    }

    /**
     * 取消预定的座位
     * @return
     */
    public JmsResult cancelActivitySeat(JmsResult result,BookActivitySeatInfo ticket) {
        ApplicationContext applicationContext = SpringContextUtil.getContext();
        CacheService cacheService = (CacheService) applicationContext.getBean("cacheService");
        CmsActivityOrderService cmsActivityOrderService = (CmsActivityOrderService)applicationContext.getBean("cmsActivityOrderService");
        CmsActivityEventService cmsActivityEventService = (CmsActivityEventService)applicationContext.getBean("cmsActivityEventService");
        CmsActivityOrderDetailService cmsActivityOrderDetailService = (CmsActivityOrderDetailService)applicationContext.getBean("cmsActivityOrderDetailService");

        //检查订单能否被取消
        String strRs = cacheService.checkSeatStatusByCancel(ticket,ticket.getSeatIds(),ticket.getBookCount(),ticket.getUserId());
        Integer backCount = 0;
        if (Constant.RESULT_STR_SUCCESS.equals(strRs)) {

            //修改内存中座位的状态
            CmsActivityEvent cmsActivityEvent =cmsActivityEventService.queryByEventId(ticket.getEventId());
            CmsActivityOrder activityOrder = cmsActivityOrderService.queryCmsActivityOrderById(ticket.getOrderId());
            if ("N".equals(activityOrder.getActivitySalesOnline())) {
                backCount =activityOrder.getOrderVotes();
            } else if ("Y".equals(activityOrder.getActivitySalesOnline())) {
                backCount = ticket.getSeatIds().length;
            }
            String seatInfo =ticket.getSeatIds() == null ? "" : ArrayToString(ticket.getSeatIds());
            String rs = cacheService.cancelOrder(ticket.getActivityId(),activityOrder,cmsActivityEvent, seatInfo ,backCount, null ,activityOrder.getActivitySalesOnline());
            //内存中座位修改成功 改变数据库座位状态
            //自由入座取消整个订单
            if ("N".equals(activityOrder.getActivitySalesOnline())) {
                Map updateMap = new HashMap();
                updateMap.put("activityOrderId",ticket.getOrderId());
                //修改订单主表状态
                int count = cmsActivityOrderService.updateOrderByActivityOrderId(updateMap);
                //修改订单子表状态
                try {
                    cmsActivityOrderDetailService.updateOrderSeatStatusByOrderId(updateMap);
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
                cmsActivityEvent.setAvailableCount(cmsActivityEvent.getAvailableCount() + backCount);
            } else {
                //在线入座取消选中的座位订单
                Map updateMap = new HashMap();
                updateMap.put("activityOrderId",activityOrder.getActivityOrderId());
                updateMap.put("seatCodes", ticket.getSeatIds());
                try {
                    int count = cmsActivityOrderDetailService.updateOrderSeatStatusBySeats(updateMap);
                } catch (Exception ex) {
                    ex.printStackTrace();
                }

                activityOrder.setOrderVotes(activityOrder.getOrderVotes() - backCount);
/*                if (activityOrder.getOrderVotes() == 0) {
                    //全部取消时根据子表订单状态修改主表状态
                    activityOrder.setOrderPayStatus((short)2);
                }*/
                //全部无预定成功状态时根据子表订单状态修改主表状态
                int count = cmsActivityOrderDetailService.queryCmsActivityOrderDetailByStatus(ticket.getOrderId(), Constant.ORDER_PAY_STATUS1);
                //不存在未取票的时候
                if (count == 0) {
                    //查询已取票的
                    count = cmsActivityOrderDetailService.queryCmsActivityOrderDetailByStatus(ticket.getOrderId(), Constant.ORDER_PAY_STATUS3);
                    if(count > 0) {
                        activityOrder.setOrderPayStatus((short)3);
                    }else {
                        //查询已验票的
                        count = cmsActivityOrderDetailService.queryCmsActivityOrderDetailByStatus(ticket.getOrderId(), (int)Constant.ORDER_PAY_STATUS4);
                        //如果不存在已验票的
                        if (count == 0) {
                            activityOrder.setOrderPayStatus((short)2);
                        } else {
                            activityOrder.setOrderPayStatus((short)4);
                        }

                    }
                } else {
                    activityOrder.setOrderPayStatus((short)1);
                }

                cmsActivityOrderService.editActivityOrder(activityOrder);
                cmsActivityEvent.setAvailableCount(cmsActivityEvent.getAvailableCount() + backCount);
            }
            cmsActivityEventService.editByActivityEvent(cmsActivityEvent);
            result.setActivityOrderId(activityOrder.getActivityOrderId());
            result.setSuccess(true);
            result.setMessage(activityOrder.getActivityOrderId());

        } else {
            result.setSuccess(false);
            result.setMessage(strRs);
        }
        result.setUserId(ticket.getUserId());
        result.setSid(ticket.getsId());

        return result;
    }


}
