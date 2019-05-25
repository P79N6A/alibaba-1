//
//  DetailNavTitleView.h
//  CultureHongshan
//
//  Created by ct on 16/5/23.
//  Copyright © 2016年 CT. All rights reserved.
//

/*
 
 详情页中的导航视图
 
 */
#import <UIKit/UIKit.h>

@interface DetailNavTitleView : UIView


- (instancetype)initWithFrame:(CGRect)frame navTitle:(NSString *)title;

- (void)setContentOffsetY:(CGFloat)offsetY;


@end
