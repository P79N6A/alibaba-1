//
//  CalendarListCell.h
//  CultureHongshan
//
//  Created by ct on 17/2/8.
//  Copyright © 2017年 CT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ActivityGatherModel;

/**
   日历列表无图片的单元格
 */
@interface CalendarListTextCell : UITableViewCell

/** 按钮操作：1-收藏   */
- (void)setButtonActionHandler:(void(^)(UIButton *sender, NSInteger index))actionHandler;

- (void)setModel:(ActivityGatherModel *)mdoel forIndexPath:(NSIndexPath *)indexPath;

+ (CGFloat)cellHeightForModel:(ActivityGatherModel *)model;


@end


#pragma mark -


/**
 日历列表有图片的单元格
 */
@interface CalendarListPictureCell : UITableViewCell

/** 按钮操作：1-收藏   */
- (void)setButtonActionHandler:(void(^)(UIButton *sender, NSInteger index))actionHandler;

- (void)setModel:(ActivityGatherModel *)mdoel forIndexPath:(NSIndexPath *)indexPath;

+ (CGFloat)cellHeightForModel:(ActivityGatherModel *)model;


@end
