//
//  ActivityRoomBookModel.h
//  CultureHongshan
//
//  Created by ct on 16/6/12.
//  Copyright © 2016年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityRoomBookModel : NSObject

@property (nonatomic, copy) NSString *bookId;//活动室预订id
@property (nonatomic, copy) NSString *roomName;
@property (nonatomic, copy) NSString *venueName;
@property (nonatomic, copy) NSString *roomPicUrl;
@property (nonatomic, copy) NSString *roomDate;//活动室预订日期：2015年4月13日 周六
@property (nonatomic, copy) NSString *openPeriod;//活动室开放时间段
@property (nonatomic, copy) NSString *roomPrice;
@property (nonatomic, copy) NSString *orderName;
@property (nonatomic, copy) NSString *orderTel;
@property (nonatomic, copy) NSArray *teamListArray;//使用者列表

@property (nonatomic, assign) NSInteger requiredScore;//需要的积分

- (id)initWithAttributes:(NSDictionary *)dictionary;


@end



/* ———————————————————  使用者列表Model  ——————————————————————— */

@interface TeamUserListModel : NSObject

@property (nonatomic, copy) NSString *tUserId;//使用者id
@property (nonatomic, copy) NSString *tUserName;//使用者名称

+ (NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray;

@end


