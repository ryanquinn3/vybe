//
//  ListNavViewController.h
//  Vybe
//
//  Created by Ryan Quinn on 3/14/14.
//  Copyright (c) 2014 vybe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICSDrawerController.h"
#import "BarListViewController.h"
#import "SideMenuViewController.h"

@interface ListNavViewController : UINavigationController <ICSDrawerControllerChild,ICSDrawerControllerPresenting>

@property (weak,nonatomic)ICSDrawerController* drawer;
@property (strong,nonatomic) NSArray* nearbyBars;


-(void)menuPressed;

@end
