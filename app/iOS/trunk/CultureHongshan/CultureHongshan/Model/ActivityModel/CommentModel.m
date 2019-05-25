//
//  CommentModel.m
//  CultureHongshan
//
//  Created by xiao on 15/7/9.
//  Copyright (c) 2015年 Sun3d. All rights reserved.
//

#import "CommentModel.h"


@implementation CommentModel

-(id)initWithAttributes:(NSDictionary *)dictionary
{
    if(self = [super init]){
        
        if (!dictionary || ![dictionary isKindOfClass:[NSDictionary class]])
        {
            return nil;
        }
        
        self.commentId           = [dictionary safeStringForKey:@"commentId"];
        self.commentTime         = [dictionary safeStringForKey:@"commentTime"];
        self.commentUserNickName = [dictionary safeStringForKey:@"commentUserNickName"];
        self.commentRemark       = [dictionary safeStringForKey:@"commentRemark"];
        self.commentImgUrl       = [dictionary safeStringForKey:@"commentImgUrl"];
        self.userHeadImgUrl      = [dictionary safeStringForKey:@"userHeadImgUrl"];
        self.commentStar         = [dictionary safeStringForKey:@"commentStar"];
        self.userSex             = [dictionary safeIntegerForKey:@"commentUserSex"];

        self.imageOrUrlStrArray  = [self getImageOrUrlStrArrayWithStr:_commentImgUrl];
    }
    return self;
}

//将拼接的图片链接字符串，处理成数组
- (NSArray *)getImageOrUrlStrArrayWithStr:(NSString *)imgURL
{
    if (!imgURL || ![imgURL isKindOfClass:[NSString class]])
    {
        return nil;
    }
    NSMutableArray *tmpArray = [NSMutableArray new];
    NSArray *imgUrls = [imgURL componentsSeparatedByString:@","];
    
    //最多9张图
    for (int i = 0; i < imgUrls.count && i < 9; i++)
    {
        NSString *urlStr = imgUrls[i];
        if (urlStr.length)
        {
            [tmpArray addObject:urlStr];
        }
    }
    return tmpArray;
}



+(NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray
{
    if (!dicArray || ![dicArray isKindOfClass:[NSArray class]])
    {
        return @[];
    }
    
    NSMutableArray *instanceArray = [NSMutableArray array];
    for (NSDictionary *instanceDic in dicArray)
    {
        CommentModel *model = [[CommentModel alloc] initWithAttributes:instanceDic];
        if (model) {
            [instanceArray addObject:model];
        }
    }
    return [NSArray arrayWithArray:instanceArray];
}

@end
