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
#import "BarViewController.h"
#import "ICSDrawerController.h"
#import "ListNavViewController.h"
#import "BarViewCell.h"
#import "LoginViewController.h"
#import "TransitionDelegate.h"
#import "SignUpViewController.h"
#import "BarDetailTableViewCell.h"


@interface BarListViewController : UIViewController <ICSDrawerControllerChild, ICSDrawerControllerPresenting,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak) ICSDrawerController* drawer;
@property (strong,nonatomic) NSArray* nearbyBars;
@property (strong,nonatomic) NSDictionary* barData;
-(void) setNearbyBars:(NSArray *)nearbyBars;
-(void) presentSignUpViewController;
@end
