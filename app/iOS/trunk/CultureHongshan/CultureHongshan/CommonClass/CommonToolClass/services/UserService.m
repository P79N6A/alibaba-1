//
//  UserService.m
//  CultureHongshan
//
//  Created by JackAndney on 2017/7/6.
//  Copyright © 2017年 CT. All rights reserved.
//

#import "UserService.h"
#import "LocationService2.h"

#define kUserInfo      @"UserInfo"


@interface UserService ()
{
    User *currentUser;
}
@end



@implementation UserService

+ (instancetype)sharedService {
    static UserService *service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[UserService alloc] init];
    });
    return service;
}

- (BOOL)userIsLogin {
    return self.userId.length > 0;
}

- (NSString *)userId {
    User *user = self.user;
    return user.userId.length ? user.userId : @"";
}

- (User *)user {
    if (currentUser == nil || ![currentUser isKindOfClass:[User class]]) {
        
        NSDictionary *userDict = [ToolClass getDefaultValue:kUserInfo];
        if ([userDict isKindOfClass:[NSDictionary class]] && userDict.count) {
            currentUser = [[User alloc] initWithAttributes:userDict];
        }
    }
    
    return currentUser;
}


- (double)userLat {
    return [LocationService2 sharedService].location.location.coordinate.latitude;
}

- (double)userLon {
    return [LocationService2 sharedService].location.location.coordinate.longitude;
}

- (NSString *)latitudeStr {
    return [NSString stringWithFormat:@"%.4f", [LocationService2 sharedService].location.location.coordinate.latitude];
}

- (NSString *)longitudeStr {
    return [NSString stringWithFormat:@"%.4f", [LocationService2 sharedService].location.location.coordinate.longitude];
}


#pragma mark - 

- (void)setLoginType:(LoginType)loginType {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:loginType forKey:@"LoginType"];
    [userDefaults synchronize];
}

- (LoginType)loginType {
    
    if (self.userIsLogin) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        NSDictionary *userLoginTypeDict = [userDefaults dictionaryForKey:@"TheThridLogin"];
        if ([userLoginTypeDict[@"ThreeWeChat"] length] > 0) {
            return LoginTypeWechat;
        }else if ([userLoginTypeDict[@"ThreeQQ"] length] > 0) {
            return LoginTypeQQ;
        }else if ([userLoginTypeDict[@"ThreeWeibo"] length] > 0) {
            return LoginTypeSina;
        }
        
        // 上面的是为了兼顾之前的版本
        return [userDefaults integerForKey:@"LoginType"];
    }
    return LoginTypeUnknown;
}


#pragma mark - 

+ (BOOL)userShouldReLogin {
    NSDate *lastLoginDate = [ToolClass getDefaultValue:@"user_last_Login_date"];
    UserService *userInfo = [UserService sharedService];
    if (userInfo.userId.length < 1) {
        return YES;
    }
    
    if (lastLoginDate && (userInfo.loginType == LoginTypeWenHuaYun || userInfo.loginType == LoginTypeWenHuaYunDynamic)) {
        NSTimeInterval timeDifference = [[NSDate date] timeIntervalSinceDate:lastLoginDate];
        if (timeDifference > 15*86400) {//一天的秒数:86400  15*86400
            [UserService removeUser]; // 需要重新登录时，移除用户信息
            return YES;
        }
    }
    return NO;
}


+ (void)saveUser:(User *)user {
    if (user && [user isKindOfClass:[User class]]) {
        NSMutableDictionary *userDict = [NSMutableDictionary dictionaryWithCapacity:15];
        
        [userDict setValue:user.userId forKey:@"userId"];
        [userDict setValue:user.userNameFull forKey:@"userName"];
        [userDict setValue:user.userNickName forKey:@"userNickName"];
        [userDict setValue:user.userHeadImgUrl forKey:@"userHeadImgUrl"];
        [userDict setValue:user.userPwd forKey:@"userPwd"];
        [userDict setValue:user.userArea forKey:@"userArea"];
        [userDict setValue:user.userMobileNo forKey:@"userMobileNo"];
        [userDict setValue:user.userTelephone forKey:@"userTelephone"];
        [userDict setValue:[NSNumber numberWithInteger:user.userSex] forKey:@"userSex"];
        [userDict setValue:user.userIsDisable forKey:@"userIsDisable"];
        [userDict setValue:user.commentStatus forKey:@"commentStatus"];
        [userDict setValue:user.registerOrigin forKey:@"registerOrigin"];
        [userDict setValue:[NSNumber numberWithInteger:user.userType] forKey:@"userType"];
        [userDict setValue:[NSNumber numberWithInteger:user.teamUserSize] forKey:@"teamUserSize"];
        [userDict setValue:[NSNumber numberWithInteger:user.userIntegral] forKey:@"userIntegral"];
        
        [userDict setValue:user.userAge forKey:@"userAge"];
        [userDict setValue:user.userBirth forKey:@"userBirth"];
        [userDict setValue:user.userEmail forKey:@"userEmail"];
        [userDict setValue:user.userCardNo forKey:@"userCardNo"];
        [userDict setValue:user.userQq forKey:@"userQq"];
        [userDict setValue:user.userRemark forKey:@"userRemark"];
        [userDict setValue:user.userCity forKey:@"userCity"];
        [userDict setValue:user.userProvince forKey:@"userProvince"];
        [userDict setValue:user.userAddress forKey:@"userAddress"];
        [userDict setValue:user.token forKey:@"token"];
        [userDict setValue:user.registerCode forKey:@"registerCode"];
        [userDict setValue:user.registerCount forKey:@"registerCount"];
        [userDict setValue:user.userIsLogin forKey:@"userIsLogin"];
        
        
        [ToolClass setDefaultValue:userDict forKey:kUserInfo];
        
        [UserService sharedService]->currentUser = user;
    }
    
}

+ (void)removeUser {
    [ToolClass setDefaultValue:nil forKey:kUserInfo];
    [self removeUserLoginStatus];
    [UserService sharedService]->currentUser = nil;
}



+ (void)updateUserInfo {
    NSString *userId = [UserService sharedService].userId;
    if (userId.length > 0) {
        [AppProtocol queryUserInfoWithUserId:userId UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
            if (responseCode == HttpResponseSuccess) {
                [UserService saveUser:responseObject];
            }
        }];
    }
}


+ (void)updateUserLoginStatus {
    [ToolClass setDefaultValue:[NSDate date] forKey:@"user_last_Login_date"];
}

+ (void)removeUserLoginStatus {
    [ToolClass setDefaultValue:nil forKey:@"user_last_Login_date"];
}


@end
