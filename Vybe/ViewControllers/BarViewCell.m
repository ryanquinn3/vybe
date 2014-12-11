//
//  BarViewCell.m
//  Vybe
//
//  Created by Ryan Quinn on 3/26/14.
//  Copyright (c) 2014 vybe. All rights reserved.
//

#import "BarViewCell.h"

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
    CGRect rect = CGRectMake(0, 0, self.contentView.frame.size.width, 53);
    self.infoBackgroundView = [[UIView alloc]initWithFrame:rect];
    self.infoBackgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
    [self.contentView insertSubview:self.infoBackgroundView belowSubview:self.barNameLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setinfoBackgroundViewHeight:(int)height
{
    CGRect r = self.infoBackgroundView.frame;
    r.size.height = height;
    self.infoBackgroundView.frame = r;
    
}


@end
