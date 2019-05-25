//
//  CalendarListSelectDateView.h
//  CultureHongshan
//
//  Created by ct on 17/2/9.
//  Copyright © 2017年 CT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarListSelectDateView : UIView
@property (nonatomic, strong, readonly) NSDate *currentSelectedDate;
@property (nonatomic, strong, readonly) NSString *currentShowMonth;

- (void)setDateDidChangeBlock:(void(^)(NSString *selectDate))block;

- (void)setMonthDidChangeActionBlock:(void(^)(NSString *month))actionBlock;

@end





@interface DateView : UIView
@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSDate *maxDate;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) NSInteger activityCount; // 活动数量
/**
 按钮的状态：0-不在有效期内  1-今天未选中  2-今天选中  3-其他日期未选中  4-其他日期选中
 */
@property (nonatomic, assign) NSInteger buttonStatus;


- (instancetype)initWithFrame:(CGRect)frame date:(NSDate *)date maxDate:(NSDate *)maxDate;

/** 调用前需设置selected变量 */
- (void)updateButttonStatus;

@end
