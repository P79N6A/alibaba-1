//
//  HZPhotoItemModel.h
//  photoBrowser
//
//  Created by huangzhenyu on 15/6/23.
//  Copyright (c) 2015年 eamon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HZPhotoItemModel : NSObject

@property (nonatomic, copy) id imageOrUrlStr;//图片资源或者是图片的链接地址


@property (nonatomic, copy) NSString *lowImageUrl;
@property (nonatomic, copy) NSString *highImageUrl;


@end
