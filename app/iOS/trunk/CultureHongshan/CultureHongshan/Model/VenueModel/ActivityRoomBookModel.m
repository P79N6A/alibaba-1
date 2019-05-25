//
//  ActivityRoomBookModel.m
//  CultureHongshan
//
//  Created by ct on 16/6/12.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "ActivityRoomBookModel.h"


@interface ActivityRoomBookModel ()

@property (nonatomic, copy) NSString *venueLon;//活动室预订id
@property (nonatomic, copy) NSString *venueLat;

@end


@implementation ActivityRoomBookModel

- (id)initWithAttributes:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        if (!dictionary || ![dictionary isKindOfClass:[NSDictionary class]])
        {
            return nil;
        }
        self.bookId        = [dictionary safeStringForKey:@"cmsRoomBookId"];
        self.roomName      = [dictionary safeStringForKey:@"roomName"];
        self.venueName     = [dictionary safeStringForKey:@"cmsVenueName"];
        self.roomPicUrl    = [dictionary safeStringForKey:@"roomPicUrl"];
        self.roomDate      = [dictionary safeStringForKey:@"date"];
        self.openPeriod    = [dictionary safeStringForKey:@"openPeriod"];
        self.roomPrice     = [dictionary safeStringForKey:@"price"];
        self.requiredScore = [dictionary safeIntegerForKey:@"requiredScore"];
        self.orderName     = [dictionary safeStringForKey:@"orderName"];
        self.orderTel      = [dictionary safeStringForKey:@"orderTel"];

        self.venueLat      = [dictionary safeStringForKey:@"venueLat"];
        self.venueLon      = [dictionary safeStringForKey:@"venueLon"];
        
        self.teamListArray = [TeamUserListModel instanceArrayFromDictArray:dictionary[@"teamList"]];
    }
    return self;
}

@end




/*    ——————————————  使用者列表Model  ————————————————   */

@implementation TeamUserListModel

- (id)initWithAttributes:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        if (!dictionary || ![dictionary isKindOfClass:[NSDictionary class]])
        {
            return nil;
        }
        self.tUserId   = [dictionary safeStringForKey:@"tuserId"];
        self.tUserName = [dictionary safeStringForKey:@"tuserName"];
    }
    return self;
}


+ (NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray
{
    if (!dicArray || ![dicArray isKindOfClass:[NSArray class]])
    {
        return @[];
    }
    
    NSMutableArray *instanceArray = [NSMutableArray array];
    for (NSDictionary *instanceDic in dicArray) {
        TeamUserListModel *model = [[TeamUserListModel alloc] initWithAttributes:instanceDic];
        if (model.tUserId.length && model.tUserName.length) {
            [instanceArray addObject:model];
        }
    }
    return [NSArray arrayWithArray:instanceArray];
}

@end




