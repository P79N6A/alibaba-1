//
//  UserTagServices.h
//  CultureHongshan
//
//  Created by ct on 2016/11/24.
//  Copyright © 2016年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserTagServices : NSObject
+(UserTagServices *)getInstance;
-(void)saveUserTag:(NSString *)userid citycode:(NSString *) citycode tagcontent:(NSString *) tagcontent;
-(NSString * )getUserTag:(NSString *)userid citycode:(NSString *) citycode;
@end
