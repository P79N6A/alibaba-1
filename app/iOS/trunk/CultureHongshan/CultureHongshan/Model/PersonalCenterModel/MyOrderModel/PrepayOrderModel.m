//
//  PrepayOrderModel.m
//  CultureHongshan
//
//  Created by ct on 17/2/20.
//  Copyright © 2017年 CT. All rights reserved.
//

#import "PrepayOrderModel.h"

@implementation PrepayOrderModel

- (id)initWithAttributes:(NSDictionary *)dict type:(DataType)type {
    if (self = [super init]) {
        
        if (dict == nil || ![dict isKindOfClass:[NSDictionary class]]) return nil;
        self.type = type;
        
        if (type == DataTypeActivity) {
            
            self.orderId           = [dict safeStringForKey:@"activityOrderId"];
            self.activityName      = [dict safeStringForKey:@"activityName"];
            self.venueName         = [dict safeStringForKey:@"venueName"];
            self.activityAddress   = [dict safeStringForKey:@"activityAddress"];
            self.activityUnitPrice = [dict safeDoubleForKey:@"activityPayPrice"];
            self.peopleCount       = [dict safeIntegerForKey:@"orderVotes"];
            self.orderPayStatus    = [dict safeIntegerForKey:@"orderPaymentStatus"];
            self.orderContacts = [ToolClass getJointedString:[dict safeStringForKey:@"orderName"] otherStr:[dict safeStringForKey:@"orderPhoneNo"] jointedBy:@"  "];
            
            // 支付成功后需要的参数
            self.qrCodeImgUrl      = [dict safeStringForKey:@"activityQrcodeUrl"];
            self.checkCode         = [dict safeStringForKey:@"orderValidateCode"];
            
            
            // 日期处理
            NSString *startDate = [dict safeStringForKey:@"eventDate"];
            NSString *endDate = [dict safeStringForKey:@"eventEndDate"];
            NSString *eventTime = [dict safeStringForKey:@"eventTime"];
            
            if (startDate.length && endDate.length) {
                if ([startDate isEqualToString:endDate]) {
                    NSDate *participateDate = [DateTool dateForDateString:startDate formatter:@"yyyy-MM-dd" ];
                    self.activityDate = [NSString stringWithFormat:@"%@  %@  %@", [DateTool dateStringForDate:participateDate formatter:@"yyyy年MM月dd日"], [DateTool weekStringForDate:participateDate], eventTime];
                }else {
                    self.activityDate = [NSString stringWithFormat:@"%@至%@  %@",startDate, endDate, eventTime];
                }
            }else{
                self.activityDate = startDate;
            }
            
            // 倒计时处理
            NSTimeInterval orderCreateTime = [dict safeIntegerForKey:@"orderTime"];
            NSTimeInterval nowTime = ([dict safeStringForKey:@"now"].length > 10) ? [[dict safeStringForKey:@"now"] longLongValue]/1000 : [[dict safeStringForKey:@"now"] longLongValue];
            self.remainedTime = MAX(orderCreateTime + 900 - nowTime, 0); // 15分钟
            
            // 座位
            if ([[dict safeStringForKey:@"activitySalesOnline"] isEqualToString:@"Y"]) {
                NSArray *seatArray = [ToolClass seatsArrayForOrderSeats:[dict safeStringForKey:@"activitySeats"]];
                if (seatArray.count) {
                    self.activitySeats = [ToolClass getComponentString:seatArray combinedBy:@" "];
                }
            }
            
            
        }else {
            return nil;
        }
    }
    return self;
}




@end
