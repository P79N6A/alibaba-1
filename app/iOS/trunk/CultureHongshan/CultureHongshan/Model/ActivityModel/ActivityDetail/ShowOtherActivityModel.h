//
//  ShowOtherActivityModel.h
//  CultureHongshan
//
//  Created by JackAndney on 16/7/24.
//  Copyright © 2016年 ct. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  演出方的其它活动
 */
@interface ShowOtherActivityModel : NSObject

@property (nonatomic, assign) NSInteger type;// 1. App形式的活动详情  2.H5端的活动详情

@property (nonatomic, copy) NSString *activityId;
@property (nonatomic, copy) NSString *activityName;
@property (nonatomic, copy) NSString *activityType;//类型
@property (nonatomic, copy) NSString *activityIconUrl;

+ (NSArray *)listArrayWithArray:(NSArray *)array removedActivityId:(NSString *)activityId;

@end
