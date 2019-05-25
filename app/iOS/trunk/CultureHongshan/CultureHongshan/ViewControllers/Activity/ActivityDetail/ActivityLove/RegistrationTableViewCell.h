//
//  Registration TableViewCell.h
//  CultureHongshan
//
//  Created by xiao on 15/12/8.
//  Copyright © 2015年 CT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrationTableViewCell : UITableViewCell

//头像
@property (strong, nonatomic) UIButton *headerImage;

//姓名
@property (strong, nonatomic) UILabel *nameLabel;

//性别
//@property (strong, nonatomic) UILabel *sexLabel;

//年龄
@property (strong, nonatomic) UILabel *ageLabel;

//分割线
@property (strong, nonatomic) UIView *lineView;

@end
