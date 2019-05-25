//
//  PerfectInformationViewController.m
//  CultureHongshan
//
//  Created by ct on 17/2/15.
//  Copyright © 2017年 CT. All rights reserved.
//

#import "PerfectInformationViewController.h"



#define kBaseTag_InterestTag  200
#define kBaseTag_StatusTag    300

@interface PerfectInformationViewController ()
{
    UIScrollView *_interestScrollView; // 兴趣
    UIScrollView *_personalStatusScrollView; // 个人状态
    NSMutableArray *_interestTagArray;
    NSArray *_personalStatusTagArray; // 个人状态有关的标签数组
    
    int _selectedPersonalStatusTag[10];
}
@property (nonatomic, strong) MYMaskView *indicatorView;
@property (nonatomic, strong) MYMaskView *navigatorView; // 顶部的导航视图

@end

@implementation PerfectInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    _scrollView.backgroundColor = kWhiteColor;
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = NO;
    _interestTagArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 10; i++) {
        _selectedPersonalStatusTag[i] = -1;
    }
    
    
    [self loadUI];
    
    [self loadInterestTagData];
    
    [self loadPersonalStatusTagData];
    
    [self loadBrandView];
}

- (void)loadUI {
    [self loadNavigatorView];
    
    WS(weakSelf)
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.navigatorView.mas_bottom).offset(1);
    }];
    
    UIView *interestView = [self loadInterestView];
    UIView *personalStatusView = [self loadPersonalStatusView];
    UIView *brandView = [self loadBrandView];
    
    [interestView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView);
        make.top.equalTo(weakSelf.navigatorView.mas_bottom);
        make.bottom.and.width.equalTo(weakSelf.view);
    }];
    
    [personalStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(interestView.mas_right);
        make.top.height.width.equalTo(interestView);
    }];
    
    [brandView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(personalStatusView.mas_right);
        make.right.equalTo(_scrollView.mas_right);
        make.top.height.and.width.equalTo(personalStatusView);
    }];
}

/** 导航视图 */
- (void)loadNavigatorView {
    self.navigatorView = [MYMaskView maskViewWithBgColor:kWhiteColor frame:CGRectZero radius:0];
    [self.view addSubview:self.navigatorView];
    
    MYMaskView *bottomLine = [MYMaskView maskViewWithBgColor:RGB(193, 193, 193) frame:CGRectZero radius:0];
    bottomLine.tag = 20;
    [self.navigatorView addSubview:bottomLine];
    
    self.indicatorView = [MYMaskView maskViewWithBgColor:kThemeDeepColor frame:CGRectZero radius:0];
    [self.navigatorView addSubview:self.indicatorView];
    
    
    NSArray *titleArray = @[@"兴趣", @"个人状态", @"品牌"];
    
    WS(weakSelf);
    MYSmartButton *preButton = nil;
    for (int i = 0; i < titleArray.count; i++) {
        MYSmartButton *button = [[MYSmartButton alloc] initWithFrame:CGRectZero title:titleArray[i] font:FONT(14) tColor:kLightLabelColor bgColor:nil actionBlock:^(MYSmartButton *sender) {
            if (sender.selected) {
                return;
            }
            [weakSelf changeToPageIndex:sender.tag];
        }];
        button.tag = i;
        [button setTitleColor:kThemeDeepColor forState:UIControlStateSelected];
        [self.navigatorView addSubview:button];
        
        
        if (i == 0) {
            button.selected = YES;
            [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(button);
                make.width.equalTo(button).multipliedBy(0.6);
                make.height.mas_equalTo(1.6);
                make.centerY.equalTo(bottomLine);
            }];
        }
        
        if (i < titleArray.count-1) {
            MYMaskView *line = [MYMaskView maskViewWithBgColor:bottomLine.backgroundColor frame:CGRectZero radius:0];
            [button addSubview:line];
            
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0.7);
                make.height.equalTo(button).multipliedBy(0.55);
                make.centerY.equalTo(button);
                make.right.equalTo(button);
            }];
        }
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            if (preButton) {
                make.left.equalTo(preButton.mas_right);
                make.width.height.and.centerY.equalTo(preButton);
            }else {
                make.left.top.equalTo(weakSelf.navigatorView);
                make.bottom.equalTo(bottomLine.mas_top);
            }
        }];
        
        preButton = button;
    }
    
    [preButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.navigatorView);
    }];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.navigatorView);
        make.bottom.equalTo(weakSelf.navigatorView).offset(-1);
        make.height.mas_equalTo(0.5);
    }];
    
    
    [self.navigatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view).offset(HEIGHT_TOP_BAR);
        make.height.mas_equalTo(45);
    }];
    
    [self.navigatorView bringSubviewToFront:self.indicatorView];
}

/** 兴趣子页面 */
- (UIView *)loadInterestView {
    UIView *bgView = [UIView new];
    bgView.backgroundColor = kWhiteColor;
    [_scrollView addSubview:bgView];
    
    // 送积分提示
    UIView *integralTipView = [self addIntegralTipViewOnView:bgView];
    
    // ScrollView
    _interestScrollView = [[UIScrollView alloc] init];
    _interestScrollView.backgroundColor = kWhiteColor;
    [bgView addSubview:_interestScrollView];
    
    // 下一步
    WS(weakSelf)
    MYSmartButton *nextButton = [[MYSmartButton alloc] initWithFrame:CGRectZero title:@"下一步 (多选)" font:FontYT(14) tColor:nil bgColor:kThemeDeepColor actionBlock:^(MYSmartButton *sender) {
        [weakSelf changeToPageIndex:1];
    }];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[nextButton currentTitle] attributes:@{NSFontAttributeName : FONT(17), NSForegroundColorAttributeName: kWhiteColor}];
    [attributedString addAttributes:@{NSFontAttributeName : FONT(14)} range:NSMakeRange(3, [nextButton currentTitle].length-3)];
    [nextButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    nextButton.radius = 4;
    [bgView addSubview:nextButton];
    
    // 继续完善
    MYSmartLabel *perfectTipLabel = [MYSmartLabel al_labelWithMaxRow:1 text:@"继续完善，可以获得更多积分哦~" font:FontYT(15) color:kThemeDeepColor lineSpacing:0 align:NSTextAlignmentCenter breakMode:NSLineBreakByWordWrapping];
    [bgView addSubview:perfectTipLabel];
    
    
    [_interestScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(integralTipView.mas_bottom);
        make.bottom.equalTo(perfectTipLabel.mas_top).offset(-10);
        make.left.and.right.equalTo(bgView);
    }];
    
    [perfectTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(nextButton.mas_top).offset(-14);
        make.centerX.equalTo(bgView);
    }];
    
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgView).offset(-37);
        make.left.equalTo(bgView).offset(23);
        make.right.equalTo(bgView).offset(-23);
        make.height.mas_equalTo(43);
    }];
    
    return bgView;
}

/** 个人状态子页面 */
- (UIView *)loadPersonalStatusView {
    UIView *bgView = [UIView new];
    bgView.backgroundColor = kWhiteColor;
    [_scrollView addSubview:bgView];
    
    // 送积分提示
    UIView *integralTipView = [self addIntegralTipViewOnView:bgView];
    
    // ScrollView
    _personalStatusScrollView = [[UIScrollView alloc] init];
    [bgView addSubview:_personalStatusScrollView];
    
    // 上一步
    WS(weakSelf)
    MYSmartButton *previousButton = [[MYSmartButton alloc] initWithFrame:CGRectZero title:@"上一步 (多选)" font:FontYT(14) tColor:nil bgColor:RGB(239, 237, 244) actionBlock:^(MYSmartButton *sender) {
        [weakSelf changeToPageIndex:0];
    }];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[previousButton currentTitle] attributes:@{NSFontAttributeName : FONT(17), NSForegroundColorAttributeName: kThemeDeepColor}];
    [attributedString addAttributes:@{NSFontAttributeName : FONT(14)} range:NSMakeRange(3, [previousButton currentTitle].length-3)];
    [previousButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    previousButton.radius = 4;
    previousButton.layer.borderColor = kThemeDeepColor.CGColor;
    previousButton.layer.borderWidth = 0.8;
    [bgView addSubview:previousButton];
    
    // 下一步
    MYSmartButton *nextButton = [[MYSmartButton alloc] initWithFrame:CGRectZero title:@"下一步 (多选)" font:FontYT(14) tColor:nil bgColor:kThemeDeepColor actionBlock:^(MYSmartButton *sender) {
        [weakSelf changeToPageIndex:2];
    }];
    attributedString = [[NSMutableAttributedString alloc] initWithString:[nextButton currentTitle] attributes:@{NSFontAttributeName : FONT(17), NSForegroundColorAttributeName: kWhiteColor}];
    [attributedString addAttributes:@{NSFontAttributeName : FONT(14)} range:NSMakeRange(3, [nextButton currentTitle].length-3)];
    [nextButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    nextButton.radius = 4;
    [bgView addSubview:nextButton];
    
    // 继续完善
    MYSmartLabel *perfectTipLabel = [MYSmartLabel al_labelWithMaxRow:1 text:@"继续完善，可以获得更多积分哦~" font:FontYT(15) color:kThemeDeepColor lineSpacing:0 align:NSTextAlignmentCenter breakMode:NSLineBreakByWordWrapping];
    [bgView addSubview:perfectTipLabel];
    
    
    [_personalStatusScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(integralTipView.mas_bottom);
        make.bottom.equalTo(perfectTipLabel.mas_top).offset(-10);
        make.left.and.right.equalTo(bgView);
    }];
    
    [perfectTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(nextButton.mas_top).offset(-14);
        make.centerX.equalTo(bgView);
    }];
    
    [previousButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgView).offset(-37);
        make.left.equalTo(bgView).offset(23);
        make.height.mas_equalTo(43);
    }];
    
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.height.width.equalTo(previousButton);
        make.right.equalTo(bgView).offset(-23);
        make.left.equalTo(previousButton.mas_right).offset(30);
    }];
    
    return bgView;
}

/** 品牌子页面 */
- (UIView *)loadBrandView {
    UIView *bgView = [UIView new];
    [_scrollView addSubview:bgView];
    
    UIScrollView *brandScrollView = [UIScrollView new];
    brandScrollView.showsVerticalScrollIndicator = NO;
    brandScrollView.bounces = NO;
    [bgView addSubview:brandScrollView];
    [brandScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bgView);
    }];
    
    UIImage *brandImage = IMG(@"icon_brand.jpg");
    CGFloat scale = brandImage.size.height / brandImage.size.width;
    MYSmartButton *brandButton = [[MYSmartButton alloc] initWithFrame:CGRectZero image:brandImage selectedImage:brandImage actionBlock:^(MYSmartButton *sender) {
        
    }];
    [brandButton setImage:brandImage forState:UIControlStateHighlighted];
    [brandScrollView addSubview:brandButton];
    [brandButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bgView);
        make.top.equalTo(0);
        make.height.equalTo(brandButton.mas_width).multipliedBy(scale);
        make.bottom.equalTo(brandScrollView);
    }];
    
    return bgView;
}

/** 送积分提示 */
- (UIView *)addIntegralTipViewOnView:(UIView *)view {
    MYMaskView *integralTipView = [MYMaskView maskViewWithBgColor:kThemeDeepColor frame:CGRectZero radius:0];
    [view addSubview:integralTipView];
    [integralTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.equalTo(view);
        make.height.mas_equalTo(27);
    }];
    
    UIImageView *iconView = [[UIImageView alloc] initWithImage:IMG(@"icon_提示")];
    [integralTipView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(integralTipView).offset(10);
        make.centerY.equalTo(integralTipView);
    }];
    
    
    MYSmartLabel *label = [MYSmartLabel al_labelWithMaxRow:1 text:@"首次完善，可以获得100积分哦！" font:FontYT(13) color:kWhiteColor lineSpacing:0];
    [integralTipView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(5);
//        make.right.equalTo(integralTipView).offset(-10);
        make.top.and.bottom.equalTo(integralTipView);
    }];
    
    return integralTipView;
}




#pragma mark - 

- (void)loadInterestTagData {
    
    NSArray *array = @[@"音乐", @"演出", @"展览", @"戏曲", @"书法", @"运动", @"电影", @"美食", @"旅游"];
    [_interestTagArray addObjectsFromArray:array];
    
    [self layoutInterestTagButtons];
}

- (void)loadPersonalStatusTagData {
    _personalStatusTagArray = (NSArray *)[JsonTool jsonObjectFromData:[NSData dataWithContentsOfFile:kPersonalStatusTagListPath]];
    [self layoutPersonalStatusTagButtons];
}


/** 添加兴趣标签按钮 */
- (void)layoutInterestTagButtons {
    
    NSInteger itemSize = 76;
    
    MYSmartButton *preButton = nil;
    for (int i = 0; i < _interestTagArray.count; i++) {
        NSString *title = _interestTagArray[i];
        
        MYSmartButton *button = [[MYSmartButton alloc] initWithFrame:CGRectZero title:@"" font:FONT(14) tColor:kDeepLabelColor bgColor:nil actionBlock:^(MYSmartButton *sender) {
            sender.selected = !sender.selected;
            UIImageView *checkmarkView = [sender viewWithTag:1];
            checkmarkView.hidden = !sender.selected;
        }];
        button.backgroundColor = RandomColor();
        button.tag = i + kBaseTag_InterestTag;
        [_interestScrollView addSubview:button];
        
        UIImageView *checkmarkView = [UIImageView new];
        checkmarkView.backgroundColor = kRedColor;
        checkmarkView.tag = 1;
        checkmarkView.hidden = YES;
        [button addSubview:checkmarkView];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i%3 == 0) {
                make.centerX.equalTo(_interestScrollView).multipliedBy(0.3654); // 0.1827/0.5
                
                if (i > 0) {
                    make.width.height.equalTo(preButton);
                    make.top.equalTo(preButton.mas_bottom).offset(30 + 18);
                }else {
                    make.top.mas_equalTo(30);
                    make.size.mas_equalTo(CGSizeMake(itemSize, itemSize));
                }
            }else if (i%3 == 1) {
                make.centerX.equalTo(_interestScrollView);
                make.top.width.height.equalTo(preButton);
            }else {
                make.centerX.equalTo(_interestScrollView).multipliedBy(1.6346); // 0.8173/0.5
                make.top.width.height.equalTo(preButton);
            }
        }];
        
        MYSmartLabel *titleLabel = [MYSmartLabel al_labelWithMaxRow:1 text:MYStringAddSpaceHandle(title) font:FONT(14) color:kBlackColor lineSpacing:0 align:NSTextAlignmentCenter breakMode:NSLineBreakByTruncatingMiddle];
        [button addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(button.mas_bottom).offset(4);
            make.width.equalTo(button).multipliedBy(1.2);
            make.centerX.equalTo(button);
        }];
        
        [checkmarkView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(18, 18));
            make.centerX.equalTo(button).multipliedBy(1.5915);
            make.centerY.equalTo(button).multipliedBy(1.5915);
        }];
        
        preButton = button;
    }
    
    [preButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_interestScrollView).offset(-30-18);
    }];
}

/** 添加个人状态标签按钮 */
- (void)layoutPersonalStatusTagButtons {
    NSInteger itemSize = 70;
    MYSmartButton *preButton = nil;
    WS(weakSelf)
    
    for (int i = 0; i < _personalStatusTagArray.count; i++) {
        NSDictionary *groupDict = _personalStatusTagArray[i];
        NSString *groupName = [groupDict safeStringForKey:@"groupName"];
        NSArray *tagList = [groupDict safeArrayForKey:@"tagList"];
        
        if (tagList.count == 0) continue;
        
        
        MYSmartLabel *groupTitleLabel = [MYSmartLabel al_labelWithMaxRow:5 text:groupName font:FontYT(15) color:kDeepLabelColor lineSpacing:groupName.length > 2 ? 5 : 0 align:NSTextAlignmentCenter breakMode:NSLineBreakByClipping];
        [_personalStatusScrollView addSubview:groupTitleLabel];
        
        MYMaskView *line = [MYMaskView maskViewWithBgColor:RGB(142, 142, 142) frame:CGRectZero radius:0];
        [_personalStatusScrollView addSubview:line];
        
        // 标签的背景视图（添加这个视图，只是方便布局按钮）
        MYMaskView *tagBgView = [MYMaskView maskViewWithBgColor:kWhiteColor frame:CGRectZero radius:0];
        [_personalStatusScrollView addSubview:tagBgView];
        [tagBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(line.mas_right).offset(10);
            make.right.equalTo(_personalStatusScrollView.superview).offset(-20);
            if (preButton) {
                make.top.equalTo(preButton.superview.mas_bottom).offset(35);
            }else {
                make.top.mas_equalTo(30);
            }
        }];
        
        
        for (int j = 0; j < tagList.count; j++) {
            NSDictionary *tagDict = tagList[j];
            
            
            MYSmartButton *button = [[MYSmartButton alloc] initWithFrame:CGRectZero title:@"" font:FONT(14) tColor:kDeepLabelColor bgColor:nil actionBlock:^(MYSmartButton *sender) {
                [weakSelf personalStatusButtonClick:sender];
            }];
            button.backgroundColor = RandomColor();
            button.row = i;
            button.tag = kBaseTag_StatusTag + j;
            [tagBgView addSubview:button];
            
            UIImageView *checkmarkView = [UIImageView new];
            checkmarkView.backgroundColor = kRedColor;
            checkmarkView.tag = 1;
            checkmarkView.hidden = YES;
            [button addSubview:checkmarkView];
            
            MYSmartLabel *titleLabel = [MYSmartLabel al_labelWithMaxRow:1 text:[tagDict safeStringForKey:@"tagName"] font:FONT(14) color:kBlackColor lineSpacing:0 align:NSTextAlignmentCenter breakMode:NSLineBreakByTruncatingMiddle];
            [button addSubview:titleLabel];
            
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(button.mas_bottom).offset(4);
                make.width.equalTo(button).multipliedBy(1.2);
                make.centerX.equalTo(button);
            }];
            
            [checkmarkView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(18, 18));
                make.centerX.equalTo(button).multipliedBy(1.5915);
                make.centerY.equalTo(button).multipliedBy(1.5915);
            }];
            
            
            if (j == 0) {
                CGFloat textWidth = [UIToolClass textWidth:groupTitleLabel.text font:groupTitleLabel.font]+2;
                [groupTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(button);
                    make.left.mas_equalTo(18);
                    make.width.mas_equalTo(textWidth);
                }];
                
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(groupTitleLabel.mas_right).offset(4);
                    make.size.mas_equalTo(CGSizeMake(15, 0.6));
                    make.centerY.equalTo(groupTitleLabel);
                }];
            }
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                if (j%3 == 0) {
                    make.left.mas_equalTo(0);
                    
                    if (j > 0) {
                        make.width.height.equalTo(preButton);
                        make.top.equalTo(preButton.mas_bottom).offset(30 + 18);
                    }else {
                        make.top.mas_equalTo(0);
                        make.size.mas_equalTo(CGSizeMake(itemSize, itemSize));
                    }
                }else if (j%3 == 1) {
                    make.centerX.equalTo(tagBgView);
                    make.top.width.height.equalTo(preButton);
                }else {
                    make.right.equalTo(tagBgView);
                    make.top.width.height.equalTo(preButton);
                }
            }];
            
            preButton = button;
        }
        
        [preButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(tagBgView).offset(-20);
        }];
    }
    
    [preButton.superview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_personalStatusScrollView).offset(-30);
    }];
}

#pragma mark -


/** 左右切换 */
- (void)changeToPageIndex:(NSInteger)index {
    
    WS(weakSelf)
    UIView *bottomLine = [self.navigatorView viewWithTag:20];
    
    for (UIButton *button in self.navigatorView.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            if (button.tag == index) {
                button.selected = YES;
                [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(button);
                    make.width.equalTo(button).multipliedBy(0.6);
                    make.height.mas_equalTo(1.6);
                    make.centerY.equalTo(bottomLine);
                }];
            }else {
                button.selected = NO;
            }
        }
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf.navigatorView setNeedsLayout];
        [weakSelf.navigatorView layoutIfNeeded];
    }];
    
    [_scrollView setContentOffset:CGPointMake(index * _scrollView.width, 0) animated:YES];
}

- (void)personalStatusButtonClick:(MYSmartButton *)sender {
    if (sender.selected) {
        return;
    }
    
    _selectedPersonalStatusTag[sender.row] = (int)(sender.tag - kBaseTag_StatusTag + 1);
    
    for (MYSmartButton *button in sender.superview.subviews) {
        UIImageView *checkmarkView = [button viewWithTag:1];
        if (button != sender) {
            checkmarkView.hidden = YES;
            button.selected = NO;
        }else {
            checkmarkView.hidden = NO;
            button.selected = YES;
        }
    }
}



/** 字符串添加空格处理 */
NSString *MYStringAddSpaceHandle(NSString *string) {
    if (string.length) {
        if ([string rangeOfString:@"^[\u4e00-\u9fa5]{2,5}$" options:NSRegularExpressionSearch].length == string.length) {
            NSMutableString *tmpString = [NSMutableString stringWithString:string];
            NSInteger length = string.length;
            
            for (NSInteger i = length-1; i > 0; i--) {
                [tmpString insertString:@" " atIndex:i];
            }
            return tmpString;
        }
        return string;
    }
    return @"";
}



@end
