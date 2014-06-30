//
//  BarViewCell.m
//  Vybe
//
//  Created by Ryan Quinn on 3/26/14.
//  Copyright (c) 2014 vybe. All rights reserved.
//

#import "BarViewCell.h"
#import "BarQuickView.h"

@implementation BarViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setVisibility:(BOOL)images andDistanceLabel:(BOOL)label
{
    self.rightIconImageView.hidden = images;
    self.leftIconImageView.hidden = images;
    self.distanceLabel.hidden = label;
}
-(void)setLeftImage:(NSString*)leftImageName andRight:(NSString*)rightImageName
{
    [self.leftIconImageView setImage:[UIImage imageNamed:leftImageName]];
    [self.rightIconImageView setImage:[UIImage imageNamed:rightImageName]];
}
-(void)setOpacityofLeftImage:(CGFloat)leftOpacity andRight:(CGFloat)rightOpacity
{
    self.leftIconImageView.alpha = leftOpacity;
    self.rightIconImageView.alpha = rightOpacity;
}




@end
