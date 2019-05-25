//
//  MyCommentModel.m
//  CultureHongshan
//
//  Created by ct on 16/4/13.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "MyCommentModel.h"

@implementation MyCommentModel


- (id)initWithDict:(NSDictionary *)dict withType:(DataType)type
{
    if (self = [super init])
    {
        //防止返回null时崩溃
        if (dict == nil || ![dict isKindOfClass:[NSDictionary class]] || (type != 1 && type != 2)) {
            return nil;
        }
        self.type = type;
        
        NSString *commentIdKey = (type == DataTypeActivity) ? @"commentId":@"commentId";
        NSString *modelIdKey   = (type == DataTypeActivity) ? @"activityId":@"venueId";
        NSString *titleKey     = (type == DataTypeActivity) ? @"activityName":@"venueName";
        NSString *addressKey   = (type == DataTypeActivity) ? @"venueName":@"";
        NSString *contentKey   = (type == DataTypeActivity) ? @"commentRemark":@"commentRemark";
        NSString *imageUrlKey  = (type == DataTypeActivity) ? @"commentImgUrl":@"commentImgUrl";
        NSString *dateKey      = (type == DataTypeActivity) ? @"commentTime":@"commentTime";
        
        
        self.commentId     = [dict safeStringForKey:commentIdKey];
        self.modelId       = [dict safeStringForKey:modelIdKey];
        self.titleStr      = [dict safeStringForKey:titleKey];
        self.addressStr    = [dict safeStringForKey:addressKey];
        self.contentStr    = [dict safeStringForKey:contentKey];
        self.imageUrlArray = [self getImageUrlArrayWithUrlStr:[dict safeStringForKey:imageUrlKey]];
        self.dateStr       = [dict safeStringForKey:dateKey];
        
        if (type==DataTypeActivity) {
            if (_addressStr.length < 1) {
                self.addressStr = [ToolClass getJointedString:dict[@"activityAddress"] otherStr:dict[@"activitySite"] jointedBy:@"."];
            }
        }
    }
    return self;
}


- (NSArray *)getImageUrlArrayWithUrlStr:(NSString *)imageUrlStr
{
    if (imageUrlStr == nil || ![imageUrlStr isKindOfClass:[NSString class]])
    {
        return @[];
    }
    imageUrlStr = [imageUrlStr stringByReplacingOccurrencesOfString:@";" withString:@","];
    imageUrlStr = [imageUrlStr stringByReplacingOccurrencesOfString:@"，" withString:@","];
    NSArray *imageUrlArray = [imageUrlStr componentsSeparatedByString:@","];
    
    NSMutableArray *tmpArray = [NSMutableArray new];
    for (int i = 0; i < imageUrlArray.count && i < 9; i++) {
        NSString *str = imageUrlArray[i];
        if (str.length) {
            [tmpArray addObject:str];
        }
    }
    return [tmpArray copy];
}



+ (NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray withType:(DataType)type
{
    if (dicArray == nil || ![dicArray isKindOfClass:[NSArray class]])
    {
        return nil;
    }
    
    NSMutableArray *instanceArray = [NSMutableArray array];
    for (NSDictionary *instanceDic in dicArray)
    {
        MyCommentModel *model = [[MyCommentModel alloc] initWithDict:instanceDic withType:type];
        if (model) {
            [instanceArray addObject:model];
        }
    }
    return [instanceArray copy];
}


@end
