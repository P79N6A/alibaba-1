//
//  LogService.h
//  CultureHongshan
//
//  Created by ct on 16/11/8.
//  Copyright © 2016年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 日志、用户行为记录
 */
@interface LogModel : NSObject
@property(nonatomic,strong) NSString * currentClassName;
@property(nonatomic,strong)  NSString * key;
@property(nonatomic) NSTimeInterval  startTimeInterval;
@property(nonatomic) NSTimeInterval  endTimeInterval;
@end

@interface LogService : NSObject
{
    
    NSMutableDictionary * _mapDic;
    
}
@property(nonatomic,strong)  NSMutableDictionary * mapDic;


-(void)resetValue;
+(LogService *)getInstance;



// 上传日志

+(void)updateLogKey:(NSString * )key addr:(NSString *)addr;
+(void)beginLog:(NSString *)classname addr:(NSString *)addr;
+(void)endLog:(NSString *)classname addr:(NSString *)addr;
@end

