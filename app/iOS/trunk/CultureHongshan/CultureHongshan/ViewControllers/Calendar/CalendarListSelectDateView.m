//
//  CalendarListSelectDateView.m
//  CultureHongshan
//
//  Created by ct on 17/2/9.
//  Copyright © 2017年 CT. All rights reserved.
//

#import "CalendarListSelectDateView.h"

#define kMaxSelectMonthCount 3
#define kDeepColor   RGB(29, 29, 29)
#define kLightColor  RGB(151, 151, 151)



#define LoadStatusUnload   0 // 未加载过
#define LoadStatusLoading  1 // 请求中
#define LoadStatusLoaded   2 // 请求成功并赋值

@interface CalendarListSelectDateView () <UIScrollViewDelegate>
{
    int _activityCountLoadStatus[15];
}
@property (nonatomic, strong) NSDate *maxSelectDate;
@property (nonatomic, strong) NSArray *weekdayTitles;
@property (nonatomic, strong) NSArray<NSDate *> *allDates;
@property (nonatomic, strong) UIScrollView *dateScrollView;
@property (nonatomic, assign) NSInteger pageIndex; // 当前显示的是第几页
@property (nonatomic, strong) DateView *lastSelectedDateView;// 上一次选中的按钮

@property (nonatomic, copy) void(^dateChangeHandler)(NSString *selectDate);
@property (nonatomic, copy) void(^monthChangeHandler)(NSString *month);
@end

@implementation CalendarListSelectDateView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kWhiteColor;
        
        for (int i = 0; i < 15; i++) {
            _activityCountLoadStatus[i] = LoadStatusUnload;
        }
        
        WS(weakSelf)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            weakSelf.weekdayTitles = [weakSelf getWeekdayTitleArray];
            NSDate *tmpDate = nil;
            weakSelf.allDates = [weakSelf getAllDatesWithinAllowedDateRange:&tmpDate];
            weakSelf.maxSelectDate = tmpDate;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf loadUI];
                
                [weakSelf LoadFirstThreeWeekActivityCount:0];
            });
        });
    }
    return self;
}


- (void)loadUI {
    WS(weakSelf)
    
    // 星期标题
    UIView *weekdayView = [UIView new];
    [self addSubview:weekdayView];
    [weekdayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.top.equalTo(weakSelf);
        make.height.mas_equalTo(33);
    }];
    
    UIView *preWeekdayLabel = nil;
    for (NSString *weekday in self.weekdayTitles) {
        UILabel *weekdayLabel = [[UILabel alloc] init];
        weekdayLabel.textColor = kLightLabelColor;
        weekdayLabel.textAlignment = NSTextAlignmentCenter;
        weekdayLabel.font = FontYT(14);
        weekdayLabel.text = weekday;
        [weekdayView addSubview:weekdayLabel];
        
        [weekdayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(weekdayView);
            if (preWeekdayLabel) {
                make.left.equalTo(preWeekdayLabel.mas_right);
                make.width.equalTo(preWeekdayLabel);
            }else {
                make.left.mas_equalTo(0);
            }
        }];
        preWeekdayLabel = weekdayLabel;
    }
    [preWeekdayLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weekdayView);
    }];
    
    
    // 分割线
    MYMaskView *line = [MYMaskView maskViewWithBgColor:RGB(245, 245, 245) frame:CGRectZero radius:0];
    [weekdayView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(weekdayView);
        make.height.mas_equalTo(0.8);
        make.top.equalTo(weekdayView.mas_bottom).offset(-0.8);
    }];
    
    // 日期容器视图
    self.dateScrollView = [UIScrollView new];
    self.dateScrollView.pagingEnabled = YES;
    self.dateScrollView.delegate = self;
    [self addSubview:self.dateScrollView];
    [self.dateScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(weakSelf);
        make.top.equalTo(weekdayView.mas_bottom);
        make.bottom.equalTo(weakSelf);
    }];
    
    
    UIView *preDateView = nil;
    for (NSInteger i = 0; i < self.allDates.count; i++) {
        
        DateView *dateView = [[DateView alloc] initWithFrame:CGRectZero date:self.allDates[i] maxDate:self.maxSelectDate];
        dateView.button.tag = 1+i;
        [dateView.button addTarget:self action:@selector(dateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.dateScrollView addSubview:dateView];
        
        [dateView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.and.bottom.equalTo(weakSelf.dateScrollView);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(65);
            if (preDateView) {
                make.left.equalTo(preDateView.mas_right);
                make.width.equalTo(preDateView);
            }else {
                make.left.mas_equalTo(weakSelf.dateScrollView);
                make.width.equalTo(weakSelf.mas_width).multipliedBy(1.0/7);
            }
        }];
        
        preDateView = dateView;
    }
    
    [preDateView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.dateScrollView);
    }];
}






#pragma mark - Data Source

- (void)LoadFirstThreeWeekActivityCount:(NSInteger)index {
    if (index < self.allDates.count / 7) {
        WS(weakSelf)
        [self loadEveryDayActivityCountIfNeeded:index completionHandler:^(BOOL success) {
            [weakSelf LoadFirstThreeWeekActivityCount:index+1];
        }];
    }
}


- (void)loadEveryDayActivityCountIfNeeded:(NSInteger)pageIndex completionHandler:(void(^)(BOOL success))handler {
    if (_activityCountLoadStatus[pageIndex] == LoadStatusLoaded || _activityCountLoadStatus[pageIndex] == LoadStatusLoading) {
        return;
    }
    
    NSString *startDate = [DateTool dateStringForDate:self.allDates[7*pageIndex]];
    NSString *endDate = [DateTool dateStringForDate:self.allDates[7*pageIndex + 6]];
    
    _activityCountLoadStatus[pageIndex] = LoadStatusLoading;
    
    WS(weakSelf)    
    [AppProtocol getActivityCountByDayWithStartDate:startDate endDate:endDate cacheMode:CACHE_MODE_REALTIME UsingBlock:^(HttpResponseCode responseCode, id responseObject) {
        
        if (responseCode == HttpResponseSuccess) {
            [weakSelf updateActivityCountWithActCountDict:responseObject pageIndex:pageIndex];
            _activityCountLoadStatus[pageIndex] = LoadStatusLoaded;
            
            if (handler) {
                handler(YES);
            }
        }else {
            _activityCountLoadStatus[pageIndex] = LoadStatusUnload;
            if (handler) {
                handler(NO);
            }
        }
    }];
}

- (void)updateActivityCountWithActCountDict:(NSDictionary *)actCountdict pageIndex:(NSInteger)pageIndex {
    for (NSInteger i = 7*pageIndex; i < 7*pageIndex + 7; i++) {
        DateView *dateView = self.dateScrollView.subviews[i];
        NSString *dateString = [DateTool dateStringForDate:dateView.date];
        
        if ([actCountdict valueForKey:dateString]) {
            dateView.activityCount =  [actCountdict safeIntegerForKey:dateString];
        }
    }
}


/** 获取星期Title */
- (NSArray<NSString *> *)getWeekdayTitleArray {
    return @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
}

/**
 获取三个月内的所有日期
 
 @discussion  星期从周日开始，两端可能会有多余不可选的日期
 @param maxSelectDate 最大可以选择的日期
 @return 日期数组
 */
- (NSArray<NSDate *> *)getAllDatesWithinAllowedDateRange:(NSDate **)maxSelectDate {
    NSMutableArray *allDates = [NSMutableArray arrayWithCapacity:50];
    
    NSDate *nowDate = [NSDate date];
    
    NSInteger nowWeekday = [DateTool weekDayForDate:nowDate sysDefault:YES];
    NSInteger currentDay = [[DateTool dateStringForDate:nowDate formatter:@"dd"] integerValue];
    NSInteger dayNumOfCurrentMonth = [DateTool dayNumOfMonthForDate:nowDate];
    
    NSDate *tmpDate = [nowDate copy];
    [allDates addObject:tmpDate];
    
    // 1. 今天之前本周的日期
    for (NSInteger i = nowWeekday-1-1; i >= 0; i--) {
        tmpDate = [DateTool dateByAddingDayNum:-1 toDate:tmpDate];
        [allDates insertObject:tmpDate atIndex:0];
    }
    
    // 2. 今天之后有效的日期
    tmpDate = [nowDate copy];
    
    NSInteger dayNumOfNextTwoMonth = [DateTool dayNumOfMonthForDate:[DateTool dateByAddMonthNum:1 toDate:nowDate]] + [DateTool dayNumOfMonthForDate:[DateTool dateByAddMonthNum:2 toDate:nowDate]];
    
    for (NSInteger i = currentDay; i < dayNumOfCurrentMonth + dayNumOfNextTwoMonth; i++) {
        tmpDate = [DateTool dateByAddingDayNum:1 toDate:tmpDate];
        [allDates addObject:tmpDate];
    }
    
    if (maxSelectDate) { *maxSelectDate = [tmpDate copy]; }
    
    // 3. 有效日期后的日期
    NSInteger lastDateWeekday = [DateTool weekDayForDate:tmpDate sysDefault:YES];
    if (lastDateWeekday < 1) { lastDateWeekday = 7; }
    
    for (NSInteger i = 0; i < 7-lastDateWeekday; i++) {
        tmpDate = [DateTool dateByAddingDayNum:1 toDate:tmpDate];
        [allDates addObject:tmpDate];
    }

    return allDates;
    
    /*
     周日  weekday = 1
     
     周日  1
     周一  2
     周二  3
     周三  4
     周四  5
     周五  6
     周六  0
     
     */
}

// 获取一个月内的所有日期
- (NSArray<NSDate *> *)dayArrayForMonth:(NSDate *)date {
    NSInteger dayNumOfCurrentMonth = [DateTool dayNumOfMonthForDate:date];
    
    NSMutableArray *allDays = [NSMutableArray arrayWithCapacity:dayNumOfCurrentMonth];
    
    NSDate *tmpDate = [DateTool firstDayOfMonthForDate:date]; // 这个月的第一天
    [allDays addObject:tmpDate];
    
    for (NSInteger i = 0; i < dayNumOfCurrentMonth-1; i++) {
        tmpDate = [DateTool dateByAddingDayNum:1 toDate:tmpDate];
        [allDays addObject:tmpDate];
    }
    return allDays;
}

#pragma mark - 

- (void)dateButtonClick:(UIButton *)sender {
    if (self.lastSelectedDateView && self.lastSelectedDateView.button.tag == sender.tag) {
        return;
    }
    DateView *clickedDateView = (DateView *)sender.superview;
    clickedDateView.selected = YES;
    [clickedDateView updateButttonStatus];
    
    self.lastSelectedDateView.selected = NO;
    [self.lastSelectedDateView updateButttonStatus];
    
    self.lastSelectedDateView = clickedDateView;
    
    if (self.dateChangeHandler) {
        NSString *dateString = [DateTool dateStringForDate:clickedDateView.date];
        self.dateChangeHandler(dateString);
    }
}

- (NSDate *)currentSelectedDate {
    if (self.lastSelectedDateView) {
        return [self.lastSelectedDateView.date copy];
    }else {
        return [NSDate date];
    }
}

// 获取当前显示的月份
- (NSString *)currentShowMonth {
    NSString *monthFormatter = @"yyyy.MM";
    if (self.pageIndex == 0) {
        return [DateTool dateStringForDate:[NSDate date] formatter:monthFormatter];
    }else if (self.pageIndex == self.allDates.count/7 - 1) {
        return [DateTool dateStringForDate:self.maxSelectDate formatter:monthFormatter];
    }else {
        NSDate *maxDateForCurrentPage = self.allDates[self.pageIndex * 7 + 6];
        NSInteger day = [[DateTool dateStringForDate:maxDateForCurrentPage formatter:@"dd"] integerValue];
        if (day < 4) {
            return [DateTool dateStringForDate:self.allDates[self.pageIndex * 7] formatter:monthFormatter];
        }else {
            return [DateTool dateStringForDate:maxDateForCurrentPage formatter:monthFormatter];
        }
    }
}


#pragma mark - 

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = (int)scrollView.contentOffset.x / scrollView.frame.size.width;
    if (self.pageIndex == index) {
        return;
    }
    
    self.pageIndex = index;
    
    if (self.monthChangeHandler) {
        self.monthChangeHandler(self.currentShowMonth);
    }
    
    [self loadEveryDayActivityCountIfNeeded:index completionHandler:nil];
}

- (void)setDateDidChangeBlock:(void (^)(NSString *))block {
    self.dateChangeHandler = block;
}

- (void)setMonthDidChangeActionBlock:(void (^)(NSString *))actionBlock {
    self.monthChangeHandler = actionBlock;
}

@end



#pragma mark - ——————————————————— DateView ———————————————————

@interface DateView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@end


@implementation DateView

- (instancetype)initWithFrame:(CGRect)frame date:(NSDate *)date maxDate:(NSDate *)maxDate {
    if (self = [super initWithFrame:frame]) {
        self.date = date;
        self.maxDate = maxDate;
        
        [self loadUI];
    }
    return self;
}

- (void)loadUI {
    NSString *dayString = [DateTool dateStringForDate:self.date formatter:@"dd"];
    
    self.titleLabel = [MYSmartLabel al_labelWithMaxRow:1 text:dayString font:FontYT(16) color:kDeepColor lineSpacing:0 align:NSTextAlignmentCenter breakMode:NSLineBreakByClipping];
    self.titleLabel.radius = 14;
    [self addSubview:self.titleLabel];
    
    self.subTitleLabel = [MYSmartLabel al_labelWithMaxRow:1 text:@"" font:FontYT(12) color:RGB(163, 163, 163) lineSpacing:0 align:NSTextAlignmentCenter breakMode:NSLineBreakByTruncatingMiddle];
    [self addSubview:self.subTitleLabel];
    
    self.button = [[UIButton alloc] init];
    [self addSubview:self.button];
    
    
    WS(weakSelf)
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(2*weakSelf.titleLabel.radius, 2*weakSelf.titleLabel.radius));
        make.top.equalTo(weakSelf).offset(9);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(1);
        make.height.mas_equalTo([UIToolClass fontHeight:weakSelf.subTitleLabel.font]);
        make.left.and.right.equalTo(weakSelf);
    }];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.width.equalTo(weakSelf).multipliedBy(0.8);
        make.top.and.bottom.equalTo(weakSelf);
    }];
    
    
    [self updateButttonStatus];
}


- (void)updateButttonStatus {
    if (self.date && self.maxDate) {
        if ([DateTool dayCompare:self.date comparedDate:[NSDate date]] == DayEarly ||
            [DateTool dayCompare:self.date comparedDate:self.maxDate] == DayLater
            ) {
            // 超过日期限制
            self.buttonStatus = 0;
        }else {
            
            if ([DateTool dayCompare:self.date comparedDate:[NSDate date]] == DaySame) {
                // 今天
                if (self.selected) {
                    self.buttonStatus = 2;
                }else {
                    self.buttonStatus = 1;
                }
            }else {
                // 其他日期
                if (self.selected) {
                    self.buttonStatus = 4;
                }else {
                    self.buttonStatus = 3;
                }
            }
        }
    }
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    self.button.selected = selected;
}

- (void)setButtonStatus:(NSInteger)buttonStatus {
    _buttonStatus = buttonStatus;
// 0-不在有效期内  1-今天未选中  2-今天选中  3-其他日期未选中  4-其他日期选中
    switch (buttonStatus) {
        case 0:
        {
            self.titleLabel.layer.borderWidth = 0;
            self.titleLabel.layer.borderColor = [UIColor clearColor].CGColor;
            self.titleLabel.textColor = kLightColor;
            self.titleLabel.backgroundColor = [UIColor clearColor];
            if (self.button.userInteractionEnabled) {
                self.button.userInteractionEnabled = NO;
            }
        }
            break;
        case 1:
        case 2:
        {
            self.titleLabel.layer.borderWidth = 0.6;
            self.titleLabel.layer.borderColor = kThemeDeepColor.CGColor;
            self.titleLabel.textColor = kWhiteColor;
            self.titleLabel.backgroundColor = kThemeDeepColor;
        }
            break;
        case 3:
        {
            self.titleLabel.layer.borderWidth = 0;
            self.titleLabel.layer.borderColor = [UIColor clearColor].CGColor;
            self.titleLabel.textColor = kDeepColor;
            self.titleLabel.backgroundColor = [UIColor clearColor];
        }
            break;
        case 4:
        {
            self.titleLabel.layer.borderWidth = 0.6;
            self.titleLabel.layer.borderColor = kDeepColor.CGColor;
            self.titleLabel.textColor = kDeepColor;
            self.titleLabel.backgroundColor = [UIColor clearColor];
        }
            break;
            
        default:
            break;
    }
}


- (void)setActivityCount:(NSInteger)activityCount {
    self.subTitleLabel.text = [NSString stringWithFormat:@"%ld场", (long)activityCount];
}


@end


