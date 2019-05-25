//
//  AccumulativeScoreCell.h
//  CultureHongshan
//
//  Created by ct on 16/5/27.
//  Copyright © 2016年 CT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserAccumulativeScoreModel;

@interface AccumulativeScoreCell : UITableViewCell


- (void)setModel:(UserAccumulativeScoreModel *)model isLineHiddden:(BOOL)isHidden;


@end
