//
//  CustomSegmentView.m
//  CultureHongshan
//
//  Created by ct on 16/4/12.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "CustomSegmentView.h"

@interface CustomSegmentView ()
{
    BOOL _isSameIndex;
    MYMaskView *_indicatorView;//水平指示条
    UIButton *_lastSelectedButton;
}

@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, copy) IndexBlock block;


@end



@implementation CustomSegmentView


+ (instancetype)segmentViewWithFrame:(CGRect)frame
                         normalColor:(UIColor *)normalColor
                       selectedColor:(UIColor *)selectedColor
                            lineColor:(UIColor *)lineColor
                         titleArrray:(NSArray *)titleArray
                       callBackBlock:(IndexBlock)block
{
    if (titleArray.count == 0 || titleArray == nil) {
        return nil;
    }
    
    CustomSegmentView *segmentView = [[CustomSegmentView alloc] initWithFrame:frame];
    segmentView.backgroundColor = [UIColor whiteColor];
    segmentView.normalColor = normalColor;
    segmentView.selectedColor = selectedColor;
    segmentView.lineColor = lineColor;
    segmentView.block = block;
    segmentView.titleArray = titleArray;
    
    [segmentView initSubviews];
    
    return segmentView;
}




- (void)initSubviews
{
    CGFloat offsetX = 0;
    CGFloat btnWidth = self.width / _titleArray.count;
    CGFloat btnHeight = self.height;
    
    for (int i = 0; i < _titleArray.count; i++)
    {
        //按钮
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(offsetX, 0, btnWidth, btnHeight)];
        button.tag = i + 1;
        button.titleLabel.font = (i==1) ? FONT(17) : FONTBOLD(17);
        [button setTitle:_titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:_normalColor forState:UIControlStateNormal];
        [button setTitleColor:_selectedColor forState:UIControlStateSelected];
        button.selected = (i < 1) ? YES : NO;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        //按钮之间的分割线
        if (_titleArray.count > 1 && i < _titleArray.count-1)
        {
            MYMaskView *lineView = [MYMaskView maskViewWithBgColor:RGB(228, 228, 228) frame:CGRectMake(btnWidth-1, 2, 1, btnHeight-5) radius:0];
            [button addSubview:lineView];
        }
        
        offsetX += btnWidth;
    }
    
    MYMaskView *lineView = [MYMaskView maskViewWithBgColor:RGB(240, 240, 240) frame:CGRectMake(0, self.height-2, self.width, 2) radius:0];
    [self addSubview:lineView];
    
    //水平指示条
    _indicatorView = [MYMaskView maskViewWithBgColor:ColorFromHex(@"5e6d98") frame:CGRectMake(0, self.height-2, btnWidth, 2) radius:0];
    [self addSubview:_indicatorView];
}




- (void)buttonClick:(UIButton *)sender
{
    _isSameIndex = (_lastSelectedButton == sender);
    
    _lastSelectedButton.selected = NO;
    _lastSelectedButton.titleLabel.font = FONT(17);
    
    sender.selected = YES;
    sender.titleLabel.font = FONTBOLD(17);
    
    if (_isSameIndex == NO)
    {
        //改变指示条的位置
        _indicatorView.centerX = sender.centerX;
        _indicatorView.width = sender.width;
    }
    
    //回调Block
    if (_block) {
        _block(sender, sender.tag - 1, _isSameIndex);
    }

    _lastSelectedButton = sender;
}




// Getting Methods

- (BOOL)isSameIndex
{
    return _isSameIndex;
}



@end
