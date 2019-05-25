//
//  ActivityRoomBookViewController.m
//  CultureHongshan
//
//  Created by ct on 16/6/3.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "ActivityRoomBookViewController.h"

#import "MYTextInputView.h"

#import "ActivityRoomBookModel.h"

#import "ActivityRoomBookSuccessViewController.h"


#define kHeight  42

@interface ActivityRoomBookViewController ()<UIScrollViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource, MYTextInputViewDelegate>
{
    UIScrollView *_bgScrollView;
    UIScrollView *_promptScrollView;//选择使用者的弹窗
    
    MYTextField *_roomUserTF;//使用者
    MYTextField *_roomBookerTF;//预订联系人
    MYTextField *_bookerTelTF;//联系人手机
    MYTextView *_textView;//预订用途
    
    UIButton *_userSelectButton;
    UIPickerView *_pickerView;
    
    
    NSInteger _selecteduserIndex;
    CGFloat _leftWidth;
    CGFloat _rightWidth;
}

@end

@implementation ActivityRoomBookViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    _hasInputView = YES;
    self.navigationItem.title = @"活动室预订";
    self.view.backgroundColor = kBgColor;
    _selecteduserIndex = -1;
    
    _leftWidth = [UIToolClass textWidth:@"预订联系人：" font:FontYT(15)]+1;
    _rightWidth = kScreenWidth-2*8-_leftWidth-5;
    
    
    [self initScrollView];
    [self initScrollViewSubviews];
    [self initBottomView];
}


- (void)initScrollView
{
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-HEIGHT_TOP_BAR-50-HEIGHT_HOME_INDICATOR)];
    _bgScrollView.backgroundColor = [UIColor whiteColor];
    _bgScrollView.showsVerticalScrollIndicator = NO;
    _bgScrollView.delegate = self;
    [self.view addSubview:_bgScrollView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandle:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [_bgScrollView addGestureRecognizer:tapGesture];
    
    MYMaskView *topBgView = [MYMaskView maskViewWithBgColor:kBgColor frame:CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenHeight) radius:9];
    [_bgScrollView addSubview:topBgView];
}

- (void)initScrollViewSubviews
{
    CGFloat position = [self creatTitleView];//活动室的基本信息
    position = [self creatDateInfoView:position];//活动室的日期、场次信息等
    position = [self creatContactInfoView:position];//活动室预订的联系人信息等
    
    _bgScrollView.contentSize = CGSizeMake(_bgScrollView.width, MAX(position, _bgScrollView.height + 40));
}

- (void)initBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(-1, _bgScrollView.maxY, kScreenWidth+2, 52)];
    bottomView.layer.borderWidth = 0.6;
    bottomView.layer.borderColor = RGB(225, 225, 225).CGColor;
    bottomView.backgroundColor = kBgColor;
    [self.view addSubview:bottomView];
    
    CGFloat offsetX = 0;
    if (_model.requiredScore > 0 ) {
        UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, kScreenWidth*0.58, 50)];
        moneyLabel.font = FontYT(17);
        moneyLabel.textColor = [UIToolClass colorFromHex:@"262626"];
        NSString *moneyStr = [NSString stringWithFormat:@"积分抵扣:%@积分",StrFromInt(_model.requiredScore)];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:moneyStr];
        [attributedString addAttributes:@{NSForegroundColorAttributeName:kDeepLabelColor, NSFontAttributeName:FontYT(17)} range:NSMakeRange(0, 5)];
        [attributedString addAttributes:@{NSForegroundColorAttributeName:ColorFromHex(@"C05459"), NSFontAttributeName:FontYT(17)} range:NSMakeRange(5, moneyStr.length-2-5)];
        [attributedString addAttributes:@{NSForegroundColorAttributeName:kDeepLabelColor, NSFontAttributeName:FontYT(12)} range:NSMakeRange(moneyStr.length-2, 2)];
        moneyLabel.attributedText = attributedString;
        [bottomView addSubview:moneyLabel];
        offsetX = moneyLabel.maxX+8;
    }
    
    UIButton *reserveBtn = [[UIButton alloc] initWithFrame:CGRectMake(offsetX, 0, kScreenWidth-offsetX+2, 50)];
    reserveBtn.backgroundColor = kThemeDeepColor;
    reserveBtn.titleLabel.font = FontSystemBold(18);
    [reserveBtn setTitle:@"确认预订" forState:UIControlStateNormal];
    [reserveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [reserveBtn addTarget:self action:@selector(reserveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:reserveBtn];
}

//活动室的基本信息
- (CGFloat)creatTitleView
{
    CGFloat picHeight = 85;
    
    //按钮
    UIButton *titleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, picHeight+2*15)];
    titleButton.userInteractionEnabled = NO;
    [_bgScrollView addSubview:titleButton];
    
    //图片
    UIImageView *picView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 15, picHeight*1.5, picHeight)];
    UIImage *placeImg = [UIToolClass getPlaceholderWithViewSize:picView.viewSize centerSize:CGSizeMake(25, 25) isBorder:YES];
    [picView sd_setImageWithURL:[NSURL URLWithString:JointedImageURL(_model.roomPicUrl, kImageSize_750_500)] placeholderImage:placeImg];
    [titleButton addSubview:picView];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(picView.maxX+8, picView.originalY, kScreenWidth-8-picView.maxX-8, 0)];
    titleLabel.numberOfLines = 0;
    titleLabel.font = FontYT(17);
    titleLabel.textColor = [UIToolClass colorFromHex:@"262626"];
    titleLabel.attributedText = [UIToolClass getAttributedStr:_model.roomName font:titleLabel.font lineSpacing:4];
    titleLabel.height = [UIToolClass textHeight:_model.roomName lineSpacing:4 font:titleLabel.font width:titleLabel.width maxRow:2];
    [titleButton addSubview:titleLabel];
    
    //位置图标
    UIImageView *locationView = [[UIImageView alloc] initWithFrame:CGRectMake(titleLabel.originalX, titleLabel.maxY+9, 12, 16)];
    locationView.image = IMG(@"icon_mapon");
    [titleButton addSubview:locationView];
    
    //地址或场馆名
    UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(locationView.maxX+5, titleLabel.maxY+10, kScreenWidth-8-locationView.maxX-5, 0)];
    locationLabel.numberOfLines = 0;
    locationLabel.font = FontYT(13);
    locationLabel.textColor = kLightLabelColor;
    locationLabel.attributedText = [UIToolClass getAttributedStr:_model.venueName font:locationLabel.font lineSpacing:4];
    locationLabel.height = [UIToolClass textHeight:_model.venueName lineSpacing:4 font:locationLabel.font width:locationLabel.width maxRow:2];
    [titleButton addSubview:locationLabel];
    
    MYMaskView *line = [MYMaskView maskViewWithBgColor:kBgColor frame:CGRectMake(0, titleButton.maxY, kScreenWidth, 8) radius:0];
    [_bgScrollView addSubview:line];
    
    return line.maxY;
}

//活动室的日期、场次信息等
- (CGFloat)creatDateInfoView:(CGFloat)position
{
    position += 8;
    
    
    UILabel *leftLabel = nil;
    UILabel *rightLabel = nil;
    //日期
    if (_model.roomDate.length) {
        leftLabel = [self getLeftLabel:@"日  期：" originalY:position];
        [_bgScrollView addSubview:leftLabel];
        
        rightLabel = [self getRightLabel:_model.roomDate originalY:leftLabel.originalY lineShow:_model.openPeriod.length || _model.requiredScore > 0];
        [_bgScrollView addSubview:rightLabel];
        
        position = rightLabel.maxY;
    }
    //场次
    if (_model.openPeriod.length) {
        leftLabel = [self getLeftLabel:@"场  次：" originalY:position];
        [_bgScrollView addSubview:leftLabel];
        
        rightLabel = [self getRightLabel:_model.openPeriod originalY:leftLabel.originalY lineShow:(_model.requiredScore > 0  || _model.roomPrice.length > 0)];
        [_bgScrollView addSubview:rightLabel];
        
        position = rightLabel.maxY;
    }
    
    //价格
    if (_model.roomPrice.length > 0) {
        leftLabel = [self getLeftLabel:@"价  格：" originalY:position];
        [_bgScrollView addSubview:leftLabel];
        
        rightLabel = [self getRightLabel:_model.roomPrice originalY:leftLabel.originalY lineShow:(_model.requiredScore > 0)];
        rightLabel.textColor = ColorFromHex(@"C05459");
        [_bgScrollView addSubview:rightLabel];
        
        position = rightLabel.maxY;
    }
    
    //积分
    if (_model.requiredScore > 0) {
        leftLabel = [self getLeftLabel:@"积  分：" originalY:position];
        [_bgScrollView addSubview:leftLabel];
        
        rightLabel = [self getRightLabel:StrFromInt(_model.requiredScore) originalY:leftLabel.originalY lineShow:NO];
        rightLabel.textColor = ColorFromHex(@"C05459");
        [_bgScrollView addSubview:rightLabel];
        
        position = rightLabel.maxY;
    }
    
    MYMaskView *line = [MYMaskView maskViewWithBgColor:kBgColor frame:CGRectMake(0, position+8, kScreenWidth, 8) radius:0];
    [_bgScrollView addSubview:line];
    return line.maxY;
}


//活动室预订的联系人信息等
- (CGFloat)creatContactInfoView:(CGFloat)position
{
    UILabel *leftLabel = nil;
    MYTextField *textField = nil;
    //使用者
    leftLabel = [self getLeftLabel:@"使用者：" originalY:position+8];
    [_bgScrollView addSubview:leftLabel];
    
    textField = _roomUserTF = [self getTextField:@"请填写使用者名称" originalY:leftLabel.originalY lineShow:YES limitedLength:20];
    [_bgScrollView addSubview:textField];
    
    //预订联系人
    leftLabel = [self getLeftLabel:@"预订联系人：" originalY:textField.maxY];
    [_bgScrollView addSubview:leftLabel];
    
    textField = _roomBookerTF  = [self getTextField:@"请填写联系人姓名" originalY:leftLabel.originalY lineShow:YES limitedLength:20];
    if (_model.orderName.length) {
        textField.text = _model.orderName;
    }
    [_bgScrollView addSubview:textField];
    
    //联系人手机
    leftLabel = [self getLeftLabel:@"联系人手机：" originalY:textField.maxY];
    [_bgScrollView addSubview:leftLabel];
    
    textField = _bookerTelTF  = [self getTextField:@"请填写联系人手机号" originalY:leftLabel.originalY lineShow:YES limitedLength:15];
    textField.isPhoneInput = YES;
    textField.text = _model.orderTel;
    [_bgScrollView addSubview:textField];
    
    //预订用途
    leftLabel = [self getLeftLabel:@"预订用途：" originalY:textField.maxY];
    [_bgScrollView addSubview:leftLabel];
    
    _textView = [[MYTextView alloc] initWithFrame:CGRectMake(textField.originalX-2, leftLabel.originalY+1, textField.width, textField.height+80)];
    _textView.textColor = [UIToolClass colorFromHex:@"808080"]; // UIEdgeInsetsMake(14, 0, 10, 2)
    _textView.font = FontYT(15);
    _textView.maxLength = 500;
    [_textView setPlaceholder:@"请填写活动室使用用途" andColor:ColorFromHex(@"CCCCCC")];
    _textView.delegateObject = self;
    [_bgScrollView addSubview:_textView];
    
    if (_model.teamListArray.count > 0)
    {
        TeamUserListModel *model = _model.teamListArray[0];
        _roomUserTF.text = model.tUserName;
        _selecteduserIndex = 0;
        
        if(_model.teamListArray.count > 0)
        {
            _userSelectButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-8-80, 0, 80, 35)];
            _userSelectButton.layer.borderColor = ColorFromHex(@"CCCCCC").CGColor;
            _userSelectButton.layer.borderWidth = 0.6;
            _userSelectButton.clipsToBounds = YES;
            _userSelectButton.radius = 4;
            _userSelectButton.backgroundColor = RGB(234, 234, 234);
            _userSelectButton.titleLabel.font = leftLabel.font;
            [_userSelectButton setTitle: @"选择" forState:UIControlStateNormal];
            [_userSelectButton setTitleColor:leftLabel.textColor forState:UIControlStateNormal];
            [_userSelectButton addTarget:self action:@selector(roomUserButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_bgScrollView addSubview:_userSelectButton];
            _userSelectButton.centerY = _roomUserTF.centerY;
            
            _roomUserTF.width = _userSelectButton.originalX-2-_roomUserTF.originalX;
            
            _pickerView = [UIPickerView new];
            _pickerView.frame = CGRectMake(_userSelectButton.originalX-5-180, _userSelectButton.originalY, 180, 0);//216
            [_pickerView setNeedsLayout];
            _pickerView.layer.borderWidth = 0.6;
            _pickerView.layer.borderColor = ColorFromHex(@"CCCCCC").CGColor;
            _pickerView.radius = 4;
            _pickerView.backgroundColor = RGB(244, 244, 244);//ColorFromHex(@"F4F4F4")
            _pickerView.delegate = self;
            _pickerView.dataSource = self;
            _pickerView.hidden = YES;
            _pickerView.alpha = 0;
            _pickerView.showsSelectionIndicator = YES;
            [_bgScrollView addSubview:_pickerView];
        }
    }
    
    return _textView.maxY + 30;
}



#pragma mark - 数据请求

//预订活动室订单确定
- (void)startActivityRoomBookRequest
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"正在为您预订..."];
    
    NSString *teamUserId = [self getTeamUserId];
    
    WS(weakSelf);
    
    [AppProtocol playroomOrderConfirmWithBookId:_model.bookId
                                      orderName:_roomBookerTF.text
                                       orderTel:_bookerTelTF.text
                                     teamUserId:teamUserId
                                   teamUserName:_roomUserTF.text
                                        purpose:_textView.text
                                     UsingBlock:^(HttpResponseCode responseCode, id responseObject)
    {
        if (responseCode == HttpResponseSuccess) {
            [SVProgressHUD dismiss];
            ActivityRoomBookSuccessViewController *vc = [ActivityRoomBookSuccessViewController new];
            vc.model = responseObject;
            vc.tUserId = teamUserId;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else {
            [SVProgressHUD showInfoWithStatus:responseObject];
        }
        
    }];
}


#pragma mark - UIScrollViewDelegate


#pragma mark - MYTextInputViewDelegate

- (BOOL)textInputViewShouldBeginEditing:(id)inputView {
    if ([_userSelectButton.titleLabel.text isEqualToString:@"确定"]) {
        [self dismissUserSelectView];
    }
    return YES;
}

#pragma mark - UIPickerViewDelegate And DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _model.teamListArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    TeamUserListModel *model = _model.teamListArray[row];
    return [[NSAttributedString alloc] initWithString:model.tUserName attributes:@{NSForegroundColorAttributeName:kDeepLabelColor, NSFontAttributeName:FontYT(15)}];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if (!view) {
        view = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.width-18, 40)];
    }
    //标题
    UILabel *titleLabel = (UILabel *)view;
    titleLabel.numberOfLines = 0;
    
    TeamUserListModel *model = _model.teamListArray[row];
    if ([UIToolClass textWidth:model.tUserName font:FontYT(15)] <= titleLabel.width ) {//一行可以显示完
        titleLabel.attributedText = nil;
        titleLabel.font = FontYT(15);
        titleLabel.textColor = kDeepLabelColor;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = model.tUserName;
    } else {
        NSMutableAttributedString *attributedString = (NSMutableAttributedString *)[UIToolClass getAttributedStr:model.tUserName font:FontYT(13) lineSpacing:4 alignment:NSTextAlignmentCenter];
        [attributedString addAttribute:NSForegroundColorAttributeName value:kDeepLabelColor range:NSMakeRange(0, model.tUserName.length)];
        titleLabel.attributedText = attributedString;
    }
    
    return titleLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selecteduserIndex = row;
    TeamUserListModel *model = _model.teamListArray[row];
    _roomUserTF.text = model.tUserName;
}

#pragma mark - 点击事件

- (void)reserveButtonClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    //使用者
    NSString *roomUser = [_roomUserTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (roomUser.length < 1) {
        [SVProgressHUD showInfoWithStatus:@"请填写使用者!"];
        return;
    }
    NSString *numberRegex = @"^[\u4e00-\u9fa5a-zA-Z0-9]+$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numberRegex];
    if ([numberTest evaluateWithObject:roomUser] == NO){
        [SVProgressHUD showInfoWithStatus:@"使用者名称中只允许包含汉字,数字和字母"];
        return;
    }
    //预订联系人
    NSString *roomBooker = [_roomBookerTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (roomBooker.length < 1) {
        [SVProgressHUD showInfoWithStatus:@"请填写预订联系人!"];
        return;
    }
    if ([numberTest evaluateWithObject:roomBooker] == NO){
        [SVProgressHUD showInfoWithStatus:@"预订联系人只允许包含汉字,数字和字母"];
        return;
    }
    //联系人手机
    NSString *bookerTel = [_bookerTelTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (bookerTel.length < 1) {
        [SVProgressHUD showInfoWithStatus:@"请填写联系人手机号!"];
        return;
    }
    //预订用途
    NSString *bookPurpose = [_textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (bookPurpose.length < 1) {
        [SVProgressHUD showInfoWithStatus:@"请填写预订用途!"];
        return;
    }
    
    //预订活动室请求
    [self startActivityRoomBookRequest];
}


- (void)roomUserButtonClick:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"选择"]) {
        [self showUserSelectView];
    }else if ([sender.titleLabel.text isEqualToString:@"确定"]) {
        [self dismissUserSelectView];
    }
}

- (void)showUserSelectView
{
    WS(weakSelf);
    _pickerView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        _pickerView.height = [weakSelf getPickerViewHeight];
        [_pickerView  setNeedsLayout];
        _pickerView.alpha = 1;

    } completion:^(BOOL finished) {
        [_userSelectButton setTitle:@"确定" forState:UIControlStateNormal];
    }];
}

- (void)dismissUserSelectView
{
    [UIView animateWithDuration:0.10 animations:^{
         _pickerView.alpha = 0;
    } completion:^(BOOL finished) {
        _pickerView.hidden = YES;
        [_userSelectButton setTitle:@"选择" forState:UIControlStateNormal];
    }];
}

- (void)tapGestureHandle:(UITapGestureRecognizer *)tapGesture
{
    [self.view endEditing:YES];
    if ([_userSelectButton.titleLabel.text isEqualToString:@"确定"]) {
        [self dismissUserSelectView];
    }
}

#pragma mark - 其它方法

- (CGFloat)getPickerViewHeight
{
    return 162;
}

- (UILabel *)getLeftLabel:(NSString *)title originalY:(CGFloat)originalY
{
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, originalY, _leftWidth, kHeight)];
    leftLabel.font = FontYT(15);
    leftLabel.textColor = [UIToolClass colorFromHex:@"262626"];
    leftLabel.text = title;
    return leftLabel;
}

- (UILabel *)getRightLabel:(NSString *)title originalY:(CGFloat)originalY lineShow:(BOOL)isLineShow
{
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(8+_leftWidth+5, originalY, _rightWidth, kHeight)];
    rightLabel.font = FontYT(15);
    rightLabel.textColor = [UIToolClass colorFromHex:@"808080"];
    rightLabel.text = title;
    
    if (isLineShow) {
        MYMaskView *line = [MYMaskView maskViewWithBgColor:kLineGrayColor frame:CGRectMake(8, originalY+rightLabel.height, kScreenWidth-16, kLineThick) radius:0];
        [_bgScrollView addSubview:line];
    }
    
    return rightLabel;
}

- (MYTextField *)getTextField:(NSString *)placeholder originalY:(CGFloat)originalY lineShow:(BOOL)isLineShow limitedLength:(int)limitedLength
{
    MYTextField *textField = [[MYTextField alloc] initWithFrame:CGRectMake(8+_leftWidth+5-7, originalY, _rightWidth+7, kHeight)];
    textField.font = FontYT(15);
    [textField setPlaceholder:placeholder andColor:[UIToolClass colorFromHex:@"CCCCCC"]];
    textField.maxLength = limitedLength;
    textField.delegateObject = self;
    textField.textColor = [UIToolClass colorFromHex:@"808080"];
    textField.returnKeyType = UIReturnKeyDone;
    
    if (isLineShow) {
        MYMaskView *line = [MYMaskView maskViewWithBgColor:kLineGrayColor frame:CGRectMake(8, originalY+textField.height, kScreenWidth-16, kLineThick) radius:0];
        [_bgScrollView addSubview:line];
    }
    
    return textField;
}


- (NSString *)getTeamUserId
{
    NSString *teamUserId = @"";
    for (int i = 0; i < _model.teamListArray.count; i++) {
        TeamUserListModel *userModel = _model.teamListArray[i];
        if ([userModel.tUserName isEqualToString:_roomUserTF.text] && _roomUserTF.text.length) {
            teamUserId = userModel.tUserId;
            break;
        }
    }
//    if (_selecteduserIndex > -1) {
//        TeamUserListModel *userModel = _model.teamListArray[_selecteduserIndex];
//        if ([userModel.tUserName isEqualToString:_roomUserTF.text]) {
//            teamUserId = userModel.tUserId;
//        }
//    }
    return teamUserId;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
