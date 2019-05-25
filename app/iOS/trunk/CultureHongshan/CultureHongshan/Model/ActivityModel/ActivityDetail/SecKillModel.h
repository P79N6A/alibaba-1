//
//  SecKillModel.h
//  CultureHongshan
//
//  Created by ct on 16/5/31.
//  Copyright © 2016年 CT. All rights reserved.
//


/*
 
 活动详情 秒杀播报Model
 
 */


#import <Foundation/Foundation.h>

@interface SecKillModel : NSObject

@property (nonatomic, copy) NSString *eventId;//场次Id
@property (nonatomic, copy) NSString *eventStartDate;//场次开始日期
@property (nonatomic, copy) NSString *eventEndDate;//场次结束日期
@property (nonatomic, copy) NSString *eventTime;//场次时间段
@property (nonatomic, copy) NSString *orderPrice;//每个场次的票价
@property (nonatomic, assign) BOOL isSingleEvent;//是否为单场次活动
@property (nonatomic, assign) BOOL isSeckillActivity;//是否为秒杀的活动
@property (nonatomic, assign) NSTimeInterval remainedSeconds;//秒杀倒计时（秒数）

@property (nonatomic, copy) NSString *timeSp;//秒杀时间（时间戳）
@property (nonatomic, copy) NSString *dateStr;//日期
@property (nonatomic, copy) NSString *timeStr;//时间点
@property (nonatomic, assign) int ticketCount;//余票数

@property (nonatomic, readonly) NSString *showedStatus;//显示出来的秒杀状态：已结束，正在秒杀，即将开始，未开始
@property (nonatomic, assign) NSInteger status;//秒杀的状态：1-已结束， 2-正在秒杀， 3-即将开始，  4-未开始



+ (NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray isSeckill:(BOOL)isSeckill;

+ (NSArray *)updateSeckillStatus:(NSArray *)seckillArray status:(NSInteger *)status remainedSeconds:(NSTimeInterval *)remainedSeconds savedIndex:(NSString **)savedIndex isPast:(BOOL)isPast;//更新秒杀状态



@end
