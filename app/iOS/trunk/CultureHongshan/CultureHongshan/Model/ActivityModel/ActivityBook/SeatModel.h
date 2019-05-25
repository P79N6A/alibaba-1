//
//  SeatModel.h
//  CultureHongshan
//
//  Created by ct on 16/5/25.
//  Copyright © 2016年 ct. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SeatModel : NSObject

@property (nonatomic, assign) NSInteger seatStatus;//1. 可选座位   2.已售座位  3. 座位不存在
@property (nonatomic, assign) NSInteger seatRow;
@property (nonatomic, assign) NSInteger seatColumn;//传给后台----0628
@property (nonatomic, assign) NSInteger seatVal;//显示给用户

+ (NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray;

@end
