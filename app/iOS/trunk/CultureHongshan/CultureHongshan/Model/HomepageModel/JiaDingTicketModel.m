//
//  JiaDingTicketModel.m
//  CultureHongshan
//
//  Created by ct on 16/3/21.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "JiaDingTicketModel.h"

@implementation JiaDingTicketModel

+ (NSDictionary *)listDictWithDict:(NSDictionary *)dict
{
    if (!dict || ![dict isKindOfClass:[NSDictionary class]])
    {
        return nil;
    }
    
    NSArray *keyArray = [dict allKeys];
    
    NSMutableDictionary *tmpDict = [NSMutableDictionary new];
    
    for (NSString *activityId in keyArray)
    {
        if ([activityId isKindOfClass:[NSString class]])
        {
            if (activityId.length)
            {
                JiaDingTicketModel *model = [[JiaDingTicketModel alloc] init];
                model.ticketCount = [dict safeIntegerForKey:activityId];
                model.activityId = activityId;
                [tmpDict setObject:model forKey:activityId];
            }
        }
    }
    
    return tmpDict;
}



@end
