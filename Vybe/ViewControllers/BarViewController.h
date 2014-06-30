//
//  RateBarViewController.h
//  Vybe
//
//  Created by Adriana Diakite on 11/16/13.
//  Copyright (c) 2013 vybe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bar.h"
#import "RateBarViewController.h"

@interface BarViewController : UIViewController
@property (nonatomic, strong) Bar *selectedBar;
@property (strong, nonatomic) IBOutlet UILabel *walkDistanceLabel;
@property (strong,nonatomic) NSString* walkDistanceString;
@end
