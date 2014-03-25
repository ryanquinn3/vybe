//
//  BarMapViewController.h
//  Vybe
//
//  Created by Ryan Quinn on 3/14/14.
//  Copyright (c) 2014 vybe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Bar.h"
#import "ICSDrawerController.h"
#import "VybeUtil.h"
#import "MapNavViewController.h"

@interface BarMapViewController : UIViewController
@property (nonatomic,weak)ICSDrawerController * drawer;
@property (strong,nonatomic) NSArray* nearbyBars;
@property (strong,nonatomic) CLLocation* location;
-(void) setNearbyBars:(NSArray *)nearbyBars;
@end
