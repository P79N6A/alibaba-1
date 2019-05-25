//
//  VenueModel.m
//  CultureHongshan
//
//  Created by one on 15/11/7.
//  Copyright © 2015年 CT. All rights reserved.
//

#import "VenueModel.h"


@implementation VenueModel

-(id)initWithAttributes:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        
        if (!dictionary || ![dictionary isKindOfClass:[NSDictionary class]])
        {
            return nil;
        }
        
        self.venueId      = [dictionary safeStringForKey:@"venueId"];
        self.venueName    = [dictionary safeStringForKey:@"venueName"];
        self.venueAddress = [dictionary safeStringForKey:@"venueAddress"];
        self.venueIconUrl = [dictionary safeImgUrlForKey:@"venueIconUrl"];
        self.venueLat     = [dictionary safeStringForKey:@"venueLat"];
        self.venueLon     = [dictionary safeStringForKey:@"venueLon"];
        self.distance     = [dictionary safeStringForKey:@"distance"];
        self.venueIsReserve = [dictionary safeIntegerForKey:@"venueIsReserve"] == 2;// 是否预订:1-不可预订  2-可预订

        self.venueOnlineActivityCount = [dictionary safeIntegerForKey:@"actCount"];
        self.venueRoomCount           = [dictionary safeIntegerForKey:@"roomCount"];
        
        // 暂时不用的字段
        self.activityNewName  = [dictionary safeStringForKey:@"activityName"];
        self.remarkUserImgUrl = [dictionary safeStringForKey:@"remarkUserImgUrl"];
        self.venueHasMetro    = [dictionary safeIntegerForKey:@"venueHasMetro"] == 2;//有无地铁：1-无  2-有
        self.venueHasBus      = [dictionary safeIntegerForKey:@"venueHasBus"] == 2;//有无公交：1-无  2-有
        self.venueStars       = [dictionary safeStringForKey:@"venueStars"];
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
    for (NSDictionary *instanceDic in dicArray) {
        VenueModel *model = [[VenueModel alloc] initWithAttributes:instanceDic];
        if (model) {
            [instanceArray addObject:model];
        }
    }
    return [NSArray arrayWithArray:instanceArray];
}

- (NSString *)showedDistance
{
    if ([_venueLat floatValue] < 1 && [_venueLon floatValue] < 1) {
        return @"--";
    }
    return [ToolClass getDistance:[_distance doubleValue]];
}

// 获取所有的场馆Id
+ (NSString *)getAllVenueIdStringWithListArray:(NSArray *)listArray
{
    if (!listArray || ![listArray isKindOfClass:[NSArray class]] || listArray.count == 0)
    {
        return @"";
    }
    
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
    for (VenueModel *model in listArray)
    {
        if (model.venueId.length)
        {
            [tmpArray addObject:model.venueId];
        }
    }
    return [tmpArray componentsJoinedByString:@","];
}

//匹配两个数组里Model的属性
+ (NSArray *)getMatchedModelWithVenueModelArray:(NSArray *)venueArray subModelDict:(NSDictionary *)subModelDict;
{
    if (!venueArray || !subModelDict || ![venueArray isKindOfClass:[NSArray class]] || ![subModelDict isKindOfClass:[NSDictionary class]])
    {
        return nil;
    }
    
    for (VenueModel *model in venueArray)
    {
        if ([model isKindOfClass:[VenueModel class]]) {
            VenueSubModel *subModel = [subModelDict objectForKey:model.venueId];
            if (subModel.venueId.length)
            {
                model.venueOnlineActivityCount = subModel.actCount;//活动数
                model.venueRoomCount = subModel.roomCount;//活动室数
            }
        }
    }
    
    
    return venueArray;
}






@end
