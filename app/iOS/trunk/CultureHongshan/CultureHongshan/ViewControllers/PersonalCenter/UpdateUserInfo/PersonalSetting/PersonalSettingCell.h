//
//  PersonalSettingCell.h
//  CultureHongshan
//
//  Created by JackAndney on 16/4/17.
//  Copyright © 2016年 CT. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PersonalSettingModel.h"


@interface PersonalSettingCell : UITableViewCell

- (void)setModel:(PersonalSettingModel *)model forIndexPath:(NSIndexPath *)indexPath;

-(void)hiddenIndicatorArrow;

@end
