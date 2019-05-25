//
//  FilterModel.m
//  FSDropDownMenu
//
//  Created by ct on 16/3/11.
//  Copyright © 2016年 chx. All rights reserved.
//

#import "ActivityFilterModel.h"

#import "CitySwitchModel.h"

@implementation AreaFilterListModel


- (instancetype)initWithDictItem:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if (!dict || ![dict isKindOfClass:[NSDictionary class]])
        {
            return nil;
        }
        /*
         
         dictId:   区域id ___暂时不需要
         dictCode: 区域code
         dictName: 区域名称
         id:       商圈id
         name:     商圈名称
         
         */
        
        self.conditionId = [dict safeStringForKey:@"dictCode"];//区域代码
        self.conditionName = [dict safeStringForKey:@"dictName"];;//区域名称
        
        
        NSArray *listArray = [AreaFilterModel listArrayWithDictArray:dict[@"dictList"] areaCode:_conditionId];
        
        NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithArray:listArray];
        AreaFilterModel *model = [AreaFilterModel new];
        model.areaCode = _conditionId;
        model.conditionId = @"";
        model.conditionName = [NSString stringWithFormat:@"全部%@",_conditionName];
        [tmpArray insertObject:model atIndex:0];
        
        self.listArray = [tmpArray copy];
    }
    return self;
}

+ (NSArray *)listArrayWithDictArray:(NSArray *)dictArray
{
    if (!dictArray || ![dictArray isKindOfClass:[NSArray class]])
    {
        return @[];
    }
    
    NSMutableArray *tmpArray = [NSMutableArray new];
    for (NSDictionary *dict in dictArray)
    {
        AreaFilterListModel *model = [[AreaFilterListModel alloc] initWithDictItem:dict];
        if (model) {
            [tmpArray addObject:model];
        }
    }
    
    AreaFilterListModel *listModel = [AreaFilterListModel new];
    listModel.conditionId = @"";
    
    listModel.conditionName = [NSString stringWithFormat:@"全%@", CITY_NAME];
    
    AreaFilterModel *model = [AreaFilterModel new];
    model.areaCode = @"";
    model.conditionId = @"";
    model.conditionName = listModel.conditionName;
    listModel.listArray = @[model];
    [tmpArray insertObject:listModel atIndex:0];
    
    return [NSArray arrayWithArray:tmpArray];
}


@end







/*       —————————————— 商圈Model ——————————————————       */


@implementation AreaFilterModel


- (id)initWithDictItem:(NSDictionary *)dict areaCode:(NSString *)areaCode
{
    if (self = [super init])
    {
        if (!dict || ![dict isKindOfClass:[NSDictionary class]])
        {
            return nil;
        }
        self.conditionId = [dict safeStringForKey:@"id"];//商圈Id
        self.conditionName = [dict safeStringForKey:@"name"];//商圈名称
        self.areaCode = areaCode;
    }
    return self;
}


+ (NSArray *)listArrayWithDictArray:(NSArray *)dictArray areaCode:(NSString *)areaCode
{
    if (!dictArray || ![dictArray isKindOfClass:[NSArray class]])
    {
        return @[];
    }
    
    NSMutableArray *tmpArray = [NSMutableArray new];
    for (NSDictionary *dict in dictArray)
    {
        [tmpArray addObject:[[self alloc] initWithDictItem:dict areaCode:areaCode]];
    }
    
    return [NSArray arrayWithArray:tmpArray];
}



@end
