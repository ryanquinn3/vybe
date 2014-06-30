//
//  BarQuickView.m
//  Vybe
//
//  Created by Ryan Quinn on 6/17/14.
//  Copyright (c) 2014 vybe. All rights reserved.
//

#import "BarQuickView.h"

@implementation BarQuickView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UILabel* label = [[UILabel alloc]initWithFrame:rect];
    label.text = @"       Suck me";
    label.textColor = [UIColor whiteColor];
    [self addSubview:label];
}


@end
