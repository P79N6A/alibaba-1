//
//  OrderPayModel.h
//  CultureHongshan
//
//  Created by ct on 17/2/23.
//  Copyright © 2017年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PayService.h"

/** 订单支付Model */
@interface OrderPayModel : NSObject
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, assign) PayPlatformType payType;

/* ———————————————————————————— 微信支付 —————————————————————————————— */
@property (nonatomic, copy) NSString *partnerId; // 商户Id
@property (nonatomic, copy) NSString *prepayId; // 预支付订单Id
@property (nonatomic, copy) NSString *nonceStr; // 随机字符串：防止重发,不长于32位
@property (nonatomic, copy) NSString *timeStamp; // 时间戳：精确到秒
@property (nonatomic, copy) NSString *package; // 扩展字段：暂填写固定值Sign=WXPay
@property (nonatomic, copy) NSString *sign; // 签名

/* ———————————————————————————— 支付宝支付 —————————————————————————————— */
@property (nonatomic, copy) NSString *orderInfo;


- (id)initWithAttributes:(NSDictionary *)dict payType:(PayPlatformType)payType;

@end
