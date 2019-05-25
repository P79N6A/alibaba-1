//
//  AntiqueModel.m
//  CultureHongshan
//
//  Created by one on 15/11/23.
//  Copyright © 2015年 CT. All rights reserved.
//

#import "AntiqueModel.h"


@implementation AntiqueModel

-(id)initWithAttributes:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        if (!dictionary || ![dictionary isKindOfClass:[NSDictionary class]])
        {
            return nil;
        }
        
        _antiqueId       = [dictionary safeStringForKey:@"antiqueId"];
        _antiqueImageUrl = [dictionary safeStringForKey:@"antiqueImgUrl"];
        _antiqueName     = [dictionary safeStringForKey:@"antiqueName"];
        _antiqueTime     = [dictionary safeStringForKey:@"anitqueTime"];
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
        AntiqueModel *model = [[AntiqueModel alloc] initWithAttributes:instanceDic];
        if (model) {
            [instanceArray addObject:model];
        }
    }
    return [NSArray arrayWithArray:instanceArray];
}


@end
