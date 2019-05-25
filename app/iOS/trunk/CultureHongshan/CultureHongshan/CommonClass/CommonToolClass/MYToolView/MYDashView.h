//
//  MYDashView.h
//  CheckTicketSystem
//
//  Created by JackAndney on 2017/11/9.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 虚线视图
 */
@interface MYDashView : UIView
+ (instancetype)dashViewWithColor:(UIColor *)color spacing:(CGFloat)spacing length:(CGFloat)length;
@end
