//
//  BarSummaryView.m
//  Vybe
//
//  Created by Ryan Quinn on 9/27/14.
//  Copyright (c) 2014 vybe. All rights reserved.
//

#import "BarSummaryView.h"

@implementation BarSummaryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
}
 */


-(void)doDraw
{
    [[self subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGRect rect = self.frame;
    rect.origin.x += 10;
    rect.origin.y += 10;
    rect.size.height -= 20;
    rect.size.width -= 20;
    
    NSMutableArray* viewsArray = [[NSMutableArray alloc]init];
    CGRect topLabelRect = CGRectMake(rect.origin.x + 5, rect.origin.y, rect.size.width/2, 30);
    UILabel* topLabel = [[UILabel alloc]initWithFrame:topLabelRect];
    topLabel.text = @"Tonights Vybes";
    topLabel.font = VYBE_FONT(14);
    topLabel.textColor = UIColorFromRGB(CONCRETE, 1);
    [viewsArray addObject:topLabel];
    
    self.goButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.goButton setTitle:@"Check it out" forState:UIControlStateNormal];
    self.goButton.titleLabel.font = VYBE_FONT(14);
    [self.goButton setTitleColor:UIColorFromRGB(CONCRETE, 1) forState:UIControlStateNormal];
    self.goButton.frame = CGRectMake(rect.size.width/2 + 40,rect.origin.y,rect.size.width/2,30);
    self.goButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [viewsArray addObject:self.goButton];
    
    UIView* dividerView = [[UIView alloc]initWithFrame:CGRectMake(rect.origin.x, rect.origin.y + 30, rect.size.width, 2)];
    [dividerView setBackgroundColor:UIColorFromRGB(0xFFFFFF, .4)];
    dividerView.layer.cornerRadius = 1;
    [viewsArray addObject:dividerView];
    
    CGRect hashtagArea = CGRectMake(rect.origin.x + 5, rect.size.height/4.0, rect.size.width, rect.size.height * .75);
    UIView* hashtagView = [[UIView alloc]initWithFrame:hashtagArea];
    
    if(self.hashtags.count == 0)
    {
        UILabel* emptyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, hashtagArea.size.height/2, hashtagArea.size.width, 30)];
        [emptyLabel setTextAlignment:NSTextAlignmentCenter];
        [emptyLabel setText:@"No hashtags have been submitted yet"];
        [emptyLabel setFont:VYBE_FONT(16)];
        [emptyLabel setTextColor:WHITE];
        [hashtagView addSubview:emptyLabel];
    
    }
    else
    {
        NSString* hashtag;
        CGRect htRect;
        int row, col;
        UILabel* htlabel;
        for(int i = 0;i < self.hashtags.count && i < 6;i++)
        {
            hashtag = self.hashtags[i];
            row = i % 3;
            col = i / 3;
            htRect = CGRectMake((hashtagArea.size.width/2)*col, (hashtagArea.size.height/3)*row, hashtagArea.size.width/2, hashtagArea.size.height/3);
            htlabel = [[UILabel alloc]initWithFrame:htRect];
            htlabel.text = [@"#" stringByAppendingString:hashtag];
            htlabel.textColor = WHITE;
            htlabel.font = VYBE_FONT(17);
            htlabel.adjustsFontSizeToFitWidth = YES;
            [hashtagView addSubview:htlabel];
        }
    }
    
    [viewsArray addObject:hashtagView];
    
    for(UIView* view in viewsArray){
        [self addSubview:view];
    }

}







@end
