//
//  FontService.h
//  CultureHongshan
//
//  Created by ct on 16/6/28.
//  Copyright © 2016年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FontService : NSObject


+(void)unZipFontFile;
+(UIFont*)customFontWithPath:(CGFloat)size;
@end
