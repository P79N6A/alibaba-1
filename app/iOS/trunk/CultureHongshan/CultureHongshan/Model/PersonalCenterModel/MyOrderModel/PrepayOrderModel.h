//
//  PrepayOrderModel.h
//  CultureHongshan
//
//  Created by ct on 17/2/20.
//  Copyright © 2017年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 预支付订单Model */
@interface PrepayOrderModel : NSObject
@property (nonatomic, assign) DataType type;


@property (nonatomic, assign) NSInteger orderPayStatus; // 订单支付状态

@property (nonatomic, copy) NSString *orderId; // 订单Id
@property (nonatomic, copy) NSString *activityName; // 活动名
@property (nonatomic, copy) NSString *venueName; // 所属场馆名（不存在时，需要用活动地址代替）
@property (nonatomic, copy) NSString *activityAddress; // 活动地址
@property (nonatomic, copy) NSString *activityDate; // 活动日期：2014年4月13日  周六  10:00-22:00
@property (nonatomic, copy) NSString *activitySeats; // 座位信息: 5排14座 3排13座
@property (nonatomic, copy) NSString *orderContacts; // 联系人：白晓君  123xxxxx
@property (nonatomic, assign) double activityUnitPrice; // 单价：50.00
@property (nonatomic, assign) NSInteger peopleCount; // 人数： 2
@property (nonatomic, assign) NSTimeInterval remainedTime; // 倒计时剩余时间：以秒为单位

// 支付成功后需要的参数
@property (nonatomic, copy) NSString *qrCodeImgUrl;
@property (nonatomic, copy) NSString *checkCode;


- (id)initWithAttributes:(NSDictionary *)dict type:(DataType)type;

@end
