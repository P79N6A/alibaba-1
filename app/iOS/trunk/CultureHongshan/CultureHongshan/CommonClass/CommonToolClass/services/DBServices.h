//
//  DBServices.h
//  徐家汇
//
//  Created by 李 兴 on 13-9-18.
//  Copyright (c) 2013年 李 兴. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBServices : NSObject
{
    char * errmsg;
}

+(DBServices * )shareInstance;
-(Boolean) exec:(NSString *)s;
-(NSArray *)query:(NSString *)s;
@end
