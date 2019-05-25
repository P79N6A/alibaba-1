//
//  FBButton.m
//  ParkTour
//
//  Created by 李 兴 on 15-4-16.
//  Copyright (c) 2015年 李 兴. All rights reserved.
//

#import "FBButton.h"

@implementation FBButton

-(id)initWithText:(CGRect)frame font:(UIFont *)font fcolor:(UIColor *)fcolor bgcolor:(UIColor *)bgcolor  text:(NSString *)text
{
    if (self = [super init])
    {
        self.frame = frame;
        [self setTitleColor:fcolor forState:UIControlStateNormal];
        [self setBackgroundColor:bgcolor];
        self.titleLabel.font = font;
        [self setTitle:text forState:UIControlStateNormal];
        _animation = YES;
        
    }
    return self;
}




-(id)initWithImage:(CGRect)frame  bgcolor:(UIColor *)bgcolor  img:(UIImage *)img
{
    if (self = [super init])
    {
        self.frame = frame;
        [self setBackgroundColor:bgcolor];
        [self setImage:img forState:UIControlStateNormal];
         _animation = YES;

    }
    return self;
}

-(id)initWithText:(CGRect)frame font:(UIFont *)font fcolor:(UIColor *)fcolor bgcolor:(UIColor *)bgcolor  text:(NSString *)text clickEvent:(ClickEvent )block
{
    if (self = [self initWithText:frame font:font fcolor:fcolor bgcolor:bgcolor text:text])
    {
        [self addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        _block = block;

    }
    return self;
}

-(id)initWithImage:(CGRect)frame  bgcolor:(UIColor *)bgcolor  img:(UIImage *)img clickEvent:(ClickEvent )block
{
    if (self = [self initWithImage:frame bgcolor:bgcolor img:img])
    {
        [self addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        _block = block;

    }
    return self;
}


- (void)setTitle:(NSString *)title image:(UIImage *)image forState:(UIControlState)state isHorizontal:(BOOL)horizontal
{
    [self setTitle:title forState:state];
    [self setImage:image forState:state];
    
    if (title.length && image) {
        if (horizontal) {
            CGFloat textWidth = [UIToolClass textWidth:title font:self.titleLabel.font];
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -image.size.width-2, 0, image.size.width+2);
            self.imageEdgeInsets = UIEdgeInsetsMake(0, textWidth+2, 0, -textWidth-2);
        }else{
            CGFloat textHeight = [UIToolClass fontHeight:self.titleLabel.font];
            CGFloat textWidth = [UIToolClass textWidth:title font:self.titleLabel.font];
            
            self.titleEdgeInsets = UIEdgeInsetsMake(0.5*image.size.height, -0.5*image.size.width, -0.5*image.size.height, 0.5*image.size.width);
            self.imageEdgeInsets = UIEdgeInsetsMake(-0.5*textHeight, 0.5*textWidth, 0.5*textHeight, -0.5*textWidth);
        }
    }else {
        self.titleEdgeInsets = UIEdgeInsetsZero;
        self.imageEdgeInsets = UIEdgeInsetsZero;
    }
}




-(void)click
{
    NSArray * scale = [AnimationTool animationValues:@2 toValue:@1 usingSpringWithDamping:5 initialSpringVelocity:30 duration:.5];
    if (scale != nil  &&  _animation)
    {
        CAKeyframeAnimation * keya = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        keya.duration = 1.f;
        NSMutableArray * muarray = [[NSMutableArray alloc] initWithCapacity:scale.count];
        for (int i=0; i<scale.count; i++)
        {
            float s = [scale[i] floatValue];
            //NSValue * value =  [NSValue valueWithCGAffineTransform:CGAffineTransformMakeScale(s, s)];
            NSValue * value =  [NSValue valueWithCATransform3D:CATransform3DMakeScale(s, s, s)];
            [muarray addObject:value];
        }
        keya.values = muarray;
        [self.layer addAnimation:keya forKey:nil];
    }
   
    
    _block(self);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
