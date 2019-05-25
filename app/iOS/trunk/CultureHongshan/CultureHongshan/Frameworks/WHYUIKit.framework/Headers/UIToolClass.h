//
//  UIToolClass.h
//  WHYUIKit
//
//  Created by JackAndney on 2017/5/14.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  UI工具类
 */
@interface UIToolClass : NSObject


#pragma mark - 字符串和字体的高度、宽度计算等

+ (CGFloat)fontHeight:(UIFont *)font;
+ (CGFloat)fontWidth:(UIFont *)font;
+ (CGFloat)textWidth:(NSString *)text font:(UIFont *)font;
+ (CGFloat)textHeight:(NSString *)text font:(UIFont *)font width:(CGFloat)width;
+ (CGFloat)textHeight:(NSString *)text font:(UIFont *)font width:(CGFloat)width maxRow:(NSInteger)maxRow;

+ (CGFloat)textHeight:(NSString *)text lineSpacing:(CGFloat)spacing font:(UIFont *)font width:(CGFloat)width;
+ (CGFloat)textHeight:(NSString *)text lineSpacing:(CGFloat)spacing font:(UIFont *)font width:(CGFloat)width maxRow:(NSInteger)maxRow;
+ (CGFloat)attributedTextWidth:(NSAttributedString *)attributedString;
+ (CGFloat)attributedTextHeight:(NSAttributedString *)attributedString width:(CGFloat)width;
+ (NSMutableAttributedString *)getAttributedStr:(NSString *)text font:(UIFont *)font lineSpacing:(CGFloat)spacing;
+ (NSMutableAttributedString *)getAttributedStr:(NSString *)text font:(UIFont *)font lineSpacing:(CGFloat)spacing alignment:(NSTextAlignment)alignment;

/** 粗体字符串 */
+ (NSMutableAttributedString *)boldString:(NSString *)text font:(UIFont *)font;
/** 粗体字符串 */
+ (NSMutableAttributedString *)boldString:(NSString *)text font:(UIFont *)font lineSpacing:(CGFloat)spacing alignment:(NSTextAlignment)alignment;
/** 文本显示的行数 */
+ (NSUInteger)rowNumForText:(NSString *)text font:(UIFont *)font containerWidth:(CGFloat)width;


#pragma mark - 颜色
/**
 *  根据16进制字符串返回颜色
 *  @param hexString 16进制字符串(长度必须为6)
 */
+ (UIColor *)colorFromHex:(NSString *)hexString;
UIColor *ColorFromHex(NSString *hexString);


#pragma mark - 图片相关

/**
 * 截屏
 * @param size 截图后的图片尺寸大小
 * @param viewArray  需要截图的视图数组
 * @param isBlurry  YES时，图片会做模糊处理
 */
+ (UIImage *)getScreenShotImageWithSize:(CGSize)size views:(NSArray *)viewArray isBlurry:(BOOL)isBlurry;



#pragma mark - 其它

/**
 获取网页中的正文文本
 
 @param webView 加载完成后的网页视图
 */
+ (NSString *)getHTMLContentFromWebView:(UIWebView *)webView;

/** 拨打电话 */
+ (void)callPhone:(NSString *)phoneNum sourceVC:(UIViewController *)vc;

/** 获取视图所在的视图控制器 */
+ (UIViewController *)getViewControllerFromView:(UIView *)view;

+ (UIWindow *)getKeyWindow;

/** 获取屏幕的方向 */
+ (UIInterfaceOrientation)getInterfaceOrientation;

/** 视图转换为图片 */
+ (UIImage *)convertImgFromView:(UIView *)view;

/** App启动页图片的路径 */
+ (NSString *)appLaunchImagePath;


#pragma mark - C Style Function

UIColor *RandomColor(); // 随机颜色



@end
