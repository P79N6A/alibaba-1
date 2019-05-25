//
//  PushServices.m
//  CultureHongshan
//
//  Created by ct on 16/10/10.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "PushServices.h"


#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif



@interface PushServices ()<JPUSHRegisterDelegate>
@end




@implementation PushServices


// 使用单例类的主要原因是，防止该变量被释放（避免通知收到时，接收通知的对象已经被释放掉了）
+ (instancetype)sharedInstance
{
    static PushServices *service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[PushServices alloc] init];
    });
    return service;
}


+ (void)configureWithOptions:(NSDictionary *)launchOptions
{
    NSDictionary *remoteUserInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteUserInfo) {
        //APP未启动，点击推送消息，iOS10下还是跟以前一样在此获取
        
        
        
    }
    
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:[PushServices sharedInstance]];
#endif
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    
    [JPUSHService setupWithOption:launchOptions appKey:kAppKey_JPush
                          channel:DEBUG_MODE ? @"Development channel" : @"Production channel"
                 apsForProduction:!DEBUG_MODE
            advertisingIdentifier:nil];
    
    
    // 添加极光推送自定义消息的监听
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:[PushServices sharedInstance] selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    [defaultCenter addObserver:[PushServices sharedInstance] selector:@selector(jPushDidLogin:) name:kJPFNetworkDidLoginNotification object:nil];
    
    // 2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0) {
            FBLOG(@"registrationID获取成功：%@",registrationID);
        }else {
            FBLOG(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
//    [PushServices setTags:nil alias:[UserService sharedService].userId];
}


+ (void)registerDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
}

+ (void)handleRemoteNotification:(NSDictionary *)remoteInfo
{
    [JPUSHService handleRemoteNotification:remoteInfo];
}



// 给用户贴标签和设置别名
+ (void)setTags:(NSArray *)tags alias:(NSString *)alias
{
    if (alias.length < 1) {
        alias = @"anonymous";
    }
    
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:0];
    if ([tags isKindOfClass:[NSArray class]] && tags.count) {
        for (NSString *str in tags) {
            if ([str isKindOfClass:[NSString class]] && str.length) {
                [tmpArray addObject:str];
            }
        }
    }
    
    [JPUSHService setTags:tmpArray.count?[NSSet setWithArray:tmpArray]:nil alias:alias fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        
        FBLOG(@"设置推送：iResCode = %d  iTags = %@   iAlias = %@", iResCode, iTags, iAlias);
    }];
}



#pragma mark- ——————  BadgeNumber  ——————

+ (void)updateBadgeNumber:(NSInteger)badgeNumber
{
    badgeNumber = MAX(badgeNumber, 0);
    [JPUSHService setBadge:badgeNumber]; // 更新服务器中badgeNumber的值
    [UIApplication sharedApplication].applicationIconBadgeNumber = badgeNumber;
    if (badgeNumber < 1) {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
}

+ (void)addBadgeNumber
{
    [PushServices updateBadgeNumber:[PushServices getBadgeNumber]+1];
}

+ (NSInteger)getBadgeNumber
{
    return [UIApplication sharedApplication].applicationIconBadgeNumber;
}



#pragma mark-  JPUSHRegisterDelegate

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
// 即将在前台显示通知
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if (badge) {
        [PushServices addBadgeNumber];
    }
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        FBLOG(@"iOS10 前台收到远程通知:%@", [PushServices logDic:userInfo]);
    }
    else {
        // 判断为本地通知
        FBLOG(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

// 收到通知响应
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
//    NSString *body = content.body;    // 推送消息体
//    UNNotificationSound *sound = content.sound;  // 推送消息的声音
//    NSString *subtitle = content.subtitle;  // 推送消息的副标题
//    NSString *title = content.title;  // 推送消息的标题
    
    
    
    if (badge) {
        [PushServices addBadgeNumber];
    }
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        FBLOG(@"iOS10 后台收到远程通知:%@", [PushServices logDic:userInfo]);
    }
    else {
        // 判断为本地通知
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif

// 极光推送的自定义消息接收
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];

    ALERTSHOW(content);
    
//    [PushServices addBadgeNumber];
}

- (void)jPushDidLogin:(NSNotification *)notification {
    [PushServices setTags:nil alias:[UserService sharedService].userId];
}


#pragma mark-  ————————  Other  ————————

// log NSSet with UTF 。  if not ,log will be \Uxxx
+ (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}




@end
