//
//  TagModel.m
//  CultureHongshan
//
//  Created by ct on 15/11/7.
//  Copyright © 2015年 CT. All rights reserved.
//

#import "TagModel.h"


@implementation TagModel

-(instancetype)initWithAttributes:(NSDictionary *)dict type:(NSInteger)type
{
    if (self = [super init]) {
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
        self.type = type;
        
        if (type == 1) {
            
        }else if (type == 2){
            
        }else if (type == 3){
            
        }else if (type == 4){
            
        }else if (type == 5){
            
        }
    }
    return self;
}


+ (NSArray *)listArrayWithArray:(NSArray *)dictArray type:(NSInteger)type
{
    if (!dictArray || ![dictArray isKindOfClass:[NSArray class]]) {
        return @[];
    }
    
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *dict in dictArray) {
        TagModel *model = [[TagModel alloc] initWithAttributes:dict type:type];
        if (model) {
            [tmpArray addObject:model];
        }
    }
    return [tmpArray copy];
}
@end



@implementation ThemeTagModel//活动主题标签

- (id)initWithItemDict:(NSDictionary *)itemDict
{
    if (self = [super init])
    {
        if (!itemDict || ![itemDict isKindOfClass:[NSDictionary class]])
        {
            return nil;
        }
        self.recommendTagId = @"";
        self.tagName = [itemDict safeStringForKey:@"tagName"];
        self.tagId = [itemDict safeStringForKey:@"tagId"];
        self.tagImageUrl = [itemDict safeStringForKey:@"tagImageUrl"];
        
        self.status = [itemDict safeStringForKey:@"status"];
    }
    return self;
}


+ (NSArray *)listArrayWithArray:(NSArray *)array
{
    if (![array isKindOfClass:[NSArray class]] || !array)
    {
        return @[@"",@[]];
    }
    
    NSString *recommendTagId = @"";
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
    
    NSInteger recommendIndex = -1;
    
//    for (int i = 0; i < array.count; i++)
//    {
//        NSDictionary *dict = array[i];
//        NSString *tagName = [dict safeStringForKey:@"tagName"];
//        if ([tagName isEqualToString:@"推荐"])
//        {
//            recommendIndex = i;
//            break;
//        }
//    }
    
    if (recommendIndex > -1)
    {
        recommendTagId = array[recommendIndex][@"tagId"];
    }
    
    for (NSDictionary *item in array)
    {
        if (![item[@"tagName"] isEqualToString:@"推荐"])
        {
            ThemeTagModel *model = [[ThemeTagModel alloc] initWithItemDict:item];
            if (model.tagId.length && model.tagName.length) {
                [tmpArray addObject:[[self alloc] initWithItemDict:item]];
            }
        }
    }
    
    
    return @[recommendTagId, [tmpArray copy]];
}

@end


