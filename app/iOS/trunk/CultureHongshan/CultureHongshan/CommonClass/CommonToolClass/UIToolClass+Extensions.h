//
//  UIToolClass+Extensions.h
//  CultureHongshan
//
//  Created by JackAndney on 2017/7/6.
//  Copyright © 2017年 CT. All rights reserved.
//

#import <WHYUIKit/WHYUIKit.h>

@interface UIToolClass (Extensions)

+ (UIImage *)getPlaceholderWithViewSize:(CGSize)viewSize centerSize:(CGSize)centerSize isBorder:(BOOL)isBorder;


/**
 设置滑动视图不自动调整内容偏移量

 @param scrollView 滑动视图
 @param vc 滑动视图所在的视图控制器
 */
+ (void)setupDontAutoAdjustContentInsets:(UIScrollView *)scrollView forController:(UIViewController *)vc;

@end
