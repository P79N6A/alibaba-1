//
//  ActivityFilterModel.h
//  FSDropDownMenu
//
//  Created by ct on 16/3/11.
//  Copyright © 2016年 chx. All rights reserved.
//

#import <Foundation/Foundation.h>


/*       —————————————— 区域 Model ——————————————————       */

@interface AreaFilterListModel : NSObject

@property (nonatomic,copy) NSString *conditionName;//筛选的名字
@property (nonatomic,copy) NSString *conditionId;//筛选的id：id或者区域代码

@property (nonatomic,strong) NSArray *listArray;


- (id)initWithDictItem:(NSDictionary *)dict;

/**
 *  返回区域Model数组
 *
 *  @param dictArray 字典数组
 *
 *  @return 区域Model数组
 */
+ (NSArray *)listArrayWithDictArray:(NSArray *)dictArray;


@end



/*       —————————————— 商圈Model ——————————————————       */



@interface AreaFilterModel : NSObject

@property (nonatomic,copy) NSString *conditionName;//筛选条件的名字
@property (nonatomic,copy) NSString *conditionId;//筛选条件的id：商圈id
@property (nonatomic,copy) NSString *areaCode;//区域代码

/**
 *  返回商圈Model数组
 *
 *  @param dictArray 字典数组
 *  @param areaCode  区域代码
 *
 *  @return 商圈Model数组
 */
+ (NSArray *)listArrayWithDictArray:(NSArray *)dictArray areaCode:(NSString *)areaCode;

@end

