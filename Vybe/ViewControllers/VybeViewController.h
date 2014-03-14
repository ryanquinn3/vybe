//
//  MapViewController.h
//  Vybe
//
//  Created by Adriana Diakite on 11/16/13.
//  Copyright (c) 2013 vybe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bar.h"
#import "BarViewController.h"
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>



@interface VybeViewController : UIViewController
@property (nonatomic, strong) Bar *selectedBar;
@property (strong, nonatomic) BarViewController * dvc;
@property (strong, nonatomic) CLLocation *location;

-(void)showTable;


@end
