//
//  DateTool.h
//  WHYFoundationKit
//
//  Created by JackAndney on 2017/5/14.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, DayCompareResult) {
    DayUnknown = 0,
    DaySame,
    DayEarly,
    DayLater,
};


@interface DateTool : NSObject

/**
 根据指定日期获取该月的周数
 
 @param date 指定的日期
 
 @return 周数（如果给的date参数无效，则有可能返回周数为0）,可能的值为4、5、6
 */
+ (NSInteger)weekNumOfMonthForDate:(NSDate *)date firstWeekday:(NSInteger)firstWeekday;

/**
 根据指定日期获取该月有多少天
 
 @param date 指定的日期
 
 @return 一个月的天数
 */
+ (NSUInteger)dayNumOfMonthForDate:(NSDate *)date;

/**
 根据年份和月份获取该月有多少天
 
 @param year  年份
 @param month 月份
 @return 一个月的天数
 */
+ (int)dayNumOfMonthForYear:(NSInteger)year month:(NSInteger)month;

/**
 日历控件中指定日期所在月的第一个日期
 
 @param date 指定的日期
 
 @return 日历控件中的第一个日期（位于第一行、第一列）
 */
+ (NSDate *)firstDayInCalendarViewForDate:(NSDate *)date firstWeekday:(NSInteger)firstWeekday;

/**
 根据指定日期获取该月的第一天
 
 @param date 指定的日期
 
 @return 该月的第一天
 */
+ (NSDate *)firstDayOfMonthForDate:(NSDate *)date;

/**
 根据指定日期获取该月的最后一天
 
 @param date 指定的日期
 
 @return 该月的最后一天
 */
+ (NSDate *)lastDayOfMonthForDate:(NSDate *)date;

/**
 根据指定日期获取所在周的第一天
 
 @param date 指定的日期
 
 @return 该周的第一天
 */
+ (NSDate *)firstDayOfWeekForDate:(NSDate *)date;

/**
 根据指定日期获取所在周的最后一天
 
 @param date 指定的日期
 
 @return 该周的最后一天
 */
+ (NSDate *)lastDayOfWeekForDate:(NSDate *)date;

/**
 获取指定日期是周几
 
 @param date       指定的日期
 @param sysDefault 是否使用系统默认的weekday值（设置为YES时，1-周日，2-周一，...,7-周六；设置为NO时，1-周一，...,7-周日）
 
 @return 周几
 */
+ (NSInteger)weekDayForDate:(NSDate *)date sysDefault:(BOOL)sysDefault;

/**
 获取两个日期之间的小时差
 
 @param date      日期1
 @param otherDate 日期2
 
 @return 小时差（date > otherDate时，为正值）
 */
+ (long long)hourDifferenceBetweenDate:(NSDate *)date andDate:(NSDate *)otherDate;

/**
 获取两个日期之间的天数差
 
 @param date      日期1
 @param otherDate 日期2
 
 @return 天数差（date > otherDate时，为正值）
 */
+ (long long)dayDifferenceBetweenDate:(NSDate *)date andDate:(NSDate *)otherDate;

/**
 获取两个日期之间的月份差
 
 @param date      日期1
 @param otherDate 日期2
 
 @return 月份差（date > otherDate时，为正值）
 */
+ (long long)monthDifferenceBetweenDate:(NSDate *)date andDate:(NSDate *)otherDate;

/**
 获取两个日期之间的年份差
 
 @param date      日期1
 @param otherDate 日期2
 
 @return 年份差（date > otherDate时，为正值）
 */
+ (NSInteger)yearDifferenceBetweenDate:(NSDate *)date andDate:(NSDate *)otherDate;

/**
 获取和指定日期相隔一定天数的日期
 
 @param dayNum 间隔的天数（可以为负值）
 @param date   指定的日期
 
 @return 和指定日期相隔指定天数的日期
 */
+ (NSDate *)dateByAddingDayNum:(NSInteger)dayNum toDate:(NSDate *)date;

/**
 获取和指定日期相隔一定月数的日期（返回日期均为当月的第一天）
 
 @param monthNum 间隔的月数（可以为负值）
 @param date     指定的日期
 
 @return 和 指定日期所在月份 相隔 指定月数 的日期所在月份的第一天
 */
+ (NSDate *)dateByAddMonthNum:(NSInteger)monthNum toDate:(NSDate *)date;

/**
 判断日期是否在当月内
 
 @param date      日期
 @param monthDate 当月内的任意一个日期
 
 @return 布尔值:YES时，日期在当月内
 */
+ (BOOL)isDate:(NSDate *)date inCurrentMonth:(NSDate *)monthDate;

/**
 判断日期是否在本周内
 
 @param date      日期
 @param weekDate  本周内的任意一个日期
 
 @return 布尔值:YES时，日期在本周内
 */
+ (BOOL)isDate:(NSDate *)date inCurrentWeek:(NSDate *)weekDate;

/**
 判断日期是否是周六或周日
 
 @param date 给定的日期
 
 @return 布尔值
 */
+ (BOOL)isDateInWeekend:(NSDate *)date;

/**
 判断给定的日期是否在两个日期之间
 
 @param date  给定的日期
 @param date1 日期1
 @param date2 日期2
 
 @return 布尔值
 */
+ (BOOL)isDate:(NSDate *)date betweenMinDate:(NSDate *)date1 andMaxDate:(NSDate *)date2;

/**
 获取给定日期所在月份的日期数组
 
 @param date             给定日期
 @param firstWeekday     周几作为一周的开始（1-周日）
 @param onlyCurrentMonth 是否只包含当前月的日期
 @param removeLastRow    是否移除“多余的第六行”
 @param option           包含其它月的日期时，其它月的日期处理方式:0-和本月日期一样的方式加入到数组中, 1-相应的日期以空字符串的形式加入到数组中
 
 @return 日期数组
 */
+ (NSArray<NSDate *> *)dateArrayOfMonthForDate:(NSDate *)date firstWeekday:(NSInteger)firstWeekday onlyCurrentMonth:(BOOL)onlyCurrentMonth removeLastRow:(BOOL)removeLastRow otherMonthOption:(int)option;

/**
 获取两个日期之间的日期数组
 
 @param date      开始日期yyyy-MM-dd
 @param otherDate 结束日期yyyy-MM-dd
 @return 日期字符串数组(yyyy-MM-dd)
 */
+ (NSArray<NSString *> *)dateArrayBetweenDate:(NSString *)date andOtherDate:(NSString *)otherDate;



#pragma mark -

/**
 根据日期获取时间戳字符串
 
 @param date 给定的日期
 @param msec 是否要精确到毫秒
 
 @return 时间戳字符串
 */
+ (NSString *)timeSpForDate:(NSDate *)date millisecond:(BOOL)msec;

/**
 根据日期字符串及日期格式获取时间戳字符串
 
 @param dateStr   日期字符串
 @param formatter 日期格式
 @param msec      是否要精确到毫秒
 
 @return 时间戳字符串
 */
+ (NSString *)timeSpForDateString:(NSString *)dateStr formatter:(NSString *)formatter millisecond:(BOOL)msec;

/**
 根据给定的日期字符串以及日期格式获取日期
 
 @param dateStr   日期字符串
 @param formatter 日期格式
 
 @return 日期
 */
+ (NSDate *)dateForDateString:(NSString *)dateStr formatter:(NSString *)formatter;

/**
 根据时间戳字符串获取日期
 
 @param timeSP   时间戳字符串
 @param msec     是否为毫秒精度的时间戳
 
 @return 日期
 */
+ (NSDate *)dateForTimeSp:(NSString *)timeSP millisecond:(BOOL)msec;

/**
 根据时间戳以及日期格式获取日期字符串
 
 @param timeSP    时间戳字符串
 @param formatter 日期格式
 @param msec      是否为毫秒精度的时间戳
 
 @return 日期字符串
 */
+ (NSString *)dateStringForTimeSp:(NSString *)timeSP formatter:(NSString *)formatter millisecond:(BOOL)msec;

/**
 根据日期获取日期字符串(yyyy-MM-dd)
 
 @param date 日期
 
 @return 日期字符串
 */
+ (NSString *)dateStringForDate:(NSDate *)date;

/**
 根据日期以及日期格式获取日期字符串
 
 @param date      日期
 @param formatter 日期格式
 
 @return 日期字符串
 */
+ (NSString *)dateStringForDate:(NSDate *)date formatter:(NSString *)formatter;


/**
 获取日期的相关信息
 
 @param date    给定的日期
 @param year    年
 @param month   月
 @param day     日
 @param hour    小时
 @param minute  分钟
 @param second  秒
 @param weekday 周几
 
 @return 日期是否解析成功
 */
+ (BOOL)componentsInfoForDate:(NSDate *)date year:(NSInteger *)year month:(NSInteger *)month day:(NSInteger *)day hour:(NSInteger *)hour minute:(NSInteger *)minute second:(NSInteger *)second weekday:(NSInteger *)weekday;


/**
 根据日期获取周几
 
 @param date 日期
 
 @return 周一 到 周日
 */
+ (NSString *)weekStringForDate:(NSDate *)date;

/**
 获取日期的天
 
 @param date 日期
 
 @return 给定日期的天
 */
+ (int)dayForDate:(NSDate *)date;

/**
 获取日期的月份
 
 @param date 日期
 
 @return 给定日期的月份
 */
+ (int)monthForDate:(NSDate *)date;

/**
 获取日期的年份
 
 @param date 日期
 
 @return 给定日期的年份
 */
+ (int)yearForDate:(NSDate *)date;

/**
 两个日期，天的比较
 
 @param date         日期
 @param comparedDate 被比较的日期
 
 @return 早、晚、同一天、未知
 */
+ (DayCompareResult)dayCompare:(NSDate *)date comparedDate:(NSDate *)comparedDate;


@end
