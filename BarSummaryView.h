//
//  BarSummaryView.h
//  Vybe
//
//  Created by Ryan Quinn on 9/27/14.
//  Copyright (c) 2014 vybe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VybeUtil.h"
#import <Parse/Parse.h>


@interface BarSummaryView : UIView

@property (strong,nonatomic) NSArray* hashtags;
@property (strong,nonatomic) UIButton* goButton;


-(void)doDraw;
@end
