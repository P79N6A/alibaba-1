//
//  SearchTag.h
//  CultureHongshan
//
//  Created by ct on 15/11/10.
//  Copyright © 2015年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchTag : NSObject


@property (nonatomic,copy) NSString *tagId;
@property (nonatomic,copy) NSString *tagName;


+ (NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray;


@end
