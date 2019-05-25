//
//  DataValidate+Extensions.h
//  CultureHongshan
//
//  Created by ct on 17/3/17.
//  Copyright © 2017年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MAX_LENGTH_NAME  15  // 昵称最大长度
#define MIN_LENGTH_NAME  0  // 昵称最小长度
#define MAX_LENGTH_PWD   20 // 密码最大长度
#define MIN_LENGTH_PWD   6  // 密码最小长度

/** 密码的类型 */
typedef NS_ENUM(NSInteger, PasswordType) {
    /** 注册时填写密码 */
    PasswordTypeRegister = 1,
    /** 登录时填写密码 */
    PasswordTypeLogin,
    /** 忘记密码填写旧密码 */
    PasswordTypeOld,
    /** 忘记密码填写新密码 */
    PasswordTypeNew,
};



/**
 数据有效性检查
 */
@interface DataValidate: NSObject

+ (BOOL)isValidPhoneNumber:(NSString *)phoneNum; // 手机号
+ (BOOL)isValidNickname:(NSString *)nickname; // 用户名/昵称
+ (BOOL)isValidPassword:(NSString *)pwd passwordType:(PasswordType)type; // 密码
+ (BOOL)isValidConfirmPassword:(NSString *)pwd confirmPassword:(NSString *)confirmPwd; // 确认密码
+ (BOOL)isValidCheckCode:(NSString *)checkCode; // 验证码
+ (BOOL)isValidIDNumber:(NSString *)IDNumber; // 身份证号
+ (BOOL)isValidEmail:(NSString *)email; // 邮箱

+ (BOOL)isPureInt:(NSString *)number; // 整形判断
+ (BOOL)isPureFloat:(NSString *)number; // 浮点形判断(整形的数字也是作为浮点型)

@end
