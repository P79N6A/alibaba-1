//
//  CultureSpacingTagModel.m
//  CultureHongshan
//
//  Created by ct on 16/7/28.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "CultureSpacingTagModel.h"

@implementation CultureSpacingTagModel


- (id)initWithItemDict:(NSDictionary *)itemDict type:(NSInteger)type
{
    if (self = [super init])
    {
        if (!itemDict || ![itemDict isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
        self.type = type;
        
        self.tagName        = [itemDict safeStringForKey:@"advertTitle"];
        self.tagId          = [itemDict safeStringForKey:@"advertUrl"];
        self.tagIsOuterLink = [itemDict safeIntegerForKey:@"advertLink"] == 1;
        self.tagSort        = [itemDict safeIntegerForKey:@"advertSort"];
        
        if (_tagIsOuterLink && [_tagId hasPrefix:@"http"] == NO) {
            self.tagId = @"";
        }
        
        /*
         
         advertId = 80832ec0b8764893a7ccc46d28c98764;
         advertImgUrl = "admin/45/201608/Img/Imgd052da86889e4aab83c5630f631b22f7.jpg";
         advertLink = 1;
         advertLinkType = "<null>";
         advertPostion = 2;
         advertSort = 2;
         advertState = 1;
         advertTitle = test;
         advertType = A;
         advertUrl = htp://shouce.jb51.net/spring/aop.html;
         createBy = 1;
         createTime = 1470813981000;
         updateBy = 1;
         updateTime = 1470813981000;
         
         */

    }
    return self;
}


+ (NSArray *)listArrayWithArray:(NSArray *)dicArray type:(NSInteger)type
{
    if (![dicArray isKindOfClass:[NSArray class]] || !dicArray)
    {
        return @[];
    }
    
    NSMutableArray *instanceArray = [NSMutableArray array];
    for (NSDictionary *instanceDic in dicArray)
    {
        CultureSpacingTagModel *model = [[CultureSpacingTagModel alloc] initWithItemDict:instanceDic type:type];
        if (model.tagId.length) {
            [instanceArray addObject:model];
        }
    }
    
    [instanceArray sortUsingComparator:^NSComparisonResult(CultureSpacingTagModel *obj1, CultureSpacingTagModel *obj2) {
        
        if (obj1.tagSort > obj2.tagSort) {
            return NSOrderedDescending;
        }else if (obj1.tagSort < obj2.tagSort) {
            return NSOrderedAscending;
        }else{
            return NSOrderedSame;
        }
    }];
    
    return [NSArray arrayWithArray:instanceArray];
}

+ (NSArray *)getTestData
{
    NSMutableArray *instanceArray = [NSMutableArray array];
    for (int i = 0; i < 10; i++)
    {
        CultureSpacingTagModel *model = [CultureSpacingTagModel new];
        
        model.tagIsOuterLink = arc4random()%3 && i > 1 ? NO : YES;
        if (model.tagIsOuterLink) {
            model.tagId = @"https://www.so.com/";
        }else{
            model.tagId = StrFromInt(i+1);
        }
        model.tagName = [NSString stringWithFormat:@"%02d标签",i];
        [instanceArray addObject:model];
    }
    
    return [NSArray arrayWithArray:instanceArray];
}




@end
