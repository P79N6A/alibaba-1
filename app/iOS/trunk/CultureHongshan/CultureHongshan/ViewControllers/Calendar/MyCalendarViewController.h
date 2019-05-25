//
//  MyCalendarViewController.h
//  CultureHongshan
//
//  Created by ct on 17/2/10.
//  Copyright © 2017年 CT. All rights reserved.
//

#import "CommonTableViewController.h"

/**
   我的日历页面
 */
@interface MyCalendarViewController : BasicViewController

@property (nonatomic, copy) void (^collectOperationHandler)(NSString *modelId, BOOL isCollect);

@end


/*
 
 收藏操作：
      1. 日历列表 ---->  活动详情：只更新“日历列表”的收藏状态
      2. 日历列表 ---->  我的日历：只更新“日历列表”的收藏状态
      3. 我的日历 ---->  活动详情：需同时更新 日历列表、我的日历 的收藏状态
 
 */
