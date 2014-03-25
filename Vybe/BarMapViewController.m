//
//  BarMapViewController.m
//  Vybe
//
//  Created by Ryan Quinn on 3/14/14.
//  Copyright (c) 2014 vybe. All rights reserved.
//

#import "BarMapViewController.h"

@interface BarMapViewController ()  <MKMapViewDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak,nonatomic) CLLocationManager* locationManager;
@property (nonatomic) NSInteger locationErrorCode;
@end

@implementation BarMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)menuPressed:(id)sender {
    [(MapNavViewController*)self.navigationController menuPressed];
}

-(void) setNearbyBars:(NSArray *)nearbyBars
{
    _nearbyBars = nearbyBars;
    //[self updateMapAnnotations];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(MIDNIGHT_BLUE,1);
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(CONCRETE, 1);
    self.navigationController.navigationBar.translucent = NO;
    [self.locationManager startUpdatingLocation];
	[self updateMapAnnotations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CLLocationManager*)locationManager
{
    if (!_locationManager) {
        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        
        _locationManager = locationManager;
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return _locationManager;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.location = [locations lastObject];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    self.locationErrorCode = error.code;
}


- (void)setLocation:(CLLocation *)location
{
    if (!_location) {
        _location = location;
        
    }
    
}

-(void)updateMapAnnotations
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    for (Bar *bar in self.nearbyBars) {
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        CLLocationCoordinate2D centerCoordinate;
        centerCoordinate.latitude = bar.latitude;
        centerCoordinate.longitude = bar.longitude;
        [annotation setCoordinate:centerCoordinate];
        [annotation setTitle:bar.name]; //You can set the subtitle too
        [annotations addObject:annotation];
    }
    
    [self.mapView addAnnotations:annotations];
    [self.mapView showAnnotations:annotations animated:YES];

}


- (void)drawerControllerWillOpen:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = NO;
}

- (void)drawerControllerDidClose:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = YES;
}



@end
