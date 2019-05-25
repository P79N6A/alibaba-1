//
//  UserInfo.h
//  CultureHongshan
//
//  Created by xiao on 15/7/13.
//  Copyright (c) 2015年 Sun3d. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserMessage : NSObject

@property (strong,nonatomic) NSString *messageContent;
@property (strong,nonatomic) NSString *messageType;
@property (strong,nonatomic) NSString *messageId;//（删除消息使用）

- (id)initWithAttributes:(NSDictionary *)dictionary;
+ (NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray;

@end
