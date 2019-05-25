//
//  SeatModel.m
//  CultureHongshan
//
//  Created by ct on 16/5/25.
//  Copyright © 2016年 ct. All rights reserved.
//

#import "SeatModel.h"

@implementation SeatModel


- (id)initWithAttributes:(NSDictionary *)dictionary
{
    if(self = [super init])
    {
        if (dictionary == nil || ![dictionary isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
        self.seatRow    = [dictionary safeIntegerForKey:@"seatRow"];
        self.seatStatus = [dictionary safeIntegerForKey:@"seatStatus"];
        self.seatColumn = [dictionary safeIntegerForKey:@"seatColumn"];
        self.seatVal    = [dictionary safeIntegerForKey:@"seatVal"];
    }
    return self;
}


+ (NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray
{
    if (dicArray == nil || ![dicArray isKindOfClass:[NSArray class]]) {
        return @[];
    }
    
    return [self getSeatArrayWithArray:dicArray];
}


//正式数据:二维数组
+ (NSArray *)getSeatArrayWithArray:(NSArray *)dataArray
{
    if (dataArray.count < 1) {
        return @[];
    }
    
    NSMutableArray *seatArray = [NSMutableArray new];//保存多行多列的座位信息
    NSMutableArray *rowArray = [NSMutableArray new];//保存一行的座位信息
    
    SeatModel *lastModel = [SeatModel new];
    
    for (int i = 0; i < dataArray.count; i++)
    {
        NSDictionary *dict = dataArray[i];
        if (dict.count)
        {
            SeatModel *model = [[SeatModel alloc] initWithAttributes:dict];
            if (lastModel.seatRow > 0 && lastModel.seatRow != model.seatRow)//座位的行数（排数）发生变化
            {
                [seatArray addObject:[rowArray copy]];
                rowArray = nil;
                rowArray = [NSMutableArray new];
            }
            
            [rowArray addObject:model];
            lastModel = model;
            
            if (i == dataArray.count-1) {
                [seatArray addObject:rowArray];
            }
        }
    }
    return [seatArray copy];
}

@end
