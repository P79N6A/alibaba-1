//
//  UserService.h
//  CultureHongshan
//
//  Created by JackAndney on 2017/7/6.
//  Copyright © 2017年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserService : NSObject

/** 用户信息 */
@property (nonatomic, strong, readonly) User *user;
/** 用户Id */
@property (nonatomic, copy, readonly) NSString *userId;
/** 用户是否登录 */
@property (nonatomic, assign, readonly) BOOL userIsLogin;
/** 登录类型 */
@property (nonatomic, assign) LoginType loginType;

@property (nonatomic, assign, readonly) double userLat;
@property (nonatomic, assign, readonly) double userLon;

/** 纬度字符串 */
@property (nonatomic, readonly) NSString *latitudeStr;
/** 经度字符串 */
@property (nonatomic, readonly) NSString *longitudeStr;

+ (instancetype)sharedService;

/** 用户是否需要重新登录 */
+ (BOOL)userShouldReLogin;
/** 保存用户信息 */
+ (void)saveUser:(User *)user;
/** 移除用户信息 */
+ (void)removeUser;


/** 调用接口更新用户信息 */
+ (void)updateUserInfo;

/** 更新用户登录状态 */
+ (void)updateUserLoginStatus;
/** 删除用户登录状态 */
+ (void)removeUserLoginStatus;


@end
