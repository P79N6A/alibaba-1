//
//  ShowMapViewController.h
//  徐家汇
//
//  Created by 李 兴 on 13-11-5.
//  Copyright (c) 2013年 李 兴. All rights reserved.
//

#import "BasicViewController.h"
#import <MapKit/MapKit.h>

@interface ShowMapViewController : BasicViewController<MKMapViewDelegate>


@property(retain,nonatomic)IBOutlet MKMapView * mapView;
@property(retain,nonatomic)NSString * address;
@property(retain,nonatomic)NSString * name;



@property double gps_x;
@property double gps_y;
@end
