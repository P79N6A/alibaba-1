//
//  AppUpdateModel.h
//  CultureHongshan
//
//  Created by ct on 16/4/28.
//  Copyright © 2016年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>


/** 版本更新Model */
@interface AppUpdateModel : NSObject

/** 更新类型：0-无需更新  1-普通更新  2-强制更新 */
@property (nonatomic, assign) NSInteger updateType;
/** 是否为强制更新 */
@property (nonatomic, assign, readonly) BOOL forceUpdate;
/** 最新版本 */
@property (nonatomic, copy) NSString *updateVersion;
/** 更新简介 */
@property (nonatomic, copy) NSString *updateDescription;
/** 更新链接 */
@property (nonatomic, copy) NSString *updateLink;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
