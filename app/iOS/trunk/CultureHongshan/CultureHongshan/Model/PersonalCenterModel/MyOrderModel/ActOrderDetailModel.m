//
//  ActOrderDetailModel.m
//  CultureHongshan
//
//  Created by ct on 17/2/23.
//  Copyright © 2017年 CT. All rights reserved.
//

#import "ActOrderDetailModel.h"

@implementation ActOrderDetailModel


- (id)initWithAttributes:(NSDictionary *)dict {
    if (dict == nil || ![dict isKindOfClass:[NSDictionary class]]) return nil;
    if (self = [super init]) {
        self.isDelete = [dict safeIntForKey:@"activityIsDel"] != 1;
        
        self.longitude = [dict safeDoubleForKey:@"activityLon"];
        self.latitude  = [dict safeDoubleForKey:@"activityLat"];
        
        self.orderId      = [dict safeStringForKey:@"activityOrderId"];
        self.activityId   = [dict safeStringForKey:@"activityId"];
        self.activityName = [dict safeStringForKey:@"activityName"];
        self.venueName    = [dict safeStringForKey:@"venueName"];
        self.venueAddress = [dict safeStringForKey:@"venueAddress"];
        
        self.activityIconUrl = [dict safeImgUrlForKey:@"activityIconUrl"];
        self.addressString   = [ToolClass getJointedString:dict[@"activityAddress"] otherStr:dict[@"activitySite"] jointedBy:@" . "];
        self.activityAddress = [dict safeStringForKey:@"activityAddress"];
        
        [self activityParticipateTimeHandler:dict];
        
        
        self.orderCreatTime = [DateTool dateStringForTimeSp:[dict safeStringForKey:@"orderTime"] formatter:@"yyyy.MM.dd HH:mm:ss" millisecond:NO];
        self.orderPayTime   = [DateTool dateStringForTimeSp:[dict safeStringForKey:@"orderPayTime"] formatter:@"yyyy.MM.dd HH:mm:ss" millisecond:NO];
        
        self.orderNumber   = [ToolClass getSpaceSeparatedString:[dict safeStringForKey:@"orderNumber"] length:4];
        self.orderUserName = [dict safeStringForKey:@"orderName"];
        self.orderPhoneNum = [dict safeStringForKey:@"orderPhoneNo"];
        self.qrCodeImgUrl  = [dict safeStringForKey:@"activityQrcodeUrl"];
        //取票码处理
        self.checkCode = [ToolClass getSpaceSeparatedString:[dict safeStringForKey:@"orderValidateCode"] length:4];
        
        //积分
        self.costCredit    = [dict safeIntegerForKey:@"costTotalCredit"];
        self.tUserIsFreeze = [dict safeIntegerForKey:@"tuserIsDisplay"] == 2;//使用者是否被冻结
        
        self.activityUnitPrice = [dict safeDoubleForKey:@"activityPayPrice"];
        
        self.activityIsFree        = [dict safeIntForKey:@"activityIsFree"] == 0 || [dict safeIntForKey:@"activityIsFree"] == 1;//活动是否收费 1-免费 2-收费
        self.activityIsSalesOnline = [[dict safeStringForKey:@"activitySalesOnline"] isEqualToString:@"Y"];// Y-在线选座  N-直接前往
        self.peopleCount           = [dict safeIntegerForKey:@"orderVotes"];
        if (self.activityIsSalesOnline) {
            self.showedSeatArray = [ToolClass seatsArrayForOrderSeats:[dict safeStringForKey:@"activitySeats"]];
        }
        
        
        NSInteger orderStatus = [dict safeIntegerForKey:@"orderPayStatus"];
        self.orderStatus    = (orderStatus>0 && orderStatus<7) ? orderStatus : 0;// 1-6与服务器的订单状态一致
        self.orderPayStatus = [dict safeIntegerForKey:@"orderPaymentStatus"];
        self.orderPayMethod = [dict safeIntForKey:@"orderPayType"];
    }
    return self;
}

/** 参加日期与时间段处理 */
- (void)activityParticipateTimeHandler:(NSDictionary *)dict {
    
    NSString *startDate = [dict safeStringForKey:@"eventDate"];
    NSString *endDate   = [dict safeStringForKey:@"eventEndDate"];
    
    if (startDate.length && endDate.length) {
        if ([startDate isEqualToString:endDate]) {
            NSDate *participateDate = [DateTool dateForDateString:startDate formatter:@"yyyy-MM-dd" ];
            self.participateDate = [NSString stringWithFormat:@"%@  %@",[DateTool dateStringForDate:participateDate formatter:@"yyyy年MM月dd日"],[DateTool weekStringForDate:participateDate]];
        }else {
            self.participateDate = [NSString stringWithFormat:@"%@ 至 %@",startDate, endDate];
        }
    }else {
        self.participateDate = startDate;
    }
    
    self.participateTime = [dict safeStringForKey:@"eventTime"];
}





@end
