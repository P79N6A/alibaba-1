//
//  UserGroupInfoListModel.h
//  CultureHongshan
//
//  Created by ct on 15/11/25.
//  Copyright © 2015年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>

//请求参数：userId


@interface UserGroupInfoListModel : NSObject

@property (nonatomic, strong) NSArray *listArray;


- (id)initWithListArray:(NSArray *)array;



@end



@interface GroupInfoModel : NSObject

@property (nonatomic, copy) NSString *teamUserName;//团体用户名称
@property (nonatomic, copy) NSString *TUserId;//团体用户id

//status:
//查询信息成功
//该用户不是团体用户

- (id)initWithAttributes:(NSDictionary *)dictionary;



@end
