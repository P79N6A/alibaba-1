//
//  PublishCommentViewController.h
//  CultureHongshan
//
//  Created by one on 16/1/25.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "BasicScrollViewController.h"
@class CommentModel;


/**
 *  发表评论页面
 */
@interface PublishCommentViewController : BasicScrollViewController

@property (nonatomic, assign) DataType dataType;// 1-场馆, 2- 活动
@property (nonatomic, copy) NSString *modelId;//活动或场馆的Id

/** 评论成功后的回调block */
@property (nonatomic, copy) void (^successBlock)(CommentModel *model);

@end
