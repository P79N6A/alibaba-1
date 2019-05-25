//
//  VenListCell.h
//  CultureHongshan
//
//  Created by ct on 17/3/20.
//  Copyright © 2017年 CT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VenueModel;

@interface VenListCell : UITableViewCell

- (void)setModel:(VenueModel *)model forIndexPath:(NSIndexPath *)indexPath;
- (UIImageView *)getImageView; // 进入场馆详情时的动画需要用到该ImageView

@end
