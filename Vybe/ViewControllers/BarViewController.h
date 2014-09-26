//
//  RateBarViewController.h
//  Vybe
//
//  Created by Adriana Diakite on 11/16/13.
//  Copyright (c) 2013 vybe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bar.h"
#import <QuartzCore/QuartzCore.h>
#import "HashtagTableViewController.h"
#import "RateBarViewController.h"

@interface BarViewController : UIViewController
@property (nonatomic, strong) NSMutableDictionary *selectedBar;
@property (strong,nonatomic) NSString* walkDistanceString;
@property (strong,nonatomic) NSMutableArray* submittedHashtags;
-(void)returnFromHashtagSelect;
-(void)updateRatingsFromParse;
@end
