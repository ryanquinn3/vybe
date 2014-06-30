//
//  RateBarViewController.h
//  Vybe
//
//  Created by Ryan Quinn on 3/5/14.
//  Copyright (c) 2014 vybe. All rights reserved.
//

#import "RMStepsController.h"
#import "Bar.h"

@interface RateBarViewController : RMStepsController
@property (strong,nonatomic) Bar* selectedBar;
-(void)setRating:(NSNumber*)value forKey:(NSString *)key;
@end
