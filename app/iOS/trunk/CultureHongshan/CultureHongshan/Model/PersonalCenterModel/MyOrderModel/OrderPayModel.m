//
//  OrderPayModel.m
//  CultureHongshan
//
//  Created by ct on 17/2/23.
//  Copyright © 2017年 CT. All rights reserved.
//

#import "OrderPayModel.h"

@implementation OrderPayModel

- (id)initWithAttributes:(NSDictionary *)dict payType:(PayPlatformType)payType {
    if (self = [super init]) {
        
        if (dict == nil || ![dict isKindOfClass:[NSDictionary class]]) return nil;
        
        self.orderId = [dict safeStringForKey:@"orderId"];
        self.payType = payType;
        
        if (payType == PayPlatformTypeWeiXin) {
            [self handleWechatPayOrderAttributes:dict]; // 微信支付
        }else if (payType == PayPlatformTypeAliPay) {
            [self handleAliPayOrderAttributes:dict]; // 支付宝支付
        }
    }
    return self;
}

- (void)handleWechatPayOrderAttributes:(NSDictionary *)dict {
    self.partnerId = [dict safeStringForKey:@"partnerId"];
    self.prepayId  = [dict safeStringForKey:@"prepayId"];
    self.nonceStr  = [dict safeStringForKey:@"noncestr"];
    self.timeStamp = [dict safeStringForKey:@"timestamp"];
    self.package   = [dict safeStringForKey:@"pack_age"];
    self.sign      = [dict safeStringForKey:@"sign"];
}


- (void)handleAliPayOrderAttributes:(NSDictionary *)dict {
    self.orderInfo = [dict safeStringForKey:@"orderStr"];
}


@end
