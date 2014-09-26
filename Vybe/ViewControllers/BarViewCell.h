//
//  BarViewCell.h
//  Vybe
//
//  Created by Ryan Quinn on 3/26/14.
//  Copyright (c) 2014 vybe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VybeUtil.h"

@interface BarViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *barNameLabel;

@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;

@property (strong, nonatomic) UIView* infoBackgroundView;


-(void)setinfoBackgroundViewHeight:(int)height;
@end
