//
//  ActivityDetailViewController.h
//  CultureHongshan
//
//  Created by xiao on 15/11/6.
//  Copyright © 2015年 CT. All rights reserved.
//

#import "BasicViewController.h"

@class CommentModel;
@class ActivityDetail;

/**
 *  活动详情页面
 */
@interface ActivityDetailViewController : BasicViewController

@property (nonatomic, copy) NSString *activityId;
@property (nonatomic, copy) NSString *tagName;//从列表页传过来的标签名字

// 从列表进入活动详情时，上下两张图片分开动画所需的图片
@property (nonatomic, copy) NSArray *screenshotImages;

@property (nonatomic, copy) void (^collectOperationHandler)(NSString *modelId, BOOL isCollect);

@property (nonatomic,strong)  ActivityDetail *activityDetail;

- (void)updateActivityDetailData;

@end
