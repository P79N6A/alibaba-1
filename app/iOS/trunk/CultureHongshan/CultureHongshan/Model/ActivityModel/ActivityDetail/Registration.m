//
//  Registration.m
//  CultureHongshan
//
//  Created by xiao on 15/12/8.
//  Copyright © 2015年 CT. All rights reserved.
//

#import "Registration.h"


@implementation Registration

/*
 
 微信头像：http://wx.qlogo.cn/mmopen/
 微博头像：http://tp1.sinaimg.cn/
 Q Q头像：http://qzapp.qlogo.cn/qzapp/
 
 */
-(id)initWithAttributes:(NSDictionary *)dictionary
{
    if(self = [super init])
    {
        if (!dictionary || ![dictionary isKindOfClass:[NSDictionary class]])
        {
            return nil;
        }
        
        self.userId         = [dictionary safeStringForKey:@"userId"];
        self.userBirth      = [dictionary safeStringForKey:@"userBirth"];
        self.userSex        = [dictionary safeIntegerForKey:@"userSex"];
        self.userHeadImgUrl = [dictionary safeStringForKey:@"userHeadImgUrl"];
        self.pageTotal      = [dictionary safeIntegerForKey:@"pageTotal"];
        self.userName       = [dictionary safeStringForKey:@"userName"];
        
        if (_userName.length > 7)
        {
            self.userName = [_userName substringToIndex:7];
        }
    }
    return self;
}

+(NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray
{
    if (!dicArray || ![dicArray isKindOfClass:[NSArray class]])
    {
        return @[];
    }
    
    NSMutableArray *instanceArray = [NSMutableArray array];
    for (NSDictionary *instanceDic in dicArray)
    {
        Registration *model = [[Registration alloc] initWithAttributes:instanceDic];
        if (model) {
            [instanceArray addObject:model];
        }
    }
    return [NSArray arrayWithArray:instanceArray];
}

@end
