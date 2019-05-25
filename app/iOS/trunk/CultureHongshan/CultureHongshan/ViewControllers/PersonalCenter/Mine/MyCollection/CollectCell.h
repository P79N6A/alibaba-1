//
//  CollectCell.h
//  CultureHongshan
//
//  Created by ct on 16/4/12.
//  Copyright © 2016年 CT. All rights reserved.
//


/*
 
 我的收藏单元格
 
 
 */

#import <UIKit/UIKit.h>

#import "UserCollectModel.h"

@interface CollectCell : UITableViewCell


@property (nonatomic, assign, readonly) NSInteger type;//type说明: 1 - 活动， 2 － 场馆


@property (nonatomic, retain) UserCollectModel *model;

- (void)setModel:(UserCollectModel *)model forIndexPath:(NSIndexPath *)indexPath;



@end
