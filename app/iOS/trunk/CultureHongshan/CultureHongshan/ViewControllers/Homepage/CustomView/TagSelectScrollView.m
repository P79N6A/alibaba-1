//
//  TagSelectScrollView.m
//  TableViewTest
//
//  Created by ct on 16/4/8.
//  Copyright © 2016年 ct. All rights reserved.
//

#import "TagSelectScrollView.h"
#import "MyLoveViewController.h"

@implementation TagSelectScrollView

- (instancetype)initWithFrame:(CGRect)frame autolayout:(BOOL)autolayout {
    if (self = [super initWithFrame:frame]) {
        _autolayout = autolayout;
        
        self.backgroundColor = kWhiteColor;
        self.normalColor = kLightLabelColor;
        self.selectedColor = kThemeDeepColor;
        _canGoPreTag = YES;
        _canGoNextTag = YES;
        
        [self loadSubviews];
    }
    return self;
}

- (void)loadSubviews {
    _indicatorView = [UIView new];
    _indicatorView.backgroundColor = kThemeDeepColor;
    
    if (_autolayout) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        [self addSubview:_scrollView];
        
        WS(weakSelf)
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.top.equalTo(weakSelf);
            make.bottom.equalTo(weakSelf).offset(-5);
        }];
        
        [self updateSelectTagArray];
        
        _bottomLineView = [MYMaskView maskViewWithBgColor:RGB(245, 245, 245) frame:CGRectZero radius:0];
        [self addSubview:_bottomLineView];
        [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.bottom.equalTo(weakSelf);
            make.height.mas_equalTo(3);
        }];
    }else {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width-42, self.height-5)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        [self addSubview:_scrollView];
        [self updateSelectTagArray];
        [self initAddButton];
        
        _bottomLineView = [MYMaskView maskViewWithBgColor:RGB(240, 240, 242) frame:CGRectMake(0, _scrollView.height, self.width, 5) radius:0];
        [self addSubview:_bottomLineView];
    }
}

- (void)updateSelectTagArray
{
    if (_delegate)
    {
        if ([_delegate isKindOfClass: NSClassFromString(@"VenueListViewController")]) {
            self.titleArray = [DictionaryService getAllCultureSpacingTags];
        }else if ([_delegate isKindOfClass:NSClassFromString(@"CalendarViewController")]) {
            self.titleArray = [DictionaryService getCalendarListTagsWithFirstTitles:@[@"全部", @"附近"] completionBlock:nil];
        }else {
            self.titleArray = [DictionaryService getUserActTagsWithFirstTitle:nil];
        }
        _canGoPreTag = NO;
        if(self.titleArray == nil || self.titleArray.count == 1)
        {
            _canGoNextTag = NO;
        }
        else
        {
            _canGoNextTag = YES;
        }
    }
    
}

//＋号按钮
- (void)initAddButton
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.width-60, 0, 60, _scrollView.height)];
    [button setImage:IMG(@"icon_plus") forState:UIControlStateNormal];
    [button setImage:IMG(@"icon_plus") forState:UIControlStateHighlighted];
    button.tag = 1;
    button.tintColor = [UIColor clearColor];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

- (void)setTitleArray:(NSArray *)titleArray
{
    if (titleArray.count)
    {
        if (_titleArray)
        {
            _titleArray = nil;
        }
        _titleArray = titleArray;
        
        //移除之前的视图
        [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_scrollView addSubview:_indicatorView];
        
        CGFloat btnSpacing = 25;
        CGFloat offsetX = 10;
        CGFloat btnWidth = 0;
        CGFloat btnHeight = _scrollView.height;
        
        UIView *preButton = nil;
        for (int i = 0; i < _titleArray.count; i++)
        {
            ThemeTagModel * model = _titleArray[i];
            NSString *tagName = [model isKindOfClass:[NSString class]] ? (NSString *)model : model.tagName;
            
            btnWidth = btnSpacing + [UIToolClass textWidth:tagName font:FONT(16)];
            
            UIButton *button = [[UIButton alloc] initWithFrame:_autolayout ? CGRectZero : CGRectMake(offsetX, 0, btnWidth, btnHeight)];
            button.titleLabel.font = FONT(16);
            [button setTitleColor:_normalColor forState:UIControlStateNormal];
            [button setTitle:tagName forState:UIControlStateNormal];
            button.tag = 2 + i;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:button];
            
            if (i == 0)
            {
                _lastSelectedButton = button;
                [_scrollView bringSubviewToFront:_indicatorView];
                button.titleLabel.font = FONT(18);
                [button setTitleColor:_selectedColor forState:UIControlStateNormal];
                
                if (_autolayout) {
                    [button mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(_scrollView).offset(10);
                        make.width.mas_equalTo(btnWidth);
                        make.top.equalTo(0);
                        make.bottom.equalTo(_bottomLineView.mas_top);
                    }];
                    
                    [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.width.centerX.equalTo(button);
                        make.height.mas_equalTo(1);
                        make.bottom.equalTo(button).offset(-2.5);
                    }];
                }else {
                    _indicatorView.frame  = MRECT(offsetX, btnHeight - 2.5, btnWidth, 1);
                }
            }
            else
            {
                [button setTitleColor:_normalColor forState:UIControlStateNormal];
                if (_autolayout) {
                    [button mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(preButton.mas_right);
                        make.top.and.height.equalTo(preButton);
                        make.width.mas_equalTo(btnWidth);
                    }];
                }
            }
            
            if (_autolayout) {
                preButton = button;
            }else {
                offsetX += btnWidth;
            }
        }
        
        if (_autolayout) {
            [preButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_scrollView).offset(-10);
            }];
        }else {
            _scrollView.contentSize = CGSizeMake(offsetX + 10,_scrollView.height);
        }
    }
}



-(void)movePreTag
{
    
    if (_canGoPreTag)
    {
        NSInteger tag = _lastSelectedButton.tag;
        UIButton * button = [_scrollView viewWithTag:tag - 1];
        [self buttonClick:button];
    }
}

-(void)moveNextTag
{
    
    if (_canGoNextTag)
    {
        NSInteger tag = _lastSelectedButton.tag;
        UIButton * button = [_scrollView viewWithTag:tag + 1];
        [self buttonClick:button];
    }
    
}

- (void)moveToIndex:(NSInteger)index
{
    if (index < 0 || index >= _titleArray.count) {
        return;
    }
    UIButton * button = [_scrollView viewWithTag:index + 2];
    [self buttonClick:button];
}

- (void)hiddenAddButton
{
    for (UIView *subView in self.subviews) {
        
        if ([subView isKindOfClass:[UIScrollView class]]) {
            subView.width = kScreenWidth;
        } else if ([subView isKindOfClass:[UIButton class]]) {
            [subView removeFromSuperview];
        }
    }
}

#pragma mark - Button Action Methods

//＋号的tag为1，标签的tag从2开始
- (void)buttonClick:(UIButton *)sender
{
    if (sender.tag > 1)//排除＋号按钮
    {
        if (_autolayout) {
            [_indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.and.centerX.equalTo(sender);
                make.height.mas_equalTo(1);
                make.bottom.equalTo(sender).offset(-2.5);
            }];
            
            [UIView animateWithDuration:.5f animations:^{
                [_indicatorView.superview setNeedsLayout];
                [_indicatorView.superview layoutIfNeeded];
                
                _lastSelectedButton.titleLabel.font = FONT(16);
                sender.titleLabel.font = FONT(18);
            }];
        }else {
            [UIView animateWithDuration:.5f animations:^{
                _indicatorView.originalX = sender.originalX;
                _indicatorView.width = sender.width;
                _lastSelectedButton.titleLabel.font = FONT(16);
                sender.titleLabel.font = FONT(18);
            }];
        }
        
        NSInteger realIndexAtButtonArray = sender.tag - 2;
        _canGoPreTag = (realIndexAtButtonArray > 0);
        _canGoNextTag = (realIndexAtButtonArray < (_titleArray.count - 1));
        self.isSameButton = (_lastSelectedButton == sender);
        if (_isSameButton == NO) {
            [_lastSelectedButton setTitleColor:_normalColor forState:UIControlStateNormal];
            [sender setTitleColor:_selectedColor forState:UIControlStateNormal];
            
            [self changeContentOffsetWithTouchedButtonCenter:sender.centerX];
        }
        _lastSelectedButton = sender;
        //调用代理方法
        if (_delegate && [_delegate respondsToSelector:@selector(tagSelectView:didSelectItem:forIndex:)])
        {
            [_delegate tagSelectView:self didSelectItem:_titleArray[sender.tag-2] forIndex:sender.tag];
        }
    }
    else
    {
        if(_delegate && [_delegate isKindOfClass:[UIViewController class]])
        {
            MyLoveViewController  * vc = [MyLoveViewController new];
            [((UIViewController *)_delegate).navigationController pushViewController:vc animated:YES];
            
        }
    }
}


- (void)changeContentOffsetWithTouchedButtonCenter:(CGFloat)center
{
    CGFloat offsetX = _scrollView.contentOffset.x;
    
    CGFloat leftShowedWidth = center - offsetX;
    CGFloat targetOffsetX = offsetX - (_scrollView.width*0.5 - leftShowedWidth);
    
    if (targetOffsetX < 0) {
        targetOffsetX = 0;
        [_scrollView setContentOffset:CGPointMake(targetOffsetX, 0) animated:YES];
    }
    if (targetOffsetX > _scrollView.contentSize.width - _scrollView.width && targetOffsetX > 0) {
        targetOffsetX = _scrollView.contentSize.width - _scrollView.width;
        if (targetOffsetX < 0) {
            targetOffsetX = 0;
        }
    }
    [_scrollView setContentOffset:CGPointMake(targetOffsetX, 0) animated:YES];
}


@end
