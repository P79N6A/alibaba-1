//
//  UIImage+SDKExtensions.h
//  WHYUIKit
//
//  Created by JackAndney on 2017/5/14.
//  Copyright © 2017年 Creatoo. All rights reserved.
//
// 图像的一些扩展方法


#import <UIKit/UIKit.h>



#pragma mark - ImageCorner

/**
 *  图片圆角
 */
@interface UIImage (ImageCorner)

/** 圆形图片 */
- (UIImage *)circleImage;

/**
 圆角图片
 
 @param size   图片展示的大小
 @param radius 圆角半径（必须大于0）
 @return 带有圆角的图片
 */
- (UIImage *)roundedImageWithSize:(CGSize)size radius:(CGFloat)radius;

/** 部分圆角的图片 */
- (UIImage *)roundedImageWithSize:(CGSize)size radius:(CGFloat)radius roundingCorners:(UIRectCorner)corners;

@end


#pragma mark - ImageResize

/**
 *  图片裁剪或变换
 */
@interface UIImage (ImageResize)

/**
 获取x倍图
 
 @param scale 图片比例
 */
- (UIImage *)getScaleImage:(CGFloat)scale;
- (UIImage *)get2xImage; // 获取 @2x 图片
- (UIImage *)get3xImage; // 获取 @3x 图片

/** 限制图片的最大像素尺寸 */
- (UIImage *)limitToMaxPixel:(NSUInteger)maxPixel;

/** 限制图片的最大像素尺寸 */
- (UIImage *)limitToMaxPixel:(NSUInteger)maxPixel scale:(CGFloat)scale;

/**
 图片缩放至指定的宽度
 
 @param width  指定的宽度
 @param larger 宽度不够的图片是否要进行放大
 @param scale  图片的缩小因子
 */
- (UIImage *)scaleToWidth:(NSUInteger)width canBeLarger:(BOOL)larger imgScale:(CGFloat)scale;


/** 裁剪图片的指定区域 */
- (UIImage *)clipInRect:(CGRect)rect;

/** 裁剪图片至指定的 高度 与 宽度 之比 */
- (UIImage *)clipToScale:(CGFloat)scale;

/**
 裁剪图片至指定的大小
 
 @discussion  当图片的尺寸小于指定的大小时，将会放大图片
 
 @param size  指定的图片大小
 @param scale 图片的缩小因子
 */
- (UIImage *)clipToSize:(CGSize)size imgScale:(CGFloat)scale;


@end





#pragma mark - FileSizeCompress

/** 图片的文件大小压缩 */
@interface UIImage (FileSizeCompress)

- (NSData *)imageDataLimitWithMaxPixel:(NSInteger)maxPixel maxByte:(unsigned long long)maxLength;
- (NSData *)imageDataLimitWithMaxByte:(unsigned long long)maxLength;

@end






#pragma mark - ImageEffects

/** 图片模糊效果 */
@interface UIImage (ImageEffects)

- (UIImage *)blurryImage; // 模糊图片

- (UIImage *)applyLightEffect;
- (UIImage *)applyExtraLightEffect;
- (UIImage *)applyDarkEffect;
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;
- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

@end





#pragma mark - OtherExtension



@interface UIImage (OtherExtension)

/** 是否为有效的图片 */
- (BOOL)isValidImg;

- (BOOL)hasAlpha;

/** 矫正图片的方向 */
- (UIImage *)orientationFixedImage;

/**
 图片添加水印
 
 @param watermakImg 水印图片
 @param text        水印文字
 @param attributes  水印文字的属性
 @param position    水印的位置：1-底部居右 2-底部居中 3-图片中心
 @param imageRight  水印图片和文字同时存在时，是否把图片放在右侧
 */
- (UIImage *)addWatermark:(UIImage *)watermakImg andText:(NSString *)text attributes:(NSDictionary *)attributes position:(int)position imageRight:(BOOL)imageRight;


/**
 生成占位图
 
 @param viewSize    占位图的大小
 @param centerSize  中间图标的大小
 @param fillColor   填充色
 @param borderWidth 边框宽度
 @param borderColor 边框颜色
 */
- (UIImage *)placeholderWithViewSize:(CGSize)viewSize centerSize:(CGSize)centerSize fillColor:(UIColor *)fillColor borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;



@end
