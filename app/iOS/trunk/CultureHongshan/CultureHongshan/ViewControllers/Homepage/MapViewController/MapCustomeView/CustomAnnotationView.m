//
//  CustomAnnotationView.m
//  CustomAnnotationDemo
//
//  Created by songjian on 13-3-11.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "CustomAnnotationView.h"
#import "CustomCalloutView.h"
#import "CustomPointAnnotation.h"


@interface CustomAnnotationView ()<CustomCalloutViewDelegate>

@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation CustomAnnotationView


- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self)
    {
        CGFloat width = ConvertSize(60);
        CGFloat height = ConvertSize(60)*4.0/3;
        
        self.bounds = CGRectMake(0.f, 0.f, width, height);
        
        self.portraitImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.portraitImageView];
    }
    
    return self;
}



#pragma mark - Handle Action





#pragma mark - Override

- (UIImage *)portrait
{
    return self.portraitImageView.image;
}

- (void)setPortrait:(UIImage *)portrait
{
    self.portraitImageView.image = portrait;
}

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected || [self.reuseIdentifier isEqualToString:@"Destination"] || !self.annotation)
    {
        return;
    }
    
    if (selected)
    {
        
        if ([self.reuseIdentifier isEqualToString:@"ActivityMap"])//活动地图
        {
            if (_delegate && [_delegate respondsToSelector:@selector(annotationViewDidSelect:)]) {
                [_delegate annotationViewDidSelect:self];
            }
        }
        else
        {
            if (self.calloutView == nil)
            {
                if ([self.reuseIdentifier isEqualToString:@"Activity"])
                {
                    self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-ConvertSize(80), ConvertSize(100)+10) type:@"Activity"];
                }
                else if ([self.reuseIdentifier isEqualToString:@"Venue"])
                {
                    self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-ConvertSize(80), ConvertSize(100)+10) type:@"Venue"];
                }
                else if ([self.reuseIdentifier isEqualToString:@"VenueMap"])//场馆地图里需要显示进入详情的按钮，停车场里则不需要
                {
                    self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-ConvertSize(80), ConvertSize(100)+10) type:@"VenueMap"];
                }
            }
            
            CustomPointAnnotation *annotation = self.annotation;
            
            self.calloutView.annotation = annotation;
            
            self.calloutView.delegate = self;
            
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,-CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
            
            [self addSubview:self.calloutView];
        }
    }
    else
    {
        
        
        if ([self.reuseIdentifier isEqualToString:@"ActivityMap"])//活动地图
        {
            if (_delegate && [_delegate respondsToSelector:@selector(annotationViewDidUnselect:)]) {
                [_delegate annotationViewDidUnselect:self];
            }
        }
        else
        {
            [self.calloutView removeFromSuperview];
        }
    }
    
    [super setSelected:selected animated:animated];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    /* Points that lie outside the receiver’s bounds are never reported as hits,
     even if they actually lie within one of the receiver’s subviews.
     This can occur if the current view’s clipsToBounds property is set to NO and the affected subview extends beyond the view’s bounds.
     */
    if (!inside && self.selected)
    {
        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
    }
    
    return inside;
}


- (void)calloutView:(CustomCalloutView *)calloutView didSelectedButton:(UIButton *)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(annotationView:didSelectedCalloutView:)]) {
        [_delegate annotationView:self didSelectedCalloutView:calloutView];
    }
}

@end
