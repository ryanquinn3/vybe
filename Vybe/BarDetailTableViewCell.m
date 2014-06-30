//
//  BarDetailTableViewCell.m
//  Vybe
//
//  Created by Ryan Quinn on 6/17/14.
//  Copyright (c) 2014 vybe. All rights reserved.
//

#import "BarDetailTableViewCell.h"

@implementation BarDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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

@end
