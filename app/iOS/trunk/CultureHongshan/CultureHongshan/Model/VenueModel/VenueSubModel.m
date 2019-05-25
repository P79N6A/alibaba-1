//
//  VenueSubModel.m
//  CultureHongshan
//
//  Created by ct on 16/8/10.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "VenueSubModel.h"

@implementation VenueSubModel

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        //防止返回null时崩溃
        if (dict == nil || ![dict isKindOfClass:[NSDictionary class]])
        {
            return nil;
        }
        self.venueId   = [dict safeStringForKey:@"venueId"];
        self.actCount  = [dict safeIntegerForKey:@"actCount"];
        self.roomCount = [dict safeIntegerForKey:@"roomCount"];
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
        VenueSubModel *model = [[VenueSubModel alloc] initWithDict:item];
        if (model.venueId.length)
        {
            [dict setObject:model forKey:model.venueId];
        }
    }
    return dict;
}



@end
