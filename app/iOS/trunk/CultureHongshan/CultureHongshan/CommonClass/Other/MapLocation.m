//
//  MapLocation.m
//  徐家汇
//
//  Created by 李 兴 on 13-11-19.
//  Copyright (c) 2013年 李 兴. All rights reserved.
//

#import "MapLocation.h"

@implementation MapLocation
@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

-(id)initWithCoordinate:(CLLocationCoordinate2D) coords
{
    if (self = [super init])
    {
        coordinate = coords;
    }
    return self;
    
}


@end
