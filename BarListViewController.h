//
//  BarListViewController.h
//  Vybe
//
//  Created by Ryan Quinn on 3/14/14.
//  Copyright (c) 2014 vybe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VybeUtil.h"
#import "Bar.h"
#import "RateBarViewController.h"
#import "ICSDrawerController.h"
#import "ListNavViewController.h"



@interface BarListViewController : UIViewController <ICSDrawerControllerChild, ICSDrawerControllerPresenting>
@property (nonatomic,weak) ICSDrawerController* drawer;
@property (strong,nonatomic) NSArray* nearbyBars;

-(void) setNearbyBars:(NSArray *)nearbyBars;
@end
