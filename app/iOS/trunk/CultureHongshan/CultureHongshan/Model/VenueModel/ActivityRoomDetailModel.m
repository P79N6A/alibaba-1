//
//  ActivityRoomDetailModel.m
//  CultureHongshan
//
//  Created by one on 15/11/16.
//  Copyright © 2015年 CT. All rights reserved.
//

#import "ActivityRoomDetailModel.h"

#import "ActivityRoomTimeModel.h"


@implementation ActivityRoomDetailModel

-(id)initWithAttributes:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        if (!dictionary || ![dictionary isKindOfClass:[NSDictionary class]])
        {
            return nil;
        }
        
        self.roomId         = [dictionary safeStringForKey:@"roomId"];
        self.roomName       = [dictionary safeStringForKey:@"roomName"];
        self.roomCapacity   = [dictionary safeStringForKey:@"roomCapacity"];
        self.roomArea       = [dictionary safeStringForKey:@"roomArea"];
        self.roomPicUrl     = [dictionary safeStringForKey:@"roomPicUrl"];
        self.roomConsultTel = [dictionary safeStringForKey:@"roomConsultTel"];
        self.roomFee        = [dictionary safeStringForKey:@"roomFee"];
        
        self.venueName    = [dictionary safeStringForKey:@"venueName"];
        self.venueAddress = [dictionary safeStringForKey:@"venueAddress"];
        self.sysNo        = [dictionary safeIntegerForKey:@"sysNo"];
        self.roomRemark   = [dictionary safeStringForKey:@"roomRemark"];
        
        self.roomIsFree = [[dictionary safeStringForKey:@"roomIsFree"] isEqualToString:@"2"] == NO; //1-免费， 2-收费
        self.facilityArray = [ToolClass getComponentArray:[dictionary safeStringForKey:@"facility"] separatedBy:@","];
        
        
        NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:1];

        NSString *roomTagName = [dictionary safeStringForKey:@"roomTagName"];
        if (roomTagName.length) {
            [tmpArray addObject:[[ToolClass getComponentArrayIgnoreBlank:roomTagName separatedBy:@","] firstObject]];
        }
        
        NSArray *subListArray = [dictionary safeArrayForKey:@"subList"];
        for (int i = 0; i < subListArray.count && i < 2; i++) {
            NSDictionary *tagDict = subListArray[i];
            NSString *tagName = [tagDict safeStringForKey:@"tagName"];
            if (tagName.length) {
                [tmpArray addObject:tagName];
            }
        }
        self.roomTagNames = tmpArray;
        
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
        ActivityRoomDetailModel *model = [[ActivityRoomDetailModel alloc] initWithAttributes:instanceDic];
        if (model) {
            [instanceArray addObject:model];
        }
    }
    return [NSArray arrayWithArray:instanceArray];
}

@end
