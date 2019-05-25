//
//  SearchLocationTag.h
//  CultureHongshan
//
//  Created by ct on 15/11/11.
//  Copyright © 2015年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchLocationTag : NSObject

@property (nonatomic,copy) NSString *areaCode;//区域码
@property (nonatomic,copy) NSString *areaName;//地名

+ (NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray;


@end
