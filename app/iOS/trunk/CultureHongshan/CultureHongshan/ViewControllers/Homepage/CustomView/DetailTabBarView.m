//
//  DetailTabBarView.m
//  CultureHongshan
//
//  Created by ct on 16/4/11.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "DetailTabBarView.h"
#import <QuartzCore/CAAnimation.h>
#import "SharePresentView.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@interface DetailTabBarView () <CAAnimationDelegate>
#else
@interface DetailTabBarView ()
#endif
{
    NSArray *_imageNames;
    
    UIButton *_lastSelectedButton;
    
    BOOL _isSelected[4];
    
    UIButton *_commentButton;//评论按钮：
    UIButton *_loveButton;//点赞按钮
    UIButton *_collectButton;//收藏按钮
    UIButton *_shareButton;//分享按钮
    UIButton *_otherButton;//other按钮
    UIImageView *_refreshView;//size: 38x49
}

@end





@implementation DetailTabBarView


- (instancetype)initWithFrame:(CGRect)frame prompt:(NSString *)prompt
{
    if (self = [super initWithFrame:frame])
    {
        NSMutableArray *promptArray = [NSMutableArray arrayWithCapacity:2];
        if (prompt.length) {
            if ([prompt hasPrefix:@"|"]) {
                [promptArray addObject:[prompt substringFromIndex:1]];
            }else {
                NSArray *array = [ToolClass getComponentArray:prompt separatedBy:@"|"];
                if (array.count == 1) {
                    [promptArray addObject:[array firstObject]];
                }else if (array.count == 2){
                    [promptArray addObject:array[1]];
                    [promptArray addObject:array[0]];
                }
            }
        }
        
        self.backgroundColor = ColorFromHex(@"F4F4F4");
        
        BOOL shareButtonHidden = NO;
        if ([SharePresentView canShowShareView]) {
            shareButtonHidden = NO;
        }else {
            shareButtonHidden = YES;
        }
        
        
        CGFloat commentWidth = 0;
        CGFloat otherWidth = 0;
        CGFloat loveWidth = 0;
        
        if (shareButtonHidden) { // 隐藏分享功能
            commentWidth = kScreenWidth < 321 ?  ConvertSize(170) : ConvertSize(160);
            otherWidth = kScreenWidth < 321 ?  ConvertSize(370) : ConvertSize(350);
            loveWidth = (kScreenWidth - commentWidth - otherWidth)/2.0;
        }else {
            commentWidth = kScreenWidth < 321 ?  ConvertSize(150) : ConvertSize(148);
            otherWidth = kScreenWidth < 321 ?  ConvertSize(370) : ConvertSize(350);
            loveWidth = (kScreenWidth - commentWidth - otherWidth)/3.0;
        }
        
        CGFloat offsetY = 0;
        CGFloat height = 50;
        
        if (promptArray.count) {
            //顶部的积分提示信息
            MYMaskView *bgView = [MYMaskView maskViewWithBgColor:ColorFromHex(@"FFF8DF") frame:CGRectMake(0, 0, kScreenWidth, promptArray.count == 2 ? 52.5 : 30) radius:0];
            [self addSubview:bgView];
            
            CGFloat fontHeight = [UIToolClass fontHeight:FontYT(13)];
            CGFloat originalY = promptArray.count == 2 ? ( bgView.height-(2*fontHeight+6) )*0.5 : ( bgView.height-fontHeight )*0.5;
            for (int i = 0; i < promptArray.count; i++) {
                NSString *noticeStr = promptArray[i];
                
                //提示Label
                UILabel *promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(31,originalY+i*(fontHeight+6), kScreenWidth-15-31, fontHeight)];
                NSMutableAttributedString *attributedString = (NSMutableAttributedString *)[UIToolClass getAttributedStr:noticeStr font:FontYT(13) lineSpacing:0];
                [attributedString addAttribute:NSForegroundColorAttributeName value:kDeepLabelColor range:NSMakeRange(0, noticeStr.length)];
                
                NSArray *rangeArray = [ToolClass getDigitalNumberRanges:noticeStr];
                for (NSValue *rangeValue in rangeArray) {
                    [attributedString addAttribute:NSForegroundColorAttributeName value:kDarkRedColor range:rangeValue.rangeValue];
                }
                promptLabel.attributedText = attributedString;
                [bgView addSubview:promptLabel];
                
                //提示图标
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 0, 13, 13)];
                imgView.image = IMG(@"icon_提示");
                [bgView addSubview:imgView];
                imgView.centerY = promptLabel.centerY;
            }
            offsetY = bgView.height;
        }
        
        //评论
        _commentButton = [[UIButton alloc] initWithFrame:CGRectMake(0, offsetY, commentWidth, height)];
        _commentButton.tag = 10;
        [_commentButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_commentButton];
        
        UIImage *commentImage = IMG(@"点评3.5");
        CGFloat offsetX = (commentWidth-(commentImage.size.width*0.5+4+[UIToolClass textWidth:@"评论" font:FontYT(14)]))*0.5;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(offsetX, offsetY, commentImage.size.width, commentImage.size.height)];
        imgView.tag = 1;
        imgView.image = commentImage;
        [_commentButton addSubview:imgView];
        imgView.centerY = height*0.5;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imgView.maxX + 4, 0, 100, height)];
        label.tag = 2;
        label.text = @"评论";
        label.font = FontYT(14);
        label.textColor = kDeepLabelColor;
        [_commentButton addSubview:label];
        label.centerY = height*0.5;
        
        //点赞
        _loveButton = [[UIButton alloc] initWithFrame:CGRectMake(_commentButton.maxX, offsetY, loveWidth, height)];
        _loveButton.tag = 11;
        [_loveButton setImage:IMG(@"赞3.5") forState:UIControlStateNormal];
        [_loveButton setImage:IMG(@"赞3.5") forState:UIControlStateSelected];
        [_loveButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_loveButton];
        
        //收藏
        _collectButton = [[UIButton alloc] initWithFrame:CGRectMake(_loveButton.maxX, offsetY, loveWidth, height)];
        _collectButton.tag = 12;
        [_collectButton setImage:IMG(@"收藏3.5") forState:UIControlStateNormal];
        [_collectButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_collectButton];
        
        
        if (shareButtonHidden == NO) {
            // 分享
            _shareButton = [[UIButton alloc] initWithFrame:CGRectMake(_collectButton.maxX, offsetY, loveWidth, height)];
            _shareButton.tag = 13;
            [_shareButton setImage:IMG(@"分享3.5") forState:UIControlStateNormal];
            [_shareButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_shareButton];
        }
        
        //顶部的分割线
        MYMaskView *topLineView = [MYMaskView maskViewWithBgColor:ColorFromHex(@"E1E1E1") frame:CGRectMake(0, offsetY, kScreenWidth, 1) radius:0];
        [self addSubview:topLineView];
        
        // 其他
        if (_shareButton) {
            _otherButton = [[UIButton alloc] initWithFrame:CGRectMake(_shareButton.maxX, offsetY, otherWidth, height)];
        }else {
            _otherButton = [[UIButton alloc] initWithFrame:CGRectMake(_collectButton.maxX, offsetY, otherWidth, height)];
        }
        _otherButton.tag = 14;
        _otherButton.titleLabel.font = FONT(20);
        [_otherButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_otherButton];
        
        //刷新Logo
        CGFloat positionX = _otherButton.width*0.5-[UIToolClass textWidth:@"未开始" font:_otherButton.titleLabel.font]*0.5-8-19;
        _refreshView = [[UIImageView alloc] initWithImage:IMG(@"icon_refresh")];
        _refreshView.frame = CGRectMake(positionX, 0, 19, 25);
        [_otherButton addSubview:_refreshView];
        _refreshView.centerY = _otherButton.height*0.5;
        
        
        // 三条分割线
        NSInteger lineCount = 0;
        if (_shareButton) {
            lineCount = 3;
        }else {
            lineCount = 2;
        }
        
        for (int i = 0; i < lineCount; i++) {
            UIView *lineView = [MYMaskView maskViewWithBgColor:ColorFromHex(@"D5D5D5") frame:CGRectMake(_commentButton.maxX + i*loveWidth, offsetY+12.5, 1, height-25) radius:0];
            [self addSubview:lineView];
        }
        
        self.height = offsetY+height + HEIGHT_HOME_INDICATOR;
        self.originalY = kScreenHeight-self.height;
    }
    return self;
}





- (void)buttonClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 10://评论
        {
            if (self.callBackBlock)
            {
                _callBackBlock(sender, sender.tag - 10, _isSelected[sender.tag-10]);
            }
        }
            break;
        case 11://点赞
        {
            
            if (self.callBackBlock)
            {
                _callBackBlock(sender, sender.tag - 10, _isSelected[sender.tag-10]);
            }
        }
            break;
        case 12://收藏
        {
            if (self.callBackBlock)
            {
                _callBackBlock(sender, sender.tag - 10, _isSelected[sender.tag-10]);
            }
        }
            break;
        case 13://分享
        {
            if (self.callBackBlock)
            {
                _callBackBlock(sender, sender.tag - 10, _isSelected[sender.tag-10]);
            }
        }
            break;
        case 14://其他
        {
            if (self.callBackBlock && _otherButton.selected)
            {
                _callBackBlock(sender, sender.tag - 10, YES);
                if (_refreshView.hidden == NO){
                    [self refreshAnimation];
                }
            }
        }
            break;
            
        default:
            break;
    }
}


/*
 
 title只有“其他”按钮使用
 
 */
- (void)setButtonStatusWithIndex:(NSInteger)btnIndex title:(id)title selected:(BOOL)selected
{
    //    _isSelected[btnIndex] = selected;
    
    switch (btnIndex + 10) {
        case 10://评论
        {
            _commentButton.selected = selected;
        }
            break;
        case 11://点赞
        {
            _loveButton.selected = selected;
            if (selected) {
                [_loveButton setImage:IMG(@"赞3.5_on") forState:UIControlStateSelected];
            }else{
                [_loveButton setImage:IMG(@"赞3.5") forState:UIControlStateNormal];
            }
        }
            break;
        case 12://收藏
        {
            _collectButton.selected = selected;
            if (selected) {
                [_collectButton setImage:IMG(@"收藏3.5_on") forState:UIControlStateSelected];
            }else{
                [_collectButton setImage:IMG(@"收藏3.5") forState:UIControlStateNormal];
            }
        }
            break;
        case 13://分享
        {
            _shareButton.selected = selected;
        }
            break;
        case 14://其他
        {
            _otherButton.selected = selected;
            if ([title isKindOfClass:[NSString class]]) {
                [_otherButton setAttributedTitle:nil forState:UIControlStateNormal];
                if ([title isEqualToString:@"未开始"]) {
                    _refreshView.hidden = NO;
                }else{
                    _refreshView.hidden = YES;
                }
                
                [_otherButton setTitle:title forState:UIControlStateNormal];
            }else{
                _refreshView.hidden = YES;
                [_otherButton setTitle:@"" forState:UIControlStateNormal];
                [_otherButton setAttributedTitle:title forState:UIControlStateNormal];
            }
            [_otherButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            if ((selected && ![title isEqualToString:@"未开始"]) || [title isKindOfClass:[NSAttributedString class]] ) {
                _otherButton.backgroundColor = kThemeDeepColor;
            }else{
                _otherButton.backgroundColor = ColorFromHex(@"CCCCCC");
            }
            
            if ([title isKindOfClass:[NSString class]])
            {
                if ([title isEqualToString:@"秒 杀"]) {
                    _otherButton.backgroundColor = ColorFromHex(@"C05459");
                }
            }
            
        }
            break;
            
        default:
            break;
    }
}



- (void)showWithAnimation:(UIScrollView *)tableView
{
    WS(weakSelf);
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.originalY = kScreenHeight-weakSelf.height;
        tableView.height = kScreenHeight-weakSelf.height;
    } completion:^(BOOL finished) {
    }];
}

- (void)dismissWithAnimation:(UIScrollView *)tableView
{
    WS(weakSelf);
    [UIView animateWithDuration:0.3 animations:^{
       
        tableView.height = kScreenHeight;
         weakSelf.originalY = kScreenHeight;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)refreshAnimation
{
    if (_refreshView.hidden == NO){
        _otherButton.userInteractionEnabled = NO;
        
        CABasicAnimation *rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
        rotationAnimation.duration = 0.5;
        rotationAnimation.repeatCount = 1;
        rotationAnimation.delegate = self;
        
        [_refreshView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    _otherButton.userInteractionEnabled = YES;
}

@end
