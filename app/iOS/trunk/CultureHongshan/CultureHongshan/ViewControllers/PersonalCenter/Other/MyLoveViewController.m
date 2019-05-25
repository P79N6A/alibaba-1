//
//  MyLoveViewController.m
//  CultureHongshan
//
//  Created by 刘行 on 16/1/8.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "MyLoveViewController.h"

#import "UIButton+WebCache.h"

#import "DictionaryService.h"

#import "ActivityListViewController.h"

#import "UserTagServices.h"
#import "CitySwitchModel.h"

@interface MyLoveViewController ()
{
    NSDictionary *_parameterDict;
    UIScrollView *_backgroundScrool;
    UIButton *_selectAllButton;
    
    BOOL _isTagSelected[80];
    
    BOOL _isLocalTagData;
    
    CGFloat _scrollViewBottom;
    
    NSString *_recommendTagId;//推荐标签id
    
    NSInteger _numberOfSelectedTag;
}


@property (strong, nonatomic) UIView *tagView;

@property (strong, nonatomic) UIButton *enterButton;

@property (strong, nonatomic) NSMutableArray *selectedBtnArr;

@property (nonatomic , strong) NSArray *themeTagArray;

@end



@implementation MyLoveViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    self.statusBarIsBlack = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [super viewWillDisappear:animated];
    
    self.statusBarIsBlack = NO;
    
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad
{
    self.view.backgroundColor = kBgColor;
    
    
    [super viewDidLoad];
    
    [self initNavgationBar];
    
    [self startRequestTagData];
}



- (void)initNavgationBar
{
    _selectAllButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-17.5-100, 0, 100, 50)];
    [_selectAllButton addTarget:self action:@selector(selectAllButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_selectAllButton];
    _selectAllButton.selected = NO;
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, [UIToolClass fontHeight:FONT(13                                                                                                              )]+6)];
    titleLabel.tag = 1;
    titleLabel.radius = 7.5;
    titleLabel.layer.borderColor = kThemeDeepColor.CGColor;
    titleLabel.layer.borderWidth = .5f;
    titleLabel.font = FONT(13);
    titleLabel.textColor = kThemeDeepColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_selectAllButton addSubview:titleLabel];
    titleLabel.centerY = _selectAllButton.height*0.5;
    
    
    [self setSelectAllBtnStatus:NO];
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(7, HEIGHT_STATUS_BAR+3, 50, 50)];
    [backBtn setImage:IMG(@"icon_return_gray") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    _selectAllButton.centerY = backBtn.centerY;
}


#pragma mark - 获取主题和类型标签的数据
- (void)startRequestTagData
{
    [SVProgressHUD showLoading];
    WS(weakSelf)
    [AppProtocol getTagListOfActivityWithUserId:[UserService sharedService].userId UsingBlock:^(HttpResponseCode responseCode, id responseObject)
     {
         [SVProgressHUD dismiss];
         
         if (responseCode == HttpResponseSuccess) {
             NSArray *array = [ThemeTagModel listArrayWithArray:responseObject];
             _themeTagArray = array[1];
             _recommendTagId = array[0];
             [weakSelf setupTagStatus];
             [weakSelf createTagView];
         }else {
             [WHYAlertActionUtil showAlertWithTitle:@"温馨提示" msg:@"网络开小差了，请稍后再试!" actionBlock:^(NSInteger index, NSString *buttonTitle) {
                 [weakSelf.navigationController popViewControllerAnimated:YES];
             } buttonTitles:@"确定", nil];
         }
     }];
}

- (void)setupTagStatus
{
    _numberOfSelectedTag = 0;
    
    NSArray *array = [DictionaryService getUserActTagsWithFirstTitle:nil]; // 用户已经选中的标签
    
    for (int i = 0; i < _themeTagArray.count; i++)
    {
        ThemeTagModel *themeTag = _themeTagArray[i];
        if (array.count > 0) {//使用本地的数据
            _isTagSelected[i] = NO;
            for (int j = 0; j < array.count; j++)
            {
                ThemeTagModel *model = array[j];
                if ([model.tagId isEqualToString:themeTag.tagId]) {
                    _isTagSelected[i] = YES;
                    break;
                }
            }
            if (_isTagSelected[i]) {
                _numberOfSelectedTag++;
            }
        }else{
            _isTagSelected[i] = ([themeTag.status intValue] == 1) ? YES : NO;
            if (_isTagSelected[i])
            {
                _numberOfSelectedTag++;
            }
        }
    }
    _selectAllButton.selected = _numberOfSelectedTag == _themeTagArray.count;
    [self setSelectAllBtnStatus:_selectAllButton.selected];
}

#pragma mark - 创建标签按钮
- (void)createTagView
{
    _scrollViewBottom = kScreenHeight - 80 - 40;//“确定”按钮的高度为40
    
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _selectAllButton.maxY + 38, kScreenWidth, [UIToolClass fontHeight:FONT(17)])];
    titleLabel.font = FONT(17);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"选择您感兴趣的主题";
    titleLabel.textColor = kDeepLabelColor;
    [self.view addSubview:titleLabel];
    
    //分割线
    MYMaskView *lineView = [MYMaskView maskViewWithBgColor:ColorFromHex(@"CCCCCC") frame:CGRectMake(10, titleLabel.maxY+10, kScreenWidth-20, 0.5) radius:0];
    [self.view addSubview:lineView];
    
    //标签滚动视图
    _backgroundScrool = [[UIScrollView alloc] initWithFrame:CGRectMake(0, lineView.maxY + 25, kScreenWidth, kScreenHeight-90-titleLabel.frame.origin.y-50)];
    _backgroundScrool.showsVerticalScrollIndicator = YES;
    [self.view addSubview:_backgroundScrool];
    
    int tagFontNumber = 17;
    if (kScreenWidth < 321)
    {
        tagFontNumber = 15;
    }
    
    //添加tag按钮
    CGFloat offsetY = 10;
    CGFloat spacingX = 10;
    CGFloat spacingY = 25;
    int number = 0;
    CGFloat btnWidth = [ToolClass getElementWidthWithMinWidth:[UIToolClass textWidth:@"旅游" font:FontYT(14)]+30 elementSpacing:spacingX containerWidth:kScreenWidth-2*spacingX elementNum:&number];
    CGFloat btnHeight = [UIToolClass fontHeight:FONT(tagFontNumber)]+14;
    
    //最后一行按钮的maxY
    CGFloat btnMaxY = _backgroundScrool.originalX + 100;
    
    for (int i = 0; i < _themeTagArray.count; i++)
    {
        UIButton *tagButton = [[UIButton alloc] initWithFrame:CGRectMake(spacingX+i%number*(btnWidth+spacingX), offsetY + i/number*(btnHeight+spacingY), btnWidth, btnHeight)];
        tagButton.backgroundColor = [UIColor whiteColor];
        tagButton.radius = 3;
        tagButton.layer.borderWidth = .5f;
        tagButton.tag = 1000+i;
        [tagButton addTarget:self action:@selector(tagClick:) forControlEvents:UIControlEventTouchUpInside];
        [_backgroundScrool addSubview:tagButton];
        
        ThemeTagModel *model = _themeTagArray[i];
        [tagButton setTitle:model.tagName forState:UIControlStateNormal];
        tagButton.titleLabel.font = FONT(14);
        [self setTagButtonWithButton:tagButton selected:_isTagSelected[i]];
        
        //设置滚动视图的contentSize
        if (i == _themeTagArray.count - 1)
        {
            btnMaxY = tagButton.maxY;
        }
    }
    
    _backgroundScrool.contentSize = CGSizeMake(_backgroundScrool.bounds.size.width, btnMaxY+15);
    
    if (_backgroundScrool.contentSize.height + _backgroundScrool.originalY > _scrollViewBottom)
    {
        _backgroundScrool.height = _scrollViewBottom - _backgroundScrool.originalY;
    }
    else
    {
        _backgroundScrool.height = _backgroundScrool.contentSize.height;
    }
    
    self.enterButton = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth-135)/2, CGRectGetMaxY(_backgroundScrool.frame) + 40, 135, 40)];
    [self.enterButton setTitle:@"确 定" forState:UIControlStateNormal];
    _enterButton.layer.borderWidth = 1;
    self.enterButton.radius = 5;
    [self.enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.enterButton.titleLabel.font = FONT(17);
    [self.enterButton addTarget:self action:@selector(enterClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.enterButton];
    
    if (_numberOfSelectedTag < 1)
    {
        [self enterButtonColorSetting:NO];
    }
    else
    {
        [self enterButtonColorSetting:YES];
    }
    
    //[self initNavgationBar];
}


- (void)back:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)tagClick:(UIButton *)btn
{
    if (_isTagSelected[btn.tag-1000])//原来是选中的 -1
    {
        _numberOfSelectedTag -= 1;
    }
    else//原来是未选中的 +1
    {
        _numberOfSelectedTag += 1;
    }
    
    if (_numberOfSelectedTag < 1)
    {
        [self enterButtonColorSetting:NO];
    }
    else
    {
        [self enterButtonColorSetting:YES];
    }
    
    _isTagSelected[btn.tag-1000] = !_isTagSelected[btn.tag-1000];
    
    
    [self setTagButtonWithButton:btn selected:_isTagSelected[btn.tag-1000]];
    
    if (_numberOfSelectedTag == _themeTagArray.count)
    {
        _selectAllButton.selected = YES;
        [self setSelectAllBtnStatus:YES];
    }
    else
    {
        _selectAllButton.selected = NO;
        [self setSelectAllBtnStatus:NO];
    }
}




- (void)selectAllButtonClick:(UIButton *)sender
{
    if (_backgroundScrool.subviews.count < 1 || _themeTagArray.count < 1)
    {
        return;
    }
    sender.selected = !sender.selected;//默认为NO，显示的标题为“全选”
    
    if (sender.selected)
    {
        [self setSelectAllBtnStatus:YES];
        //全选
        for (int i = 0; i < _themeTagArray.count; i++)
        {
            _isTagSelected[i] = YES;
        }
        _numberOfSelectedTag = _themeTagArray.count;
        if (_numberOfSelectedTag)
        {
            [self enterButtonColorSetting:YES];
        }
        else
        {
            [self enterButtonColorSetting:NO];
        }
        
        for (UIButton *tagButton in _backgroundScrool.subviews)
        {
            [self setTagButtonWithButton:tagButton selected:YES];
        }
    }
    else//取消全选
    {
        [self setSelectAllBtnStatus:NO];
        
        for (int i = 0; i < _themeTagArray.count; i++)
        {
            _isTagSelected[i] = NO;
        }
        
        for (UIButton *tagButton in _backgroundScrool.subviews)
        {
            [self setTagButtonWithButton:tagButton selected:NO];
        }
        _numberOfSelectedTag = 0;
        
        if (_numberOfSelectedTag)
        {
            [self enterButtonColorSetting:YES];
        }
        else
        {
            [self enterButtonColorSetting:NO];
        }
    }
}



- (void)enterButtonColorSetting:(BOOL)status
{
    if (status)
    {
        _enterButton.userInteractionEnabled = YES;
        [_enterButton setTitleColor:kThemeDeepColor forState:UIControlStateNormal];
        _enterButton.backgroundColor = [UIColor whiteColor];
        _enterButton.layer.borderColor = kThemeDeepColor.CGColor;
    }
    else
    {
        _enterButton.userInteractionEnabled = YES;
        [_enterButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _enterButton.backgroundColor = [UIColor lightGrayColor];
        _enterButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
}

/**
 * isAllSelected为YES时，标题为"取消全选",_selectAllButton.selected默认为NO
 */
- (void)setSelectAllBtnStatus:(BOOL)isAllSelected
{
    NSString *btnTitle = isAllSelected && _themeTagArray.count ? @"取消全选" : @"全选";
    CGFloat width = [UIToolClass textWidth:btnTitle font:FONT(13)]+ 14;
    UILabel *titleLabel = [_selectAllButton viewWithTag:1];
    titleLabel.text = btnTitle;
    titleLabel.width = width;
    titleLabel.originalX = _selectAllButton.width-width;
}


- (void)setTagButtonWithButton:(UIButton *)button selected:(BOOL)selected
{
    if (![button isKindOfClass:[UIButton class]]){
        return;
    }
    
    if (selected)
    {
        button.backgroundColor = kThemeDeepColor;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.borderColor = kThemeDeepColor.CGColor;
    }
    else
    {
        button.backgroundColor = [UIColor clearColor];
        [button setTitleColor:ColorFromHex(@"7C7C7C") forState:UIControlStateNormal];
        button.layer.borderColor = ColorFromHex(@"BABABA").CGColor;
    }
}


#pragma mark - Go按钮

- (void)enterClick:(UIButton *)button
{
    if (_numberOfSelectedTag < 1)
    {
        [SVProgressHUD showInfoWithStatus:@"请至少选择一个主题后，再来点我吧^_^"];
        return;
    }
    
    [self postThedata:[self getSelectedTagId]];
}


- (NSString *)getSelectedTagId
{
    if (_themeTagArray.count < 1)
    {
        return @"";
    }
    
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < _themeTagArray.count; i++)
    {
        if (_isTagSelected[i])
        {
            ThemeTagModel *themeTag = _themeTagArray[i];
            if (themeTag.tagId.length)
            {
                [tmpArray addObject:themeTag.tagId];
            }
        }
    }
    NSString *string = [tmpArray componentsJoinedByString:@","];
    return string.length ? string : @"";
}



- (void)postThedata:(NSString *)tagstr
{
    NSString *userId = [UserService sharedService].userId;
    
    if (userId.length < 1)
    {
        [self uploadSuccess];
        return;
    }
    
    WS(weakSelf)
    [AppProtocol uploadUserTagsWithUserSelectedTags:tagstr UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        
        if (responseCode == HttpResponseSuccess) {
            [SVProgressHUD showInfoWithStatus:responseObject];
            [weakSelf uploadSuccess];
        } else {
            [SVProgressHUD showInfoWithStatus:responseObject]; // @"未能成功添加，请检查网络后再试!"
        }
    }];
}

#pragma mark - 保存用户选择的标签
- (void)saveUserSelectedTag
{
    NSMutableArray *themeTagArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < _themeTagArray.count; i++)
    {
        if (_isTagSelected[i])
        {
            ThemeTagModel *model = _themeTagArray[i];
            
            if (model.tagId.length && model.tagName.length)
            {
                NSDictionary *dict = [[NSDictionary alloc] initWithObjects:@[model.tagId,model.tagName] forKeys:@[@"tagId",@"tagName"]];
                [themeTagArray addObject:dict];
            }
        }
    }
    
    NSString *jsonTag = [ToolClass jsonActTagsForTagArray:themeTagArray isServerTag:NO];
    
    [[UserTagServices getInstance] saveUserTag:[UserService sharedService].userId citycode:CITY_AD_CODE tagcontent:jsonTag];
}



- (void)uploadSuccess
{
    [self saveUserSelectedTag];
    
    NSArray *navArray = self.navigationController.parentViewController.childViewControllers;
    if (navArray.count > 1) {
        
        UINavigationController *navController2 = navArray[1];
        ActivityListViewController *nearVC = navController2.viewControllers[0];
        [nearVC setNeedUpdateSelectTagView:YES];
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
