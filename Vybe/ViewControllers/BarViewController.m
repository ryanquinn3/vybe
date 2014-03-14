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
#import "VybeUtil.h"
#import <Parse/Parse.h>


@interface BarViewController ()
@property (weak, nonatomic) IBOutlet UILabel *barTitle;

@property (weak, nonatomic) IBOutlet UILabel *barAddress;

@property (strong, nonatomic) NSMutableDictionary* barRating;

@property (strong,nonatomic) MSAnnotatedGauge* ratioGauge;
@property (strong,nonatomic) MSAnnotatedGauge* atmosphereGauge;
@property (strong,nonatomic) MSAnnotatedGauge* coverGauge;
@property (strong,nonatomic) MSAnnotatedGauge* crowdGauge;
@property (strong,nonatomic) MSAnnotatedGauge* waitTimeGauge;
@property (strong, nonatomic) IBOutlet UIButton *shapeButton;
@property (strong, nonatomic) IBOutlet UILabel *walkDistanceLabel;



@end



@implementation BarViewController

- (void)updateBarInfo
{
    self.barTitle.text = self.selectedBar.name;
    self.barAddress.text = self.selectedBar.address;
   }
- (IBAction)refreshPressed:(id)sender {
    
    [self updateBarStats];
}
-(void)updateSliders
{
    if(!self.barRating) return;
    
    self.ratioGauge.value = (int)([self.barRating[@"ratio"]floatValue]*100);
    self.atmosphereGauge.value = (int)([self.barRating[@"atmosphere"]floatValue]*100);
    self.coverGauge.value = (int)([self.barRating[@"cover"]floatValue]*100);
    self.crowdGauge.value = (int)([self.barRating[@"crowd"]floatValue]*100);
       
    
    
}

- (void)updateBarStats
{
    PFQuery *query = [PFQuery queryWithClassName:@"Rating"];
    
    [query whereKey:@"bar" equalTo:self.selectedBar.object];
    
    // Retrieve the most recent ones
  //  [query orderByDescending:@"createdAt"];
    
    // Consider only getting some
    [query findObjectsInBackgroundWithBlock:^(NSArray *ratings, NSError *error) {
        // Comments now contains the last ten comments, and the "post" field
        // has been populated. For example:
        
        if([ratings count] == 0)
        {
            self.barRating[@"attractiveness"] = [NSNumber numberWithFloat: .5];
            self.barRating[@"crowd"] = [NSNumber numberWithFloat: .5];
            self.barRating[@"ratio"] = [NSNumber numberWithFloat: .5];
            self.barRating[@"atmosphere"] = [NSNumber numberWithFloat: .5];
            self.barRating[@"cover"] = [NSNumber numberWithFloat: .5];
            [self updateSliders];
            return;
        }
        
        
        int numRatings = 0;
        float attract = 0.0;
        float crowded = 0.0;
        float ratio = 0.0;
        float cover = 0.0;
        float atmosphere = 0.0;
        
        for (PFObject *rating in ratings) {
            // This does not require a network access.

            attract += [(NSNumber *)[rating objectForKey:@"attractiveness"] floatValue];
            crowded += [(NSNumber *)[rating objectForKey:@"crowd"] floatValue];
            ratio += [(NSNumber *)[rating objectForKey:@"ratio"] floatValue];
            cover += [(NSNumber *)[rating objectForKey:@"cover"] floatValue];
            atmosphere += [(NSNumber *)[rating objectForKey:@"atmosphere"] floatValue];
            numRatings++;
        }
        self.barRating[@"attractiveness"] = [NSNumber numberWithFloat: (attract/ (float)numRatings)];
        self.barRating[@"crowd"] = [NSNumber numberWithFloat: (crowded/ (float)numRatings)];
        self.barRating[@"ratio"] = [NSNumber numberWithFloat: (ratio/ (float)numRatings)];
        self.barRating[@"atmosphere"] = [NSNumber numberWithFloat: (atmosphere/ (float)numRatings)];
        self.barRating[@"cover"] = [NSNumber numberWithFloat:(cover/(float)numRatings)];
        
        [self updateSliders];
        
    }];
    
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [self updateBarInfo];
//}


-(void)loadGauges
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    
    CGRect ratioRect= CGRectMake(15,80,140,90);
    CGRect coverRect= CGRectMake(15,300,140,90);
    CGRect atmosRect= CGRectMake(95,200,140,90);
    CGRect crowdRect= CGRectMake(175,80,140,90);
    CGRect waitRect = CGRectMake(175,300,140,90);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (!(screenSize.height > 480.0f))
        {
          //  ratioRect.origin.y -= 5;
            //crowdRect.origin.y -= 5;
            
            atmosRect.origin.y -= 25;

            waitRect.origin.y  -= 40;
            coverRect.origin.y -= 40;
        }}
    

    self.ratioGauge = [[MSAnnotatedGauge alloc]initWithFrame:ratioRect];
    self.coverGauge = [[MSAnnotatedGauge alloc]initWithFrame:coverRect];
    self.atmosphereGauge = [[MSAnnotatedGauge alloc]initWithFrame:atmosRect];
    self.crowdGauge = [[MSAnnotatedGauge alloc]initWithFrame:crowdRect];
    self.waitTimeGauge = [[MSAnnotatedGauge alloc]initWithFrame:waitRect];
    
    
    self.ratioGauge.backgroundColor = UIColorFromRGB(0x95a5a6, 1);
    self.coverGauge.backgroundColor = UIColorFromRGB(0x95a5a6, 1);
    self.atmosphereGauge.backgroundColor = UIColorFromRGB(0x95a5a6, 1);
    self.crowdGauge.backgroundColor = UIColorFromRGB(0x95a5a6, 1);
    self.waitTimeGauge.backgroundColor = UIColorFromRGB(0x95a5a6, 1);
    
    self.ratioGauge.minValue = 0;
    self.coverGauge.minValue = 0;
    self.atmosphereGauge.minValue =0;
    self.crowdGauge.minValue = 0;
    self.waitTimeGauge.minValue = 0;
    
    self.ratioGauge.maxValue = 100;
    self.coverGauge.maxValue = 100;
    self.atmosphereGauge.maxValue = 100;
    self.crowdGauge.maxValue = 100;
    self.waitTimeGauge.maxValue = 100;
    
    self.ratioGauge.titleLabel.text = @"Ratio";
    self.coverGauge.titleLabel.text = @"Cover Charge";
    self.atmosphereGauge.titleLabel.text = @"Atmosphere";
    self.crowdGauge.titleLabel.text = @"Crowdedness";
    self.waitTimeGauge.titleLabel.text = @"Wait time";
    
    
    self.ratioGauge.titleLabel.textColor = UIColorFromRGB(MIDNIGHT_BLUE, 1);
    self.coverGauge.titleLabel.textColor = UIColorFromRGB(MIDNIGHT_BLUE, 1);
    self.atmosphereGauge.titleLabel.textColor = UIColorFromRGB(MIDNIGHT_BLUE, 1);
    self.crowdGauge.titleLabel.textColor = UIColorFromRGB(MIDNIGHT_BLUE, 1);
    self.waitTimeGauge.titleLabel.textColor = UIColorFromRGB(MIDNIGHT_BLUE, 1);
    
    self.ratioGauge.titleLabel.textColor = UIColorFromRGB(MIDNIGHT_BLUE, 1);
    self.coverGauge.titleLabel.textColor = UIColorFromRGB(MIDNIGHT_BLUE, 1);
    self.atmosphereGauge.titleLabel.textColor = UIColorFromRGB(MIDNIGHT_BLUE, 1);
    self.crowdGauge.titleLabel.textColor = UIColorFromRGB(MIDNIGHT_BLUE, 1);
    self.waitTimeGauge.titleLabel.textColor = UIColorFromRGB(MIDNIGHT_BLUE, 1);
    
    
    
    
    self.ratioGauge.startRangeLabel.text = @"All guys";
    self.ratioGauge.endRangeLabel.text = @"All girls";
    
    self.coverGauge.startRangeLabel.text = @"Free";
    self.coverGauge.endRangeLabel.text = @"$20+";
    
    self.atmosphereGauge.startRangeLabel.text = @"Talking";
    self.atmosphereGauge.endRangeLabel.text = @"Dancing";
    
    self.crowdGauge.startRangeLabel.text = @"Empty";
    self.crowdGauge.endRangeLabel.text = @"Packed";
    
    self.waitTimeGauge.startRangeLabel.text = @"No wait";
    self.waitTimeGauge.endRangeLabel.text = @"30 mins+";
    
    
    
    self.ratioGauge.fillArcFillColor = UIColorFromRGB(HOT_PINK, 1);
    self.ratioGauge.fillArcStrokeColor = UIColorFromRGB(HOT_PINK, 1);
    

    self.ratioGauge.backgroundArcFillColor = UIColorFromRGB(BABY_BLUE, 1);
    self.ratioGauge.backgroundArcStrokeColor = UIColorFromRGB(CONCRETE, 1);


    self.atmosphereGauge.backgroundArcFillColor = UIColorFromRGB(TURQUOISE, 1);
    self.atmosphereGauge.backgroundArcStrokeColor = UIColorFromRGB(CONCRETE, 1);

    self.atmosphereGauge.fillArcFillColor = UIColorFromRGB(POMEGRANATE, 1);
    self.atmosphereGauge.fillArcStrokeColor = UIColorFromRGB(POMEGRANATE, 1);



    self.coverGauge.backgroundArcFillColor = UIColorFromRGB(CLOUDS, 1);
    self.coverGauge.backgroundArcStrokeColor = UIColorFromRGB(CONCRETE, 1);

    self.coverGauge.fillArcFillColor = UIColorFromRGB(NEPHRITIS, 1);
    self.coverGauge.fillArcStrokeColor = UIColorFromRGB(NEPHRITIS, 1);
    

    self.crowdGauge.backgroundArcFillColor = UIColorFromRGB(0x1abc9c,1);
    self.crowdGauge.backgroundArcStrokeColor = UIColorFromRGB(CONCRETE,1);

    self.crowdGauge.fillArcFillColor = UIColorFromRGB(0xf39c12,1);
    self.crowdGauge.fillArcStrokeColor = UIColorFromRGB(0xf39c12,1);


    self.waitTimeGauge.backgroundArcFillColor = UIColorFromRGB(EMERALD,1);
    self.waitTimeGauge.backgroundArcStrokeColor = UIColorFromRGB(CONCRETE,1);
    
    self.waitTimeGauge.fillArcFillColor = UIColorFromRGB(0xff0000,1);
    self.waitTimeGauge.fillArcStrokeColor = UIColorFromRGB(0xff0000,1);
    
    
    
    self.ratioGauge.needleView.needleColor = UIColorFromRGB(MIDNIGHT_BLUE,1);
    self.coverGauge.needleView.needleColor = UIColorFromRGB(MIDNIGHT_BLUE,1);
    self.atmosphereGauge.needleView.needleColor = UIColorFromRGB(MIDNIGHT_BLUE,1);
    self.waitTimeGauge.needleView.needleColor = UIColorFromRGB(MIDNIGHT_BLUE,1);
    self.crowdGauge.needleView.needleColor = UIColorFromRGB(MIDNIGHT_BLUE,1);


    [self.view addSubview:self.ratioGauge];
    [self.view addSubview:self.atmosphereGauge];
    [self.view addSubview:self.coverGauge];
    [self.view addSubview:self.crowdGauge];
    [self.view addSubview:self.waitTimeGauge];
    
    
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
        Bar *selectedBar = self.selectedBar;
        if ([segue.destinationViewController respondsToSelector:@selector(setSelectedBar:)])
        {
            [segue.destinationViewController performSelector:@selector(setSelectedBar:) withObject:selectedBar];}
        
    }
    
}


@end
