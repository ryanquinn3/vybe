//
//  BarDetailTableViewCell.h
//  Vybe
//
//  Created by Ryan Quinn on 6/17/14.
//  Copyright (c) 2014 vybe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarDetailTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIButton *goButton;
@property (strong, nonatomic) IBOutlet UIView *customView;

@end
