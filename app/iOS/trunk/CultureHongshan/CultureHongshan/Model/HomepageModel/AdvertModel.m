//
//  AdvertModel.m
//  CultureHongshan
//
//  Created by ct on 16/6/27.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "AdvertModel.h"

@implementation AdvertModel

- (id)initWithItemDict:(NSDictionary *)itemDict type:(NSInteger)type
{
    if (self = [super init])
    {
        if (!itemDict || ![itemDict isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
        self.type = type;
        
        if (type == 1) { // 文化活动列表中的插入广告（跟随标签切换）
            self.advImgUrl   = [itemDict safeStringForKey:@"advertImgUrl"];
            self.advUrl      = [itemDict safeStringForKey:@"advertUrl"];
            self.advLinkType = -1;
            self.isOuterLink = YES;
            self.advertSort  = [itemDict safeIntegerForKey:@"advertSort"];
            
            self.advShareImgUrl  = [itemDict safeStringForKey:@"advShareImgUrl"];
            self.advShareContent = [itemDict safeStringForKey:@"advShareContent"];
        }else if (type == 2) { // 文化日历中的一个广告
            self.advertName  = [itemDict safeStringForKey:@"advertName"];
            self.advImgUrl   = [itemDict safeStringForKey:@"advImgUrl"];
            self.advUrl      = [itemDict safeStringForKey:@"advUrl"];
            self.advLinkType = [itemDict safeIntegerForKey:@"advLinkType"];
            self.isOuterLink = [itemDict safeIntegerForKey:@"advLink"] == 1;
            
            self.advShareImgUrl  = [itemDict safeStringForKey:@"advShareImgUrl"];
            self.advShareContent = [itemDict safeStringForKey:@"advShareContent"];
        }else { // type = 3、4
            self.advertId    = [itemDict safeStringForKey:@"advertId"];
            self.advertName  = [itemDict safeStringForKey:@"advertTitle"];
            self.advertType  = [itemDict safeStringForKey:@"advertType"];
            self.advImgUrl   = [itemDict safeStringForKey:@"advertImgUrl"];
            self.advUrl      = [itemDict safeStringForKey:@"advertUrl"];
            self.advLinkType = [itemDict safeIntegerForKey:@"advertLinkType"];
            self.isOuterLink = [itemDict safeIntegerForKey:@"advertLink"] == 1;
            self.advertSort  = [itemDict safeIntegerForKey:@"advertSort"];
            
            self.advShareImgUrl  = [itemDict safeStringForKey:@"advShareImgUrl"];
            self.advShareContent = [itemDict safeStringForKey:@"advShareContent"];
        }
        
        // 文化空间列表中的插入广告（不跟随标签切换）
    }
    return self;
}

+ (NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray type:(NSInteger)type
{
    if (![dicArray isKindOfClass:[NSArray class]] || !dicArray)
    {
        return @[];
    }
    
    NSMutableArray *instanceArray = [NSMutableArray array];
    for (NSDictionary *instanceDic in dicArray)
    {
        AdvertModel *model = [[AdvertModel alloc] initWithItemDict:instanceDic type:type];
        if (model) {
            [instanceArray addObject:model];
        }
    }
    
    if (type == 3) {
        [AdvertModel sortAdvertArray:instanceArray];
    }
    
    return [NSArray arrayWithArray:instanceArray];
}

// 进行位置排序
+ (void)sortAdvertArray:(NSMutableArray *)modelArray
{
    if ([modelArray isKindOfClass:[NSMutableArray class]] && modelArray.count) {
        
        [modelArray sortUsingComparator:^NSComparisonResult(AdvertModel *obj1, AdvertModel *obj2) {
            
            if (obj1.advertSort > obj2.advertSort) {
                return NSOrderedDescending;
            }else if (obj1.advertSort < obj2.advertSort) {
                return NSOrderedAscending;
            }else{
                return NSOrderedSame;
            }
        }];
    }
}

@end
