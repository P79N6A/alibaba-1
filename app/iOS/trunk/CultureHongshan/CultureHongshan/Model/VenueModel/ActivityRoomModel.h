//
//  ActivityRoomModel.h
//  CultureHongshan
//
//  Created by one on 15/11/13.
//  Copyright © 2015年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityRoomModel : NSObject

@property (nonatomic, copy) NSString *roomId;//活动室id
@property (nonatomic, copy) NSString *roomPicUrl;//活动室图片
@property (nonatomic, copy) NSString *roomName;//活动室名称
@property (nonatomic, copy) NSString *roomAddress;//活动室地址(即场馆地址)
@property (nonatomic, copy) NSString *roomArea;//活动室面积
@property (nonatomic, copy) NSString *roomCapacity;//活动室客容量
@property (nonatomic, copy) NSArray *roomTagArray;//活动室标签

@property (nonatomic, copy) NSString *roomFee;//活动室费用
@property (nonatomic, assign) NSInteger sysNo;//子平台对接
@property (nonatomic, assign) NSInteger roomIsFree;//
@property (nonatomic, assign) NSInteger roomIsReserve;//活动室是否可预订（0:否 ）


-(id)initWithAttributes:(NSDictionary *)dictionary;
+(NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray;

@end
