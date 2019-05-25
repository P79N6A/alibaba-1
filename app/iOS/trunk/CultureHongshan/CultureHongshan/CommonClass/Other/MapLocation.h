//
//  MapLocation.h
//  徐家汇
//
//  Created by 李 兴 on 13-11-19.
//  Copyright (c) 2013年 李 兴. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapLocation : NSObject<MKAnnotation>
{
    
    
    //NSString * address;
}
@property(copy,nonatomic)NSString * title;
@property(copy,nonatomic)NSString * subtitle;
@property(readonly,nonatomic)CLLocationCoordinate2D coordinate;

-(id)initWithCoordinate:(CLLocationCoordinate2D) coords;
@end
