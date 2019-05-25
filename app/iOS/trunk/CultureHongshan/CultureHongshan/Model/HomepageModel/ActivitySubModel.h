//
//  ActivitySubModel.h
//  CultureHongshan
//
//  Created by ct on 16/3/18.
//  Copyright © 2016年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivitySubModel : NSObject

@property (nonatomic,copy) NSString *activityId;//活动id
@property (nonatomic,copy) NSString *scanCount;//浏览量
@property (nonatomic,copy) NSString *collectCount;//收藏量
@property (nonatomic,copy) NSString *commentCount;//评论量
@property (nonatomic,assign) NSInteger ticketCount;//余票

@property (nonatomic,assign) double distance;//距离
@property (nonatomic,copy) NSString *showedDistance;//显示的距离



+ (NSDictionary *)listDictWithDictArray:(NSArray *)dictArray;

@end
