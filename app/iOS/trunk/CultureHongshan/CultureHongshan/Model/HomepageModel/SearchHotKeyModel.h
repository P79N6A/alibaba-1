//
//  SearchHotKeyModel.h
//  CultureHongshan
//
//  Created by ct on 16/4/20.
//  Copyright © 2016年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchHotKeyModel : NSObject


@property (nonatomic,copy) NSString *hotKey;


+ (NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray;


@end
