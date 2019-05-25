//
//  Registration.h
//  CultureHongshan
//
//  Created by xiao on 15/12/8.
//  Copyright © 2015年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 点赞（报名）Model */
@interface Registration : NSObject

@property (copy,nonatomic) NSString *userId;
@property (copy,nonatomic) NSString *userBirth;
@property (nonatomic,assign) NSInteger userSex;
@property (copy,nonatomic) NSString *userName;
@property (copy,nonatomic) NSString *userHeadImgUrl;
@property (nonatomic) NSInteger pageTotal;


+(NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray;

@end
