//
//  RateBarViewController.m
//  Vybe
//
//  Created by Ryan Quinn on 3/5/14.
//  Copyright (c) 2014 vybe. All rights reserved.
//

#import "RateBarViewController.h"
#import "RatingViewController.h"


@interface RateBarViewController ()
@property (strong,nonatomic) NSMutableDictionary* ratingValues;
@end

@implementation RateBarViewController

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
    self.ratingValues = [[NSMutableDictionary alloc]init];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSArray *)stepViewControllers {
    
    RatingViewController *atmosphere = [self.storyboard instantiateViewControllerWithIdentifier:@"SomeStep1"];
    atmosphere.step.title = @"";
    atmosphere.labelDictionary = @{@"minCategoryLabel":@"Very casual",@"category":@"atmosphere",@"min2CategoryLabel": @"Pretty causal",@"max2CategoryLabel":@"Mingling",@"maxCategoryLabel":@"Dancing",@"buttonText":@"Next",@"currentValue":self.selectedBar.object[@"avgAtmosphere"]};
    
    RatingViewController * crowd = [self.storyboard instantiateViewControllerWithIdentifier:@"SomeStep1"];
    crowd.step.title = @"";
    crowd.labelDictionary = @{@"minCategoryLabel":@"Very empty",@"category":@"Crowdedness",@"min2CategoryLabel": @"Pretty empty",@"max2CategoryLabel":@"Reasonably crowded",@"maxCategoryLabel":@"Packed",@"buttonText":@"Next",@"currentValue":self.selectedBar.object[@"avgCrowd"]};
    
    RatingViewController *ratio = [self.storyboard instantiateViewControllerWithIdentifier:@"SomeStep1"];
    ratio.step.title = @"";
    ratio.labelDictionary = @{@"minCategoryLabel":@"All guys",@"category":@"Girl-Guy Ratio",@"min2CategoryLabel": @"Mostly guys",@"max2CategoryLabel":@"Mostly girls",@"maxCategoryLabel":@"All girls",@"buttonText":@"Next",@"currentValue":self.selectedBar.object[@"avgRatio"]};
    
    RatingViewController *cover = [self.storyboard instantiateViewControllerWithIdentifier:@"SomeStep1"];
    cover.step.title = @"";
    cover.labelDictionary = @{@"minCategoryLabel":@"Free",@"category":@"Cover charge",@"min2CategoryLabel": @"<$5",@"max2CategoryLabel":@"$5-$10",@"maxCategoryLabel":@"$10+",@"buttonText":@"Next",@"currentValue":self.selectedBar.object[@"avgCover"]};
    
    RatingViewController *waitTime = [self.storyboard instantiateViewControllerWithIdentifier:@"SomeStep1"];
    waitTime.step.title = @"";
    waitTime.labelDictionary = @{@"minCategoryLabel":@"0-5 mins",@"category":@"Wait time",@"min2CategoryLabel": @"5-10 mins",@"max2CategoryLabel":@"10-20 mins",@"maxCategoryLabel":@"20+ mins",@"buttonText":@"Next",@"currentValue":self.selectedBar.object[@"avgWait"]};

    
    return @[atmosphere, crowd, ratio, cover, waitTime];
}

- (void)finishedAllSteps {
    
    //send to parse
    PFObject* new_rating = [PFObject objectWithClassName:@"Rating"];

    new_rating[@"bar"] = self.selectedBar.object;
    new_rating[@"atmosphere"] = self.ratingValues[@"atmosphere"];
    new_rating[@"crowd"] = self.ratingValues[@"Crowdedness"];
    new_rating[@"ratio"] = self.ratingValues[@"Girl-Guy Ratio"];
    new_rating[@"wait"] = self.ratingValues[@"Wait time"];
    new_rating[@"cover"] = self.ratingValues[@"Cover charge"];
    [new_rating saveInBackground];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)canceled {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setRating:(NSNumber*)value forKey:(NSString *)key
{
    [self.ratingValues setValue:value forKey:key];
}




@end
