//
//  MapViewController.m
//  Vybe
//
//  Created by Adriana Diakite on 11/16/13.
//  Copyright (c) 2013 vybe. All rights reserved.
//

#import "VybeViewController.h"
#import "BarViewController.h"
#import "BarTVC.h"
#import "VybeUtil.h"



@interface VybeViewController () < MKMapViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) BarTVC *tvc;
@property (weak, nonatomic) IBOutlet UITableView *storyboardTvc;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) NSInteger locationErrorCode;
@property (strong, nonatomic) IBOutlet UILabel *vyberCountLabel;




@end

@implementation VybeViewController


- (void)setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    self.mapView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.locationManager startUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.locationManager stopUpdatingLocation];
    self.location = nil;
}
#pragma mark - Location

- (CLLocationManager *)locationManager
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
        self.tvc.nearbyBars = nil;
        [self updateMapViewAnnotations];
        [self.storyboardTvc reloadData];
    }
    
}

- (BarTVC *)tvc
{
    if (!_tvc) {
        _tvc = [[BarTVC alloc] init];
        _tvc.mvc = self;
    }
    return _tvc;
}
-(void)showTable
{
    self.storyboardTvc.hidden = NO;
    self.storyboardTvc.separatorStyle = UITableViewCellSelectionStyleNone;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(DRK_BLUE, 1);
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(MIDNIGHT_BLUE, 1);
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(CONCRETE, 1);
   
    
    self.vyberCountLabel.backgroundColor = UIColorFromRGB(MIDNIGHT_BLUE, 1);
    self.vyberCountLabel.font = VYBE_FONT(17.0);
    self.storyboardTvc.delegate = self.tvc;
    self.storyboardTvc.dataSource = self.tvc;
    [ self updateMapViewAnnotations];
    self.storyboardTvc.hidden = YES;
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showBar"]) {
        self.dvc = segue.destinationViewController;
        
    }
}

- (void)updateMapViewAnnotations
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    for (Bar *bar in self.tvc.nearbyBars) {
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


@end
