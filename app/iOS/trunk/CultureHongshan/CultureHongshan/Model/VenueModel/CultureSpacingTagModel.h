//
//  CultureSpacingTagModel.h
//  CultureHongshan
//
//  Created by ct on 16/7/28.
//  Copyright © 2016年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CultureSpacingTagModel : NSObject

@property (nonatomic, assign) NSInteger type;// 暂时没用
@property (nonatomic, assign) BOOL tagIsOuterLink;//是否为外链

@property (nonatomic, copy  ) NSString  *tagId;// 网址 或 标签id
@property (nonatomic, copy  ) NSString  *tagName;
@property (nonatomic, assign) NSInteger tagSort;// 排序

+ (NSArray *)listArrayWithArray:(NSArray *)dictArray type:(NSInteger)type;

+ (NSArray *)getTestData;

@end
