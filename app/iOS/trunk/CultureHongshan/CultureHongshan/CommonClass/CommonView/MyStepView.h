//
//  MyStepView.h
//  ThousandStone
//
//  Created by 李 兴 on 14-12-24.
//  Copyright (c) 2014年 李 兴. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyStepView;

@protocol MyStepViewDelegate <NSObject>

@optional
-(void)MyStepView:(MyStepView *)stepView  value:(NSInteger) value;

@end

@interface MyStepView : UIView
{
    UIButton * _addButton;
    UIButton * _subButton;
    UITextField * _valueField;
}
@property(nonatomic)NSInteger maxValue;
@property(nonatomic)NSInteger minValue;
@property(nonatomic)NSInteger value;
@property(nonatomic,weak)id<MyStepViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame;
-(id)initWithFrame:(CGRect)frame value:(int)value;
@end
