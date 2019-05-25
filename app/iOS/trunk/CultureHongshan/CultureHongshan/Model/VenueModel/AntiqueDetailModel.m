//
//  AntiqueDetailModel.m
//  CultureHongshan
//
//  Created by one on 15/11/23.
//  Copyright © 2015年 CT. All rights reserved.
//

#import "AntiqueDetailModel.h"

@implementation AntiqueDetailModel

-(id)initWithAttributes:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        if (!dictionary || ![dictionary isKindOfClass:[NSDictionary class]])
        {
            return nil;
        }
        self.antiqueId            = [dictionary safeStringForKey:@"antiqueId"];
        self.antiqueImgUrl        = [dictionary safeStringForKey:@"antiqueImgUrl"];
        self.antiqueTime          = [dictionary safeStringForKey:@"antiqueTime"];
        self.antiqueName          = [dictionary safeStringForKey:@"antiqueName"];
        self.antiqueSpectfictaion = [dictionary safeStringForKey:@"antiqueSpectfication"];
        self.VenueName            = [dictionary safeStringForKey:@"venueName"];
        self.antiqueVoiceUrl      = [dictionary safeStringForKey:@"antiqueVoiceUrl"];
        self.antiqueVideoUrl      = [dictionary safeStringForKey:@"antiqueVideoUrl"];
        
        
        NSString *antiqueRemark = [dictionary safeStringForKey:@"antiqueRemark"];
        if (antiqueRemark.length) {
            self.antiqueIntroduction = antiqueRemark.isPlainText ? [NSString stringWithFormat:@"<p style='margin-left:8px'>简介：</p><p>%@</p>",antiqueRemark] : [NSString stringWithFormat:@"<p style='margin-left:8px'>简介：</p>%@",antiqueRemark];
        }else {
            self.antiqueIntroduction = @"";
        }
    }
    return self;
}


+(NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray
{
    if (!dicArray || ![dicArray isKindOfClass:[NSArray class]])
    {
        return @[];
    }
    
    NSMutableArray *instanceArray = [NSMutableArray array];
    for (NSDictionary *instanceDic in dicArray) {
        AntiqueDetailModel *model = [[AntiqueDetailModel alloc] initWithAttributes:instanceDic];
        if (model) {
            [instanceArray addObject:model];
        }
    }
    return [NSArray arrayWithArray:instanceArray];
}

@end
