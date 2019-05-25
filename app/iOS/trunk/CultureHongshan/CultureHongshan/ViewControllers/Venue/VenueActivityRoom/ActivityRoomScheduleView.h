//
//  ActivityRoomScheduleView.h
//  CultureHongshan
//
//  Created by JackAndney on 16/5/29.
//  Copyright © 2016年 CT. All rights reserved.
//

#import <UIKit/UIKit.h>

/*! @brief 给类添加说明
 *
 */
@interface ActivityRoomScheduleView : UIView

@property (nonatomic,strong) NSMutableArray *listArray;//里面存放ActivityRoomTimeModel
@property (nonatomic,assign) BOOL isBookable;
@property (nonatomic, copy ,readonly) NSString *selectedDateAndTime;//选定时间段的日期、时间段和bookId: 2016-05-30|10:00-15:00|2se5e67sdr345yesrtr

- (id)initWithFrame:(CGRect)frame dataArray:(NSArray *)listArray;
+ (NSInteger)getMaxRowNumber:(NSArray *)array;

@end
