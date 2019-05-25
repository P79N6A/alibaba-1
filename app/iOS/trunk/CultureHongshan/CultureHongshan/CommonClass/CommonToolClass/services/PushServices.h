//
//  PushServices.h
//  CultureHongshan
//
//  Created by ct on 16/10/10.
//  Copyright © 2016年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 极光推送服务层
 */
@interface PushServices : NSObject



/**
 配置推送服务
 */
+ (void)configureWithOptions:(NSDictionary *)launchOptions;


+ (void)registerDeviceToken:(NSData *)deviceToken;
+ (void)handleRemoteNotification:(NSDictionary *)remoteInfo;

/**
 设置用户的标签与别名

 @param tags  用户标签数组
 @param alias 用户的别名:(最好用userId)
 */
+ (void)setTags:(NSArray *)tags alias:(NSString *)alias;



+ (void)updateBadgeNumber:(NSInteger)badgeNumber;
+ (void)addBadgeNumber;// 每调用一次，数字＋1
+ (NSInteger)getBadgeNumber;



@end
