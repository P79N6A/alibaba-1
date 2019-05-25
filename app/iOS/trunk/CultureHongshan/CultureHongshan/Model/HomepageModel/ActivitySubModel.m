//
//  ActivitySubModel.m
//  CultureHongshan
//
//  Created by ct on 16/3/18.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "ActivitySubModel.h"
#import "LocationService2.h"

@implementation ActivitySubModel


- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        //防止返回null时崩溃
        if (dict == nil || ![dict isKindOfClass:[NSDictionary class]])
        {
            return nil;
        }
        self.activityId = [dict safeStringForKey:@"activityId"];
        self.scanCount = [dict safeStringForKey:@"scanCount"];
        self.collectCount = [dict safeStringForKey:@"collectCount"];
        self.commentCount = [dict safeStringForKey:@"commentCount"];
        self.ticketCount = [dict safeIntegerForKey:@"ticketCount"];
        self.distance = [dict safeDoubleForKey:@"distance"];
        
        self.showedDistance = [self getShowedDistanceWithDistance:_distance];
    }
    return self;
}



+ (NSDictionary *)listDictWithDictArray:(NSArray *)dictArray
{
    if (!dictArray || ![dictArray isKindOfClass:[NSArray class]])
    {
        return nil;
    }

    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    for (NSDictionary *item in dictArray)
    {
        ActivitySubModel *model = [[ActivitySubModel alloc] initWithDict:item];
        if (model.activityId.length)
        {
            [dict setObject:model forKey:model.activityId];
        }
    }
    return dict;
}



- (NSString *)getShowedDistanceWithDistance:(double)distance
{
    NSString *distanceStr = @"0km";

    if ([LocationService2 sharedService].havePosition == NO)//不允许定位，直接显示 0km
    {
        return distanceStr;
    }
    
    
    if (distance < 1 && distance > 0)
    {
        if (distance*1000 < 10)
        {
            distanceStr = [NSString stringWithFormat:@"%.3lfkm",distance];
        }
        else if (distance*1000 < 100)
        {
            distanceStr = [NSString stringWithFormat:@"%.2lfkm",distance];
        }
        else
        {
            distanceStr = [NSString stringWithFormat:@"%.1lfkm",distance];
        }
    }
    else if (distance >= 1 && distance < 10)
    {
        distanceStr = [NSString stringWithFormat:@"%.1lfkm",distance];
    }
    else if (distance >= 10)
    {
        distanceStr = [NSString stringWithFormat:@"%.0lfkm",distance];
    }
    
    distanceStr = [distanceStr stringByReplacingOccurrencesOfString:@"0.000" withString:@"0"];
    
    return distanceStr;
}


@end
