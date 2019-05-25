//
//  UserGroupInfoListModel.m
//  CultureHongshan
//
//  Created by ct on 15/11/25.
//  Copyright © 2015年 CT. All rights reserved.
//

#import "UserGroupInfoListModel.h"

@implementation UserGroupInfoListModel


- (id)initWithListArray:(NSArray *)array
{
    if(self = [super init])
    {
        if (!array || ![array isKindOfClass:[NSArray class]])
        {
            return nil;
        }
        
        NSMutableArray *tmpArray = [NSMutableArray array];
        for (NSDictionary *item in array)
        {
            GroupInfoModel *aGroup = [[GroupInfoModel alloc] initWithAttributes:item];
            [tmpArray addObject:aGroup];
        }
        self.listArray = [tmpArray copy];
    }
    
    return self;
}



@end



// ———————————————— GroupInfoModel ——————————————————————



@implementation GroupInfoModel

- (id)initWithAttributes:(NSDictionary *)dictionary
{
    if(self = [super init])
    {
        if (!dictionary || ![dictionary isKindOfClass:[NSDictionary class]])
        {
            return nil;
        }
        
        self.teamUserName = dictionary[@"teamUserName"];
        self.TUserId = dictionary[@"TUserId"];
    }
    return self;
}

@end
