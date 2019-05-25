//
//  DropDownMenuMultipleButtonsCell.m
//  CultureHongshan
//
//  Created by ct on 16/3/18.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "DropDownMenuMultipleButtonsCell.h"

@implementation DropDownMenuMultipleButtonsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.titleButton = [[ExtendedButton alloc] init];
        _titleButton.tag = 99;
        _titleButton.layer.borderColor = ColorFromHex(@"C8C8C8").CGColor;
        _titleButton.layer.borderWidth = 1;
        _titleButton.radius = 8;
        _titleButton.titleLabel.font = FONT(17);
        [_titleButton setTitleColor:ColorFromHex(@"666666") forState:UIControlStateNormal];
        [self.contentView addSubview:_titleButton];
        
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth-30, 1)];
        _lineView.backgroundColor = ColorFromHex(@"E2E2E2");
        [self.contentView addSubview:_lineView];
    }
    
    return self;
}


- (void)setTitleString:(NSString *)titleString withSection:(NSInteger)section spacing:(CGFloat)spacing
{
    if (!titleString || titleString.length == 0)
    {
        return;
    }
    _titleString = titleString;
    
    
    NSArray *array = [titleString componentsSeparatedByString:@","];
    
    for (ExtendedButton *button in self.contentView.subviews)//移除之前的自定义按钮
    {
        if ([button isKindOfClass:[ExtendedButton class]])
        {
            if (button.index.tag > 99)
            {
                [button removeFromSuperview];
            }
        }
    }
    
    CGFloat btnSpacing = 8;
    CGFloat btnWidth = (kScreenWidth - 2*15 - 3*btnSpacing)*0.25;
    CGFloat btnHeight = 38;
    CGFloat offsetY = _lineView.maxY+spacing;
    
    for (int i = 0; i < array.count; i++)
    {
        ExtendedButton *btn = [[ExtendedButton alloc] initWithFrame:CGRectMake(15+i%4*(btnSpacing+btnWidth), offsetY+i/4*(btnHeight+15), btnWidth, btnHeight)];
        btn.tag = 100+i;//为了方便找到按钮,改变按钮的颜色
        btn.index = ButtonIndexMake(section, 100+i);
        [btn setTitleColor:ColorFromHex(@"666666") forState:UIControlStateNormal];
        btn.layer.borderColor = ColorFromHex(@"C8C8C8").CGColor;
        btn.layer.borderWidth = 0.8;
        btn.radius = 5;
        
        [btn setTitle:array[i] forState:UIControlStateNormal];
        if (kScreenWidth < 321)
        {
            btn.titleLabel.font = FONT(14);
        }
        else if (kScreenWidth > 340)
        {
            btn.titleLabel.font = FONT(17);
        }
        [self.contentView addSubview:btn];
    }
}

@end
