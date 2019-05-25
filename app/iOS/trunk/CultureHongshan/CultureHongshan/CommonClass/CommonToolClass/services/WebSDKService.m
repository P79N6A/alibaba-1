//
//  WebSDKService.m
//  WHYProjectTemplate
//
//  Created by ct on 17/1/4.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import "WebSDKService.h"
#import "Reachability.h"

#import "WebViewController.h"

#import "WebPhotoBrowser.h"
#import "LocationService2.h"


@implementation WebSDKService


// 获取当前网络状态
- (NSInteger)currentNetworkState {
    return [WebSDKService currentNetworkState];
}

// 判断用户是否已登录
- (BOOL)userIsLogin {
    return [UserService sharedService].userIsLogin;
}

// 获取用户信息
- (NSString *)getUserInfo {
    User *user = [UserService sharedService].user;
    if (user.userId.length) {
        NSDictionary *dict = @{
                               @"userId" : user.userId,
                               @"userName" : user.userNameFull,
                               @"userLat" : StrFromDouble([UserService sharedService].userLat),
                               @"userLon" : StrFromDouble([UserService sharedService].userLon),
                               @"platform" : @"iPhone",
                               @"appVersion" : APP_VERSION,
                               @"sysVersion" : [[UIDevice currentDevice] systemVersion],
                               };
        return [JsonTool jsonStringFromDict:dict escapedKeys:nil];
    }else {
        return @"";
    }
}

// 获取设备信息
- (NSString *)getDeviceInfo {
    NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] initWithCapacity:3];
    tmpDict[@"platform"]   = @"iPhone";
    tmpDict[@"appVersion"] = APP_VERSION;
    tmpDict[@"sysVersion"] = [[UIDevice currentDevice] systemVersion];
    
    return [JsonTool jsonStringFromDict:tmpDict escapedKeys:nil];
}

// 获取位置信息
- (NSString *)getUserGeoLocation {
    NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] initWithCapacity:3];
    tmpDict[@"authStatus"] = [LocationService2 isAllowLocating] ? @"1" : @"0";
    tmpDict[@"userLat"] = StrFromDouble([UserService sharedService].userLat);
    tmpDict[@"userLon"] = StrFromDouble([UserService sharedService].userLon);
    
    return [JsonTool jsonStringFromDict:tmpDict escapedKeys:nil];
}

// 发送用户信息给App
- (void)sendUserInfoToApp:(NSString *)userInfo {
    if (userInfo && [userInfo isKindOfClass:[NSString class]]) {
        
        NSDictionary *dict = [JsonTool jsonObjectFromString:userInfo];
        if (dict.count > 0) {
            User *aUser = [[User alloc] initWithAttributes:dict];
            
            if (aUser.userId.length < 1) return;
            
            [UserService saveUser:aUser];
            [UserService updateUserLoginStatus];
            
            //设置帐号来源
            if ([aUser.registerOrigin intValue] == 1) {
                [[UserService sharedService] setLoginType:LoginTypeWenHuaYun];
            }else if ([aUser.registerOrigin intValue] == 2) {
                [[UserService sharedService] setLoginType:LoginTypeQQ];
            }else if ([aUser.registerOrigin intValue] == 3) {
                [[UserService sharedService] setLoginType:LoginTypeSina];
            }else if ([aUser.registerOrigin intValue] == 4) {
                [[UserService sharedService] setLoginType:LoginTypeWechat];
            }else {
                [[UserService sharedService] setLoginType:LoginTypeUnknown];
            }
        }
    }
}

// 改变导航栏标题
- (void)changeNavTitle:(NSString *)navTitle {
    
    if (navTitle.length > 0 && self.sourceVC) {
        WS(weakSelf)
        // 返回主线程修改UI
        dispatch_async(dispatch_get_main_queue(), ^{
            SS(strongSelf)
            strongSelf.sourceVC.navigationItem.title = navTitle;
            
            if ([strongSelf.sourceVC isKindOfClass:[WebViewController class]]) {
                [(WebViewController *)strongSelf.sourceVC setCurrentPageNavTitleChanged:YES];
            }
        });
    }
    
}

// 设置分享按钮的显示或隐藏
- (void)setAppShareButtonStatus:(BOOL)isShow {
    WS(weakSelf);
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([weakSelf.sourceVC isKindOfClass:[WebViewController class]]) {
            [((WebViewController *)weakSelf.sourceVC) setShareButtonHidden:!isShow];
        }
    });
}

// H5调用App的分享功能
- (void)shareByApp:(NSString *)shareInfo {
    if ([self.sourceVC isKindOfClass:[WebViewController class]]) {
        WS(weakSelf)
        dispatch_async(dispatch_get_main_queue(), ^{
            SS(strongSelf)
            NSDictionary *shareDict = [JsonTool jsonObjectFromString:shareInfo];
            [(WebViewController *)strongSelf.sourceVC shareByApp:shareDict];
        });
    }
}

// 订单支付
- (BOOL)appOrderPay:(NSString *)orderId {
    if (orderId.length) {
        WS(weakSelf);
        dispatch_async(dispatch_get_main_queue(), ^{
            [PageAccessTool accessAppPage:AppPageTypeOrderPay url:orderId navVC:weakSelf.sourceVC.navigationController sourceType:2 extParams:nil];
        });
        return YES;
    }
    return NO;
}

// 访问详情页面
- (void)accessDetailPageByApp:(NSString *)url {
    [self enterNewWindow:url];
}

// 进入一个新的页面
- (void)enterNewWindow:(NSString *)url {
    if (![url hasPrefix:@"http"]) return;
    
    WS(weakSelf)
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        WebViewController *vc = [[WebViewController alloc] init];
        vc.url = url;
        [strongSelf.sourceVC.navigationController pushViewController:vc animated:YES];
    });
}

// 预订完后，要直接返回到详情页面（相当于退出浏览器）
- (void)appPageJumpAfterBooking:(AppPageType)type {
    [self exitWebPage];
}

// 退出H5页面
- (void)exitWebPage {
    if ([self.sourceVC isKindOfClass:[WebViewController class]]) {
        WS(weakSelf)
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.sourceVC.navigationController popViewControllerAnimated:YES];
        });
    }
}







#pragma mark -




// H5访问App页面的接口
- (BOOL)accessAppPage:(AppPageType)type url:(NSString *)url {
    __block BOOL success = NO;
    
    if ([NSThread isMainThread]) {
        success = [PageAccessTool accessAppPage:type url:url navVC:self.sourceVC.navigationController sourceType:2 extParams:nil];
    }else {
        WS(weakSelf)
        dispatch_async(dispatch_get_main_queue(), ^{
            [PageAccessTool accessAppPage:type url:url navVC:weakSelf.sourceVC.navigationController sourceType:2 extParams:nil];
        });
        
        success = [PageAccessTool canAccessPage:type url:url];
    }
    return success;
}


// H5调用App的图片浏览器
- (BOOL)appPhotoBrowser:(NSString *)imgUrl imgUrls:(NSString *)imgUrls {
    if (imgUrls.length) {
        NSArray *imgUrlArray = [ToolClass getComponentArrayIgnoreBlank:imgUrls separatedBy:@";"];
        if (imgUrlArray.count) {
            NSInteger currentIndex = 0;
            for (int i = 0; i < imgUrlArray.count; i++) {
                if ([imgUrl isEqualToString:imgUrlArray[i]]) {
                    currentIndex = i;
                    break;
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [WebPhotoBrowser photoBrowserWithImageUrlArray:imgUrlArray currentIndex:currentIndex completionBlock:^(WebPhotoBrowser *photoBrowser) {
                }];
            });
            return YES;
        }
    }
    return NO;
}
 





#pragma mark - 类方法


// 配置浏览器的User Agent
+ (void)registerWebViewUserAgent {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *oldAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *newAgent = [oldAgent stringByAppendingString: [NSString stringWithFormat:@"%@/%@ Platform/ios", USER_AGENT_IDENTIFIER, APP_VERSION]];
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
}

// 获取当前网络状态
+ (NSInteger)currentNetworkState {
    switch ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus]) {
        case NotReachable: {
            return 0;
        }
            break;
        case ReachableViaWiFi: {
            return 1;
        }
            break;
        case ReachableViaWWAN: {
            return 2;
        }
            break;
            
        default:
            break;
    }
    return 0;
}


@end
