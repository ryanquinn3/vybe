//
//  RateBarViewController.m
//  Vybe
//
//  Created by Adriana Diakite on 11/16/13.
//  Copyright (c) 2013 vybe. All rights reserved.
//

#import "BarViewController.h"

#import "SFGaugeView.h"
#import "MSAnnotatedGauge.h"
#import "MSSimpleGauge.h"
#import "VybeUtil.h"
#import <Parse/Parse.h>


@interface BarViewController ()
@property (weak, nonatomic) IBOutlet UILabel *barTitle;

@property (weak, nonatomic) IBOutlet UILabel *barAddress;

@property (strong, nonatomic) NSMutableDictionary* barRating;

@property (strong,nonatomic) MSSimpleGauge* ratioGauge;
@property (strong,nonatomic) MSSimpleGauge* atmosphereGauge;
@property (strong,nonatomic) MSSimpleGauge* crowdGauge;
@property (strong,nonatomic) MSSimpleGauge* waitTimeGauge;

@property (strong, nonatomic) IBOutlet UIButton *shapeButton;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;

@property (strong, nonatomic) IBOutlet UIImageView *coverImage;


@end



@implementation BarViewController

- (void)updateBarInfo
{
    self.barTitle.text = self.selectedBar.name;
    self.barAddress.text = self.selectedBar.address;
    self.walkDistanceLabel.text = self.walkDistanceString;
   }
- (IBAction)refreshPressed:(id)sender {
    
    [self updateBarStats];
}
-(void)updateSliders
{
    if(!self.barRating) return;
    
    self.ratioGauge.value = (int)([self.barRating[@"ratio"]floatValue]);
    self.atmosphereGauge.value = (int)([self.barRating[@"atmosphere"]floatValue]);
    self.crowdGauge.value = (int)([self.barRating[@"crowd"]floatValue]);
    self.waitTimeGauge.value = (int)([self.barRating[@"wait"]floatValue]);
    
    self.coverImage.alpha = ([self.barRating[@"cover"]floatValue])/100;
    //cover...
}

- (void)updateBarStats
{
    PFQuery *query = [PFQuery queryWithClassName:@"Bar"];
       [query whereKey:@"name" equalTo:self.selectedBar.object[@"name"]];
   
    // Retrieve the most recent ones
  //  [query orderByDescending:@"createdAt"];
    
    // Consider only getting some
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *bars, NSError *error) {
        
        [self.selectedBar setObject:bars[0]];
        self.barRating[@"wait"] = self.selectedBar.object[@"avgWait"];
        self.barRating[@"crowd"] = self.selectedBar.object[@"avgCrowd"];
        self.barRating[@"ratio"] = self.selectedBar.object[@"avgRatio"];
        self.barRating[@"atmosphere"] = self.selectedBar.object[@"avgAtmosphere"];
        self.barRating[@"cover"] = self.selectedBar.object[@"avgCover"];
        
        if([self.selectedBar.object[@"numRatings"]integerValue] == 0 )
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Ratings!"
                                                           message:@"There are no ratings for this bar. Be the first to shape it!"
                                                          delegate:self
                                                 cancelButtonTitle:@"Ok"
                                                 otherButtonTitles:nil];
            [alert show];
        }

          [self updateSliders];
        
        /*
        if([ratings count] == 0)
        {
            self.refreshButton.enabled = NO;
            self.barRating[@"wait"] = [NSNumber numberWithFloat: 50.0];
            self.barRating[@"crowd"] = [NSNumber numberWithFloat: 50.0];
            self.barRating[@"ratio"] = [NSNumber numberWithFloat: 50.0];
            self.barRating[@"atmosphere"] = [NSNumber numberWithFloat: 50.0];
            self.barRating[@"cover"] = [NSNumber numberWithFloat: 50.0];
            [self updateSliders];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Ratings!"
                                                           message:@"There are no ratings for this bar. Be the first to shape it!"
                                                          delegate:self
                                                 cancelButtonTitle:@"Ok"
                                                 otherButtonTitles:nil];
            [alert show];
            
            return;
        }
        if (!self.refreshButton.isEnabled)
            self.refreshButton.enabled = YES;
        
        int numRatings = 0;
        float attract = 0.0;
        float crowded = 0.0;
        float ratio = 0.0;
        float cover = 0.0;
        float atmosphere = 0.0;
        
        for (PFObject *rating in ratings) {
            // This does not require a network access.

            attract += [(NSNumber *)[rating objectForKey:@"wait"] floatValue];
            crowded += [(NSNumber *)[rating objectForKey:@"crowd"] floatValue];
            ratio += [(NSNumber *)[rating objectForKey:@"ratio"] floatValue];
            cover += [(NSNumber *)[rating objectForKey:@"cover"] floatValue];
            atmosphere += [(NSNumber *)[rating objectForKey:@"atmosphere"] floatValue];
            numRatings++;
        }
        self.barRating[@"wait"] = [NSNumber numberWithFloat: (attract/ (float)numRatings)];
        self.barRating[@"crowd"] = [NSNumber numberWithFloat: (crowded/ (float)numRatings)];
        self.barRating[@"ratio"] = [NSNumber numberWithFloat: (ratio/ (float)numRatings)];
        self.barRating[@"atmosphere"] = [NSNumber numberWithFloat: (atmosphere/ (float)numRatings)];
        self.barRating[@"cover"] = [NSNumber numberWithFloat:(cover/(float)numRatings)];
        
      
       */
    }];
    
    
    
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [self updateBarInfo];
//}


-(void)loadGauges
{
    CGRect atmosRect= CGRectMake(165,85,130,65);
    CGRect crowdRect= CGRectMake(165,163,130,65);
    CGRect ratioRect= CGRectMake(165,241,130,65);
    CGRect waitRect = CGRectMake(165,319,130,65);
    
    
    //Atmosphere Images & Label
    CGRect atLabelRect = CGRectMake(15, 94, 130, 40);
    CGRect danceRect = CGRectMake(270, 115, 32, 30);
    CGRect beerRect = CGRectMake(160, 115, 35, 30);
    
    
    //Crowd Images & Label
    CGRect crowdLabelRect = CGRectMake(15, 175, 130, 40);
    CGRect crowdedRect = CGRectMake(270, 190, 33,30);
    CGRect nocrowdRect = CGRectMake(160, 190, 33,30);
    
    
    
    
    //Ratio Images & Label
    CGRect ratioLabelRect = CGRectMake(15, 254, 150, 40);
    CGRect guyRect = CGRectMake(160, 270, 27, 35);
    CGRect girlRect = CGRectMake(268, 270, 30, 35);
    
    
    
    //Entry Line Images & Label
    CGRect lineLabelRect = CGRectMake(15, 334, 130, 40);
    CGRect lineRect = CGRectMake(269, 352, 30, 28);
    CGRect nolineRect = CGRectMake(166, 352, 22, 28);
    
    if (!IS_IPHONE_5)
    {
        atmosRect.origin.y -= 14;
        atLabelRect.origin.y -= 14;
        danceRect.origin.y -= 14;
        beerRect.origin.y -= 14;
        
        
        crowdRect.origin.y -=17;
        crowdLabelRect.origin.y -= 17;
        crowdedRect.origin.y -= 17;
        nocrowdRect.origin.y -= 17;
        
        ratioRect.origin.y  -= 20;
        ratioLabelRect.origin.y -= 20;
        guyRect.origin.y -= 20;
        girlRect.origin.y -= 20;
        
        waitRect.origin.y -= 23;
        lineLabelRect.origin.y -= 23;
        lineRect.origin.y -= 23;
        nolineRect.origin.y -= 23;
        
        
    }
    //ATMOSPHERE
    UIImageView* beerImage = [[UIImageView alloc] initWithFrame:beerRect];
    [beerImage setImage:[UIImage imageNamed:ATMOS_LOW_IMG]];
    
    UIImageView* danceImage = [[UIImageView alloc] initWithFrame:danceRect];
    [danceImage setImage:[UIImage imageNamed:ATMOS_HIGH_IMG]];
    
    UILabel* atmosphereLabel = [[UILabel alloc]initWithFrame:atLabelRect];
    atmosphereLabel.font = VYBE_FONT(28);
    atmosphereLabel.text = @"atmosphere";
    atmosphereLabel.textColor = UIColorFromRGB(MIDNIGHT_BLUE, 1);
    
    //CROWD
    UILabel* crowdLabel = [[UILabel alloc]initWithFrame:crowdLabelRect];
    crowdLabel.font = VYBE_FONT(28);
    crowdLabel.text = @"crowdedness";
    crowdLabel.textColor = UIColorFromRGB(MIDNIGHT_BLUE, 1);
    
    UIImageView* nocrowdImage = [[UIImageView alloc]initWithFrame:nocrowdRect];
    [nocrowdImage setImage:[UIImage imageNamed:CROWD_LOW_IMG]];
    
    
    UIImageView* crowdedImage = [[UIImageView alloc]initWithFrame:crowdedRect];
    [crowdedImage setImage:[UIImage imageNamed:CROWD_HIGH_IMG]];
    
    
    //RATIO
    UILabel* ratioLabel = [[UILabel alloc]initWithFrame:ratioLabelRect];
    ratioLabel.font = VYBE_FONT(28);
    ratioLabel.text = @"girl-guy ratio";
    ratioLabel.textColor = UIColorFromRGB(MIDNIGHT_BLUE, 1);
    
    UIImageView* guyImage = [[UIImageView alloc]initWithFrame:guyRect];
    [guyImage setImage:[UIImage imageNamed:RATIO_LOW_IMG]];
    
    UIImageView* girlImage = [[UIImageView alloc]initWithFrame:girlRect];
    [girlImage setImage:[UIImage imageNamed:RATIO_HIGH_IMG]];
    
    
    //Entry Line
    UILabel* waitLabel = [[UILabel alloc]initWithFrame:lineLabelRect];
    waitLabel.font = VYBE_FONT(28);
    waitLabel.text = @"entry line";
    waitLabel.textColor = UIColorFromRGB(MIDNIGHT_BLUE, 1);
    
    UIImageView* lineImage = [[UIImageView alloc]initWithFrame:lineRect];
    [lineImage setImage:[UIImage imageNamed:WAIT_HIGH_IMG]];
    
    UIImageView* nolineImage = [[UIImageView alloc]initWithFrame:nolineRect];
    [nolineImage setImage:[UIImage imageNamed:WAIT_LOW_IMG]];

    


    self.ratioGauge = [[MSSimpleGauge alloc]initWithFrame:ratioRect];
    self.atmosphereGauge = [[MSSimpleGauge alloc]initWithFrame:atmosRect];
    self.crowdGauge = [[MSSimpleGauge alloc]initWithFrame:crowdRect];
    self.waitTimeGauge = [[MSSimpleGauge alloc]initWithFrame:waitRect];
    
    
    self.ratioGauge.backgroundColor = [UIColor clearColor];
    
    self.atmosphereGauge.backgroundColor = [UIColor clearColor];
    self.crowdGauge.backgroundColor = [UIColor clearColor];
    self.waitTimeGauge.backgroundColor = [UIColor clearColor];
    
    self.ratioGauge.minValue = 0;
    self.atmosphereGauge.minValue =0;
    self.crowdGauge.minValue = 0;
    self.waitTimeGauge.minValue = 0;
    
    self.ratioGauge.maxValue = 100;
    
    self.atmosphereGauge.maxValue = 100;
    self.crowdGauge.maxValue = 100;
    self.waitTimeGauge.maxValue = 100;
    
    self.ratioGauge.fillArcFillColor = UIColorFromRGB(CLOUDS, 1);
    self.ratioGauge.fillArcStrokeColor = UIColorFromRGB(CLOUDS, 1);
    
    self.ratioGauge.backgroundArcFillColor = UIColorFromRGB(CLOUDS, 1);
    self.ratioGauge.backgroundArcStrokeColor = UIColorFromRGB(CONCRETE, 1);

    self.atmosphereGauge.backgroundArcFillColor = UIColorFromRGB(CLOUDS, 1);
    self.atmosphereGauge.backgroundArcStrokeColor = UIColorFromRGB(CONCRETE, 1);

    self.atmosphereGauge.fillArcFillColor = UIColorFromRGB(CLOUDS, 1);
    self.atmosphereGauge.fillArcStrokeColor = UIColorFromRGB(CLOUDS, 1);
    
    self.crowdGauge.backgroundArcFillColor = UIColorFromRGB(CLOUDS,1);
    self.crowdGauge.backgroundArcStrokeColor = UIColorFromRGB(CONCRETE,1);

    self.crowdGauge.fillArcFillColor = UIColorFromRGB(CLOUDS,1);
    self.crowdGauge.fillArcStrokeColor = UIColorFromRGB(CLOUDS,1);

    self.waitTimeGauge.backgroundArcFillColor = UIColorFromRGB(CLOUDS,1);
    self.waitTimeGauge.backgroundArcStrokeColor = UIColorFromRGB(CONCRETE,1);
    
    self.waitTimeGauge.fillArcFillColor = UIColorFromRGB(CLOUDS,1);
    self.waitTimeGauge.fillArcStrokeColor = UIColorFromRGB(CLOUDS,1);
    
    
    self.ratioGauge.needleView.needleColor = UIColorFromRGB(MIDNIGHT_BLUE,1);
    self.atmosphereGauge.needleView.needleColor = UIColorFromRGB(MIDNIGHT_BLUE,1);
    self.waitTimeGauge.needleView.needleColor = UIColorFromRGB(MIDNIGHT_BLUE,1);
    self.crowdGauge.needleView.needleColor = UIColorFromRGB(MIDNIGHT_BLUE,1);


    [self.view addSubview:self.ratioGauge];
    [self.view addSubview:self.atmosphereGauge];
    [self.view addSubview:self.crowdGauge];
    [self.view addSubview:self.waitTimeGauge];
    [self.view addSubview:atmosphereLabel];
    [self.view addSubview:beerImage];
    [self.view addSubview:danceImage];
    [self.view addSubview:crowdLabel];
    [self.view addSubview:ratioLabel];
    [self.view addSubview:waitLabel];
    [self.view addSubview:guyImage];
    [self.view addSubview:girlImage];
    [self.view addSubview:lineImage];
    [self.view addSubview:nolineImage];
    [self.view addSubview:crowdedImage];
    [self.view addSubview:nocrowdImage];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0x95a5a6, 1);
    [self loadGauges];
    self.barTitle.font = VYBE_FONT(35);
    self.barTitle.textColor = UIColorFromRGB(MIDNIGHT_BLUE, 1);
    
    self.barAddress.font = VYBE_FONT(15);
    self.barAddress.textColor = UIColorFromRGB(MIDNIGHT_BLUE, 1);
    
    [self.coverImage setImage:[UIImage imageNamed:COVER_CAT_IMG]];
    
    self.shapeButton.backgroundColor = UIColorFromRGB(MIDNIGHT_BLUE, 1);
    self.shapeButton.tintColor = UIColorFromRGB(CONCRETE, 1);
    self.shapeButton.titleLabel.font = VYBE_FONT(23);
    self.shapeButton.titleLabel.textColor = UIColorFromRGB(CONCRETE, 1);
    
    self.walkDistanceLabel.font = VYBE_FONT(20);
    self.walkDistanceLabel.textColor = UIColorFromRGB(MIDNIGHT_BLUE, 1);
    

	// Do any additional setup after loading the view.
    self.barRating = [[NSMutableDictionary alloc]init];
    [self updateBarInfo];
    [self updateBarStats];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"shapeIt"]) {
        ((RateBarViewController*)segue.destinationViewController).selectedBar = self.selectedBar;
    }
}

@end
