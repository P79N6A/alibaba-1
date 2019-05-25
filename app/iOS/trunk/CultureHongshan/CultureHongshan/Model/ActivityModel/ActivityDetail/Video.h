//
//  Video.h
//  CultureHongshan
//
//  Created by xiao on 16/1/11.
//  Copyright © 2016年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Video : NSObject

@property (nonatomic,strong) NSString *videoImgUrl;//图片
@property (nonatomic,strong) NSString *videoTitle;//标题
@property (nonatomic,strong) NSString *videoLink;//地址
@property (nonatomic,strong) NSString *videoCreateTime;//创建时间


-(id)initWithAttributes:(NSDictionary *)dictionary;
+(NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray;


@end
