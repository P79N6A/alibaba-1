//
//  ActivityRoomCell.h
//  CultureHongshan
//
//  Created by one on 15/11/10.
//  Copyright © 2015年 CT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ActivityRoomModel;



@interface ActivityRoomCell : UITableViewCell


- (void)setModel:(ActivityRoomModel *)model forIndexPath:(NSIndexPath *)indexPath;


@end
