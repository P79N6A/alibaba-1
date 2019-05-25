//
//  MYLabel.m
//  WHYUIToolKit
//
//  Created by JackAndney on 2017/10/19.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import "MYLabel.h"

@interface MYLabel ()
{
    UILabel *_dotView;
}
@end



@implementation MYLabel

/**
 *  初始化Label
 *
 *  @param frame  视图的Frame
 *  @param text   显示文本
 *  @param font   字体
 *  @param tColor 文本颜色
 *  @param lines  行数
 *  @param align  文本水平对齐方式
 *
 */
- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font tColor:(UIColor *)tColor lines:(NSUInteger)lines align:(NSTextAlignment)align {
    self = [super initWithFrame:frame];
    if (self) {
        self.text = text;
        if (font) self.font = font;
        if (tColor) self.textColor = tColor;
        self.textAlignment = align;
        
        if (font) self.font = font;
        
        if (lines > 0) {
            self.numberOfLines = lines;
        }else {
            self.numberOfLines = 0;
        }
    }
    return self;
}

#pragma mark - Override Methods

- (void)setShowRedDot:(BOOL)showRedDot {
    _showRedDot = showRedDot;
    
    if (_showRedDot) {
        if (_dotView == nil) {
            _dotView = [[UILabel alloc] init];
            _dotView.font = [UIFont systemFontOfSize:14];
            _dotView.text = @"*";
            _dotView.textColor = [UIColor redColor];
            [self addSubview:_dotView];
            
            CGFloat differenceY = _dotView.font.lineHeight/2+2;
            
            [NSLayoutConstraint constraintWithItem:_dotView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:5].active = YES;
            [NSLayoutConstraint constraintWithItem:_dotView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:-differenceY].active = YES;
        }
        _dotView.hidden = NO;
    }else {
        if (_dotView) {
            [_dotView removeFromSuperview];
            _dotView = nil;
        }
    }
}

- (void)setDigitalColor:(UIColor *)digitalColor {
    if (digitalColor == nil) return;
    
    _digitalColor = [digitalColor copy];
    
    NSArray *rangeArray = nil;
    if (self.attributedText.length > 0) {
        rangeArray = [self.class getDigitalNumberRanges:self.attributedText.string];
        
        NSMutableAttributedString *attributedString = [self.attributedText mutableCopy];
        [self.class addAttributesOnString:attributedString attributes:@{NSForegroundColorAttributeName : digitalColor} rangeArray:rangeArray];
    }else {
        if (self.text.length > 0) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
            if (self.font) {
                [dict setValue:self.font forKey:NSFontAttributeName];
            }
            if (self.textColor) {
                [dict setValue:self.textColor forKey:NSForegroundColorAttributeName];
            }
            
            NSMutableParagraphStyle *paraStyle = [NSMutableParagraphStyle new];
            paraStyle.alignment = self.textAlignment;
            paraStyle.lineSpacing = self.line_spacing;
            if (self.textAlignment == NSTextAlignmentJustified) {
                paraStyle.firstLineHeadIndent = 0.2f;
            }
            [dict setValue:paraStyle forKey:NSParagraphStyleAttributeName];
            if (self.isBoldText) {
                [dict setValue:[NSNumber numberWithFloat:-1.5] forKey:NSStrokeWidthAttributeName];
            }
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text attributes:dict];
            self.attributedText = attributedString;
        }
    }
}

// 更新带有行间距的普通文本
- (void)updateText:(NSString *)text {
    if (text.length == 0) {
        self.attributedText = nil;
        self.text = @"";
        return;
    }
    
    if (self.line_spacing > 0 || self.isBoldText) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
        if (self.font) {
            [dict setValue:self.font forKey:NSFontAttributeName];
        }
        if (self.textColor) {
            [dict setValue:self.textColor forKey:NSForegroundColorAttributeName];
        }
        
        NSMutableParagraphStyle *paraStyle = [NSMutableParagraphStyle new];
        paraStyle.alignment = self.textAlignment;
        paraStyle.lineSpacing = MAX(self.line_spacing, 0);
        if (self.textAlignment == NSTextAlignmentJustified) {
            paraStyle.firstLineHeadIndent = 0.2f;
        }
        [dict setValue:paraStyle forKey:NSParagraphStyleAttributeName];
        if (self.isBoldText) {
            [dict setValue:[NSNumber numberWithFloat:-1.5] forKey:NSStrokeWidthAttributeName];
        }
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:dict];
        self.attributedText = attributedString;
    }else {
        self.attributedText = nil;
        self.text = text;
    }
}

#pragma mark -



/**
 *  生成属性字符串
 *
 *  @param text      原文本
 *  @param baseColor 文本默认颜色
 *  @param font      字体
 *  @param spacing   行间距
 *  @param alignment 水平对齐方式
 *
 *  @return 可变属性字符串
 */
+ (NSMutableAttributedString *)getAttributedString:(NSString *)text baseColor:(UIColor *)baseColor font:(UIFont *)font lineSpacing:(CGFloat)spacing alignment:(NSTextAlignment)alignment {
    
    if (spacing < 0 || font == nil || text == nil) {
        return nil;
    }
    
    if (baseColor == nil || ![baseColor isKindOfClass:[UIColor class]]) {
        baseColor = [UIColor clearColor];
    }
    
    
    NSMutableAttributedString *attributedStr = nil;

    if ([text isKindOfClass:[NSString class]]) {
        
        attributedStr = [[NSMutableAttributedString alloc] initWithString:text];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = spacing;
        paragraphStyle.alignment = alignment;
        if (alignment == NSTextAlignmentJustified) {
            // 两端对齐时，需要加上这一句
            paragraphStyle.firstLineHeadIndent = 0.5;
        }
        
        NSDictionary *attributes = @{
                                     NSParagraphStyleAttributeName : paragraphStyle,
                                     NSFontAttributeName : font,
                                     NSForegroundColorAttributeName : baseColor,
                                     };
        
        [attributedStr addAttributes:attributes range:NSMakeRange(0, text.length)];
    }
    return attributedStr;
}


/**
 *  给属性字符串添加新的属性
 *
 *  @param attributedString 可变属性字符串
 *  @param attrs            要添加的属性
 *  @param range            需要添加新属性的字符串范围
 */
+ (void)addAttributesOnString:(NSMutableAttributedString *)attributedString attributes:(NSDictionary<NSString *, id> *)attrs ranges:(NSString *)range, ... {
    // 取出所有的参数
    NSMutableArray *argsArray = [[NSMutableArray alloc] initWithCapacity:2];
    NSString * arg;
    va_list argList;
    
    if (range != nil) {
        [argsArray addObject:range];
        
        va_start(argList,range);
        
        while ((arg = va_arg(argList, NSString *))) {
            if ([arg isKindOfClass:[NSString class]]) {
                [argsArray addObject:arg];
            }
        }
        va_end(argList);
    }
    
    return [self addAttributesOnString:attributedString attributes:attrs rangeArray:argsArray];
}

/**
 *  给属性字符串添加新的属性
 *
 *  @param attributedString 可变属性字符串
 *  @param attrs            要添加的属性
 *  @param ranges           需要添加新属性的字符串范围数组（NSString * 或 NSValue *）
 */
+ (void)addAttributesOnString:(NSMutableAttributedString *)attributedString attributes:(NSDictionary<NSString *, id> *)attrs rangeArray:(NSArray<NSString *> *)ranges {
    
    for (NSString *rangeString in ranges) {
        if ([rangeString isKindOfClass:[NSString class]] && rangeString.length > 2) {
            NSRange range = NSRangeFromString(rangeString);
            [attributedString addAttributes:attrs range:range];
        }else if ([rangeString isKindOfClass:[NSValue class]]) {
            NSRange range = [(NSValue *)rangeString rangeValue];
            [attributedString addAttributes:attrs range:range];
        }
    }
}


/**
 *  获取字符串中数字的范围
 *
 *  @param string 原字符串
 *
 */
+ (NSArray<NSValue *> *)getDigitalNumberRanges:(NSString *)string {
    if (string.length > 0) {
        NSString *regexString = @"[-+]?\\d+\\.?\\d*";
        NSRegularExpression *regularExpression = [[NSRegularExpression alloc] initWithPattern:regexString options:NSRegularExpressionCaseInsensitive error:nil];
        NSArray *array = [regularExpression matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length)];
        
        NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithCapacity:array.count];
        
        for (NSTextCheckingResult *result in array) {
            [tmpArray addObject:[NSValue valueWithRange:result.range]];
        }
        return tmpArray;
    }else{
        return @[];
    }
}



#pragma mark - 





@end
