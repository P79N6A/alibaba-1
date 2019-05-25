//
//  CommentModel.h
//  CultureHongshan
//
//  Created by xiao on 15/7/9.
//  Copyright (c) 2015年 Sun3d. All rights reserved.
//


/*
 
 
 评论的图片链接:
 
 从服务器获取的是逗号" , "分割
 发表评论时，上传图片链接是分号" ; "分割
 
 
 */
#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

@property (copy,nonatomic) NSString *commentRemark;//评论内容
@property (copy,nonatomic) NSString *commentUserNickName;//评论人昵称
@property (copy,nonatomic) NSString *commentTime;//评论时间
@property (copy,nonatomic) NSString *commentId;
@property (copy,nonatomic) NSString *commentImgUrl;//评论图片链接（,拼接的字符串）
@property (assign,nonatomic) NSInteger userSex;//用户性别:1 男 , 2 女
@property (copy,nonatomic) NSString *userHeadImgUrl;//用户头像链接
@property (copy,nonatomic) NSString *commentStar;//评论的星级

//说明：从网络上获取的都是图片链接，发表评论时是UIImage图片
@property (copy,nonatomic) NSArray *imageOrUrlStrArray;//图片或者是图片链接数组



-(id)initWithAttributes:(NSDictionary *)dictionary;
+(NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray;


@end
