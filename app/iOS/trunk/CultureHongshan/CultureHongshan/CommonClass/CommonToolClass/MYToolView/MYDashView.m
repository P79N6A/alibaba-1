//
//  MYDashView.m
//  CheckTicketSystem
//
//  Created by JackAndney on 2017/11/9.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import "MYDashView.h"

@interface MYDashView ()
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGFloat spacing;
@property (nonatomic, assign) CGFloat length;
@end

@implementation MYDashView

+ (instancetype)dashViewWithColor:(UIColor *)color spacing:(CGFloat)spacing length:(CGFloat)length {
    MYDashView *dashView = [MYDashView new];
    dashView.backgroundColor = [UIColor clearColor];
    dashView.color = color;
    dashView.spacing = MAX(3, spacing);
    dashView.length = MAX(5, length);
    return dashView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
        [super drawRect:rect];
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetLineWidth(context, MIN(rect.size.height, rect.size.width));
    // 设置颜色
    CGContextSetStrokeColorWithColor(context, self.color.CGColor);
    CGContextBeginPath(context);
    
    CGFloat offsetX = 0;
    CGFloat offsetY = 0;
    
    if (rect.size.width > rect.size.height) {
        // 横向
        offsetY = rect.size.height/2.0f;
    }else {
        // 竖向
        offsetX = rect.size.width/2.0f;
    }

    while (offsetX < rect.size.width && offsetY < rect.size.height) {
        CGContextMoveToPoint(context, offsetX, offsetY);
        
        if (rect.size.width > rect.size.height) {
            // 横向
            CGContextAddLineToPoint(context, offsetX + self.length, offsetY);
            offsetX += self.spacing*1.3+ self.length;
        }else {
            CGContextAddLineToPoint(context, offsetX, offsetY + self.length);
            offsetY += self.spacing + self.length;
        }
    }
    CGContextStrokePath(context);
}

@end
