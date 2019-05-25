//
//  MYButton.m
//  WHYUIToolKit
//
//  Created by JackAndney on 2017/10/19.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import "MYButton.h"

@interface MYButton ()
{
    MYButtonContentLayout _layout; // 图片和文字的布局方式
}
@end




@implementation MYButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupDefalutData];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title font:(UIFont *)font tColor:(UIColor *)tColor bgColor:(UIColor *)bgColor {
    return [self initWithFrame:frame title:title font:font tColor:tColor bgColor:bgColor actionBlock:nil];
}

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image selectedImage:(UIImage *)selectedImage {
    return [self initWithFrame:frame image:image selectedImage:selectedImage actionBlock:nil];
}


- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title font:(UIFont *)font tColor:(UIColor *)tColor bgColor:(UIColor *)bgColor actionBlock:(void (^)(MYButton *))actionBlock {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDefalutData];
        
        if (title.length > 0)
            [self setTitle:title forState:UIControlStateNormal];
        
        if (font)
            self.titleLabel.font = font;
        
        if (tColor) {
            [self setTitleColor:tColor forState:UIControlStateNormal];
        }
        
        if (bgColor) {
            self.backgroundColor = bgColor;
        }
        
        if (actionBlock)
            self.clickBlock = actionBlock;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image selectedImage:(UIImage *)selectedImage actionBlock:(void (^)(MYButton *))actionBlock {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDefalutData];
        
        if (image)
            [self setImage:image forState:UIControlStateNormal];
        
        if (selectedImage)
            [self setImage:selectedImage forState:UIControlStateSelected];
        
        if (actionBlock)
            self.clickBlock = actionBlock;
    }
    return self;
}

// 图片、文字共存
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image layout:(MYButtonContentLayout)layout actionBlock:(void (^)(MYButton *))actionBlock {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDefalutData];
        _layout = layout;
        
        if (title)
            [self setTitle:title forState:UIControlStateNormal];
        if (image)
            [self setImage:image forState:UIControlStateNormal];
        
        if (actionBlock)
            self.clickBlock = actionBlock;
    }
    return self;
}

#pragma mark -

- (void)setDidSetupEdgeInsets:(BOOL)didSetupEdgeInsets {
    if (didSetupEdgeInsets) {
        // 不可以在外部设置为YES
        return;
    }
    
    _didSetupEdgeInsets = NO;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setClickBlock:(void (^)(MYButton *))clickBlock {
    if (clickBlock == nil) return;
    
    if (_clickBlock)
        _clickBlock = nil;
    
    _clickBlock = [clickBlock copy];
    
    [self removeTarget:self action:@selector(buttonClickAction) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(buttonClickAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonClickAction {
    
    if (self.animatedWhenClick) {
        NSArray * scale = [self.class my_animationValues:@2 toValue:@1 usingSpringWithDamping:5 initialSpringVelocity:30 duration:0.5f];
        if (scale != nil) {
            CAKeyframeAnimation * keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            keyFrameAnimation.duration = 1.f;
            NSMutableArray * muArray = [[NSMutableArray alloc] initWithCapacity:scale.count];
            for (int i = 0; i < scale.count; i++) {
                float s = [scale[i] floatValue];
                NSValue * value =  [NSValue valueWithCATransform3D:CATransform3DMakeScale(s, s, s)];
                [muArray addObject:value];
            }
            keyFrameAnimation.values = muArray;
            [self.layer addAnimation:keyFrameAnimation forKey:nil];
        }
    }
    
    if (self.clickBlock) {
        self.clickBlock(self);
    }
}

#pragma mark -


/**
 设置默认值
 */
- (void)setupDefalutData {
    _layout = MYButtonLayoutNormal;
    self.leftMargin = 0.0f;
    self.rightMargin = 0.0f;
    self.spacing = 5.0f;
    self.animatedWhenClick = NO;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    if (_didSetupEdgeInsets) return;
    if (_layout==MYButtonLayoutNormal || CGRectEqualToRect(self.bounds, CGRectZero) == YES) {
        return;
    }
    // 必须图片和文字同时存在
    if (self.currentTitle.length == 0 || self.imageView.image == nil) {
        return;
    }
    
    // 获取图片和文字的实际显示大小
    CGSize imgSize = self.imageView.image.size;
    CGSize titleSize = CGSizeZero;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        titleSize = self.titleLabel.intrinsicContentSize;
    }else {
        titleSize = self.titleLabel.frame.size;
    }
    
    switch (_layout) {
        case MYButtonLayoutImageLeft: { // 图片在左
            if (self.leftMargin == 0 && self.rightMargin == 0) {
                // 两者居中
                self.imageEdgeInsets = UIEdgeInsetsMake(0, -self.spacing/2.0, 0, self.spacing/2.0);
                self.titleEdgeInsets = UIEdgeInsetsMake(0, self.spacing/2.0, 0, -self.spacing/2.0);
                _didSetupEdgeInsets = YES;
            }else {
                if (self.leftMargin > 0) {
                    // 两者左对齐
                    self.imageView.frame = CGRectMake(self.leftMargin, CGRectGetMidY(self.bounds) - imgSize.height/2.0f, imgSize.width, imgSize.height);
                    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame)+self.spacing, CGRectGetMidY(self.bounds) - titleSize.height/2.0f, titleSize.width, titleSize.height);
                }else {
                    // 两者右对齐
                    self.titleLabel.frame = CGRectMake(CGRectGetWidth(self.bounds)-self.rightMargin-titleSize.width, CGRectGetMidY(self.bounds) - titleSize.height/2.0f, titleSize.width, titleSize.height);
                    self.imageView.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame)-self.spacing-imgSize.width, CGRectGetMidY(self.bounds) - imgSize.height/2.0f, imgSize.width, imgSize.height);
                }
            }
        }
            break;
        case MYButtonLayoutImageRight: { // 图片在右
            if (self.leftMargin == 0 && self.rightMargin == 0) {
                // 两者居中
                self.imageEdgeInsets = UIEdgeInsetsMake(0, titleSize.width+self.spacing/2.0, 0, -titleSize.width-self.spacing/2.0);
                self.titleEdgeInsets = UIEdgeInsetsMake(0, -imgSize.width-self.spacing/2.0, 0, imgSize.width+self.spacing/2.0);
                _didSetupEdgeInsets = YES;
            }else {
                if (self.leftMargin > 0) {
                    // 两者左对齐
                    self.titleLabel.frame = CGRectMake(self.leftMargin, CGRectGetMidY(self.bounds) - titleSize.height/2.0f, titleSize.width, titleSize.height);
                    self.imageView.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+self.spacing, CGRectGetMidY(self.bounds) - imgSize.height/2.0f, imgSize.width, imgSize.height);
                }else {
                    // 两者右对齐
                    self.imageView.frame = CGRectMake(CGRectGetWidth(self.bounds)-self.rightMargin-imgSize.width, CGRectGetMidY(self.bounds) - imgSize.height/2.0f, imgSize.width, imgSize.height);
                    self.titleLabel.frame = CGRectMake(CGRectGetMinX(self.imageView.frame)-self.spacing-titleSize.width, CGRectGetMidY(self.bounds) - titleSize.height/2.0f, titleSize.width, titleSize.height);
                }
            }
        }
            break;
        case MYButtonLayoutImageUp: { // 图片在上
            self.imageEdgeInsets = UIEdgeInsetsMake(-titleSize.height-self.spacing/2.0, 0, 0, -titleSize.width);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -imgSize.width, -imgSize.height-self.spacing/2.0 -self.spacing, 0);
            _didSetupEdgeInsets = YES;
        }
            break;
        case MYButtonLayoutImageDown: { // 图片在下
            self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, -titleSize.height-self.spacing/2.0, -titleSize.width);
            self.titleEdgeInsets = UIEdgeInsetsMake(-imgSize.height-self.spacing/2.0, -imgSize.width, 0, 0);
            _didSetupEdgeInsets = YES;
        }
            break;
        case MYButtonLayoutJustifiedImageLeft: { // 两端对齐，图片居左
            self.imageView.frame = CGRectMake(self.leftMargin, CGRectGetMidY(self.bounds) - imgSize.height/2.0f, imgSize.width, imgSize.height);
            self.titleLabel.frame = CGRectMake(CGRectGetWidth(self.bounds)-self.rightMargin-titleSize.width, CGRectGetMidY(self.bounds) - titleSize.height/2.0f, titleSize.width, titleSize.height);
        }
            break;
        case MYButtonLayoutJustifiedImageRight: { // 两端对齐，图片居右
            self.titleLabel.frame = CGRectMake(self.leftMargin, CGRectGetMidY(self.bounds) - titleSize.height/2.0f, titleSize.width, titleSize.height);
            self.imageView.frame = CGRectMake(CGRectGetWidth(self.bounds)-self.rightMargin-imgSize.width, CGRectGetMidY(self.bounds) - imgSize.height/2.0f, imgSize.width, imgSize.height);
        }
            break;
            
        default:
            break;
    }
}

// 弹簧动画效果的keyFrames
+ (NSMutableArray *)my_animationValues:(NSNumber *)fromValue toValue:(NSNumber *)toValue usingSpringWithDamping:(float)damping initialSpringVelocity:(float)velocity duration:(float)duration {
    
    static NSMutableArray *values = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        NSInteger numOfPoints  = duration * 60;
        values = [NSMutableArray arrayWithCapacity:numOfPoints];
        for (NSInteger i = 0; i < numOfPoints; i++) {
            [values addObject:@(0.0)];
        }
        CGFloat d_value = [toValue floatValue] - [fromValue floatValue];
        
        for (NSInteger point = 0; point < numOfPoints; point++) {
            CGFloat x = (CGFloat)point / (CGFloat)numOfPoints;
            
            CGFloat value = [toValue floatValue] - d_value * (pow(M_E, -damping * x) * cos(velocity * x)); //1 y = 1-e^{-5x} * cos(30x)
            values[point] = @(value);
        }
    });
    return values;
}

@end
