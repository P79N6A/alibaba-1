//
//  MyCommentCell.h
//  CultureHongshan
//
//  Created by ct on 16/4/12.
//  Copyright © 2016年 CT. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyCommentModel.h"


@interface MyCommentCell : UITableViewCell


- (void)setModel:(MyCommentModel *)model forIndexPath:(NSIndexPath *)indexPath topSpacing:(CGFloat)topSpacing;


@end
