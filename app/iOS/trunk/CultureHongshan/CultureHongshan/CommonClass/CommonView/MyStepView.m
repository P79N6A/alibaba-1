//
//  MyStepView.m
//  ThousandStone
//
//  Created by 李 兴 on 14-12-24.
//  Copyright (c) 2014年 李 兴. All rights reserved.
//

#import "MyStepView.h"

@implementation MyStepView

-(id)initWithFrame:(CGRect)frame value:(int)value
{
    if (self = [super initWithFrame:frame])
    {
        
        self.userInteractionEnabled = YES;
        _value = value;
        _maxValue = 10;
        _minValue = 0;
        [self loadUI];
    }
    return self;
}



-(id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame value:0];
}


-(void)loadUI
{
    UIColor * grayColor = RGB(0xea, 0xea, 0xea);
    UIColor * boardColor = RGB(0xcc, 0xcc, 0xcc);
    UIColor * fontColor = RGB(0xa1, 0xa1, 0xa1);
    self.radius = 4;
    self.layer.borderWidth = .5f;
    self.layer.borderColor = boardColor.CGColor;
    
    int height = self.frame.size.height;
    int fontWidth  = 0;
    int fieldWidth = self.width / 3;
    
//    //self.backgroundColor = [UIColor blackColor];
//    UILabel * countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, fontWidth, height)];
//    countLabel.text = @"数量:";
//    countLabel.textColor = [UIColor colorWithRed:80/255.0f green:80/255.0f blue:80/255.0f alpha:1];
//    countLabel.textAlignment = NSTextAlignmentRight;
//    countLabel.backgroundColor = [UIColor clearColor];
//    countLabel.font = FontYT(14);
//    [self addSubview:countLabel];
    
   
    //self.backgroundColor = grayColor;
    
    _subButton = [[UIButton alloc] initWithFrame:CGRectMake(fontWidth, 0, fieldWidth, height)];
    [_subButton setBackgroundColor:grayColor];
    [_subButton setTitle:@"－" forState:UIControlStateNormal];
    [_subButton addTarget:self action:@selector(sub) forControlEvents:UIControlEventTouchUpInside];
    [_subButton setTitleColor:fontColor forState:UIControlStateNormal];
    _subButton.titleLabel.font = FONT(15);
    [self addSubview:_subButton];
    
    
    _valueField = [[UITextField alloc] initWithFrame:CGRectMake(fieldWidth, 0, fieldWidth, height)];
    _valueField.userInteractionEnabled = NO;
    _valueField.backgroundColor = RGB(0xf6, 0xf6, 0xf6);
    _valueField.layer.borderWidth = .5f;
    _valueField.font = FONT(15);
    _valueField.layer.borderColor = boardColor.CGColor;
    _valueField.textAlignment = NSTextAlignmentCenter;
    _valueField.textColor = RGB(0x74,0x85,0xb7);
    _valueField.text = StrFromLong(_value);
    
    
    [self addSubview:_valueField];
    
    
    _addButton =  [[UIButton alloc] initWithFrame:CGRectMake(fieldWidth * 2, 0, fieldWidth, height)];
    [_addButton setBackgroundColor:grayColor];
    [_addButton addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    [_addButton setTitle:@"＋" forState:UIControlStateNormal];
    [_addButton setTitleColor:fontColor forState:UIControlStateNormal];
    _addButton.titleLabel.font = FONT(15);
    [self addSubview:_addButton];
    
    
}

-(void)add
{
    _value++;
    if (_value > _maxValue)
    {
        _value = _maxValue;
    }
    [self changeStat];
   
}
-(void)sub
{
    _value--;
    if (_value < _minValue)
    {
        _value = _minValue;
    }
    [self changeStat];
}

-(void)setValue:(NSInteger)value
{
    _value = value;
    _valueField.text = StrFromLong(_value);
}

-(void)changeStat
{
    _valueField.text = StrFromLong(_value);
    if([_delegate respondsToSelector:@selector(MyStepView:value:)])
    {
        [_delegate MyStepView:self value:_value];
    }
}

@end
