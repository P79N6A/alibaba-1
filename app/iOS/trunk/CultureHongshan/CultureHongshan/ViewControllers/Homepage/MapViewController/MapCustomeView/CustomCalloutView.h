//
//  CustomCalloutView.h
//  CultureHongshan
//
//  Created by ct on 15/11/17.
//  Copyright © 2015年 CT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomPointAnnotation;
@class InsideRoundedView;

@protocol CustomCalloutViewDelegate;


@interface CustomCalloutView : UIView

@property (nonatomic,strong) CustomPointAnnotation *annotation;//标注

//活动
@property (nonatomic,strong) UIImageView *picView;//图片
@property (nonatomic,strong) UILabel *titleLabel;//标题
@property (nonatomic,strong) UIButton *titleButton;//标题按钮

@property (nonatomic,strong) UIImageView *addressView;//地点图标
@property (nonatomic,strong) UILabel *addressLabel;//地点
@property (nonatomic,strong) UILabel *addressContext;//具体的地点
@property (nonatomic,strong) UIImageView *timeView;//时间图标
@property (nonatomic,strong) UILabel *timeLabel;//时间
@property (nonatomic,strong) UILabel *timeContext;//具体的时间
@property (nonatomic,strong) UIImageView *ticketView;//余票图标
@property (nonatomic,strong) UILabel *ticketLabel;//余票

@property (nonatomic,strong) UIButton *lookupButton;//查看按钮
@property (nonatomic,strong) UIView *colorView;//分割线

@property (nonatomic,strong) InsideRoundedView *upRoundedView;
@property (nonatomic,strong) InsideRoundedView *downRoundedView;

//场馆
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   NSString *subtitle;
@property (nonatomic, strong) UIButton *calloutButton;


@property (nonatomic, assign) id<CustomCalloutViewDelegate> delegate;


- (id)initWithFrame:(CGRect)frame type:(NSString *)type;//Activity  Venue


@end




#pragma mark - CustomCalloutViewDelegate

@protocol CustomCalloutViewDelegate <NSObject>

@optional

- (void)calloutView:(CustomCalloutView *)calloutView didSelectedButton:(UIButton *)button;


@end
