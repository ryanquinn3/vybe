//
//  MapNavViewController.h
//  Vybe
//
//  Created by Ryan Quinn on 3/14/14.
//  Copyright (c) 2014 vybe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICSDrawerController.h"
#import "BarMapViewController.h"

@interface MapNavViewController : UINavigationController<ICSDrawerControllerChild,ICSDrawerControllerPresenting>

@property (weak,nonatomic)ICSDrawerController* drawer;
@property (strong,nonatomic) NSArray* nearbyBars;


-(void)menuPressed;


@end
