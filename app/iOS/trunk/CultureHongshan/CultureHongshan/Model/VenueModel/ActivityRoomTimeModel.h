//
//  ActivityRoomTimeModel.h
//  CultureHongshan
//
//  Created by one on 15/11/16.
//  Copyright © 2015年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityRoomTimeModel : NSObject

@property (nonatomic, strong) NSArray *bookIdArray;
@property (nonatomic, strong) NSArray *openPeriodArray;
@property (nonatomic, strong) NSArray *statusArray;//0-不开放, 1-已被预订, 2-可预订, 3-已过期
@property (nonatomic,strong) NSDate *openDate;//活动室的开放日期

-(id)initWithAttributes:(NSDictionary *)dictionary;


+(NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray;

@end

/*
    status：活动室时间状态 0.已过期 1.未过期
    bookStatus：活动室状态 1-可选 2-已选 3-不可选
 */

