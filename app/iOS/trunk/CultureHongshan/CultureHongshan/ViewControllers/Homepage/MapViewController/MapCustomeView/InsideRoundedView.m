//
//  InsideRoundedView.m
//  ToolProject
//
//  Created by ct on 16/1/7.
//  Copyright © 2016年 ct. All rights reserved.
//

#import "InsideRoundedView.h"

@implementation InsideRoundedView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        self.userInteractionEnabled = YES;
        
        self.arrowPosition = frame.size.width/2.0;
        self.isArrow = NO;
        self.arrowHeight = 12;
        self.radius = 8;
        self.fillColor = [UIColor whiteColor];
    }
    return self;
}



- (void)drawRect:(CGRect)rect
{
//    return;
    [self drawInContext:UIGraphicsGetCurrentContext()];
}

- (void)setupShadow
{
    self.layer.shadowColor = [UIColor grayColor].CGColor;//shadowColor阴影颜色
    self.layer.shadowOffset = CGSizeMake(1,1);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    self.layer.shadowOpacity = 0.8;//阴影透明度，默认0
    self.layer.shadowRadius = 0.5;//阴影半径，默认3
}


- (void)drawInContext:(CGContextRef)context
{
    CGContextClip(context);
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, _fillColor.CGColor);
    
    [self getDrawPath:context];
    
    CGContextFillPath(context);
}

- (void)getDrawPath:(CGContextRef)context
{
    CGRect rect = self.bounds;

    CGFloat minX = CGRectGetMinY(rect),
    maxX = CGRectGetMaxX(rect);
    CGFloat minY = CGRectGetMinY(rect),
    maxY = CGRectGetMaxY(rect);
    
    if (_arrowPosition == 0)
    {
        _arrowPosition = self.frame.size.width/2.0;
    }
    if (_isArrow)//带箭头
    {
        maxY -= _arrowHeight;
        CGContextMoveToPoint(context, _arrowPosition+_arrowHeight*0.7, maxY);
        CGContextAddLineToPoint(context,_arrowPosition, maxY+_arrowHeight);
        CGContextAddLineToPoint(context,_arrowPosition-_arrowHeight*0.7, maxY);
    }
    else
    {
        CGContextMoveToPoint(context, _arrowPosition, maxY);
    }
    
    //左下角
    CGContextAddLineToPoint(context,minX+_radius, maxY);
    CGContextAddArcToPoint(context, minX+_radius, maxY-_radius, minX, maxY-_radius, _radius);
    //左上角
    CGContextAddLineToPoint(context,minX, minY+_radius);
    CGContextAddArcToPoint(context, minX+_radius, minY+_radius, minX+_radius, minY, _radius);
    //右上角
    CGContextAddLineToPoint(context,maxX-_radius, minY);
    CGContextAddArcToPoint(context, maxX-_radius, minY+_radius, maxX, minY+_radius, _radius);
    //右下角
    CGContextAddLineToPoint(context,maxX, maxY-_radius);
    CGContextAddArcToPoint(context, maxX-_radius, maxY-_radius, maxX-_radius, maxY, _radius);
    
    CGContextClosePath(context);
}


@end
