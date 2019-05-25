//
//  JiaDingTicketModel.h
//  CultureHongshan
//
//  Created by ct on 16/3/21.
//  Copyright © 2016年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JiaDingTicketModel : NSObject

@property (nonatomic, copy) NSString *activityId;
@property (nonatomic, assign) NSInteger ticketCount;


+ (NSDictionary *)listDictWithDict:(NSDictionary *)dict;


@end
