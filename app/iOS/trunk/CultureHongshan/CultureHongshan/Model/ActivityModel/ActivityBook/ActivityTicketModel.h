//
//  ActivityTicketModel.h
//  ActivityBookJieXiTest
//
//  Created by ct on 16/5/3.
//  Copyright © 2016年 ct. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityTicketModel : NSObject

@property (nonatomic, assign, readonly) NSInteger type;//0-只有开始日期（默认情况） 1－同时包含开始和结束日期
@property (nonatomic, copy) NSString *date;//日期
@property (nonatomic, copy) NSString *endDate;//结束日期
@property (nonatomic, copy) NSString *weekStr;//星期几
@property (nonatomic, strong) NSMutableArray *timeArray;//时间段
@property (nonatomic, strong) NSMutableArray *ticketCountArray;//每个时间段剩余的票数
@property (nonatomic, strong) NSMutableArray *eventIdArray;//每个场次的订票ID
@property (nonatomic, strong) NSMutableArray *statusArray;//每个场次的状态
@property (nonatomic, strong) NSMutableArray *priceArray;//每个场次的价格


@end
