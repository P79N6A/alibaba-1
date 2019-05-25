//
//  PayService.h
//  CultureHongshan
//
//  Created by ct on 16/5/12.
//  Copyright © 2016年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>


/** 支付平台的定义 */
typedef NS_ENUM(NSInteger, PayPlatformType) {
    /** 未知的支付平台 */
    PayPlatformTypeUnknown = 0,
    /** 微信支付 */
    PayPlatformTypeWeiXin,
    /** 支付宝支付 */
    PayPlatformTypeAliPay,
    /** 苹果支付 */
    PayPlatformTypeApple,
};


/**
 支付回调Block

 @param statusCode 状态码: 1-成功 2-支付失败 3-用户取消支付
 @param result     成功时，返回订单信息字典； 失败时，返回错误提示信息
 */
typedef void(^PayResultBlock)(NSInteger statusCode, id result);



@interface PayService : NSObject


+ (void)registerAppForPayWithOptions:(NSDictionary *)launchOptions;
+ (BOOL)handleOpenURL:(NSURL *)url;
+ (BOOL)supportPayService;
+ (void)payWithPlatformType:(PayPlatformType)platform payParams:(NSDictionary *)payParams completionHandler:(PayResultBlock)handler;



@end


