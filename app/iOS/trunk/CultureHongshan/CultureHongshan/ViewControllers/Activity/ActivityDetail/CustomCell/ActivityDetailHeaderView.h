//
//  ActivityDetailHeaderView.h
//  CultureHongshan
//
//  Created by ct on 16/1/25.
//  Copyright © 2016年 CT. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kTag_Vote       4//查看更多“我要投票”
#define kTag_NewsReport 5//查看更多“我要投票”
#define kTag_Comment    6//用户点评右侧的三个圆点按钮

#define kTag_WantGo     7//点赞
#define kTag_AddComment 8//发表评论



@interface ActivityDetailHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIButton *button;//右侧的按钮
@property (nonatomic, assign) BOOL accessoryImgHidden;
@property (nonatomic, assign) BOOL lineHaveProgressAnimation;


@property (nonatomic, copy) void (^headerViewButtonBlock)(NSInteger btnIndex);



- (void)setDataArray:(NSArray *)dataArray forSection:(NSInteger )section;

-(void)endLineProgressAnimation;

@end
