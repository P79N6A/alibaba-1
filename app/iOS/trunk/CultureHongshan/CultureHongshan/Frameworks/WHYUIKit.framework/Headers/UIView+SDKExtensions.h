//
//  UIView+SDKExtensions.h
//  WHYUIKit
//
//  Created by JackAndney on 2017/5/14.
//  Copyright © 2017年 Creatoo. All rights reserved.
//
// 视图的一些扩展方法

#import <UIKit/UIKit.h>


#pragma mark - Layout

@interface UIView (Layout)

@property (nonatomic, assign) CGFloat originalX;      // 视图左上角的X值
@property (nonatomic, assign) CGFloat originalY;      // 视图左上角的Y值
@property (nonatomic, assign, readonly) CGFloat maxX; // 视图的右下角的X值
@property (nonatomic, assign, readonly) CGFloat maxY; // 视图的右下角的Y值
@property (nonatomic, assign) CGFloat width;          // 视图的宽
@property (nonatomic, assign) CGFloat height;         // 视图的高
@property (nonatomic, assign) CGSize viewSize;        // 视图的宽和高
@property (nonatomic, assign) CGFloat centerX;        // 中心位置的X坐标
@property (nonatomic, assign) CGFloat centerY;        // 中心位置的Y坐标

@end


#pragma mark - RectCorner


@interface UIView (RectCorner)

@property (nonatomic, assign) CGFloat radius;

- (void)setCornerOnTop:(CGFloat)radius;
- (void)setCornerOnBottom:(CGFloat)radius;
- (void)setCornerOnLeft:(CGFloat)radius;
- (void)setCornerOnRight:(CGFloat)radius;
- (void)setCornerWithRoundingCorners:(UIRectCorner)corners andRadius:(CGFloat)radius;
- (void)setAllCorner:(CGFloat)radius;
- (void)setNoneCorner;


@end



#pragma mark - OtherExtension

@interface UIView (OtherExtension)

- (void)removeAllSubViews;

- (void)addDashWithWidth:(CGFloat)width color:(UIColor *)color;


@end

