//
//  SearchHotKeyModel.m
//  CultureHongshan
//
//  Created by ct on 16/4/20.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "SearchHotKeyModel.h"

@implementation SearchHotKeyModel


- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        //防止返回null时崩溃
        if (dict == nil || ![dict isKindOfClass:[NSDictionary class]])
        {
            return nil;
        }
        self.hotKey = [dict safeStringForKey:@"hotKeywords"];
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
        SearchHotKeyModel *model = [[SearchHotKeyModel alloc] initWithDict:instanceDic];
        if (model) {
            [instanceArray addObject:model];
        }
    }
    
    return [NSArray arrayWithArray:instanceArray];
}


@end
