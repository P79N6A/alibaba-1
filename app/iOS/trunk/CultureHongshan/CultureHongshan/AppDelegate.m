//
//  AppDelegate.m
//  CultureHongshan
//
//  Created by one on 15/11/5.
//  Copyright © 2015年 CT. All rights reserved.
//

#import "AppDelegate.h"

#import "PayService.h"
#import "PushServices.h"
#import "LocationService2.h"
#import "ShareService.h"
#import "WebSDKService.h"
#import "IQKeyboardManager.h"

#import "GuideViewController.h"
#import "LaunchPage.h"
#import "FBTabbarController.h"

@interface AppDelegate ()

@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    self.allowRotation = 1;
    if ([self test]) { return YES; }
    
    application.statusBarStyle = UIStatusBarStyleLightContent;
    
    if (LOG_MODE) {
        // 日志输出到文件
//        freopen([kLogPath UTF8String], "a+", stderr);
    }
    
    isConnect = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged) name:kReachabilityChangedNotification object:nil];
    self.reachablity = [Reachability reachabilityForInternetConnection];
    [self.reachablity startNotifier];
    
    [WHYSdkConfiguration setLogEnabled:DEBUG_MODE];
    
    [DictionaryService loadDictionary];// 加载标签数据
    [UserService updateUserInfo];//程序每次启动时更新一下用户的个人信息
    [AppProtocol getImageUrlPrefixUsingBlock:nil];
    [AppProtocol getAppVersionFromAppStore];
    
    // 键盘管理
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarByPosition];
    
    [self umengTrack];
    
    // 分享和登录，只要有一个允许，就配置第三方服务
#ifdef FUNCTION_ENABLED_SHARE
    [ShareService configureWithOptions:launchOptions];
#else
#ifdef FUNCTION_ENABLED_THIRD_LOGIN
    [ShareService configureWithOptions:launchOptions];
#endif
#endif
    

#ifdef FUNCTION_ENABLED_PUSH_SERVICE
    [PushServices configureWithOptions:launchOptions]; // Jpush极光推送
#endif
    
#ifdef FUNCTION_ENABLED_PAY_SERVICE
    [PayService registerAppForPayWithOptions:launchOptions]; // 支付
#endif
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self goToNextPage];


    [self reachabilityChanged];
    [WebSDKService registerWebViewUserAgent];
    
    if ([LocationService2 isAllowLocating]) {
        [[LocationService2 sharedService] beginOnceLocationWithCompletion:^(MYLocationModel *location, NSString *errorMsg) {
            if (location) {
                FBLOG(@"单次定位：%@", location);
            }else {
                FBLOG(@"单次定位失败：%@", errorMsg);
            }
        }];
    }
    
    return YES;
}



- (void)reachabilityChanged
{
    NetworkStatus  status =  self.reachablity.currentReachabilityStatus;
    switch (status)
    {
        case NotReachable:
            if (isConnect)
            {
                [SVProgressHUD dismiss];
                ALERTSHOW(@"加载超时，请检查您的网络连接！");
                isConnect = NO;
            }
            break;
        case ReachableViaWiFi:
        case ReachableViaWWAN:
            isConnect = YES;
            break;
        default:
            break;
    }
}


// 进入下一页
- (void)goToNextPage {
    
    if ([ToolClass isFirstVisit]) { // 首次安装使用
#ifdef FUNCTION_ENABLED_USER_GUIDE
        // 新手引导页
        self.window.rootViewController = nil;
        GuideViewController * vc = [GuideViewController new];
        self.window.rootViewController = vc;
#else
        // 进首页
        [self gotoHomepageWithOption:NO];
#endif
        
    }else { // 非首次安装
        
#ifdef FUNCTION_ENABLED_LAUNCH_PAGE
        WS(weakSelf);
        [LaunchPage loadLaunchPageWithBlock:^(id object, NSInteger index, BOOL isSameIndex){
            [weakSelf gotoHomepageWithOption:YES];
        }];
#else
        // 进首页
        [self gotoHomepageWithOption:NO];
#endif
        
    }
}

#pragma mark - 根视图

// 跳转到首页
- (void)gotoHomepageWithOption:(BOOL)clearLaunchPage {
    if (clearLaunchPage) {
        for (UIView *subView in [UIApplication sharedApplication].keyWindow.subviews) {
            if ([subView isKindOfClass:[LaunchPage class]]) {
                [subView removeFromSuperview];
                break;
            }
        }
    }
    
    self.window.rootViewController = nil;
    FBTabbarController * tabbar = [FBTabbarController new];
    self.window.rootViewController = tabbar;
}

// 友盟统计
- (void)umengTrack {
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    [MobClick setLogEnabled:DEBUG_MODE];
    UMConfigInstance.appKey = kAppKey_Mob;
    [MobClick startWithConfigure:UMConfigInstance];
}


- (void)applicationWillResignActive:(UIApplication *)application {
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // 清除消息条数
    [PushServices updateBadgeNumber:0];
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (self.allowRotation) {
        return UIInterfaceOrientationMaskAll;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // 将要退出App
    // 清除WebView的缓存数据
    [CacheServices clearWebCache];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [PushServices registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    FBLOG(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}

- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    FBLOG(@"收到推送通知..........%@", userInfo);
    [PushServices handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [self handleUrl:url sourceApp:sourceApplication];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    return [self handleUrl:url sourceApp:[options safeStringForKey:@"UIApplicationOpenURLOptionsSourceApplicationKey"]];
}

- (BOOL)handleUrl:(NSURL *)url sourceApp:(NSString *)sourceApp {
    if (sourceApp.length > 0) {
        if ([sourceApp isEqualToString:@"com.tencent.xin"] && [url.absoluteString containsSubString:@"pay"]) {
            // 微信支付
            return [PayService handleOpenURL:url];
        }
    }
    
    if ([url.host isEqualToString:@"safepay"] || [url.host isEqualToString:@"platformapi"]) {
        // 支付宝支付
        return [PayService handleOpenURL:url];
    }else if ([[url absoluteString] hasPrefix:APP_SCHEME_FULL]) {
        // 应该废弃掉，使用JS API的方式进行调用
        return [self handleOuterUrl:url];
    }
    
    return YES;
}


- (BOOL)handleOuterUrl:(NSURL * )url
{
    NSString * u = url.absoluteString;
    NSString * query = url.query;

    FBTabbarController * tabbar = (FBTabbarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    __weak UINavigationController * nav  = (UINavigationController *)tabbar.selectedViewController;
    
    if ([u rangeOfString:@"//activitydetail?"].location != NSNotFound)
    {
        NSString *activityId = MYGetParamValueForKey(query, @"activityId");
        if (activityId.length) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [PageAccessTool accessAppPage:AppPageTypeActivityDetail url:activityId navVC:nav sourceType:1 extParams:nil];
            });
            return YES;
        }
    }
    else if ([u rangeOfString:@"//venuedetail?"].location != NSNotFound)
    {
        NSString * venueId = MYGetParamValueForKey(query, @"venueId");
        if (venueId.length) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [PageAccessTool accessAppPage:AppPageTypeVenueDetail url:venueId navVC:nav sourceType:1 extParams:nil];
            });
            return YES;
        }
    }
    else if ([u rangeOfString:@"//orderlist"].location != NSNotFound)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [PageAccessTool accessAppPage:AppPageTypeOrderList url:nil navVC:nil sourceType:1 extParams:nil];
        });
        return YES;
    }
    else if ([u rangeOfString:@"//usercenter"].location != NSNotFound)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [PageAccessTool accessAppPage:AppPageTypePersonalCenter url:nil navVC:nil sourceType:1 extParams:nil];
        });
        return YES;
    }
    
    return NO;
}


- (BOOL)test {
    return NO;
    
    // 1. 导航控制器
//    UIViewController *vc = [NSClassFromString(@"ActivityOrderDetailViewController") new];
//    self.window.rootViewController = [[NSClassFromString(@"MyNavigationController") alloc] initWithRootViewController:vc];
    
    // 2. 仅视图控制器
    self.window.rootViewController = [NSClassFromString(@"TestViewController") new];
    
    return YES;
}



@end



