//
//  DBServices.m
//  徐家汇
//
//  Created by 李 兴 on 13-9-18.
//  Copyright (c) 2013年 李 兴. All rights reserved.
//

#import "DBServices.h"
#import <sqlite3.h>

static DBServices * instance;
static sqlite3 * dbHandel;
@implementation DBServices

+(DBServices *)shareInstance
{
    if (instance == nil)
    {
        
        NSString  * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        path = [path stringByAppendingPathComponent:@"thousandStone.sqlite"];
        FBLOG(@"sql path is %@",path);
        if (sqlite3_open([path UTF8String], &dbHandel) == SQLITE_OK)
        {
            [ToolClass addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:path]];
            instance = [[self alloc] init];
        }
        else
        {
            FBLOG(@"create db \"thousandStone.sqlite\" failed");
        }
    }
    return instance;
}





-(Boolean) exec:(NSString *)s
{
    //s = [s stringByReplacingOccurrencesOfString:@"'" withString:@"''"];//单引号替换成双单引号
    char * sql = (char * )[s UTF8String];
    int result = sqlite3_exec(dbHandel, sql, NULL, NULL, &errmsg);
    if (result != SQLITE_OK)
    {
        FBLOG(@"DBServices.exec (%s) arose erros:%s",sql,errmsg);
        errmsg = nil;
        return NO;
    }
    return YES;
}


-(NSArray *)query:(NSString *)s
{
    
    char * sql = (char * )[s UTF8String];
    
    sqlite3_stmt * stmt;
    int result = sqlite3_prepare_v2(dbHandel, sql, -1, &stmt, NULL);
    if (result != SQLITE_OK)
    {
        FBLOG(@"DBServices.query (%s) arose erros:%s",sql,errmsg);
        errmsg = nil;
        return nil;
    }
    
    NSMutableArray * array = [[NSMutableArray alloc] init];
    while (sqlite3_step(stmt) == SQLITE_ROW)
    {
        NSMutableDictionary * d = [[NSMutableDictionary alloc] init];
        int counts = sqlite3_column_count(stmt);
        for (int i=0; i<counts; i++)
        {
            char * c = (char *)sqlite3_column_text(stmt, i);
            if (c == nil)
            {
                c = "";
            }
            NSString * value = [NSString stringWithUTF8String:c];
            NSString * key = [NSString stringWithUTF8String:(char * )sqlite3_column_name(stmt, i)];
            [d setObject:value forKey:key];
        }
        
        [array addObject:d];
        
        
    }
    sqlite3_finalize(stmt);
    
    return array;
}

-(void)dealloc
{
    sqlite3_close(dbHandel);
    dbHandel = nil;
}

@end
