//
//  MapNavViewController.m
//  Vybe
//
//  Created by Ryan Quinn on 3/14/14.
//  Copyright (c) 2014 vybe. All rights reserved.
//

#import "MapNavViewController.h"

@interface MapNavViewController ()

@end

@implementation MapNavViewController

-(void)setNearbyBars:(NSArray *)nearbyBars
{
    _nearbyBars = nearbyBars;
    [(BarMapViewController*) self.viewControllers[0] setNearbyBars:nearbyBars];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)menuPressed
{
    [self.drawer open];
}
@end
