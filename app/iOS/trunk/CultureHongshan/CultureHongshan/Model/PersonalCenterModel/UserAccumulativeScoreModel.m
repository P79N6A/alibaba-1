//
//  UserAccumulativeScoreModel.m
//  CultureHongshan
//
//  Created by ct on 16/5/27.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "UserAccumulativeScoreModel.h"

@implementation UserAccumulativeScoreModel

-(id)initWithAttributes:(NSDictionary *)dictionary
{
    if(self = [super init]){
        
        if (!dictionary || ![dictionary isKindOfClass:[NSDictionary class]])
        {
            return nil;
        }
        
        self.changeType       = [dictionary safeIntegerForKey:@"changeType"];
        self.scoreType        = [dictionary safeStringForKey:@"name"];
        self.scoreDescription = [dictionary safeStringForKey:@"description"];
        self.scoreDate        = [dictionary safeStringForKey:@"date"];
        
        NSString *flag = (_changeType == 1) ? @"-" : @"+";
        self.scoreValue = [NSString stringWithFormat:@"%@ %@",flag,StrFromInt([dictionary safeIntegerForKey:@"integralChange"])];
    }
    return self;
}


+ (NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray
{
    if (!dicArray || ![dicArray isKindOfClass:[NSArray class]])
    {
        return @[];
    }
    
    NSMutableArray *instanceArray = [NSMutableArray array];
    for (NSDictionary *instanceDic in dicArray) {
        [instanceArray addObject:[[self alloc] initWithAttributes:instanceDic]];
    }
    return [NSArray arrayWithArray:instanceArray];
}

@end
