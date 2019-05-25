//
//  UserLoginToolClass.h
//  CultureHongshan
//
//  Created by JackAndney on 16/4/15.
//  Copyright © 2016年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserLoginToolClass : NSObject


/**
 *  用户登录
 *
 *  @param loginType   登录的类型：文化云、微信、QQ、微博等
 *  @param accountType 账号类型：1-手机号登录， 2-用户名登录， 3-邮箱登录
 *  @param account     账号名
 *  @param password    用户密码（必须为未加密的密码）
 *  @param block       用户登录结果的回调：1- 成功， 2-失败
 */
+ (void)loginWithLoginType:(LoginType)loginType
               accountType:(NSInteger)accountType
                   account:(NSString *)account
                password:(NSString *)password
             callbackBlock:(LoginCallBackBlock)block;

/**
 *  根据登录类型返回与后台对应的登录类型
 *
 *  @param LoginType 自定义的登录类型
 *
 *  @return 与后台对应的登录类型
 */
+ (NSString *)getMatchedTypeWithLoginType:(LoginType)type;

@end
