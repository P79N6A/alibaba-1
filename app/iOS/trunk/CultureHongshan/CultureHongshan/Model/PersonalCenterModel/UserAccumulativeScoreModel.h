//
//  UserAccumulativeScoreModel.h
//  CultureHongshan
//
//  Created by ct on 16/5/27.
//  Copyright © 2016年 CT. All rights reserved.
//

/*
    积分Model
 */

#import <Foundation/Foundation.h>

@interface UserAccumulativeScoreModel : NSObject

@property (nonatomic,assign) NSInteger changeType;//积分变化类型 0:增加、1:扣除
@property (nonatomic,copy) NSString *scoreType;//积分的类型
@property (nonatomic,copy) NSString *scoreDescription;//积分获取缘由的描述
@property (nonatomic,copy) NSString *scoreValue;//积分值
@property (nonatomic,copy) NSString *scoreDate;//积分获取的日期

+ (NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray;

@end
