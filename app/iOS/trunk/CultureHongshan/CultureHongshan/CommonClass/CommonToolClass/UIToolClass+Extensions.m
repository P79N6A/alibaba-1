
//
//  UIToolClass+Extensions.m
//  CultureHongshan
//
//  Created by JackAndney on 2017/7/6.
//  Copyright © 2017年 CT. All rights reserved.
//

#import "UIToolClass+Extensions.h"

@implementation UIToolClass (Extensions)

+ (UIImage *)getPlaceholderWithViewSize:(CGSize)viewSize centerSize:(CGSize)centerSize isBorder:(BOOL)isBorder {
    UIImage *image = [UIImage imageNamed:kPlaceholderImageName];
    if (image) {
        if (isBorder) {
            return [image placeholderWithViewSize:viewSize centerSize:centerSize fillColor:[UIColor whiteColor] borderWidth:1 borderColor:[UIColor colorWithWhite:0.756 alpha:1.0f]];
        }else {
            return [image placeholderWithViewSize:viewSize centerSize:centerSize fillColor:[UIColor whiteColor] borderWidth:0 borderColor:[UIColor clearColor]];
        }
    }
    return nil;
}


// 设置滑动视图不自动调整内容偏移量
+ (void)setupDontAutoAdjustContentInsets:(UIScrollView *)scrollView forController:(UIViewController *)vc {
    
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        if (vc) {
            vc.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
#else
    if (vc) {
        vc.automaticallyAdjustsScrollViewInsets = NO;
    }
#endif
}




@end
