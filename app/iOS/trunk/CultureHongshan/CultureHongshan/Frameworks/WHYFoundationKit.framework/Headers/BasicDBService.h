//
//  BasicDBService.h
//  WHYFoundationKit
//
//  Created by JackAndney on 2017/5/14.
//  Copyright © 2017年 Creatoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasicDBService : NSObject

+ (instancetype)sharedService;
- (BOOL)execSql:(NSString *)sql;
- (NSArray<NSDictionary *> *)querySql:(NSString *)sql;

@end
