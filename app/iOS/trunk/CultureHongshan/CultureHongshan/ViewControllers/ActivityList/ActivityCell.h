//
//  ActivityCell.h
//  CultureHongshan
//
//  Created by ct on 16/3/15.
//  Copyright © 2016年 CT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ActivityModel;



@interface ActivityCell : UITableViewCell

/*
 type说明：1－首页和搜索结果页的活动单元格，  2-附近的单元格（显示距离）  3-我的文化日历单元格_其它   4-我的文化日历单元格_已参加
 */
- (void)setModel:(ActivityModel *)model type:(NSInteger)type forIndexPath:(NSIndexPath *)indexPath;
- (UIImageView *)getHeadImage;


- (void)setButtonActionHandler:(void(^)(UIButton *, NSInteger))handler;
- (void)showCollectButton:(BOOL)show;
- (void)hideTypeView:(BOOL)hidden;



@end

