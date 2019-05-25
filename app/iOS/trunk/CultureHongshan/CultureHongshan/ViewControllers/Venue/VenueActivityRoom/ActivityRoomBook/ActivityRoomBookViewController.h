//
//  ActivityRoomBookViewController.h
//  CultureHongshan
//
//  Created by ct on 16/6/3.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "BasicViewController.h"

@class ActivityRoomBookModel;

@interface ActivityRoomBookViewController : BasicViewController


@property (nonatomic, strong) ActivityRoomBookModel *model;


@end


/*
 paraDict的参数列表:
 
 
 imageUrl 封面图片
 roomName 活动室名称
 venueName 场馆名称
 roomDate  活动室的预订日期
 roomTime  活动室预订时间段
 roomPrice 活动室的价格
 requiredScore 需要扣除的积分
 roomEventId 活动室的事件ID
 
 */
