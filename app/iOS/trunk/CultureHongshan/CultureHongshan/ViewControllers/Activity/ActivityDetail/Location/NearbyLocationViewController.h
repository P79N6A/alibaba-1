//
//  NearbyLocationViewController.h
//  CultureHongshan
//
//  Created by xiao on 15/11/18.
//  Copyright © 2015年 CT. All rights reserved.
//


#import "BasicViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface NearbyLocationViewController : BasicViewController

@property (nonatomic) CLLocationCoordinate2D locationCoordinate2D;
@property (nonatomic, copy) NSString *addressString;
@property (nonatomic, assign) DataType type;

@end

