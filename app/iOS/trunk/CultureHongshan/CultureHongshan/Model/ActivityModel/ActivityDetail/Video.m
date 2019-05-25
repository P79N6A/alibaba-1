//
//  Video.m
//  CultureHongshan
//
//  Created by xiao on 16/1/11.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "Video.h"


@implementation Video

-(id)initWithAttributes:(NSDictionary *)dictionary
{
    if(self = [super init]){
        
        self.videoImgUrl = [dictionary safeStringForKey:@"videoImgUrl"];
        self.videoTitle = [dictionary safeStringForKey:@"videoTitle"];
        self.videoLink = [dictionary safeStringForKey:@"videoLink"];
        self.videoCreateTime = [dictionary safeStringForKey:@"videoCreateTime"];
    }
    return self;
}

+(NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray
{
    NSMutableArray *instanceArray = [NSMutableArray array];
    for (NSDictionary *instanceDic in dicArray) {
        [instanceArray addObject:[[self alloc] initWithAttributes:instanceDic]];
    }
    return [NSArray arrayWithArray:instanceArray];
}

@end
