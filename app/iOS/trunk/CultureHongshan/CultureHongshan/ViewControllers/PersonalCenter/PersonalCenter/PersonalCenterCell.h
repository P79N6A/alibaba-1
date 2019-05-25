//
//  PersonalCenterCell.h
//  CultureHongshan
//
//  Created by ct on 16/5/26.
//  Copyright © 2016年 CT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PersonalSettingModel;

@interface PersonalCenterCell : UITableViewCell

//根据offset调整分割线的左右位置，达到
- (void)setModel:(PersonalSettingModel *)model lineOffset:(CGFloat)offset;


@end
