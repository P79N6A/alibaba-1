//
//  ShowOtherActivityCell.h
//  CultureHongshan
//
//  Created by JackAndney on 16/7/24.
//  Copyright © 2016年 ct. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShowOtherActivityModel;



typedef void (^ShowOtherActivityCellBlock)(ShowOtherActivityModel *model);




@interface ShowOtherActivityCell : UITableViewCell

@property (nonatomic, copy) ShowOtherActivityCellBlock block;

- (void)setLeftModel:(ShowOtherActivityModel *)leftModel
          rightModel:(ShowOtherActivityModel *)rightModel
          topSpacing:(CGFloat)topSpacing
       bottomSpacing:(CGFloat)bottomSpacing;


@end
