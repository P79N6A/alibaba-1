//
//  SearchLocationTag.m
//  CultureHongshan
//
//  Created by ct on 15/11/11.
//  Copyright © 2015年 CT. All rights reserved.
//

#import "SearchLocationTag.h"

@implementation SearchLocationTag


- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if (!dict || ![dict isKindOfClass:[NSDictionary class]])
        {
            return nil;
        }
        
        NSString *areaStr = [dict safeStringForKey:@"areaCode"];
        
        NSArray *components = nil;
        if ([areaStr rangeOfString:@":"].location != NSNotFound)
        {
            components = [areaStr componentsSeparatedByString:@":"];
        }
        else//([areaStr rangeOfString:@","].location != NSNotFound)
        {
            components = [areaStr componentsSeparatedByString:@","];
        }
        
        if (components.count >= 2)
        {
            self.areaCode = components[0];
            self.areaName = components[1];
        }
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
        SearchLocationTag *model = [[SearchLocationTag alloc] initWithDict:instanceDic];
        if (model) {
            [instanceArray addObject:model];
        }
    }
    
    return [instanceArray copy];
}



@end
