//
//  RatingViewController.m
//  Vybe
//
//  Created by Ryan Quinn on 3/5/14.
//  Copyright (c) 2014 vybe. All rights reserved.
//

#import "RatingViewController.h"
#import "UICircularSlider.h"
#import "VybeUtil.h"
#import "RateBarViewController.h"

@interface RatingViewController ()
@property (strong, nonatomic) IBOutlet UICircularSlider *circularSlider;
@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;
@property (strong, nonatomic) IBOutlet UILabel *categoryStatusLabel;
@property (strong, nonatomic) IBOutlet UIButton *advanceButton;

@end

@implementation RatingViewController

/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(CONCRETE, 1);
    
    self.categoryLabel.font = VYBE_FONT(40);
    self.categoryLabel.textColor = UIColorFromRGB(MIDNIGHT_BLUE, 1);
    self.categoryStatusLabel.font = VYBE_FONT(30);
    self.categoryStatusLabel.textColor = UIColorFromRGB(MIDNIGHT_BLUE, 1);
    
    self.advanceButton.titleLabel.font = VYBE_FONT(28);
    self.advanceButton.titleLabel.text = [self.labelDictionary objectForKey:@"buttonText"];
    self.advanceButton.backgroundColor = UIColorFromRGB(MIDNIGHT_BLUE, 1);
    self.advanceButton.titleLabel.textColor = UIColorFromRGB(CONCRETE, 1);
    
    self.circularSlider.backgroundColor = [UIColor clearColor];
    self.circularSlider.maximumTrackTintColor = UIColorFromRGB(CLOUDS, 1);
    self.circularSlider.minimumTrackTintColor = UIColorFromRGB(MIDNIGHT_BLUE, 1);
    self.circularSlider.thumbTintColor = UIColorFromRGB(ALIZARIN, 1);
    self.circularSlider.minimumValue = 0;
    self.circularSlider.maximumValue = 100;
    
    
    [self.circularSlider addTarget:self action:@selector(sliderChanged) forControlEvents:UIControlEventValueChanged];
	// Do any additional setup after loading the view.
    
    NSString* category = [self.labelDictionary objectForKey:@"category"];
    if(category!= nil)
    {
        [self.categoryLabel setText:category];
    }
    NSString* catMinString = [self.labelDictionary objectForKey:@"minCategoryLabel"];
    if(catMinString !=nil)
    {
        [self.categoryStatusLabel setText:catMinString];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)nextPressed:(id)sender {
    
    NSNumber* value = [NSNumber numberWithFloat:self.circularSlider.value];
    RateBarViewController* rbVC = (RateBarViewController*)self.stepsController;
    [rbVC setRating:value forKey:[self.labelDictionary objectForKey:@"category"]];
    [rbVC showNextStep];
}


-(void)sliderChanged
{
    if(self.circularSlider.value <= 25)
    {
        [self.categoryStatusLabel setText:[self.labelDictionary objectForKey:@"minCategoryLabel"]];
    }
    else if(self.circularSlider.value <= 50)
    {
        [self.categoryStatusLabel setText:[self.labelDictionary objectForKey:@"min2CategoryLabel"]];
    }
    else if(self.circularSlider.value <= 75)
    {
        [self.categoryStatusLabel setText:[self.labelDictionary objectForKey:@"max2CategoryLabel"]];
    }
    else if(self.circularSlider.value <= 100)
    {
        [self.categoryStatusLabel setText:[self.labelDictionary objectForKey:@"maxCategoryLabel"]];
    }
}

@end
