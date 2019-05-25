//
//  VenueSubModel.h
//  CultureHongshan
//
//  Created by ct on 16/8/10.
//  Copyright © 2016年 CT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VenueSubModel : NSObject

@property (nonatomic, copy  ) NSString  *venueId;
@property (nonatomic, assign) NSInteger actCount;
@property (nonatomic, assign) NSInteger roomCount;


+ (NSDictionary *)listDictWithDictArray:(NSArray *)dictArray;


@end
