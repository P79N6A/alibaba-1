//
//  ActivityCommentDetailCell.h
//  CultureHongshan
//
//  Created by ct on 16/3/31.
//  Copyright © 2016年 CT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentModel;


/**
 活动详情评论单元
 */
@interface ActivityCommentDetailCell : UITableViewCell


@property (nonatomic, strong) UIView *imageContainerView;//图片的容器
- (void)setLineViewHidden:(BOOL)isHidden;
- (void)setCommmentModel:(CommentModel *)model forIndexPath:(NSIndexPath *)indexPath;
@end
