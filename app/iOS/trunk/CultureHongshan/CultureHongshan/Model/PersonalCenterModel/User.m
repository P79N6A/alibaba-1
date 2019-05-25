//
//  User.m
//  CultureHongshan
//
//  Created by Simba on 15/7/8.
//  Copyright (c) 2015年 Sun3d. All rights reserved.
//

#import "User.h"



@implementation User

- (id)initWithAttributes:(NSDictionary *)dictionary
{
    if(self = [super init])
    {
        if (!dictionary || ![dictionary isKindOfClass:[NSDictionary class]])
        {
            return nil;
        }
        
        self.userEmail      = [dictionary safeStringForKey:@"userEmail"];
        self.userCardNo     = [dictionary safeStringForKey:@"userCardNo"];
        self.userName       = [dictionary safeStringForKey:@"userName"];
        self.userNickName   = [dictionary safeStringForKey:@"userNickName"];
        self.userPwd        = [dictionary safeStringForKey:@"userPwd"];
        self.userQq         = [dictionary safeStringForKey:@"userQq"];
        self.userRemark     = [dictionary safeStringForKey:@"userRemark"];
        self.registerCount  = [dictionary safeStringForKey:@"registerCount"];
        self.userSex        = [dictionary safeIntegerForKey:@"userSex"];
        self.registerCode   = [dictionary safeStringForKey:@"registerCode"];
        self.userType       = [dictionary safeIntegerForKey:@"userType"];
        self.userBirth      = [dictionary safeStringForKey:@"userBirth"];
        self.userCity       = [dictionary safeStringForKey:@"userCity"];
        self.userIsDisable  = [dictionary safeStringForKey:@"userIsDisable"];
        self.userHeadImgUrl = [dictionary safeStringForKey:@"userHeadImgUrl"];
        self.commentStatus  = [dictionary safeStringForKey:@"commentStatus"];
        self.userProvince   = [dictionary safeStringForKey:@"userProvince"];

        self.userArea       = [[dictionary safeStringForKey:@"userArea"] stringByReplacingOccurrencesOfString:@"," withString:@":"];
        self.userAddress    = [dictionary safeStringForKey:@"userAddress"];
        

        self.userAge        = [dictionary safeStringForKey:@"userAge"];
        self.userIsLogin    = [dictionary safeStringForKey:@"userIsLogin"];
        self.userMobileNo   = [dictionary safeStringForKey:@"userMobileNo"];
        self.userId         = [dictionary safeStringForKey:@"userId"];
        self.token          = [dictionary safeStringForKey:@"token"];
        self.userTelephone  = [dictionary safeStringForKey:@"userTelephone"];
        self.registerOrigin = [dictionary safeStringForKey:@"registerOrigin"];

        self.teamUserSize   = [dictionary safeIntegerForKey:@"teamUserSize"];//
        self.userIntegral   = [dictionary safeIntegerForKey:@"userIntegral"];//用户积分
    }
    return self;
}


- (NSString *)userName {
    NSString *string = [_userName copy];
    if (string.length == 0) string = [_userNickName copy];
    
    
    if (string.length > kUserNickNameMaxLength) {
        return [string substringToIndex:kUserNickNameMaxLength];
    }
    return (string.length < 1) ? @"" : string;
}


- (NSString *)userNameFull {
    if (_userName.length > 0)     return _userName;
    if (_userNickName.length > 0) return _userNickName;
    
    return @"";
}

- (NSInteger)userIntegral {
    return MAX(_userIntegral, 0);
}



+ (NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray
{
    if (dicArray == nil || ![dicArray isKindOfClass:[NSArray class]]) {
        return @[];
    }
    
    NSMutableArray *instanceArray = [NSMutableArray array];
    for (NSDictionary *instanceDic in dicArray) {
        User *model = [[User alloc] initWithAttributes:instanceDic];
        if (model) {
            [instanceArray addObject:model];
        }
    }
    return [NSArray arrayWithArray:instanceArray];
}


@end
