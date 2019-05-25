//
//  AntiqueModel.h
//  CultureHongshan
//
//  Created by one on 15/11/23.
//  Copyright © 2015年 CT. All rights reserved.
//


#import <Foundation/Foundation.h>


/**
 *  场馆藏品列表Model
 */
@interface AntiqueModel : NSObject

@property (nonatomic, strong) NSString *antiqueImageUrl;
@property (nonatomic, strong) NSString *antiqueTime;
@property (nonatomic, strong) NSString *antiqueName;
@property (nonatomic, strong) NSString *antiqueId;

-(id)initWithAttributes:(NSDictionary *)dictionary;
+(NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray;


@end
