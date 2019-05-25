//
//  ActivityRoomDetailModel.h
//  CultureHongshan
//
//  Created by one on 15/11/16.
//  Copyright © 2015年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityRoomDetailModel : NSObject

@property (nonatomic, strong) NSString *roomId;//活动室详情
@property (nonatomic, strong) NSString *roomName;//活动室名称
@property (nonatomic, strong) NSString *roomCapacity;//活动室客容量
@property (nonatomic, strong) NSString *roomArea;//活动室面积
@property (nonatomic, strong) NSString *roomPicUrl;//活动室图片路径
@property (nonatomic, strong) NSString *roomConsultTel;//活动室咨询电话
@property (nonatomic, strong) NSString *roomFee;//参与方式
@property (nonatomic, assign) BOOL roomIsFree;
@property (nonatomic, strong) NSArray *facilityArray;//活动室设施
@property (nonatomic, strong) NSString *venueName;//展馆名称
@property (nonatomic, strong) NSString *venueAddress;//展馆地址
@property (nonatomic, assign) NSInteger sysNo;
@property (nonatomic, strong) NSString *roomRemark;//活动室备注

@property (nonatomic, copy) NSArray *roomTagNames;//活动室标签


@property (nonatomic, copy) NSArray *openDateArray;// @[ActivityRoomTimeModel对象]




-(id)initWithAttributes:(NSDictionary *)dictionary;
+(NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray;

@end
