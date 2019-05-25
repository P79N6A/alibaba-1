//
//  ShowMapViewController.m
//  徐家汇
//
//  Created by 李 兴 on 13-11-5.
//  Copyright (c) 2013年 李 兴. All rights reserved.
//

#import "ShowMapViewController.h"
#import "MapLocation.h"

@interface ShowMapViewController ()

@end

@implementation ShowMapViewController
@synthesize mapView = _mapView;
@synthesize gps_x,gps_y;
@synthesize name,address;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN)];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    self.navigationItem.title = name;
    _mapView.mapType = MKMapTypeStandard;
    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(gps_y, gps_x);
    float zoomLev = 0.01;
    MKCoordinateRegion region = MKCoordinateRegionMake(coords,MKCoordinateSpanMake(zoomLev, zoomLev));
    [_mapView setRegion:[_mapView regionThatFits:region] animated:YES];
    [self createAnnotation:coords];
    //[_mapView addAnnotation:(id<MKAnnotation>)]
	// Do any additional setup after loading the view.
}

-(void)createAnnotation:(CLLocationCoordinate2D)coord
{
    MapLocation * anno = [[MapLocation alloc] initWithCoordinate:coord];
    anno.title = name;
    anno.subtitle = address;
    [_mapView addAnnotation:anno];
    [_mapView selectAnnotation:anno animated:YES];

}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MapLocation class]])
    {
        MKPinAnnotationView * pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotaion"];
        pinView.animatesDrop = YES;
        pinView.canShowCallout = YES;
        pinView.selected = YES;
        return pinView;
    }
    return nil;
  
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
