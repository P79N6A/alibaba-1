//
//  CustomAnnotationView.h
//  CustomAnnotationDemo
//
//  Created by songjian on 13-3-11.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import <AMapNaviKit/AMapNaviKit.h>
#import "CustomCalloutView.h"

@protocol CustomAnnotationViewDelegate;


@interface CustomAnnotationView : MAAnnotationView

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) UIImage *portrait;

@property (nonatomic, strong) CustomCalloutView *calloutView;

@property (nonatomic,assign ) id <CustomAnnotationViewDelegate> delegate;


@end





#pragma mark - CustomCalloutViewDelegate

@protocol CustomAnnotationViewDelegate <NSObject>

@optional

- (void)annotationView:(CustomAnnotationView *)annotationView didSelectedCalloutView:(CustomCalloutView *)calloutView;


- (void)annotationViewDidSelect:(CustomAnnotationView *)annotationView;//标记被点击时调用
- (void)annotationViewDidUnselect:(CustomAnnotationView *)annotationView;//标记取消点击时调用


@end