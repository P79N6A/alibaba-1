//
//  PayService.m
//  CultureHongshan
//
//  Created by ct on 16/5/12.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "PayService.h"

#import "WechatAuthSDK.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>



#pragma mark- ————————————————————

@protocol PayServiceDelegate;
@interface PayServiceManager : NSObject<WXApiDelegate>
@property (nonatomic, weak) id<PayServiceDelegate> delegate;
@property (nonatomic, assign) BOOL isPaying;
@property (nonatomic, strong) NSDictionary *payParams;
@property (nonatomic, copy) PayResultBlock completionHandler;
+ (instancetype)sharedManager;

/**
 *  处理支付宝订单的回调
 *
 *  @param resultDict 支付宝返回的订单支付结果
 */
- (void)processAlipayOrderResultDict:(NSDictionary *)resultDict isUrlCallback:(BOOL)isUrlCallback;
@end




@protocol PayServiceDelegate <NSObject>
@optional
@end







#pragma mark -


@implementation PayService


+ (void)registerAppForPayWithOptions:(NSDictionary *)launchOptions {
    [WXApi registerApp:kAppID_Wechat withDescription:APP_SHOW_NAME];
}

+ (BOOL)handleOpenURL:(NSURL *)url {
    
    FBLOG(@"支付结果回调URL： %@", url);
    
    if ([url.host isEqualToString:@"safepay"]) {
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            FBLOG(@"授权跳转支付宝钱包进行支付，处理支付结果processAuth_V2Result—————————————————— 1 ————————");
            [[PayServiceManager sharedManager] processAlipayOrderResultDict:resultDic isUrlCallback:YES];
        }];
        
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            // URL处理订单支付结果processOrderWithPaymentResult
            FBLOG(@"URL处理订单支付结果processOrderWithPaymentResult——————————————— 2 —————");
            [[PayServiceManager sharedManager] processAlipayOrderResultDict:resultDic isUrlCallback:YES];
        }];
        
        return YES;
    }else if ([url.host isEqualToString:@"platformapi"]) {
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            FBLOG(@"支付宝钱包快登授权返回processAuthResult——————————————————————— 3 —————————");
            [[PayServiceManager sharedManager] processAlipayOrderResultDict:resultDic isUrlCallback:YES];
        }];
        
        return YES;
    }else {
        return [WXApi handleOpenURL:url delegate:[PayServiceManager sharedManager]];
    }
}



+ (void)payWithPlatformType:(PayPlatformType)platform payParams:(NSDictionary *)payParams completionHandler:(PayResultBlock)handler {
    if (platform < PayPlatformTypeUnknown || platform > PayPlatformTypeApple) {
        if (handler) { handler(NO, @"未知的支付平台!"); }
        return;
    }
    
    PayServiceManager *manager = [PayServiceManager sharedManager];
//    if (manager.isPaying) {
//        if (handler) { handler(NO, @"您有一笔未完成支付的订单！"); }
//        return;
//    }
    
    switch (platform) {
        case PayPlatformTypeWeiXin: {
            if ([self isWXAppInstalled]) {
                manager.isPaying = YES;
                manager.payParams = payParams;
                manager.completionHandler = handler;
                
                [self payForWeiXin:payParams];
            }
        }
            break;
        case PayPlatformTypeAliPay: {
            manager.isPaying = YES;
            manager.payParams = payParams;
            manager.completionHandler = handler;
            
            [self payForAliPay:payParams];
        }
            break;
            
        default:
            break;
    }
}



/** 发起微信支付请求 */
+ (void)payForWeiXin:(NSDictionary *)params {
    
    
    PayReq *req = [PayReq new];
    req.partnerId = [params safeStringForKey:@"partnerId"]; // 商户Id
    req.prepayId = [params safeStringForKey:@"prepayId"]; // 预支付订单Id
    req.nonceStr = [params safeStringForKey:@"nonceStr"]; // 随机串，防重发
    req.timeStamp = [params safeIntForKey:@"timeStamp"]; // 时间戳，防重发
    req.package = [params safeStringForKey:@"package"];
    req.sign = [params safeStringForKey:@"sign"]; // 签名
    [WXApi sendReq:req];
}

/** 发起支付宝支付请求 */
+ (void)payForAliPay:(NSDictionary *)params {
    NSString *orderString = [params safeStringForKey:@"orderInfo"];
    if (orderString.length) {
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:APP_SCHEME callback:^(NSDictionary *resultDic) {
            FBLOG(@"支付宝直接回调——————————————————————— 0 —————————");
            [[PayServiceManager sharedManager] processAlipayOrderResultDict:resultDic isUrlCallback:NO];
        }];
    }else {
        ALERTSHOW(@"支付宝支付参数缺失！");
    }
}


#pragma mark -  客户端检查

+ (BOOL)isWXAppInstalled {
    // 1.判断是否安装微信
    if (![WXApi isWXAppInstalled]) {
        [WHYAlertActionUtil showAlertWithTitle:@"温馨提示" msg:@"您尚未安装\"微信App\",请先安装后再返回支付。" actionBlock:^(NSInteger index, NSString *buttonTitle) {
            
        } buttonTitles:@"知道了", nil];
        return NO;
    }
    // 2.判断微信的版本是否支持最新Api
    if (![WXApi isWXAppSupportApi]) {
        [WHYAlertActionUtil showAlertWithTitle:@"温馨提示" msg:@"您微信当前版本不支持此功能,请先升级微信应用" actionBlock:^(NSInteger index, NSString *buttonTitle) {
            
        } buttonTitles:@"知道了", nil];
        return NO;
    }
    return YES;
}

+ (BOOL)supportPayService {
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        return YES;
    }
    return NO;
}


@end




#pragma mark - 支付管理类

@implementation PayServiceManager


+ (instancetype)sharedManager
{
    static PayServiceManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [PayServiceManager new];
    });
    return manager;
}

// 微信返回到App的回调
- (void)onReq:(BaseReq *)req
{
    
    
}

- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[PayResp class]]) {
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *message = @"";
        switch (resp.errCode) {
            case WXSuccess:{
                self.isPaying = NO;
                if (self.completionHandler) { self.completionHandler(1, @"支付成功！"); }
                return;
            }
                break;
            case WXErrCodeUserCancel: { message = @"支付已取消"; }
                break;
            case WXErrCodeSentFail: { message = @"订单支付失败！"; }
                break;
            default: { message = @"订单支付失败！"; }
        }
        
        if (resp.errStr.length) {
            message = [NSString stringWithFormat:@"支付失败：%@ 错误码：%d", resp.errStr, resp.errCode];
        }

        if (self.completionHandler) {
            self.completionHandler(resp.errCode==WXErrCodeUserCancel ? 3 : 2, message);
        }
        
        self.isPaying = NO;
    }
}


// 支付宝返回到App的回调(暂时还不做)

- (void)processAlipayOrderResultDict:(NSDictionary *)resultDict isUrlCallback:(BOOL)isUrlCallback {
    if (resultDict && resultDict.count) {
        FBLOG(@"支付宝返回的支付结果: %@", resultDict);
        
        /*
         返回码，标识支付状态，含义如下：
             9000——订单支付成功
             8000——正在处理中
             4000——订单支付失败
             5000——重复请求
             6001——用户中途取消
             6002——网络连接出错
         */
        
        NSInteger resultCode = [resultDict safeIntegerForKey:@"resultStatus"];
        switch (resultCode) {
            case 9000: { // 支付成功
                if (self.completionHandler) {
                    self.completionHandler(1, @"支付成功！");
                    return;
                }
            }
                break;
            case 8000: { // 正在处理中
                self.completionHandler(2, @"您的订单正在处理中。");
            }
                break;
            case 4000: { // 订单支付失败
                self.completionHandler(2, @"订单支付失败！");
            }
                break;
            case 5000: { // 重复请求
                self.completionHandler(2, @"重复的订单支付请求！");
            }
                break;
            case 6001: { // 用户中途取消
                self.completionHandler(3, @"支付已取消！");
            }
                break;
            case 6002: { // 网络连接出错
                self.completionHandler(2, @"网络连接出错，请稍后再试！");
            }
                break;
                
            default: {
                self.completionHandler(2, @"订单支付失败！");
            }
                break;
        }
        
        
        // 解析 auth code
//        NSString *result = resultDict[@"result"];
//        NSString *authCode = nil;
//        if (result.length > 0) {
//            NSArray *resultArr = [result componentsSeparatedByString:@"&"];
//            for (NSString *subResult in resultArr) {
//                if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
//                    authCode = [subResult substringFromIndex:10];
//                    break;
//                }
//            }
//        }
//        FBLOG(@"授权结果 authCode = %@", authCode?:@"");
    }
}




@end


/*
 
 
 NOAUTH       	     	商户无此接口权限		商户未开通此接口权限			请商户前往申请此接口权限
 NOTENOUGH				余额不足				用户帐号余额不足				用户帐号余额不足，请用户充值或更换支付卡后再支付
 ORDERPAID				商户订单已支付			商户订单已支付，无需重复操作		商户订单已支付，无需更多操作
 ORDERCLOSED	        订单已关闭			当前订单已关闭，无法支付         当前订单已关闭，请重新下单
 SYSTEMERROR	        系统错误				系统超时						系统异常，请用相同参数重新调用
 APPID_NOT_EXIST	    APPID不存在			参数中缺少APPID				请检查APPID是否正确
 MCHID_NOT_EXIST       	MCHID不存在			参数中缺少MCHID				请检查MCHID是否正确
 APPID_MCHID_NOT_MATCH	appid和mch_id不匹配	appid和mch_id不匹配			请确认appid和mch_id是否匹配
 LACK_PARAMS			缺少参数				缺少必要的请求参数				请检查参数是否齐全
 OUT_TRADE_NO_USED		商户订单号重复			同一笔交易不能多次提交			请核实商户订单号是否重复提交
 SIGNERROR				签名错误				参数签名结果不正确				请检查签名参数和方法是否都符合签名算法要求
 XML_FORMAT_ERROR		XML格式错误			XML格式错误					请检查XML参数格式是否正确
 REQUIRE_POST_METHOD	请使用post方法		未使用post传递参数 			请检查请求参数是否通过post方法提交
 POST_DATA_EMPTY		post数据为空			post数据不能为空				请检查post数据是否为空
 NOT_UTF8				编码格式错误			未使用指定编码格式				请使用NOT_UTF8编码格式
 
 
    FBLOG(@"支付参数： %@", params);
    
    NSString *str = [NSString stringWithFormat:@"appid=wx94a16263c1f82766&noncestr=%@&package=Sign=WXPay&partnerid=1261456301&prepayid=%@&timestamp=%@&key=26bbc861d4d7bd467bf4de6a277dbe74", req.nonceStr, req.prepayId, [params safeStringForKey:@"timeStamp"]];
    NSString *md5 = [[EncryptTool md5Encode:str] uppercaseString];
    FBLOG(@"md5: %@  \n\n%@\n\n\n\n", md5, str);
    if (![req.sign isEqualToString:md5]) {
        req.sign = md5;
        FBLOG(@"服务器端与App端的签名不一致，请检查！\n");
    }
 
 */


/*
 
        // 如果极简开发包不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给开 发包
        if ([url.host isEqualToString:@"safepay"])
        {
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                //【由于在跳转支付宝客户端支付的过程中,商户 app 在后台很可能被系统 kill 了,所以 pay 接口的 callback 就会失效,请商户对 standbyCallback 返回的回调结果进行处理,就是在这个方 法里面处理跟 callback 一样的逻辑】
                FBLOG(@"result = %@",resultDic);
            }];
        }

        if ([url.host isEqualToString:@"platformapi"])//支付宝钱包快登授权返回 authCode
        {
            [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
                FBLOG(@"result = %@",resultDic);
            }];
        }
 
 */
