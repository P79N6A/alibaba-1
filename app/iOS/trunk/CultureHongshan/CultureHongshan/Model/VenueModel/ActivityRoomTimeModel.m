//
//  ActivityRoomTimeModel.m
//  CultureHongshan
//
//  Created by one on 15/11/16.
//  Copyright © 2015年 CT. All rights reserved.
//

#import "ActivityRoomTimeModel.h"


@interface ActivityRoomTimeModel ()

@property (nonatomic, copy) NSString *curDate;//活动室的开放日期
@property (nonatomic, copy) NSString *bookId;//活动室预订id
@property (nonatomic, copy) NSString *openPeriod;//活动室开放时间段
@property (nonatomic, copy) NSString *status;//活动室时间状态 0.已过期 1.未过期

@end


@implementation ActivityRoomTimeModel

-(id)initWithAttributes:(NSDictionary *)dictionary
{
    if(self = [super init]){
        if (!dictionary || ![dictionary isKindOfClass:[NSDictionary class]])
        {
            return nil;
        }
        
        self.bookIdArray     = [ToolClass getComponentArray:[dictionary safeStringForKey:@"bookId"] separatedBy:@","];
        self.openPeriodArray = [ToolClass getComponentArray:[dictionary safeStringForKey:@"openPeriod"] separatedBy:@","];
        self.statusArray     = [ToolClass getComponentArray:[dictionary safeStringForKey:@"status"] separatedBy:@","];//bookStatus
        self.openDate        = [DateTool dateForDateString:[dictionary safeStringForKey:@"curDate"] formatter:@"yyyy-MM-dd"];
        
        NSArray *statusArray = [ToolClass getComponentArray:[dictionary safeStringForKey:@"status"] separatedBy:@","];
        NSArray *bookStatusArray = [ToolClass getComponentArray:[dictionary safeStringForKey:@"bookStatus"] separatedBy:@","];
        
        [self handleBookStatusWithStatusArray:statusArray bookStatusArray:bookStatusArray];
    }
    return self;
}


- (void)handleBookStatusWithStatusArray:(NSArray *)array1 bookStatusArray:(NSArray *)array2
{
    /*  后台的状态： status：    活动室时间状态 0.已过期 1.未过期
                   bookStatus：活动室状态 1-可选 2-已选 3-不可选
     前端的状态：  0-不开放, 1-已被预订, 2-可预订, 3-已过期
     */
    
    NSInteger count = MIN(array1.count, array2.count);
    
    if (count  > 0) {
        NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i < count; i++)
        {
            NSInteger status = [array1[i] integerValue];
            NSInteger bookStatus = [array2[i] integerValue];
            
            if (status == 0) {//已过期
                [tmpArray addObject:@"3"];
            }else{
                if (bookStatus == 1) {//可选
                    [tmpArray addObject:@"2"];
                }else if (bookStatus == 2){//已选
                    [tmpArray addObject:@"1"];
                }else if (bookStatus == 3){//不可选
                    [tmpArray addObject:@"0"];
                }
            }
        }
        self.statusArray = [tmpArray copy];
    }
}

+(NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray
{
    if (!dicArray || ![dicArray isKindOfClass:[NSArray class]])
    {
        return @[];
    }
    
    NSMutableArray *instanceArray = [NSMutableArray array];
    for (NSDictionary *instanceDic in dicArray) {
        ActivityRoomTimeModel *model = [[ActivityRoomTimeModel alloc] initWithAttributes:instanceDic];
        if ( model.bookIdArray.count == model.openPeriodArray.count && model.bookIdArray.count == model.statusArray.count && model.bookIdArray.count > 0) {
            [instanceArray addObject:model];
        }
    }
    return [NSArray arrayWithArray:instanceArray];
}

@end
