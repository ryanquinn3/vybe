//
//  SideMenuViewController.h
//  Vybe
//
//  Created by Ryan Quinn on 3/14/14.
//  Copyright (c) 2014 vybe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICSDrawerController.h"
#import <MapKit/MapKit.h>
#import "Bar.h"
#import "BarMapViewController.h"
#import <Parse/Parse.h>
#import "BarListViewController.h"
#import "ListNavViewController.h"
#import "MapNavViewController.h"
#import "VybeUtil.h"

@interface SideMenuViewController : UIViewController <ICSDrawerControllerChild,ICSDrawerControllerPresenting, UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) ICSDrawerController * drawer;

@property (strong,nonatomic) NSArray* nearbyBars;


-(void) setViewControllers:(NSArray *)viewControllers;
-(void)setNearbyBars:(NSArray *)nearbyBars;

@end
