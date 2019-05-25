//
//  MYTextInputView.m
//  CommonTestProject
//
//  Created by ct on 16/12/22.
//  Copyright © 2016年 Andney. All rights reserved.
//

#import "MYTextInputView.h"
#import "IQKeyboardManager.h"

@implementation MYTextField

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configure];
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configure];
    }
    return self;
}

- (void)configure {
    [self configureLeftPlaceholderView];
    self.delegate = [IQKeyboardManager sharedManager];
    self.hideKeyboardWhenTapReturnkey = YES;
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.placeholderColor = kPlaceholderColor;
    self.keyboardType = UIKeyboardTypeDefault;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.customLeftView == NO && self.leftView) {
        self.leftView.frame = CGRectMake(0, 0, [self getLeftPlaceholderViewWidth], self.bounds.size.height);
    }
}

- (void)configureLeftPlaceholderView {
    
    UIView *placeView = [[UIView alloc] init];
//    placeView.backgroundColor = [UIColor blueColor];
    placeView.userInteractionEnabled = NO;
    
    BOOL isCustom = self.customLeftView; // 保存该变量的状态
    self.customLeftView = YES; // 设置为YES，只是为了可以设置self.leftView
    self.leftView = placeView;
    self.customLeftView = isCustom;
}

- (CGFloat)getLeftPlaceholderViewWidth {
    
    switch (self.borderStyle) {
        case UITextBorderStyleNone: {
            self.leftViewMode = UITextFieldViewModeAlways;
            return 6.8f;
        }
            break;
        case UITextBorderStyleLine: {
            self.leftViewMode = UITextFieldViewModeAlways;
            return 5.0f;
        }
            break;
        case UITextBorderStyleBezel: { return 0.0f; }
            break;
        case UITextBorderStyleRoundedRect: { return 0.0f; }
            break;
            
        default:
            break;
    }
    self.leftViewMode = UITextFieldViewModeAlways;
    return 6.8f;
}

- (void)setIsPhoneInput:(BOOL)isPhoneInput {
    _isPhoneInput = isPhoneInput;
    if (isPhoneInput) {
        self.keyboardType = UIKeyboardTypeNumberPad;
        _maxLength = 20;
        _isLongNumberInput = NO;
        
        if (self.text.length) {
            self.text = MYPhoneNumberInputHandle(self.text);
        }
    }
}

- (void)setIsLongNumberInput:(BOOL)isLongNumberInput {
    _isLongNumberInput = isLongNumberInput;
    if (isLongNumberInput) {
        self.keyboardType = UIKeyboardTypeNumberPad;
        _isPhoneInput = NO;
        
        if (self.text.length) {
            self.text = MYLongNumberInputHandle(self.text, self.maxLength);
        }
    }
}

- (void)setLeftView:(UIView *)leftView {
    if (self.customLeftView == YES) {
        [super setLeftView:leftView];
    }
}


- (void)setBorderStyle:(UITextBorderStyle)borderStyle {
    [super setBorderStyle:borderStyle];
    
    if (self.borderStyle == UITextBorderStyleRoundedRect || self.borderStyle == UITextBorderStyleBezel) {
        self.leftViewMode = UITextFieldViewModeNever;
    }else {
        self.leftViewMode = UITextFieldViewModeAlways;
    }
}

- (void)setText:(NSString *)text {
    if (self.isFirstResponder) {
        super.text = text;
    }else {
        if ([text isKindOfClass:[NSString class]]) {
            if (self.isPhoneInput) {
                super.text = MYPhoneNumberInputHandle(text);
            }else if (self.isLongNumberInput) {
                super.text = MYLongNumberInputHandle(text, self.maxLength);
            }else {
                super.text = text;
            }
        }else {
            super.text = @"";
        }
    }
}

- (void)setMaxLength:(int)maxLength {
    
    if (self.isPhoneInput) {
        _maxLength = 20;
    }else {
        _maxLength = maxLength;
    }
    
    if (self.isLongNumberInput && maxLength > 0 && self.text.length) {
        self.text = MYLongNumberInputHandle(self.text, maxLength);
    }
}
- (NSString *)text {
    if (self.isPhoneInput || self.isLongNumberInput) {
        return [super.text stringByReplacingOccurrencesOfString:@"\\D" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, super.text.length)];
    }else {
        return super.text;
    }
}

- (void)setPlaceholder:(NSString *)placeholder {
    [super setPlaceholder:placeholder];
    if (self.placeholderColor && placeholder.length) {
        [self setPlaceholder:placeholder andColor:self.placeholderColor];
    }
}

- (void)setPlaceholder:(NSString *)placeholder andColor:(UIColor *)color {
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName : self.font ? self.font : [UIFont systemFontOfSize:16],
                                 NSForegroundColorAttributeName : color ? color : [UIColor lightGrayColor]
                                 };
    NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder.length ? placeholder : @"" attributes:attributes];
    self.attributedPlaceholder = attributedPlaceholder;
}


@end


#pragma mark - ——————————————

@interface MYTextView ()
@property (nonatomic, strong) UILabel *placeholderLabel;
@end

@implementation MYTextView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configure];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configure];
    }
    return self;
}

- (void)configure {
    self.textContainerInset = UIEdgeInsetsMake(15, 7, 15, 7);
    self.placeholderColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    _placeholderLabel.hidden = self.text.length > 0;
    
    self.delegate = [IQKeyboardManager sharedManager];
    self.hideKeyboardWhenTapReturnkey = YES;
    self.keyboardType = UIKeyboardTypeDefault;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGPoint point = CGPointMake(self.textContainerInset.left+5.5, self.textContainerInset.top);
    
    self.placeholderLabel.frame = CGRectMake(point.x, point.y, self.bounds.size.width-2*point.x, 0);
    [self.placeholderLabel sizeToFit];
}


- (void)setFont:(UIFont *)font {
    [super setFont:font];
    self.placeholderLabel.font = font;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setText:(NSString *)text {
    if (self.isFirstResponder) {
        super.text = text;
    }else {
        if ([text isKindOfClass:[NSString class]]) {
            super.text = text;
        }else {
            super.text = @"";
        }
    }
    self.placeholderHidden = self.text.length > 0;
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    self.placeholderHidden = attributedText.length > 0;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = [placeholder copy];
    self.placeholderLabel.text = placeholder;
    [self.placeholderLabel sizeToFit];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = placeholderColor;
}

- (void)setPlaceholder:(NSString *)placeholder andColor:(UIColor *)color {
    self.placeholderColor = color;
    self.placeholder = placeholder;
}

- (void)setPlaceholderHidden:(BOOL)placeholderHidden {
    _placeholderHidden = placeholderHidden;
    self.placeholderLabel.hidden = placeholderHidden;
}

- (UILabel *)placeholderLabel {
    
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.numberOfLines = 0;
        _placeholderLabel.textColor = self.placeholderColor;
        [self addSubview:_placeholderLabel];
    }
    return _placeholderLabel;
}

@end



#pragma mark - ——————————————— Extension Methods ———————————————


// 手机号输入时文本的处理
NSString *MYPhoneNumberInputHandle(NSString *text) {
    
    if ([text isKindOfClass:[NSString class]]) {
        // 删除所有的非数字字符
        text = [text stringByReplacingOccurrencesOfString:@"[\\D]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, text.length)];
        if (text.length > 11) {
            text = [text substringToIndex:11];
        }
        
        /*
         1. xxx xxxx xxxx
         ^(\\d{3})(\\d{4})(\\d{0,4})$
         
         2. xxx xxxx
         ^(\\d{3})(\\d{0,3})$
         */
        if (text.length < 7) {
            text = [text stringByReplacingOccurrencesOfString:@"^(\\d{3})(\\d{0,3})$" withString:[NSString stringWithFormat:@"%@ %@", @"$1", @"$2"] options:NSRegularExpressionSearch range:NSMakeRange(0, text.length)];
        }else {
            text = [text stringByReplacingOccurrencesOfString:@"^(\\d{3})(\\d{4})(\\d{0,4})$" withString:[NSString stringWithFormat:@"%@ %@ %@", @"$1", @"$2", @"$3"] options:NSRegularExpressionSearch range:NSMakeRange(0, text.length)];
        }
        return text;
    }
    return @"";
}

// 长的数字文本输入时的处理
NSString *MYLongNumberInputHandle(NSString *text, int maxLength) {
    
    if ([text isKindOfClass:[NSString class]]) {
        // 删除所有的非数字字符
        text = [text stringByReplacingOccurrencesOfString:@"[\\D]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, text.length)];
        if (maxLength > 0 && text.length > maxLength) {
            text = [text substringToIndex:maxLength];
        }
        
        NSMutableString *targetString = [[NSMutableString alloc] initWithString:text];
        for (NSUInteger i = text.length/4; i > 0; i--) {
            if (i*4 >= text.length) {
                continue;
            }
            [targetString insertString:@" " atIndex:i*4];
        }
        return targetString;
    }
    return @"";
}

// 手机号中间部分**处理
NSString *MYPhoneNumberSecureShowHandle(NSString *text) {
    
    if ([text isKindOfClass:[NSString class]] && text.length) {
        text = [text stringByReplacingOccurrencesOfString:@"[\\D]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, text.length)];
        if (text.length > 11) {
            text = [text substringToIndex:11];
        }
        
        if (text.length == 11) {
            text = [text stringByReplacingOccurrencesOfString:@"^(\\d{3})\\d{6}(\\d{2})$" withString:[NSString stringWithFormat:@"%@******%@",@"$1", @"$2"] options:NSRegularExpressionSearch range:NSMakeRange(0, text.length)];
        }else {
            text = [text stringByReplacingOccurrencesOfString:@"^(\\d{3})(\\d{1,})$" withString:[NSString stringWithFormat:@"%@%@",@"$1", @"****"] options:NSRegularExpressionSearch range:NSMakeRange(0, text.length)];
        }
        return text;
    }
    return @"";
}
