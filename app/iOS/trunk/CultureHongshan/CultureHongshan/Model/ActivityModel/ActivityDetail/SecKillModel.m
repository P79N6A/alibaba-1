//
//  SecKillModel.m
//  CultureHongshan
//
//  Created by ct on 16/5/31.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "SecKillModel.h"


@implementation SecKillModel

- (id)initWithAttributes:(NSDictionary *)dictionary
{
    if(self = [super init])
    {
        if (!dictionary || ![dictionary isKindOfClass:[NSDictionary class]])
        {
            return nil;
        }
        self.eventId           = [dictionary safeStringForKey:@"eventId"];
        self.eventStartDate    = [dictionary safeStringForKey:@"eventDate"];
        self.eventEndDate      = [dictionary safeStringForKey:@"eventEndDate"];
        self.eventTime         = [dictionary safeStringForKey:@"eventTime"];
        self.isSingleEvent     = [dictionary safeIntegerForKey:@"singleEvent"] == 1;
        self.isSeckillActivity = [dictionary safeIntegerForKey:@"spikeType"] == 1;
        self.orderPrice        = [dictionary safeStringForKey:@"orderPrice"];
        if (_orderPrice.length < 1) {
            self.orderPrice = @"0";
        }
        self.remainedSeconds   = [[dictionary safeStringForKey:@"spikeDifference"] longLongValue];
        self.ticketCount       = (int)[dictionary safeIntegerForKey:@"availableCount"];
//        self.status            = [dictionary safeIntegerForKey:@"userName"];
        
        self.timeSp  = [dictionary safeStringForKey:@"spikeTime"];//秒杀时间点
        self.dateStr = [DateTool dateStringForTimeSp:self.timeSp formatter:@"yyyy.MM.dd" millisecond:NO];
        self.timeStr = [DateTool dateStringForTimeSp:self.timeSp formatter:@"HH:mm" millisecond:NO];
    }
    return self;
}

+ (NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray isSeckill:(BOOL)isSeckill
{
    if (!dicArray || ![dicArray isKindOfClass:[NSArray class]])
    {
        return @[];
    }
    
    NSMutableArray *instanceArray = [NSMutableArray array];
    for (NSDictionary *instanceDic in dicArray) {
        SecKillModel *model = [[SecKillModel alloc] initWithAttributes:instanceDic];
        if (model) {
            if (isSeckill) {
                if (model.isSeckillActivity) {
                    [instanceArray addObject:model];
                }
            }else{
                if (model.isSeckillActivity == NO) {
                    [instanceArray addObject:model];
                }
            }
        }
    }
    return [NSArray arrayWithArray:instanceArray];
}

//秒杀的状态：1-已结束， 2-正在秒杀， 3-即将开始，  4-未开始
- (NSString *)showedStatus
{
    NSString *status = @"";
    switch (_status) {
        case 1: {
            status = @"已结束";
        }
            break;
        case 2: {
            status = @"正在秒杀";
        }
            break;
        case 3: {
            status = @"即将开始";
        }
            break;
        case 4: {
            status = @"未开始";
        }
            break;
            
        default:
            break;
    }
    return status;
}


/*
 
 status :  0-无需秒杀  1-已订完(所有的秒杀全部结束)  2-进入倒计时  3-正在秒杀  4-未开始  5-已结束
 savedIndex: 保存可以预订的时间段Index (X,X,X)
 
 */
+ (NSArray *)updateSeckillStatus:(NSArray *)seckillArray status:(NSInteger *)status remainedSeconds:(NSTimeInterval *)remainedSeconds savedIndex:(NSString **)savedIndex isPast:(BOOL)isPast
{
    NSInteger currentCount = 0;    //当前票数
    NSInteger totalCount = 0;		//所有场次总票数
    NSTimeInterval timeDifference = -1;	//秒杀倒计时
    
    if (seckillArray.count)
    {
        //记录最后一个“已结束”的场次节点。已结束的场次之前的所有场次均为已结束
        NSInteger lastEndIndex = -1;
        for(NSInteger i = seckillArray.count-1 ;i > -1 ; i--)
        {
            SecKillModel *model = seckillArray[i];
            if(model.remainedSeconds <= 0){
                if(model.ticketCount <= 0){
                    lastEndIndex = i;
                    break;
                }
            }
        }
        
        NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:1];//保存正在秒杀的Model索引
        
        for (int i = 0; i < seckillArray.count; i++)
        {
            SecKillModel *model = seckillArray[i];
            if (isPast) {//已结束的活动，所有的场次状态均为“已结束”
                model.status = 1;
                continue;
            }
            
            if (model.remainedSeconds <= 0) {
                currentCount += model.ticketCount;
                if (model.ticketCount < 1) {
                    model.status = 1;//已结束
                }else{
                    [tmpArray addObject:StrFromInt(i)];
                    if (i <= lastEndIndex) {
                        model.status = 1;//已结束
                    }else{
                        model.status = 2;//正在秒杀
                    }
                }
            }else{
                if(model.remainedSeconds <= 86400){
                    model.status = 3;//即将开始
                    if(timeDifference == -1 && totalCount == 0){
                        timeDifference = model.remainedSeconds;
                    }
                }else{
                    model.status = 4;//未开始
                }
            }
            totalCount += model.ticketCount;
        }
        
        
        if (isPast) {
            *status = 5;//已结束
        }else{
            if (totalCount < 1){
                *status = 1;//已订完
            }else{
                if (timeDifference > 0){
                    *status = 2;//开始进行倒计时
                    *remainedSeconds = timeDifference;
                }else{
                    if (currentCount > 0 ){
                        *status = 3;//正在秒杀
                        *savedIndex = [tmpArray componentsJoinedByString:@","];
                    }else{
                        *status = 4;//未开始
                    }
                }
            }
        }
        return seckillArray;
    }else{
        *status = 0;//无需秒杀
        return @[];
    }
}


@end
