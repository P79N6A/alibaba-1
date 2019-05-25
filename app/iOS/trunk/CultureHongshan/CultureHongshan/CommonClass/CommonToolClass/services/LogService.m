//
//  LogService.m
//  CultureHongshan
//
//  Created by ct on 16/11/8.
//  Copyright © 2016年 CT. All rights reserved.
//

#import "LogService.h"

#import "WHYHttpRequest.h"

#define MIN_VIEW_DURATION 3

@implementation LogModel

-(id)init
{
    if(self = [super init])
    {
        _currentClassName = @"";
        _key = @"";
        _startTimeInterval = 0;
        _endTimeInterval = 0;
    }
    
    return self;
}
@end

static LogService * instance;
@implementation LogService

+(LogService *)getInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [LogService new];
        instance.mapDic = [NSMutableDictionary new];
        [instance resetValue];
    });
    return instance;
}


-(void)resetValue
{
  
}


+(void)updateLogKey:(NSString * )key addr:(NSString *)addr
{
    LogModel * model = instance.mapDic[addr];
    model.key = key;

}

+ (void)uploadLog:(NSString *)addr
{
    if (DEBUG_MODE) return;
    
    LogModel * logModel = instance.mapDic[addr];
    
    if(logModel == nil) return;
    
    NSTimeInterval offset = logModel.endTimeInterval - logModel.startTimeInterval;
    
    if(offset > MIN_VIEW_DURATION) {
        
        UserService *userInfo = [UserService sharedService];
        
        NSMutableString *logUrl = [[NSMutableString alloc] initWithString:@"http://www.wenhuayun.cn/stat/stat.jsp?"];
        [logUrl appendFormat:@"userid=%@&", userInfo.userId];
        [logUrl appendFormat:@"stype=%@&", logModel.currentClassName];
        [logUrl appendFormat:@"skey1=%@&", logModel.key];
        [logUrl appendFormat:@"skey2=%.0f&", offset];
        [logUrl appendFormat:@"skey3=%.1f&", IOS_VERSION];
        [logUrl appendFormat:@"skey4=%@&", APP_VERSION];
        [logUrl appendFormat:@"GUID=%@&", [ToolClass getUUID]];
        [logUrl appendFormat:@"ostype=%@&platform=iphone_p&", APP_BUNDLE_ID];
        [logUrl appendFormat:@"localurl=%@&", @""];
        [logUrl appendFormat:@"lat=%f&lont=%f&", userInfo.userLat, userInfo.userLon];
        [logUrl appendFormat:@"citycode=%@", CITY_AD_CODE];
        
        [WHYHttpRequest requestWithURL:logUrl method:HttpMethodGet params:nil requestHeaders:[ProtocolBased requestHeaderParams] withTag:nil completionHandler:nil];
    }
    [[LogService getInstance] resetValue];
    
}



+(void)beginLog:(NSString * )classname addr:(NSString *)addr
{
    FBLOG(@"------beginLog-------%@:%@",classname,addr);
    LogModel * model = [LogModel new];
    LogService * logSrv = [LogService getInstance];
    logSrv.mapDic[addr] = model;
    model.currentClassName = classname;
    model.startTimeInterval = [NSDate timeIntervalSinceReferenceDate];

}


+(void)endLog:(NSString * )classname  addr:(NSString *)addr
{
    FBLOG(@"------endLog-------%@:%@",classname,addr);
    LogModel * model =  instance.mapDic[addr];
    
    if (model == nil) return;
    
    model.endTimeInterval = [NSDate timeIntervalSinceReferenceDate];
    [LogService uploadLog:addr];
    [instance.mapDic removeObjectForKey:addr];
    model = nil;
}





@end
