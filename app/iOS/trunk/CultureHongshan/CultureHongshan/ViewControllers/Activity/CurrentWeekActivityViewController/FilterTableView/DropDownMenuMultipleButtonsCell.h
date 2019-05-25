//
//  DropDownMenuMultipleButtonsCell.h
//  CultureHongshan
//
//  Created by ct on 16/3/18.
//  Copyright © 2016年 CT. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ExtendedButton.h"



/*
 
 带有多个按钮的单元格
 
 中间带有分割线
 
 */

@interface DropDownMenuMultipleButtonsCell : UITableViewCell



@property (nonatomic,strong) UIButton *onlyWeekendButton;//只显示周末
@property (nonatomic,strong) ExtendedButton *titleButton;//上边的标题
@property (nonatomic,strong) UIView *lineView;//分割线

@property (nonatomic,copy) NSString *titleString;//标题

- (void)setTitleString:(NSString *)titleString withSection:(NSInteger)section spacing:(CGFloat)spacing;

@end
