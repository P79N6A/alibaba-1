//
//  ActivityDetailHeaderView.m
//  CultureHongshan
//
//  Created by ct on 16/1/25.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "ActivityDetailHeaderView.h"


@implementation ActivityDetailHeaderView


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        CGFloat height = 45;
        _lineHaveProgressAnimation = NO;
        
        
        self.leftLabel =  [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 0, height)];
        [self.contentView addSubview:_leftLabel];
        
        self.rightLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, height)];
        _rightLabel.font = FontYT(16);
        _rightLabel.textColor = [UIColor redColor];
        [self.contentView addSubview:_rightLabel];
        
        self.button = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 100, 0, 100, height)];
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_button setImage:IMG(@"icon_arrow_right_gray") forState:UIControlStateNormal];
        [self.contentView addSubview:_button];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, height-0.5, kScreenWidth-20, 1)];
        lineView.backgroundColor = kBgColor;
        [self.contentView addSubview:lineView];
    }
    return self;
}


- (void)setAccessoryImgHidden:(BOOL)accessoryImgHidden
{
    if (accessoryImgHidden) {
        [_button setImage:nil forState:UIControlStateNormal];
    }else{
        [_button setImage:IMG(@"icon_arrow_right_gray") forState:UIControlStateNormal];
    }
}

-(void)setLineHaveProgressAnimation:(BOOL)lineHaveProgressAnimation
{
    if (lineHaveProgressAnimation)
    {
        UIView * animationLine = [self.contentView viewWithTag:101];
        if (animationLine == nil)
        {
            animationLine = [[UIView alloc] initWithFrame:CGRectMake(10, 41, 1, 2)];
            animationLine.tag = 101;
            animationLine.backgroundColor = RGB(0x72, 0x79, 0xa0);
            [self.contentView addSubview:animationLine];

        }
        
        [UIView animateWithDuration:5 animations:^{
           
            animationLine.frame = CGRectMake(10, 41, (kScreenWidth-20) / 2, 2);
            
        }];
        
    }
}


-(void)endLineProgressAnimation
{
    UIView * view = [self.contentView viewWithTag:101];
    [view.layer removeAllAnimations];
    [UIView animateWithDuration:.1f animations:^{
        
        view.frame = CGRectMake(view.frame.origin.x, 41, kScreenWidth-20, 2);
        
    } completion:^(BOOL finished) {
        view.hidden = YES;
    }];
}

- (void)buttonClick:(UIButton *)sender
{
    if (_headerViewButtonBlock) {
        _headerViewButtonBlock(sender.tag);
    }
}

- (void)setDataArray:(NSArray *)dataArray forSection:(NSInteger )section
{
    if (dataArray.count)
    {
        if (section == 7) {
            NSString *commentStr = dataArray[0];
            if (commentStr.length) {
                NSString *titleStr = [NSString stringWithFormat:@"共 %@ 条评论",commentStr];
                
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:titleStr attributes:@{NSFontAttributeName:FONT(14), NSForegroundColorAttributeName:kDeepLabelColor}];
                [attributedString addAttribute:NSForegroundColorAttributeName value:kDarkRedColor range:NSMakeRange(2, commentStr.length)];
                _leftLabel.attributedText = attributedString;
                _rightLabel.text = @"";
            }
        }
        if (section > 0 && section < 7){
            _leftLabel.attributedText = nil;
            _leftLabel.text = dataArray[0];
            _leftLabel.font = FONT(16);
            _leftLabel.textColor = ColorFromHex(@"666666");
            
            _rightLabel.text = @"";
        }
        
        _leftLabel.width = [UIToolClass textWidth:_leftLabel.text font:_leftLabel.font];
        
        _rightLabel.width = [UIToolClass textWidth:_rightLabel.text font:_rightLabel.font];
        _rightLabel.originalX = kScreenWidth - 30 - _rightLabel.width;
    }
}


@end
