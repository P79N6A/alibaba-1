//
//  DataValidate+Extensions.m
//  CultureHongshan
//
//  Created by ct on 17/3/17.
//  Copyright © 2017年 CT. All rights reserved.
//

#import "DataValidate.h"

// 正则表达式
#define REGEX_MOBILE   @"^1(3|5|8|7)\\d{9}$" // 手机号
#define REGEX_NICKNAME @"^[\u4e00-\u9fa5a-zA-Z0-9]+$" // 昵称
#define REGEX_PWD      @"^[A-Za-z]+[0-9]+[A-Za-z0-9]*|[0-9]+[A-Za-z]+[A-Za-z0-9]*$" // 密码
#define REGEX_EMAIL    @"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$" // 邮箱

#define SHOW_SVProgressHUD

#ifdef SHOW_SVProgressHUD
#define __ERROR__(msg)  [SVProgressHUD showInfoWithStatus:msg]; return NO;
#else
#define __ERROR__(msg) NSLog(@"%@", msg); return NO;
#endif





@implementation DataValidate



+ (BOOL)isValidPhoneNumber:(NSString *)phoneNum {
    if ([phoneNum isKindOfClass:[NSString class]] && phoneNum.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self matches %@", REGEX_MOBILE];
        if ([predicate evaluateWithObject:phoneNum]) {
            return YES;
        }
        __ERROR__(@"请输入正确的11位手机号!")
    }
    __ERROR__(@"手机号码不能为空!")
}

+ (BOOL)isValidNickname:(NSString *)nickname {
    
    if (nickname == nil || nickname.length == 0) {
        __ERROR__(@"请输入昵称！")
    }
    
    if ([nickname rangeOfString:@" "].location != NSNotFound){
        __ERROR__(@"昵称中不能包含空格!")
    }
    
    if (MIN_LENGTH_NAME > 0) {
        if (nickname.length < MIN_LENGTH_NAME) {
            __ERROR__(@"昵称不能太短了哟!")
        }
    }
    
    if (nickname.length > MAX_LENGTH_NAME) {
        NSString *msg = [NSString stringWithFormat:@"昵称不能超过%d个字符", MAX_LENGTH_NAME];
        __ERROR__(msg)
    }
    
//    // 暂时不做这个限制
//    unichar firstChar = [nickname characterAtIndex:0];
//    if (firstChar >= '0' && firstChar <= '9') {
//        __ERROR__(@"昵称不能以数字开头!")
//    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self matches %@", REGEX_NICKNAME];
    if ([predicate evaluateWithObject:nickname]) {
        return YES;
    }
    __ERROR__(@"昵称只允许包含汉字、数字和字母!")
}

+ (BOOL)isValidPassword:(NSString *)pwd passwordType:(PasswordType)type {
    
    if (pwd == nil || pwd.length == 0) {
        if (type == PasswordTypeOld) {
            __ERROR__(@"请输入原密码!")
        }else if (type == PasswordTypeNew) {
            __ERROR__(@"请输入新密码!")
        }else {
            __ERROR__(@"请输入密码!")
        }
    }
    
    switch (type) {
        case PasswordTypeRegister:
        case PasswordTypeNew: {
            
            if (pwd.length < MIN_LENGTH_PWD || pwd.length > MAX_LENGTH_PWD) {
                NSString *msg = [NSString stringWithFormat:@"密码长度必须为%d-%d位!",MIN_LENGTH_PWD, MAX_LENGTH_PWD];
                if (type == PasswordTypeNew) {
                    msg = [NSString stringWithFormat:@"新%@", msg];
                }
                __ERROR__(msg)
            }
            
            // 判断密码是否为数字和字母的组合
            if (![[NSPredicate predicateWithFormat:@"self matches %@", REGEX_PWD] evaluateWithObject:pwd]){
                if (type == PasswordTypeNew) {
                    __ERROR__(@"新密码必须是字母和数字的组合!")
                }else {
                    __ERROR__(@"密码必须是字母和数字的组合!")
                }
            }else {
                return YES;
            }
        }
            break;
            
        case PasswordTypeLogin:
        case PasswordTypeOld: {
            // 登录 或 原密码，只要不为空即可
            return YES;
        }
            break;
            
        default:
            return YES;
            break;
    }
}

+ (BOOL)isValidConfirmPassword:(NSString *)pwd confirmPassword:(NSString *)confirmPwd {
    if (![self isValidPassword:pwd passwordType:PasswordTypeRegister]) {
        return NO; // 防止pwd未作校验
    }
    
    if (confirmPwd.length == 0) {
        __ERROR__(@"请输入确认密码！")
    }
    
    if (![pwd isEqualToString:confirmPwd]) {
        __ERROR__(@"两次输入的密码不一致,请确认!")
    }
    
    return YES;
}

+ (BOOL)isValidCheckCode:(NSString *)checkCode {
    if (checkCode == nil || checkCode.length == 0) {
        __ERROR__(@"请输入验证码!")
    }
    
    if (checkCode.length > 10) {
        __ERROR__(@"请输入正确的验证码!")
    }
    return YES;
}

+ (BOOL)isValidIDNumber:(NSString *)IDNumber {
    if (IDNumber.length == 0) {
        __ERROR__(@"请先填写身份证号!")
    }
    
    if (IDNumber.length != 18) {
        __ERROR__(@"请确认您填写的身份证号无误!")
    }
    
    IDNumber = [IDNumber uppercaseString];
    
    int sigma = 0;
    NSArray *  a = @[@7, @9, @10, @5, @8, @4, @2, @1, @6, @3, @7, @9, @10, @5, @8, @4, @2];
    NSArray * w = @[@"1", @"0", @"X", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    for (int i = 0; i < 17; i++)
    {
        int ai = [[IDNumber substringWithRange:NSMakeRange(i, 1)] intValue];
        int wi = [a[i] intValue];
        sigma += ai * wi;
    }
    int number = sigma % 11;
    NSString * check_number = w[number];
    
    if ([[IDNumber substringWithRange:NSMakeRange(17,1)] isEqualToString:check_number]) {
        return YES;
    }else {
        __ERROR__(@"请确认您填写的身份证号无误!")
    }
}

+ (BOOL)isValidEmail:(NSString *)email {
    if ([email isKindOfClass:[NSString class]] && email.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self matches %@", REGEX_EMAIL];
        if ([predicate evaluateWithObject:email]) {
            return YES;
        }else {
            __ERROR__(@"邮箱地址格式不正确!")
        }
    }
    __ERROR__(@"邮箱地址不能为空!")
}



#pragma mark -

+ (BOOL)isPureInt:(NSString *)number {
    NSScanner *scan = [NSScanner scannerWithString:number];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

+ (BOOL)isPureFloat:(NSString *)number {
    NSScanner *scan = [NSScanner scannerWithString:number];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}



@end
