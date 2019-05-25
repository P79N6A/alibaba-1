//
//  ActivityDetailActivityUnitCell.h
//  CultureHongshan
//
//  Created by ct on 16/4/18.
//  Copyright © 2016年 CT. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void (^ActivityUnitCellBlock)(NSString *activityUnitId);

@interface ActivityDetailActivityUnitCell : UITableViewCell

@property (nonatomic, copy) ActivityUnitCellBlock block;

- (void)setDataArray:(NSArray *)dataArray forIndexPath:(NSIndexPath *)indexPath;


@end
