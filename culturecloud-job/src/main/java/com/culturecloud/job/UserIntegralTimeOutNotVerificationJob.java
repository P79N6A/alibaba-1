package com.culturecloud.job;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.culturecloud.dao.dto.activity.CmsActivityOrderDto;
import com.culturecloud.model.bean.activity.CmsActivityOrder;
import com.culturecloud.service.local.activity.CmsActivityOrderService;
import com.culturecloud.service.local.common.SysUserIntegralDetailService;
import com.culturecloud.util.SmsUtil;

/**
 * 未核销订单扣除积分定时器
 *
 * @author zhangshun
 */
@Component("userIntegralTimeOutNotVerificationJob")
public class UserIntegralTimeOutNotVerificationJob {

    private Logger logger = Logger.getLogger(this.getClass());

    @Autowired
    private SysUserIntegralDetailService userIntegralDetailService;

    @Autowired
    private CmsActivityOrderService cmsActivityOrderService;

    public UserIntegralTimeOutNotVerificationJob() {

        logger.info("********未核销定时器创建初始化************");
    }

    public void userIntegralTimeOutNotVerification() {

        try {

            logger.info("********未核销订单扣除积分定时器执行任务************");

            int dayAgo = 4;

            // 查询4天前没有核销的订单
            List<CmsActivityOrderDto> activityOrderList = cmsActivityOrderService.queryTimeOutNotVerificationOrder(dayAgo);

            if (!activityOrderList.isEmpty()) {


                for (CmsActivityOrderDto cmsActivityOrder : activityOrderList) {

                    String userId = cmsActivityOrder.getUserId();
                    String userName = cmsActivityOrder.getOrderName();
                    String activityId = cmsActivityOrder.getActivityId();
                    Integer deductionCredit = cmsActivityOrder.getDeductionCredit();
                    String orderId = cmsActivityOrder.getActivityOrderId();
                    String orderNumer = cmsActivityOrder.getOrderNumber();

                    int result = userIntegralDetailService.timeOutNotVerificationAddIntegral(userId, userName, activityId, deductionCredit, orderId, orderNumer);
                    String[] time = cmsActivityOrder.getActivityStartTime().split("-");
                    if (result > 0) {
//                        final Map<String, Object> tempMap = new HashMap<String, Object>();
//                        tempMap.put("userName", StringUtils.isNotBlank(cmsActivityOrder.getOrderName())?cmsActivityOrder.getOrderName():"用户");
//                        tempMap.put("activity", cmsActivityOrder.getActivityName());
//                        tempMap.put("month", time[1].toString());
//                        tempMap.put("day", time[2].toString());
//                        tempMap.put("num", cmsActivityOrder.getOrderVotes().toString());
//                        tempMap.put("branch", cmsActivityOrder.getDeductionCredit().toString());
//                        SmsUtil.deductionOrderCode(cmsActivityOrder.getOrderPhoneNo(), tempMap);
                        logger.info("********未核销订单扣除积分：" + "订单ID" + orderId + " 订单号：" + orderNumer + " 活动ID：" + activityId + " 用户名：" + userName + "用户id：" + userId + "************");
                    }
                }
            } 

            logger.info("********未核销订单扣除积分定时器处理完毕！************");

        } catch (Exception e) {

            logger.error("********未核销订单扣除积分定时器执行任务失败！************", e);

            e.printStackTrace();
        }

    }


}