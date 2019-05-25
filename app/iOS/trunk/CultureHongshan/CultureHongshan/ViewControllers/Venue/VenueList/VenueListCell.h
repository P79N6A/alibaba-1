//
//  VenueListCell.h
//  CultureHongshan
//
//  Created by JackAndney on 16/4/24.
//  Copyright © 2016年 CT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VenueModel;


/**
 *  场馆列表单元格
 */
@interface VenueListCell : UITableViewCell


- (void)setModel:(VenueModel *)model forIndexPath:(NSIndexPath *)indexPath;

- (UIImageView *)getImageView; // 进入场馆详情时的动画需要用到该ImageView

@end
