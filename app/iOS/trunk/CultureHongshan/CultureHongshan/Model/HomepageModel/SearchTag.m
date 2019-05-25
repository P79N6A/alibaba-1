//
//  SearchTag.m
//  CultureHongshan
//
//  Created by ct on 15/11/10.
//  Copyright © 2015年 CT. All rights reserved.
//

#import "SearchTag.h"

@implementation SearchTag


- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        //防止返回null时崩溃
        if (dict == nil || ![dict isKindOfClass:[NSDictionary class]])
        {
            return nil;
        }
        self.tagName = [dict safeStringForKey:@"tagName"];
        self.tagId   = [dict safeStringForKey:@"tagId"];
    }
    return self;
}

+ (NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray
{
    if (![dicArray isKindOfClass:[NSArray class]] || !dicArray)
    {
        return @[];
    }
    
    NSMutableArray *instanceArray = [NSMutableArray array];
    for (NSDictionary *instanceDic in dicArray)
    {
        SearchTag *model = [[SearchTag alloc] initWithDict:instanceDic];
        if (model) {
            [instanceArray addObject:model];
        }
    }
    
    return [NSArray arrayWithArray:instanceArray];
}


@end
