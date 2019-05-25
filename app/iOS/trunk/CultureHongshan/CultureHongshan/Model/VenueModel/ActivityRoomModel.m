//
//  ActivityRoomModel.m
//  CultureHongshan
//
//  Created by one on 15/11/13.
//  Copyright © 2015年 CT. All rights reserved.
//

#import "ActivityRoomModel.h"

@implementation ActivityRoomModel

-(id)initWithAttributes:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        if (!dictionary || ![dictionary isKindOfClass:[NSDictionary class]])
        {
            return nil;
        }
        
        self.roomFee       = [dictionary safeStringForKey:@"roomFee"];
        self.roomIsFree    = [dictionary safeIntegerForKey:@"roomIsFree"];
        self.roomId        = [dictionary safeStringForKey:@"roomId"];
        self.roomName      = [dictionary safeStringForKey:@"roomName"];
        self.roomCapacity  = [dictionary safeStringForKey:@"roomCapacity"];
        self.roomArea      = [dictionary safeStringForKey:@"roomArea"];
        self.roomPicUrl    = [dictionary safeStringForKey:@"roomPicUrl"];
        self.sysNo         = [dictionary safeIntegerForKey:@"sysNo"];
        self.roomIsReserve = [dictionary safeIntegerForKey:@"roomIsReserve"];
        
        self.roomTagArray = [ToolClass getComponentArray:[dictionary safeStringForKey:@"roomTagName"] separatedBy:@","];
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
        ActivityRoomModel *model = [[ActivityRoomModel alloc] initWithAttributes:instanceDic];
        if (model) {
            [instanceArray addObject:model];
        }
    }
    return [NSArray arrayWithArray:instanceArray];
}

@end
