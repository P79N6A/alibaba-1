//
//  UserInfo.m
//  CultureHongshan
//
//  Created by xiao on 15/7/13.
//  Copyright (c) 2015年 Sun3d. All rights reserved.
//

#import "UserMessage.h"


@implementation UserMessage

-(id)initWithAttributes:(NSDictionary *)dictionary
{
    if(self = [super init]){
        
        if (!dictionary || ![dictionary isKindOfClass:[NSDictionary class]])
        {
            return nil;
        }
        
        self.messageContent = [dictionary safeStringForKey:@"messageContent"];
        self.messageType    = [dictionary safeStringForKey:@"messageType"];
        self.messageId      = [dictionary safeStringForKey:@"userMessageId"];
    }
    return self;
}

+(NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray
{
    if (!dicArray || ![dicArray isKindOfClass:[NSArray class]])
    {
        return @[];
    }
    
    NSMutableArray *instanceArray = [NSMutableArray array];
    for (NSDictionary *instanceDic in dicArray) {
        UserMessage *model = [[UserMessage alloc] initWithAttributes:instanceDic];
        if (model) {
            [instanceArray addObject:model];
        }
    }
    return [NSArray arrayWithArray:instanceArray];
}

@end
