//
//  UserTagServices.m
//  CultureHongshan
//
//  Created by ct on 2016/11/24.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "UserTagServices.h"
#import "DBServices.h"
#define DEFAULT_USERID     @"-1"
static UserTagServices * instance;
@implementation UserTagServices

+(UserTagServices *)getInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
       instance = [UserTagServices new];
        NSString * sql = @"create table if not exists usertag(id integer primary key autoincrement,userid varchar(50),citycode varchar(50),content text)";
        [[DBServices shareInstance] exec:sql];
    });
    return instance;
}


-(void)saveUserTag:(NSString *)userid citycode:(NSString *) citycode tagcontent:(NSString *) tagcontent
{
    if(![userid isNotEmpty]) userid = DEFAULT_USERID;
    
    NSString * sql = [NSString stringWithFormat:@"select count(*) as cou from usertag where userid='%@' and citycode='%@' ",userid,citycode];
    NSArray * ary = [[DBServices shareInstance] query:sql];

    if (ary.count == 1 && [ary[0][@"cou"] isEqualToString:@"0"])
    {
        sql = [NSString stringWithFormat:@"insert into usertag(userid,citycode,content) values('%@','%@','%@')",userid,citycode,tagcontent];
    }
    else
    {
        sql = [NSString stringWithFormat:@"update  usertag set content='%@' where userid='%@' and citycode='%@'",tagcontent,userid,citycode];
    }
    
    //FBLOG(@"%@ user tag result is %d\n",oper,[[DBServices shareInstance] exec:sql] );
    [[DBServices shareInstance] exec:sql];
}

-(NSString * )getUserTag:(NSString *)userid citycode:(NSString *) citycode
{
    if(![userid isNotEmpty]) userid = DEFAULT_USERID;
    
    NSString * sql = [NSString stringWithFormat:@"select content from  usertag where userid='%@' and citycode='%@' ",userid,citycode];
    NSArray * ary = [[DBServices shareInstance] query:sql];
    if (ary == nil || ary.count == 0)
    {
        return @"";
    }
    else
    {
        return ary[0][@"content"];
    }
}


@end
