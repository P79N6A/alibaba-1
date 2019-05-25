//
//  DetailTabBarView.h
//  CultureHongshan
//
//  Created by ct on 16/4/11.
//  Copyright © 2016年 CT. All rights reserved.
//


/*
 
 活动详情和场馆详情页面底部的工具栏
 
 从左到右依次为：评论、点赞、收藏、分享、咨询或者立即预约等
 
 */

#import <UIKit/UIKit.h>


@interface DetailTabBarView : UIView 


@property (nonatomic, copy) IndexBlock callBackBlock;

- (instancetype)initWithFrame:(CGRect)frame prompt:(NSString *)prompt;

/*
 
 title只有“其他”按钮使用
 
 */
- (void)setButtonStatusWithIndex:(NSInteger)btnIndex title:(id)title selected:(BOOL)selected;

- (void)showWithAnimation:(UIScrollView *)tableView;
- (void)dismissWithAnimation:(UIScrollView *)tableView;


@end
