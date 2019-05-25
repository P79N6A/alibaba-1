//
//  SearchActivityViewController.m
//  CultureHongshan
//
//  Created by ct on 16/4/13.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "SearchActivityViewController.h"

#import "SearchTag.h"
#import "SearchLocationTag.h"
#import "SearchHotKeyModel.h"
#import "UserDataCacheTool.h"

#import "MYTextInputView.h"

#import "SearchDetailViewController.h"

#define  HEIGHT_BUTTON       30
#define  HEIGHT_TITLE        60
#define  HEIGHT_BUTTON_SPAN  12
#define  kMatchedWordBaseTag 50


@interface SearchActivityViewController ()<MYTextInputViewDelegate>
{
    MYMaskView *_navView;
    MYMaskView *_searchBgView;
    MYTextField *_textField;
    UIScrollView *_dropDownScrollView;
    UIScrollView *_matchedWordScrollView; // 联想词
    
    CGFloat _matchedWordViewHeight;
    
    NSMutableArray *_matchedWords;
    
    NSString *_lastKeyword;
    
    NSUInteger _rowItemNumber;// 一行内有几个关键词
}

@end


@implementation SearchActivityViewController

-(id)initWithSearchType:(SearchType)searchType
{
    if (self = [super initWithNibName:nil bundle:nil])
    {
        _searchType = searchType;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _hasInputView = YES;
    _rowItemNumber = kScreenWidth < 321 ? 3 : 4;
    
    
    _scrollView.backgroundColor = COLOR_IWHITE;
    cacheTool = [UserDataCacheTool sharedInstance];
    _matchedWords = [NSMutableArray arrayWithCapacity:0];
    
    [self loadNavigationBarUI];
    [self loadData];
    
    if (@available(iOS 11.0, *)) {
        _matchedWordScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _dropDownScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    [self showWithAnimation];
}

/**
 *  初始化导航条
 */
-(void)loadNavigationBarUI
{
    _navView = [MYMaskView maskViewWithBgColor:kNavigationBarColor frame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_TOP_BAR) radius:0];
    [self.view addSubview:_navView];
    _navView.originalY = -_navView.height;
    
    // 搜索联想词
    _matchedWordScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _navView.height, kScreenWidth, 0)];
    _matchedWordScrollView.backgroundColor = COLOR_IWHITE;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagGesture:)];
    tap.numberOfTapsRequired = 1;
    [_matchedWordScrollView addGestureRecognizer:tap];
    [self.view addSubview:_matchedWordScrollView];
    
    
    UIScrollView *dropDownScrollView = [UIScrollView new];
    _dropDownScrollView = dropDownScrollView;
    [self.view addSubview:dropDownScrollView];
    __weak UIScrollView *weakScrollView = dropDownScrollView;
    
    _searchBgView = [MYMaskView maskViewWithBgColor:COLOR_IWHITE frame:CGRectMake(10, HEIGHT_STATUS_BAR + 6 - _navView.height, kScreenWidth-60, 30) radius:5];
    [self.view addSubview:_searchBgView];
    
    FBButton *selectButton = [[FBButton alloc] initWithImage:CGRectMake(0, 0, 70, _searchBgView.height) bgcolor:[UIColor clearColor] img:nil clickEvent:^(FBButton *owner) {
        owner.selected = !owner.selected;
        owner.imageView.transform = owner.selected ? CGAffineTransformMakeRotation(M_PI) : CGAffineTransformMakeRotation(0);
        
        BOOL isSelected = owner.selected;
        [UIView animateWithDuration:0.25 animations:^{
            weakScrollView.height = isSelected ? 80: 0;
        }];
    }];
    selectButton.titleLabel.font = FontYT(14);
    [selectButton setTitleColor:kDeepLabelColor forState:UIControlStateNormal];
    [selectButton setTitle:_searchType==SearchTypeActivity ? @"活动" : @"场馆" image:IMG(@"sh_icon_filter_arrow_gray_down") forState:UIControlStateNormal isHorizontal:YES];
    [_searchBgView addSubview:selectButton];
    
    _textField = [[MYTextField alloc] initWithFrame:CGRectMake(60, 0, _searchBgView.width-60, _searchBgView.height)];
    _textField.font = FontYT(14);
    _textField.placeholder = self.searchType==SearchTypeActivity ? @"搜索活动" : @"搜索场馆";
    _textField.maxLength = 20;
    _textField.delegateObject = self;
    _textField.returnKeyType = UIReturnKeySearch;
    _textField.hideKeyboardWhenTapReturnkey = NO;
    [_searchBgView addSubview:_textField];
    
    MYMaskView *lineView = [MYMaskView maskViewWithBgColor:RGB(193, 193, 193) frame:CGRectMake(63, 3, 0.7, _searchBgView.height-6) radius:0];
    [_searchBgView addSubview:lineView];
    
    //下拉的选择视图
    dropDownScrollView.frame = CGRectMake(_searchBgView.originalX+_searchBgView.radius, _searchBgView.maxY-5, lineView.maxX-_searchBgView.radius, 0);
    dropDownScrollView.radius = 5;
    dropDownScrollView.layer.borderColor = ColorFromHex(@"979797").CGColor;
    dropDownScrollView.layer.borderWidth = 0.6;
    dropDownScrollView.backgroundColor = [UIColor whiteColor];
    
    NSArray *titleArray = @[@"活动", @"场馆"];
    
    //8   25  5  25    12
    WS(weakSelf);
    
    for (int i = 0; i < titleArray.count; i++) {
        
        BOOL isSelected = NO;
        
        if (i == 0 && _searchType==SearchTypeActivity) {
            isSelected = YES;
        }else if (i == 1 && _searchType==SearchTypeVenue) {
            isSelected = YES;
        }
        
        FBButton *button = [[FBButton alloc] initWithImage:CGRectMake(0, 13+i*(25+5), dropDownScrollView.width, 25) bgcolor:isSelected ? [UIToolClass colorFromHex:@"F5F5F5"] : [UIColor clearColor] img:nil clickEvent:^(FBButton *owner) {
            
            [selectButton setTitle:owner.currentTitle forState:UIControlStateNormal];
            selectButton.selected = !selectButton.selected;
            selectButton.imageView.transform = selectButton.selected ? CGAffineTransformMakeRotation(M_PI) : CGAffineTransformMakeRotation(0);
            
            [weakSelf  hiddenSelectView:YES];
            if (owner.selected){
                return;
            }
            
            owner.selected = !owner.selected;
            owner.backgroundColor = owner.selected ? [UIToolClass colorFromHex:@"F5F5F5"] : [UIColor clearColor];
            
            UIButton *otherBtn = weakScrollView.subviews[1-owner.tag];
            otherBtn.selected = !owner.selected;
            otherBtn.backgroundColor = otherBtn.selected ? [UIToolClass colorFromHex:@"F5F5F5"] : [UIColor clearColor];
            
            if(owner.tag == 0 && owner.selected){
                _searchType = SearchTypeActivity;
            }else{
                _searchType = SearchTypeVenue;
            }
            _textField.placeholder = _searchType==SearchTypeActivity ? @"搜索活动" : @"搜索场馆";
            
            [weakSelf loadUI];
        }];
        button.titleLabel.font = FontYT(14);
        button.selected = isSelected;
        [button setTitleColor:kLightLabelColor forState:UIControlStateNormal];
        [button setTitleColor:kDeepLabelColor forState:UIControlStateSelected];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        button.tag = i;
        [dropDownScrollView addSubview:button];
    }
    
    MYMaskView *line = [MYMaskView maskViewWithBgColor:[UIColor colorWithCGColor:dropDownScrollView.layer.borderColor] frame:CGRectMake(0, dropDownScrollView.radius, dropDownScrollView.width, 0.6) radius:0];
    [dropDownScrollView addSubview:line];
    

    FBButton * button = [[FBButton alloc] initWithText:MRECT(WIDTH_SCREEN-50, HEIGHT_STATUS_BAR + 6, 50, 30) font:FONT(15) fcolor:COLOR_IWHITE bgcolor:COLOR_CLEAR text:@"取消" clickEvent:^(FBButton *owner) {
        [weakSelf searchBarCancelButtonClicked];
    }];
    [_navView addSubview:button];
    
    _scrollView.frame = MRECT(0, kScreenHeight, WIDTH_SCREEN, HEIGHT_SCREEN_FULL - HEIGHT_NAVIGATION_BAR - HEIGHT_STATUS_BAR);
}


#pragma mark - 请求数据

// 热门词汇
- (void)loadData {
    WS(weakSelf);
    for (int i = 0; i < 2; i++) {
        DataType type = DataTypeUnknown;
        if (i == 0) {
            type = DataTypeActivity;
        }else if ( i == 1) {
            type = DataTypeVenue;
        }
        
        [AppProtocol getSearchHotTagWithDataType:type cacheMode:CACHE_MODE_HALFREALTIME_SHORT UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
            
            [SVProgressHUD dismiss];
            if (responseCode == HttpResponseSuccess)  {
                if (i == 0) {
                    _hotKeyActivityArray = responseObject;
                }else {
                    _hotKeyVenueArray = responseObject;
                }
            }
            
            if (_searchType == SearchTypeActivity){
                
                if (i == 0) {
                    [weakSelf loadUI];
                }
            }else{
                if (i == 1) {
                    [weakSelf loadUI];
                }
            }
        }];
    }
}

// 搜索联想词
- (void)loadMatchedWordDataWithKey:(NSString *)keyword
{
    WS(weakSelf);
    WEAK_VIEW(_textField);
    [AppProtocol getSearchMatchedWordsWithKeyword:keyword UsingBlock:^(HttpResponseCode responseCode, id responseObject)
    {
        if (responseCode == HttpResponseSuccess) {
            
            if ([weakView.text rangeOfString:keyword].location != NSNotFound) {
                
                [_matchedWords removeAllObjects];
                [_matchedWords addObjectsFromArray:responseObject];
                
                [weakSelf updateMatchedWordScrollView];
            }
        }
    }];
}


-(void)loadUI
{
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    NSArray *dataArray = _searchType==SearchTypeActivity ? _hotKeyActivityArray : _hotKeyVenueArray;
    
    UIView * hotSearchView = [self getSearchGroupView:@"热门搜索" labelArray:dataArray];
    [_scrollView addSubview:hotSearchView];
    
    CGFloat viewHeight = HEIGHT_TITLE + [ToolClass  getGroupNum:dataArray.count perGroupCount:_rowItemNumber] * (HEIGHT_BUTTON + HEIGHT_BUTTON_SPAN);
    
    [hotSearchView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@0);
        make.centerX.equalTo(_scrollView);
        make.left.equalTo(@0);
        make.height.equalTo(@(viewHeight));
    }];
    
    MYMaskView *line1 = [MYMaskView maskViewWithBgColor:COLOR_GRAY_LINE frame:CGRectZero radius:0];
    line1.backgroundColor = kBgColor;
    [_scrollView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hotSearchView.mas_bottom).offset(20);
        make.left.equalTo(@0);
        make.width.equalTo(@(kScreenWidth));
        make.centerX.equalTo(_scrollView);
        make.height.equalTo(@(8));
    }];
   
    _searchHistoryView = [UIView new];
    [_scrollView addSubview:_searchHistoryView];
    
    [_searchHistoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.centerX.equalTo(_scrollView);
        make.top.equalTo(line1.mas_bottom).offset(10);
        make.bottom.equalTo(_scrollView.mas_bottom).offset(0);
    }];
   
    [self updateHistoryView];
}


-(void)updateHistoryView
{
    cacheTool.cacheType = UserDataCacheToolTypeSearchHistory;
    
    [_searchHistoryView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSArray * array = [cacheTool getAllSearchHistory];
    if (array.count < 1) {
        return;
    }
    
    if (_searchHistoryView) {
        [_searchHistoryView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(120+array.count*42));
        }];
    }
    
    WS(weakSelf);
    FBLabel * titleLabel = [[FBLabel alloc] initWithStyle:CGRectZero font:FONT_BIG fcolor:kDeepLabelColor text:@"历史搜索"];
    [_searchHistoryView addSubview:titleLabel];
    __weak UIView * weakView = _searchHistoryView;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@20);
        make.left.equalTo(@22.5);
        
    }];
    __weak FBButton * weakButton = nil;
    for (int i=0; i<array.count; i++)
    {
        FBButton * button = [[FBButton alloc] initWithText:CGRectZero font:FONT_BIG fcolor:kLightLabelColor bgcolor:COLOR_CLEAR text:array[i] clickEvent:^(FBButton *owner) {
            
            NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithCapacity:1];
            dic[@"searchKey"]  = array[i];
            [weakSelf search:dic];
            
        }];
        [_searchHistoryView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (weakButton)
            {
                make.top.equalTo(weakButton.mas_bottom).offset(1);
                
            }
            else
            {
                make.top.equalTo(titleLabel.mas_bottom).offset(12);
            }
            make.left.equalTo(@22.5);
            make.height.equalTo(@42);
            make.centerX.equalTo(weakView);
            
            
        }];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        weakButton = button;
        if(i < (array.count - 1))
        {
            MYMaskView *line = [MYMaskView maskViewWithBgColor:COLOR_GRAY_LINE frame:CGRectZero radius:0];
            [weakView addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(@10);
                make.top.equalTo(weakButton.mas_bottom).offset(0);
                make.centerX.equalTo(weakView);
                make.height.equalTo(@(kLineThick));
            }];
        }
        
    }
    if (array.count > 0)
    {
        FBButton * cleanButton = [[FBButton alloc] initWithText:CGRectZero font:FONT_BIG fcolor:kNavigationBarColor bgcolor:COLOR_CLEAR text:@"清空历史记录" clickEvent:^(FBButton *owner) {
            
            [cacheTool deleteAllItems];
            [weakSelf updateHistoryView];
        }];
        [cleanButton setImage:IMG(@"icon_delete") forState:UIControlStateNormal];
        CGFloat textHeight = [UIToolClass fontHeight:cleanButton.titleLabel.font];
        CGSize imgSize = [cleanButton currentImage].size;
        
        cleanButton.titleEdgeInsets = UIEdgeInsetsMake(0.5*imgSize.height, 0.5*imgSize.width, -0.5*imgSize.height, -0.5*imgSize.width);
        cleanButton.imageEdgeInsets = UIEdgeInsetsMake(0.5*textHeight, 4, -0.5*textHeight, -4);
        
        [weakView addSubview:cleanButton];
        [cleanButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(weakView);
            make.top.equalTo(weakButton.mas_bottom).offset(18);
            make.size.mas_equalTo(CGSizeMake(130, 20));
            
        }];
    }
}


- (void)updateMatchedWordScrollView
{
    [_matchedWordScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat btnHeight = 50;
    for (int i = 0; i < _matchedWords.count; i++) {
        NSString *title  = _matchedWords[i];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(25, i*btnHeight, _matchedWordScrollView.width-45, btnHeight)];
        button.titleLabel.font = FontYT(14);
        [button setTitleColor:kLightLabelColor forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_matchedWordScrollView addSubview:button];
        
        
        if (i == _matchedWords.count-1) {
            _matchedWordScrollView.contentSize = CGSizeMake(_matchedWordScrollView.width, button.maxY + 20);
        }else{
            MYMaskView *lineView = [MYMaskView maskViewWithBgColor:COLOR_GRAY_LINE frame:CGRectMake(10, button.maxY-0.6, _matchedWordScrollView.width-20, kLineThick) radius:0];
            [_matchedWordScrollView addSubview:lineView];
        }
    }
    
    if (_matchedWords.count && _matchedWordScrollView.height < 10) {
        [self matchedWordViewAnimation:YES duration:0.25];
    }
    
    if (_matchedWords.count == 0) {
        [self matchedWordViewAnimation:NO duration:0.1];
    }
}


-(UIView *)getSearchGroupView:(NSString * )title labelArray:(NSArray *)array
{
    UIView * view = [UIView new];
    view.tag = 1;// 0:展开 1：收起
    view.clipsToBounds = YES;
    __weak UIView * weakView = view;
    
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"▎%@",title]];
    [attrStr setAttributes:@{NSForegroundColorAttributeName:kThemeDeepColor} range:NSMakeRange(0, 1)];
    UILabel * titleLabel = [UILabel new];
    titleLabel.backgroundColor = COLOR_CLEAR;
    titleLabel.font = FONT_BIG;
    titleLabel.attributedText = attrStr;
    [view addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(@20);
    }];
    
    // 不再需要收缩起来
    if(array.count > _rowItemNumber)
    {
//        FBButton * expandButton = [[FBButton alloc] initWithText:CGRectZero font:nil fcolor:COLOR_CLEAR bgcolor:COLOR_CLEAR text:@"" clickEvent:^(FBButton *owner) {
//            
//            [UIView animateWithDuration:0.5f animations:^{
//                
//                if (weakView.tag == 0)
//                {//收起
//                    weakView.tag = 1;
//                    [weakView mas_updateConstraints:^(MASConstraintMaker *make) {
//                        
//                        make.height.equalTo(@(HEIGHT_TITLE + HEIGHT_BUTTON + HEIGHT_BUTTON_SPAN));
//                    }];
//                    UILabel *label =  owner.subviews[1];
//                    label.text  = @"展开";
//                }
//                else
//                {//展开
//                    weakView.tag = 0;
//                    [weakView mas_updateConstraints:^(MASConstraintMaker *make) {
//                        
//                        make.height.equalTo(@(HEIGHT_TITLE + [ToolClass  getGroupNum:array.count perGroupCount:_rowItemNumber] * (HEIGHT_BUTTON + HEIGHT_BUTTON_SPAN)));
//                    }];
//                    UILabel *label =  owner.subviews[1];
//                    label.text  = @"收起";
//                }
//                
//                if (weakView.superview)
//                {
//                    [weakView.superview layoutIfNeeded];
//                }
//                
//            }];
//            
//        }];
//        [view addSubview:expandButton];
//        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 47, 22)];
//        label.text = @"展开";
//        label.textAlignment = NSTextAlignmentCenter;
//        label.font = FONT_BIG;
//        label.textColor = kNavigationBarColor;
//        label.layer.borderColor = kNavigationBarColor.CGColor;
//        label.layer.borderWidth = 0.5;
//        label.radius = label.height*0.5;
//        [expandButton addSubview:label];
//        label.center = CGPointMake(67*0.5, 20);
//        
//        [expandButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(67, 40));
//            make.centerY.equalTo(titleLabel);
//            make.right.equalTo(weakView).offset(0);
//        }];
   
    }
    
    MYMaskView *line = [MYMaskView maskViewWithBgColor:COLOR_GRAY_LINE frame:CGRectZero radius:0];
    line.backgroundColor = kLineGrayColor;
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@(kLineThick));
        make.centerX.equalTo(weakView);
        make.top.equalTo(@48);
        make.left.equalTo(@10);
        
    }];
    
    int buttonWidth = (WIDTH_SCREEN-(_rowItemNumber+1)*10)*1.0/_rowItemNumber;
    NSString * hottitle = nil;
    for (int i=0; i<array.count; i++)
    {
        id obj = array[i];
        SearchTag * searchTag = nil;
        SearchLocationTag * locationTag = nil;
        SearchHotKeyModel * hotKeyModel = nil;
        
        if ([obj isKindOfClass:[SearchTag class]])
        {
            searchTag = (SearchTag *)obj;
            hottitle = searchTag.tagName;
        }
        else if([obj isKindOfClass:[SearchLocationTag class ]])
        {
            locationTag = (SearchLocationTag *)obj;
            hottitle = locationTag.areaName;
        }
        else if([obj isKindOfClass:[SearchHotKeyModel class ]])
        {
            hotKeyModel = (SearchHotKeyModel *)obj;
            hottitle = hotKeyModel.hotKey;
        }
        
        WS(weakSelf);
        FBButton * button = [[FBButton alloc] initWithText:MRECT(10+i%_rowItemNumber*(10+buttonWidth), HEIGHT_TITLE + (i/_rowItemNumber) * (HEIGHT_BUTTON_SPAN + HEIGHT_BUTTON), buttonWidth, HEIGHT_BUTTON) font:FONT(14) fcolor:ColorFromHex(@"7C7C7C") bgcolor:COLOR_CLEAR text:hottitle clickEvent:^(FBButton *owner) {
           
            NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithCapacity:1];
            if (searchTag)
            {
                dic[@"modelType"]  = searchTag.tagId;
            }
            else if(locationTag)
            {
                dic[@"modelArea"]  = locationTag.areaCode;
            }
            else if(hotKeyModel)
            {
                dic[@"searchKey"]  = hottitle;
            }
            [weakSelf search:dic];
            
        }];
        button.titleLabel.numberOfLines = 2;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [ToolClass setButtonTitle:button.currentTitle defaultFontSize:14 forState:UIControlStateNormal withButton:&button];
        button.radius = 4;
        button.layer.borderColor = ColorFromHex(@"7C7C7C").CGColor;
        button.layer.borderWidth  = .5f;
        button.clipsToBounds = YES;
        [view addSubview:button];
    }
    return view;
    
}


-(void)search:(NSDictionary * )dic
{
    [self.view endEditing:YES];
    [self hiddenSelectView:YES];
//    [self matchedWordViewAnimation:NO duration:0.25];
    
    SearchDetailViewController * vc = [SearchDetailViewController new];
    vc.searchType = (SearchType)_searchType;
    vc.parameterDict = dic;
    vc.hiddenPopAnimation = YES;
    
    WS(weakSelf);
    [self dismissWithAnimation:^(id object, NSInteger index, BOOL isSameIndex) {
        [weakSelf.navigationController pushViewController:vc animated:NO];
    }];
}



- (void)buttonClick:(UIButton *)sender
{
    NSString *searchKey = sender.currentTitle.length ? sender.currentTitle : @"";
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:searchKey, @"searchKey", nil];
    
    [self search:dict];
}


#pragma mark - Other Methods



// 取消
-(void)searchBarCancelButtonClicked
{
    [self.view endEditing:YES];
    [self hiddenSelectView:YES];
//    [self matchedWordViewAnimation:NO duration:0.25];
    
     WS(weakSelf);
    [self dismissWithAnimation:^(id object, NSInteger index, BOOL isSameIndex) {
        if (weakSelf.view.subviews.count) {
            [weakSelf.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
        [weakSelf.navigationController popViewControllerAnimated:NO];
    }];
}

- (void)textInputViewTextDidChange:(MYTextField *)inputView {
    if (inputView.markedTextRange || [inputView.text isEqualToString:_lastKeyword]) {
        return;
    }
    
    if (inputView.text.length) {
        [self loadMatchedWordDataWithKey:inputView.text];
    }else {
        [_matchedWordScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self matchedWordViewAnimation:NO duration:0];
    }
    
    _lastKeyword = inputView.text;
}

// 输入关键词搜索
- (void)textInputViewDidClickReturnKey:(MYTextField *)textField
{
    [self.view endEditing:YES];
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    dic[@"searchKey"]  = textField.text;
    
    cacheTool.cacheType = UserDataCacheToolTypeSearchHistory;
    
    [cacheTool addItemByKeyword:textField.text];
    [self updateHistoryView];
    [self search:dic];
    textField.text = @"";
}


- (void)keyboardWillShow:(NSNotification *)notification
{
    [super keyboardWillShow:notification];
    
    CGRect endFrame = [[[notification userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    double animationDuration = [[[notification userInfo] objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    
    _matchedWordViewHeight = kScreenHeight-endFrame.size.height-10-_navView.height;
    if (_matchedWords.count) {
        [self matchedWordViewAnimation:YES duration:animationDuration];
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification
{
    [super keyboardWillBeHidden:aNotification];
    
    double animationDuration = [[[aNotification userInfo] objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    
    [self matchedWordViewAnimation:NO duration:animationDuration];
}


- (void)hiddenSelectView:(BOOL)animated
{
    if (animated) {
        __weak UIScrollView *weakScrollView = _dropDownScrollView;
        [UIView animateWithDuration:0.25 animations:^{
            weakScrollView.height = 0;
        }];
    }else{
        _dropDownScrollView.height = 0;
    }
}

// 联想词视图展开与折叠动画
- (void)matchedWordViewAnimation:(BOOL)isShow duration:(CGFloat)duration
{
    CGFloat height = isShow ? _matchedWordViewHeight : 0;
    
    if (isShow) {
        _scrollView.hidden = YES;
        WEAK_VIEW(_matchedWordScrollView);
        [UIView animateWithDuration:duration animations:^{
            weakView.height = height;
        }];
    }else {
        _scrollView.hidden = NO;
        _matchedWordScrollView.height = 0;
    }
}


- (void)showWithAnimation
{
    WEAK_VIEW1(_navView);
    WEAK_VIEW2(_searchBgView);
    WEAK_VIEW3(_scrollView);
    WEAK_VIEW4(_dropDownScrollView);
    
    [UIView animateWithDuration:0.35 animations:^{
        
        weakView1.alpha = 1;
        weakView1.originalY = 0;
        weakView2.originalY = weakView1.originalY + HEIGHT_STATUS_BAR +  6;
        weakView4.originalY = weakView2.maxY-5;
        
        weakView3.originalY = weakView1.height;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissWithAnimation:(IndexBlock)block
{
    WEAK_VIEW1(_navView);
    WEAK_VIEW2(_searchBgView);
    WEAK_VIEW3(_scrollView);
    WEAK_VIEW4(_dropDownScrollView);
    
    [UIView animateWithDuration:0.30 animations:^{
        weakView1.alpha = 0;
        weakView1.originalY = -weakView1.height;
        weakView2.originalY = weakView1.originalY + 26;
        weakView4.originalY = weakView2.maxY-5;
        
        weakView3.originalY = kScreenHeight;
    } completion:^(BOOL finished) {
        if (block) {
            block(nil,0,NO);
        }
    }];
}

- (void)tagGesture:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
