//
//  BarMapViewController.m
//  Vybe
//
//  Created by Ryan Quinn on 3/14/14.
//  Copyright (c) 2014 vybe. All rights reserved.
//

#import "BarMapViewController.h"

@interface BarMapViewController ()  <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

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
    [self.drawer open];
}

-(void) setNearbyBars:(NSArray *)nearbyBars
{
    self.nearbyBars = nearbyBars;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self updateMapAnnotations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
