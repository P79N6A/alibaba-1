package com.sun3d.why.service;

public interface CacheConstant {

     //Activity(预约类型)+Perform(活动主题)+活动的唯一编号生成存放Mq的Queue
    String ACTIVITY_PERFORM_PREFIX = "activityPerform_";

    //Activity(预约类型)+Perform(活动主题)+活动的唯一编号生成存放活动票数redis
    String ACTIVITY_PERFORM_TICKET_PREFIX="activityPerformTicket_";

    //订单号redis key的固定前缀
    String ORDER_NUMBER_KEY_PREFIX = "orderNumberKey_";

    //用户编号号redis key的固定前缀
    String USER_NUMBER_KEY_PREFIX = "userNumberKey_";

    String ACTIVITY_TICKET_COUNT = "activityTicketCount_";

    String ACTIVITY_ROOM_QUEUES = "activityRoomQueues";

    String ACTIVITY_ROOM_PERFORM_PREFIX = "activityRoomPerform_";

    String ADVERT_IMG="advert_img_";

    String TAG_CACHE="tag_cache_";

    String LIKE_ACTIVITY="LIKE_ACTIVITY_";

    String SEND_SMS_INFO="send_sms_info_";

    String LOGIN_ERROR="LOGIN_ERROR_";

    String APP_RECOMMEND_ACTIVITY="APP_RECOMMEND_ACTIVITY";

    String APP_TOP_ACTIVITY="APP_TOP_ACTIVITY_";

    // why3.5
    String APP_RECOMMEND_CMS_ACTIVITY="APP_RECOMMEND_CMS_ACTIVITY";

    String APP_TOP_CMS_ACTIVITY="APP_TOP_CMS_ACTIVITY_";

}
