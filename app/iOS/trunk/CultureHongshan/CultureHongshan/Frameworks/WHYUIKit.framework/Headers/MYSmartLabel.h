//
//  MYSmartLabel.h
//  WHYToolSDK
//
//  Created by JackAndney on 2017/5/14.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
  @brief  自动计算Label的高度（或宽度），同时可以限制最大显示行数的Label
  
  @discussion 该Label的高度计算
 */
@interface MYSmartLabel : UILabel


/**
 不定行数的Label
 
 @param frame     Label的frame
 @param text      显示的文本
 @param font      Label的字体
 @param color     文本的颜色
 @param lineSpace 行间距
 
 @return Label
 */
- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font color:(UIColor *)color lineSpace:(CGFloat)lineSpace;

/**
 可以限定最大显示行数的Label

 @param frame     Label的frame
 @param text      显示的文本
 @param font      Label的字体
 @param color     文本的颜色
 @param lineSpace 行间距
 @param maxRow    显示的最大行数

 @return Label
 */
- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font color:(UIColor *)color lineSpace:(CGFloat)lineSpace maxRow:(NSUInteger)maxRow;


/**
 具有最全定制性的Label

 @param frame     Label的frame
 @param text      显示的文本
 @param font      Label的字体
 @param color     文本的颜色
 @param lineSpace 行间距
 @param align     文本的对齐方式
 @param mode      断行的方式
 @param maxRow    显示的最大行数（设置为0时，不限制最大显示行数）

 @return Label
 */
- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font color:(UIColor *)color lineSpace:(CGFloat)lineSpace align:(NSTextAlignment)align breakMode:(NSLineBreakMode)mode maxRow:(NSUInteger)maxRow;



/**
 @brief 文字只显示一行，Label的宽度会自动调整
 
 @discussion 当frame的高度小于字体的高度时，会自动将frame的高度设置为字体的lineHeight

 @param frame    Label的frame
 @param text     显示的文本
 @param font     字体
 @param color    文本的颜色
 @param maxWidth Label的最大宽度：传0时，会将frame.size.width作为maxWidth

 @return Label
 */
- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font color:(UIColor *)color breakMode:(NSLineBreakMode)mode maxWidth:(CGFloat)maxWidth;


/**
 *  给字符串中的数字添加指定的颜色
 */
- (void)addColorForDigitalNum:(UIColor *)color;


#pragma mark -  —————— Autolayout 方法 ——————

/**
 *  最全版的Autolayout创建方法
 *
 *  @param maxRow      最大显示行数
 *  @param text        要显示的文本
 *  @param font        字体
 *  @param color       文本颜色
 *  @param lineSpacing 行间距
 *  @param align       文本对齐方式
 *  @param breakMode   断行方式
 *
 *  @return Label
 */
+ (instancetype)al_labelWithMaxRow:(NSUInteger)maxRow text:(NSString *)text font:(UIFont *)font color:(UIColor *)color lineSpacing:(CGFloat)lineSpacing align:(NSTextAlignment)align breakMode:(NSLineBreakMode)breakMode;

/**
 *  简化版的Autolayout创建方法
 *
 *  @param maxRow      最大显示行数
 *  @param text        要显示的文本
 *  @param font        字体
 *  @param color       文本颜色
 *  @param lineSpacing 行间距
 *
 *  @return Label
 */
+ (instancetype)al_labelWithMaxRow:(NSUInteger)maxRow text:(NSString *)text font:(UIFont *)font color:(UIColor *)color lineSpacing:(CGFloat)lineSpacing;





@end
