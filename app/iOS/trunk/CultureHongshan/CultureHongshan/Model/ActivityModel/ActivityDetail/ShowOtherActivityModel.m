//
//  ShowOtherActivityModel.m
//  CultureHongshan
//
//  Created by JackAndney on 16/7/24.
//  Copyright © 2016年 ct. All rights reserved.
//

#import "ShowOtherActivityModel.h"

@implementation ShowOtherActivityModel

- (id)initWithAttributes:(NSDictionary *)dictionary
{
    if(self = [super init])
    {
        if (dictionary == nil || ![dictionary isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
        
        self.activityId      = [dictionary safeStringForKey:@"activityId"];
        self.activityName    = [dictionary safeStringForKey:@"activityName"];
        self.activityIconUrl = [dictionary safeImgUrlForKey:@"activityIconUrl"];
        self.activityType    = [dictionary safeStringForKey:@"tagName"];
    }
    return self;
}

+ (NSArray *)listArrayWithArray:(NSArray *)array removedActivityId:(NSString *)activityId
{
    if(![array isKindOfClass:[NSArray class]] || !array)
    {
        return @[];
    }
    
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
    for (NSDictionary *item in array)
    {
        if (activityId.length && [[item safeStringForKey:@"activityId"] isEqualToString:activityId]) {
            continue;
        }
        ShowOtherActivityModel *model = [[ShowOtherActivityModel alloc] initWithAttributes:item];
        if (model) {
            [tmpArray addObject:model];
        }
    }
    return [tmpArray copy];
}



@end
