//
//  MYLabel.h
//  WHYUIToolKit
//
//  Created by JackAndney on 2017/10/19.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYLabel : UILabel

@property (nonatomic, assign) BOOL showRedDot;
@property (nonatomic, assign, getter=isBoldText) BOOL boldText;
@property (nonatomic, assign) CGFloat line_spacing; // lineSpacing与系统的属性有冲突，会有莫名其妙的问题（文字强制顶部对齐）
@property (nonatomic, copy) UIColor *digitalColor; // 数字文本的颜色，请在设置好文本后再调用该方法

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font tColor:(UIColor *)tColor lines:(NSUInteger)lines align:(NSTextAlignment)align;

- (void)updateText:(NSString *)text; // lineSpacing>0时，通过该方法更新文本

#pragma mark -

+ (NSMutableAttributedString *)getAttributedString:(NSString *)text baseColor:(UIColor *)baseColor font:(UIFont *)font lineSpacing:(CGFloat)spacing alignment:(NSTextAlignment)alignment;
+ (void)addAttributesOnString:(NSMutableAttributedString *)attributedString attributes:(NSDictionary<NSString *, id> *)attrs ranges:(NSString *)range, ... NS_REQUIRES_NIL_TERMINATION;
+ (void)addAttributesOnString:(NSMutableAttributedString *)attributedString attributes:(NSDictionary<NSString *, id> *)attrs rangeArray:(NSArray<NSString *> *)ranges;


+ (NSArray<NSValue *> *)getDigitalNumberRanges:(NSString *)string;


@end
