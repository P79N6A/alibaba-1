//
//  ActivityRoomScheduleView.m
//  CultureHongshan
//
//  Created by JackAndney on 16/5/29.
//  Copyright © 2016年 CT. All rights reserved.
//


#import "ActivityRoomScheduleView.h"



#import "ActivityRoomTimeModel.h"

@interface ActivityRoomScheduleView ()<UIScrollViewDelegate>
{
    UIButton *_leftBtn;
    UIButton *_rightBtn;
    UIScrollView *_containerView;
    
    NSInteger _columnNum;//列数
    
    UIButton *_lastButton;
    int _pageIndex;//纪录显示的是第几页，每页最多有4个日期
}

@end

@implementation ActivityRoomScheduleView


- (id)initWithFrame:(CGRect)frame dataArray:(NSArray *)listArray
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initHeaderView];
        
        _containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _leftBtn.maxY, kScreenWidth, 0)];
        _containerView.delegate = self;
        _containerView.showsHorizontalScrollIndicator = NO;
        _containerView.pagingEnabled = YES;
        [self addSubview:_containerView];
        
        self.listArray = [NSMutableArray arrayWithArray:listArray];
        
        [self initContainerSubviews];
        [self updatePageButtonStatus];
    }
    return self;
}



- (void)initHeaderView
{
    UIImage *originalImage = IMG(@"icon_arrow_right_gray");
    UIImage *image = [originalImage scaleToWidth:originalImage.size.width*0.6 canBeLarger:NO imgScale:2];
    
    //左侧的按钮
    _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 40, 40)];
    [_leftBtn setImage:image forState:UIControlStateNormal];
    [_leftBtn addTarget:self action:@selector(gotoLastPage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_leftBtn];
    _leftBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    
    //右侧的按钮
    _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-20-40, 0, 40, 40)];
    [_rightBtn setImage:image forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(gotoNextPage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rightBtn];
    
    //中间的Title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_leftBtn.maxX+10, 0, _rightBtn.originalX-10-_leftBtn.maxX-10, _leftBtn.height)];
    titleLabel.font = FontSystemBold(16);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIToolClass colorFromHex:@"666666"];
    titleLabel.text = @"活动室预订";
    [self addSubview:titleLabel];
}

- (void)initContainerSubviews
{
    //移除原有的子视图
    [_containerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSInteger maxRow = [ActivityRoomScheduleView getMaxRowNumber:_listArray];
    if (maxRow < 1) {
        
        MYMaskView *lineView = [MYMaskView maskViewWithBgColor:ColorFromHex(@"DFDFDF") frame:CGRectMake(8, _leftBtn.height, kScreenWidth-16, 0.7) radius:0];
        [self addSubview:lineView];
        
        //提示信息
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        tipLabel.font = FontYT(16);
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.textColor = [UIToolClass colorFromHex:@"808080"];
        tipLabel.text = @"活动室暂时没有可预订的场次!";
        [_containerView addSubview:tipLabel];
        
        _containerView.height = tipLabel.height;
        self.height = _containerView.maxY;
        return;
    }
    
    
    [self updatePageButtonStatus];
    
    _columnNum = _listArray.count%4 ? (_listArray.count/4)*4+4 : _listArray.count;
    
    NSInteger totalNum = _columnNum * (maxRow+1);
    CGFloat spacing = 1;
    CGFloat btnWidth = (kScreenWidth-3*spacing)*0.25;
    CGFloat btnHeight = 45;
    
    for (int i = 0; i < totalNum; i++)
    {
        NSInteger row = i/_columnNum;//行数
        NSInteger column = i%_columnNum;//列数
        if (column < _listArray.count)
        {
            ActivityRoomTimeModel *model = _listArray[column];
            if (row == 0)//第一行:(日期＋周几)
            {
                /*
                  M.d   :  6.5    6.12
                  MM.dd :  06.05  06.12
                 */
                NSString *dateStr = [DateTool dateStringForDate:model.openDate formatter:@"M.d"];
                NSString *weekStr = [DateTool weekStringForDate:model.openDate];
                UIButton *dateButton = [[UIButton alloc] initWithFrame:CGRectMake(column*(btnWidth+spacing), row*(btnHeight+spacing), btnWidth, btnHeight)];
                dateButton.backgroundColor = [UIToolClass colorFromHex:@"666666"];
                dateButton.titleLabel.font = FontYT(15);
                [dateButton setTitle:[NSString stringWithFormat:@"%@ %@",dateStr, weekStr] forState:UIControlStateNormal];
                [dateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                dateButton.userInteractionEnabled = NO;
                [_containerView addSubview:dateButton];
            }else
            {
                if (row-1 < MIN(model.openPeriodArray.count, model.statusArray.count))
                {
                    NSInteger status = [model.statusArray[row-1] integerValue];
                    if (_isBookable == NO && status == 2 ) {
                        _isBookable = YES;
                    }
                    
                    //按钮
                    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(column*(btnWidth+spacing), row*(btnHeight+spacing), btnWidth, btnHeight)];
                    button.tag = i;
                    button.backgroundColor = [self getBgColorWithStatus:status];
                    button.titleLabel.numberOfLines = 0;
                    [button setAttributedTitle:[self getTitleWithTimeStr:model.openPeriodArray[row-1] status:status] forState:UIControlStateNormal];
                    [button setTitleColor:kDeepLabelColor forState:UIControlStateNormal];
                    button.userInteractionEnabled = (status >= 2);
                    [button addTarget:self action:@selector(timeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                    [_containerView addSubview:button];
                }
            }
        }
        
        if (i == totalNum - 1) {
            _containerView.height = row*(btnHeight+spacing)+btnHeight;
            _containerView.contentSize = CGSizeMake(column*(btnWidth+spacing)+btnWidth, _containerView.height);
            
            self.height = _containerView.maxY;
        }
    }
}


- (UIColor *)getBgColorWithStatus:(NSInteger)status
{
    if (status == 0){//不开放
        return [UIToolClass colorFromHex:@"F2F2F2"];
    }else if (status == 1){//已被预订
        return [UIToolClass colorFromHex:@"F2EBCA"];
    }else if (status == 2){//可预订(未被选中)
        return [UIToolClass colorFromHex:@"DDE0F2"];
    }else if (status == 3){//已过期
        return [UIColor lightGrayColor];
    }else {
        return [UIColor clearColor];
    }
}
/* 0-不开放, 1-已被预订, 2-可预订, 3-已过期 */
- (NSAttributedString *)getTitleWithTimeStr:(NSString *)timeStr status:(NSInteger)status
{
    if (timeStr.length)
    {
        NSString *statusStr = nil;
        if (status == 0){
            statusStr = @"不开放";
        }else if (status == 1){
            statusStr = @"已被预订";
        }else if (status == 2){
            statusStr = @"可预订";
        }else if (status == 3){
            statusStr = @"已过期";
        }
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing = 5;
        paraStyle.alignment = NSTextAlignmentCenter;
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",timeStr,statusStr] attributes:@{NSParagraphStyleAttributeName:paraStyle}];
        [attributedString addAttribute:NSFontAttributeName value:FontYT(13) range:[attributedString.string rangeOfString:timeStr]];
        [attributedString addAttribute:NSFontAttributeName value:FontYT(12) range:[attributedString.string rangeOfString:statusStr]];
        return attributedString;
    }
    else
    {
        return nil;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageIndex = (int)(scrollView.contentOffset.x/scrollView.width);
    
    [self updatePageButtonStatus];
}


#pragma mark - 点击事件

- (void)gotoLastPage
{
    _pageIndex -= 1;
    [_containerView setContentOffset:CGPointMake(_pageIndex*_containerView.width, 0) animated:YES];
    [self updatePageButtonStatus];
}

- (void)gotoNextPage
{
    _pageIndex += 1;
    [_containerView setContentOffset:CGPointMake(_pageIndex*_containerView.width, 0) animated:YES];
    [self updatePageButtonStatus];
}

- (void)timeButtonClick:(UIButton *)sender
{
    if (_lastButton != sender) {
        _lastButton.selected = NO;
        [self updateTimeButtonStatus:_lastButton isSelected:NO];
    }
    sender.selected = !sender.selected;
    [self updateTimeButtonStatus:sender isSelected:sender.selected];
    if (sender.selected){
        NSInteger row = (sender.tag-_columnNum)/_columnNum;
        NSInteger column = (sender.tag-_columnNum)%_columnNum;
        
        ActivityRoomTimeModel *model = _listArray[column];
        FBLOG(@"----->：%@",model.openPeriodArray[row]);
    }
    _lastButton = sender;
}


#pragma mark - 其它方法

- (NSString *)selectedDateAndTime
{
    if (_lastButton.selected) {
        
        NSInteger row = (_lastButton.tag-_columnNum)/_columnNum;
        NSInteger column = (_lastButton.tag-_columnNum)%_columnNum;
        
        ActivityRoomTimeModel *model = _listArray[column];
        
        NSString *dateStr = [DateTool dateStringForDate:model.openDate formatter:@"yyyy-MM-dd"];
        NSString *timeStr = model.openPeriodArray[row];
        NSString *bookId = model.bookIdArray[row];
        return [NSString stringWithFormat:@"%@|%@|%@",dateStr,timeStr,bookId];
    }
    return nil;
}


- (void)updatePageButtonStatus
{
    _leftBtn.hidden = ![self canGoLastPage];
    _rightBtn.hidden = ![self canGoNextPage];
}

- (void)updateTimeButtonStatus:(UIButton *)sender isSelected:(BOOL)isSelected
{
    sender.backgroundColor = isSelected ? kThemeDeepColor : ColorFromHex(@"DDE0F2");
    
    UIColor *titleColor = isSelected ? [UIColor whiteColor] :kDeepLabelColor;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:sender.currentAttributedTitle];
    [attributedString addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(0, attributedString.string.length)];
    [sender setAttributedTitle:attributedString forState:UIControlStateNormal];
}



- (BOOL)canGoLastPage {
    return (_pageIndex > 0) && _columnNum;
}

- (BOOL)canGoNextPage {
    return ((_pageIndex+1)*4 < _columnNum) && (_pageIndex > -1) && _columnNum;
}

+ (NSInteger)getMaxRowNumber:(NSArray *)array
{
    NSInteger maxRowNum = 0;
    for (ActivityRoomTimeModel *model in array)
    {
        NSInteger num = MIN(model.openPeriodArray.count, model.statusArray.count);
        if (num > maxRowNum) {
            maxRowNum = num;
        }
    }
    return maxRowNum;
}

@end
