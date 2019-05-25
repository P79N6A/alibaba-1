package com.sun3d.why.util;

import com.sun3d.why.dao.CmsRoomBookMapper;
import com.sun3d.why.dao.CmsRoomOrderMapper;
import com.sun3d.why.dao.CmsTerminalUserMapper;
import com.sun3d.why.dao.CmsVenueMapper;
import com.sun3d.why.model.CmsRoomBook;
import com.sun3d.why.model.CmsRoomOrder;
import com.sun3d.why.model.extmodel.SmsConfig;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.CmsUserMessageService;
import org.apache.log4j.Logger;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

/**
 * 活动室预定一系列操作公共部分
 */
public class CommonOrder {

    public static String  roomOrder(CmsRoomBook cmsRoomBook, String userId, String bookId, CmsVenueMapper cmsVenueMapper, CmsTerminalUserMapper userMapper, CmsRoomBookMapper cmsRoomBookMapper, CacheService cacheService, CmsRoomOrderMapper cmsRoomOrderMapper, CmsUserMessageService userMessageService, SmsConfig smsConfig, Logger logger) {
        //创建一个线程池
        ExecutorService pool = Executors.newFixedThreadPool(2);
        Callable roomOrderCallable = new roomOrderCallable(cmsRoomBook, userId, bookId, cmsVenueMapper, userMapper, cmsRoomBookMapper, cacheService, cmsRoomOrderMapper);
        //执行任务并获取Future对象
        Future f1 = pool.submit(roomOrderCallable);
        // 关闭线程池
        pool.shutdown();
        try {
            if (f1.get() != null) {
                CmsRoomOrder msgOrder = (CmsRoomOrder) f1.get();
                //场馆短信发送
                Map<String, Object> map = new HashMap<String, Object>();
                map.put("userName", msgOrder.getUserName());
                map.put("venueName", msgOrder.getVenueName());
                map.put("activityRoomName", msgOrder.getRoomName());
                map.put("ticketCode", msgOrder.getValidCode());

                SmsUtil.sendVenueOrderSms(msgOrder.getUserTel(), map);
                return JSONResponse.commonResultFormat(0, "预定活动室成功!", null);
            }
        } catch (Exception e) {
                   return JSONResponse.commonResultFormat(3, "保存一系列订单失败!", null);
        }
            return null;
    }
}
