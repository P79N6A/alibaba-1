//
//  AntiqueDetailModel.h
//  CultureHongshan
//
//  Created by one on 15/11/23.
//  Copyright © 2015年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  藏品详情Model
 */
@interface AntiqueDetailModel : NSObject

@property (nonatomic, copy) NSString *antiqueId;
@property (nonatomic, copy) NSString *antiqueImgUrl;
@property (nonatomic, copy) NSString *antiqueTime;
@property (nonatomic, copy) NSString *antiqueName;
@property (nonatomic, copy) NSString *antiqueSpectfictaion;
@property (nonatomic, copy) NSString *VenueName;
@property (nonatomic, copy) NSString *antiqueIntroduction;
@property (nonatomic, copy) NSString *antiqueVoiceUrl;
@property (nonatomic, copy) NSString *antiqueVideoUrl;

+(NSArray *)instanceArrayFromDictArray:(NSArray *)dicArray;

@end
