//
//  UserCollectModel.m
//  CultureHongshan
//
//  Created by xiao on 15/7/13.
//  Copyright (c) 2015年 Sun3d. All rights reserved.
//

#import "UserCollectModel.h"

@implementation UserCollectModel

- (id)initWithDict:(NSDictionary *)dict withType:(NSInteger)type
{
    if (self = [super init])
    {
        //防止返回null时崩溃
        if (dict == nil || ![dict isKindOfClass:[NSDictionary class]] || (type != 1 && type != 2))
        {
            return nil;
        }
        self.type = type;
        
        
        NSString *collectIdKey   = (type == 1) ? @"":@"";
        NSString *modelIdKey     = (type == 1) ? @"activityId":@"venueId";
        NSString *titleKey       = (type == 1) ? @"activityName":@"venueName";
        NSString *addressKey     = (type == 1) ? @"venueName":@"venueAddress";
        NSString *imageUrlKey    = (type == 1) ? @"activityIconUrl":@"venueIconUrl";
        NSString *dateKey        = (type == 1) ? @"":@"";
        NSString *collectDateKey = (type == 1) ? @"":@"";

        self.collectId      = [dict safeStringForKey:collectIdKey];
        self.modelId        = [dict safeStringForKey:modelIdKey];
        self.titleStr       = [dict safeStringForKey:titleKey];
        self.addressStr     = [dict safeStringForKey:addressKey];
        self.imageUrl       = [dict safeImgUrlForKey:imageUrlKey];
        self.dateStr        = [dict safeStringForKey:dateKey];
        self.collectDateStr = [dict safeStringForKey:collectDateKey];
        
        if (type == 1)
        {
            self.dateStr = [self getDateStrWithStartTime:[dict safeStringForKey:@"activityStartTime"] endTime:[dict safeStringForKey:@"activityEndTime"]];
            if (_addressStr.length < 1)
            {
                self.addressStr = [dict safeStringForKey:@"activityAddress"];
            }
        }
    }
    return self;
}


- (NSString *)getDateStrWithStartTime:(NSString *)startTime endTime:(NSString *)endTime
{
    NSString *dateStr = @"";
    
    if (startTime.length == 10) {
        startTime = [DateTool dateStringForDate:[DateTool dateForDateString:startTime formatter:@"yyyy-MM-dd"] formatter:@"MM.dd"];
    }
    if (endTime.length == 10) {
        endTime = [DateTool dateStringForDate:[DateTool dateForDateString:endTime formatter:@"yyyy-MM-dd"] formatter:@"MM.dd"];
    }
    
    if (startTime.length && endTime.length && ![startTime isEqualToString:endTime])
    {
        dateStr = [[NSString alloc] initWithFormat:@"%@－%@",startTime,endTime];
    }
    else
    {
        dateStr = startTime;
    }
    return dateStr;
}



+ (NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray withType:(NSInteger)type
{
    if (dicArray == nil || ![dicArray isKindOfClass:[NSArray class]])
    {
        return nil;
    }
    
    NSMutableArray *instanceArray = [NSMutableArray array];
    for (NSDictionary *instanceDic in dicArray)
    {
        [instanceArray addObject:[[self alloc] initWithDict:instanceDic withType:type]];
    }
    
    return [instanceArray copy];
}



@end
