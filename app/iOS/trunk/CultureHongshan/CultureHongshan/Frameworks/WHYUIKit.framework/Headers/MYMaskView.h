//
//  MYMaskView.h
//  WHYToolSDK
//
//  Created by JackAndney on 2017/5/14.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYMaskView : UIView

+ (id)maskViewWithBgColor:(UIColor *)color frame:(CGRect)frame radius:(CGFloat)radius;
+ (id)maskViewWithImage:(UIImage *)image frame:(CGRect)frame radius:(CGFloat)radius;

@end
