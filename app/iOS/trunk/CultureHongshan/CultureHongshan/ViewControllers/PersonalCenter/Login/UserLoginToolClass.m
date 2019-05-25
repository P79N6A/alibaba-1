//
//  UserLoginToolClass.m
//  CultureHongshan
//
//  Created by JackAndney on 16/4/15.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "UserLoginToolClass.h"

#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>


@implementation UserLoginToolClass


+ (void)loginWithLoginType:(LoginType)loginType
               accountType:(NSInteger)accountType//1-手机号登录， 2-用户名登录， 3-邮箱登录
                   account:(NSString *)account
                  password:(NSString *)password
             callbackBlock:(LoginCallBackBlock)block
{
//    LoginCallBackBlock的参数说明：1- 登录成功，  2-登录失败
    
    //如果为文化云帐号的登录，需要验证手机号和密码的有效性
    if (loginType == LoginTypeWenHuaYun)
    {
        if (accountType < 1 || accountType > 3) {
            [SVProgressHUD showErrorWithStatus:@"账户类型缺失"];
            return;
        }
        
        if (account.length < 1 || account == nil) {
            if (accountType == 1) {
                [SVProgressHUD showInfoWithStatus:@"手机号不能为空！"];
            } else {
                [SVProgressHUD showInfoWithStatus:@"用户名或邮箱不能为空！"];
            }
            return;
        }
        
        if (accountType == 1 && ![DataValidate isValidPhoneNumber:account]) {
            return;
        }
        
        if (![DataValidate isValidPassword:password passwordType:PasswordTypeLogin]) {
            return;
        }
        //给密码加密
        password = [EncryptTool md5Encode:password];
    }else if (loginType == LoginTypeWenHuaYunDynamic) {
        // 动态验证码登录
        if (![DataValidate isValidCheckCode:password]) {
            return;
        }
    }
    
    SSDKPlatformType platformType = SSDKPlatformTypeUnknown;
    if (loginType == LoginTypeWechat){
        platformType = SSDKPlatformTypeWechat;
    }else if (loginType == LoginTypeQQ){
        platformType = SSDKPlatformSubTypeQZone;
    }else if (loginType == LoginTypeSina){
        platformType = SSDKPlatformTypeSinaWeibo;
    }else if (loginType == LoginTypeSubPlatform){
        
    }
    
    if (loginType == LoginTypeWenHuaYun || loginType == LoginTypeWenHuaYunDynamic)
    {
        FBLOG(@"文化云用户登录");
        [SVProgressHUD showWithStatus:@"登录中..."];
        
        [AppProtocol userLoginWithMobile:account
                                password:password
                          dynamicLogin:loginType == LoginTypeWenHuaYunDynamic
                              UsingBlock:^(HttpResponseCode responseCode, id responseObject)
         {
             if (responseCode == HttpResponseSuccess)
             {
                 NSString *userId = [(User *)responseObject userId];
                 
                 [AppProtocol queryUserInfoWithUserId:userId UsingBlock:^(HttpResponseCode responseCode2, id responseObject2)
                  {
                      if (responseCode2 == HttpResponseSuccess) {
                          [UserService saveUser:responseObject2];
                          [[UserService sharedService] setLoginType:loginType];
                          [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                          [UserService updateUserLoginStatus];
                          
                          // 重置活动列表的标签数据
                          [DictionaryService resetActivityTags];
                          [ToolClass settingActivityListNeedUpdate];
                          
                          //一定要保存完用户信息后，再进行回调
                          block(1);
                      }else{
                          [SVProgressHUD showErrorWithStatus:responseObject2];
                          block(2);
                      }
                  }];
             }
             else{
                 if ([responseObject isKindOfClass:[NSString class]]) {
                     [SVProgressHUD showInfoWithStatus:responseObject];
                 }
                 else{
                     [SVProgressHUD showErrorWithStatus:@"登录失败"];
                 }
                 block(2);
             }
         }];
    }
    else if (platformType != SSDKPlatformTypeUnknown)
    {
        //第三方登录后，必须要用userId获取用户的信息
        [SVProgressHUD showWithStatus:@"登录中..."];
//        iOS 10 必须更新ShareSDK，该方法才会被回调
        [SSEThirdPartyLoginHelper loginByPlatform:platformType
                                       onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler)
        {
            if (user)// 第三方登录成功后，要继续登录文化云平台
            {
                NSString *openId = (platformType == SSDKPlatformTypeWechat) ? user.credential.rawData[@"unionid"] : user.uid;
                if (openId.length < 1 || openId == nil) {
                    [SVProgressHUD showErrorWithStatus:@"登录失败"];
                    block(2);
                    return;
                }
                
                [AppProtocol userLoginThirdPlatformWithOpenId:openId
                                               registerOrigin:[UserLoginToolClass getMatchedTypeWithLoginType:loginType]
                                                     birthday:@"1980-01-01"
                                                     nickName:MYEmojiFilter(user.nickname)
                                                 headImageUrl:user.icon
                                                      userSex:[NSString stringWithFormat:@"%d", (uint)user.gender]
                                                   UsingBlock:^(HttpResponseCode responseCode, id responseObject)
                {
                    if (responseCode == HttpResponseSuccess)
                    {
                        NSString *userId = [(User *)responseObject userId];
                        [AppProtocol queryUserInfoWithUserId:userId UsingBlock:^(HttpResponseCode responseCode, id responseObject)
                         {
                             if (responseCode == HttpResponseSuccess) {
                                 [UserService saveUser:responseObject];
                                 [[UserService sharedService] setLoginType:loginType];
                                 [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                                 [UserService updateUserLoginStatus];
                                 
                                 // 重置活动列表的标签数据
                                 [DictionaryService resetActivityTags];
                                 [ToolClass settingActivityListNeedUpdate];
                                 
                                 //一定要保存完用户信息后，再进行回调
                                 block(1);
                             }else{
                                 [SVProgressHUD showErrorWithStatus:responseObject];
                                 block(2);
                             }
                        }];
                    }
                    else{
                        if ([responseObject isKindOfClass:[NSString class]]) {
                            [SVProgressHUD showInfoWithStatus:responseObject];
                        }
                        else{
                            [SVProgressHUD showErrorWithStatus:@"登录失败"];
                        }
                        block(2);
                    }
                }];
            }
            else{
                [SVProgressHUD showErrorWithStatus:@"登录失败"];
                block(2);
            }
        } onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error)
         {
             if (state == SSDKResponseStateCancel){
                 [SVProgressHUD showInfoWithStatus:@"已取消登录"];
             }
        }];
        
/*—————————————————————————————————————————————————————*/

        
    }
}

+ (NSString *)getMatchedTypeWithLoginType:(LoginType)type
{
    if (type == LoginTypeQQ) {
        return @"2";
    }
    else if (type == LoginTypeSina){
        return @"3";
    }
    else if (type == LoginTypeWechat){
        return @"4";
    }
    else if (type == LoginTypeWenHuaYun){
        return @"100";
    }
    else
    {
        return @"";
    }
}






@end
