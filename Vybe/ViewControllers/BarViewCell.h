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
@property (strong, nonatomic) IBOutlet UIImageView *leftIconImageView;
@property (strong, nonatomic) IBOutlet UIImageView *rightIconImageView;


-(void)setVisibility:(BOOL)images andDistanceLabel:(BOOL)label;
-(void)setLeftImage:(NSString*)leftImageName andRight:(NSString*)rightImageName;
-(void)setOpacityofLeftImage:(CGFloat)leftOpacity andRight:(CGFloat)rightOpacity;

@end
