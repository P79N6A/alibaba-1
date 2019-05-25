//
//  AnimationTool.h
//  WHYUIKit
//
//  Created by JackAndney on 2017/5/14.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIView;


/**
 *  动画效果工具类
 */
@interface AnimationTool : NSObject

/** 添加UIAlertView出现时的动画效果 */
+ (void)addAlertAnimationOnView:(UIView *)view;

/** 视图放大再缩小的动画 */
+ (void)addScaleAnimationOnView:(UIView *)view;

/** 弹簧动画效果的keyFrames */
+ (NSMutableArray *)animationValues:(NSNumber *)fromValue toValue:(NSNumber *)toValue usingSpringWithDamping:(float)damping initialSpringVelocity:(float)velocity duration:(float)duration;

@end
