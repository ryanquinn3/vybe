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
#import "BarListViewController"

@interface SideMenuViewController : UIViewController <ICSDrawerControllerChild,ICSDrawerControllerPresenting, UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) ICSDrawerController * drawer;
@property (strong,nonatomic) CLLocation* location;



-(void) setViewControllers:(NSArray *)viewControllers;


@end
