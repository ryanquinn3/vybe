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



#define SPACE_OFFSET 10
@interface BarViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property(strong,nonatomic) UILabel* barTitle;
@property(strong,nonatomic) UILabel* barAddress;
@property(strong,nonatomic) UILabel* walkDistanceLabel;
@property (strong,nonatomic) UIButton* submitHashtagButton;

@end


#define UPVOTED_BG UIColorFromRGB(CONCRETE, 1)
#define UPVOTED_TX UIColorFromRGB(0, .9)

#define DWNVOTED_BG UIColorFromRGB(0, .9)
#define DWNVOTED_TX UIColorFromRGB(0xffffff, .15)

@implementation BarViewController

float contentSize;
NSArray* sortedHashtagList;
bool shouldHideSubmitButton;

- (void)updateBarInfo
{
    self.barTitle.text = self.selectedBar[@"bar"][@"name"];
    self.barAddress.text = self.selectedBar[@"bar"][@"address"];
}
- (IBAction)refreshPressed:(id)sender {
    
    [self updateRatingsFromParse];
    
}


-(void)clearAndReloadViews{
    
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    sortedHashtagList = [self sortedHashTags:self.selectedBar];
    contentSize = 0.0;
    [self initTextSection];
    //Update bar stats was here
    [self initTypicalSection];
    [self initCurrentSection];
    [self addSubmitNewHashTag];
    [self.scrollView setContentSize:CGSizeMake(self.view.bounds.size.width, contentSize+NAVBAR_SIZE+15)];
    
    

}

-(void)initTextSection
{
    CGRect barTitleRect = CGRectMake(5,5,290,30);
    CGRect barAddressRect = CGRectMake(5,28,290,24);
    
    self.barTitle = [[UILabel alloc]initWithFrame:barTitleRect];
    self.barAddress = [[UILabel alloc] initWithFrame:barAddressRect];
    
    [self updateBarInfo];
    
    //Will need to adjust for length here
    self.barTitle.font = VYBE_FONT_LT(24);
    if(self.barAddress.text.length > 30)
        self.barAddress.font = VYBE_FONT_LT(14);
    else
        self.barAddress.font = VYBE_FONT_LT(18);
    
    self.barTitle.textColor = self.barAddress.textColor = WHITE;
    self.barTitle.shadowColor = self.barAddress.shadowColor = WHITE;
    self.barTitle.shadowOffset = self.barAddress.shadowOffset = CGSizeMake(0,1.0);
    self.barTitle.textAlignment = self.barAddress.textAlignment = NSTextAlignmentCenter;

    UIView* textBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(15, 20, 290, 130)];
    
    textBackgroundView.backgroundColor = UIColorFromRGB(0, .7);
    textBackgroundView.layer.cornerRadius = 5;
    textBackgroundView.layer.masksToBounds = YES;
    [textBackgroundView addSubview:self.barTitle];
    [textBackgroundView addSubview:self.barAddress];
    
    UIImageView* barTypeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 168)];
    NSString* venueType = self.selectedBar[@"bar"][@"venueType"];
    barTypeImage.image = [UIImage imageNamed:[self imageNameForBarType:venueType]];
    
    [self.scrollView addSubview:barTypeImage];
    [self.scrollView addSubview:textBackgroundView];
    
    contentSize += barTypeImage.bounds.size.height;
    
    UIView* dividerView = [[UIView alloc]initWithFrame:CGRectMake(10, contentSize, 300, 2)];
    [dividerView setBackgroundColor:UIColorFromRGB(0xFFFFFF, .4)];
    dividerView.layer.cornerRadius = 1;
    [self.scrollView addSubview:dividerView];
    
}


-(void)initTypicalSection
{
    
    //NSArray* typicalHashTags = [NSArray arrayWithObjects:@"crowded",@"young",@"dancing",nil];
    NSString* barId = ((PFObject*)self.selectedBar[@"bar"]).objectId;
    NSDictionary* topMap = [[NSUserDefaults standardUserDefaults]objectForKey:@"topHashtagsForBars"];
    NSArray* thisMap = [topMap objectForKey:barId];
    
    
    NSMutableArray* typicalHashTags = [[NSMutableArray alloc]init];
    
    for(NSDictionary* entry in thisMap){
        [typicalHashTags addObject:entry[@"hashtag"]];
    }
    if([typicalHashTags count] == 0){
        [typicalHashTags addObject:@" "];
    }
    
    
    
    NSString* trendingHeader = @"Typical Vybes";
    UIView* trendingSection = [self hashTagSection:CGPointMake(0, 70) withHashTags:typicalHashTags andTitle:trendingHeader];
    [self.scrollView addSubview:trendingSection];
}

-(void)initCurrentSection
{
    
    UILabel* currentVybeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, contentSize+SPACE_OFFSET, 290, 30)];
    currentVybeLabel.font = VYBE_FONT(20);
    currentVybeLabel.textColor = UIColorFromRGB(CONCRETE, .9);
    currentVybeLabel.text = @"Tonight's vybes";
    
    [self.scrollView addSubview:currentVybeLabel];
    contentSize += currentVybeLabel.bounds.size.height;
    
    NSArray* currentHashTags = [self sortedHashTags:self.selectedBar];
    
    
    for (NSString* hashTag in currentHashTags) {

        CGRect hashtagRect = CGRectMake(15, contentSize +SPACE_OFFSET, 290, 40);
        [self.scrollView addSubview:[self hashtagRow:hashtagRect withHashTag:[@"#" stringByAppendingString:hashTag]]];
        contentSize += hashtagRect.size.height+SPACE_OFFSET;
    }
}


-(UIView*)hashTagSection:(CGPoint)origin withHashTags:(NSArray*)hashTags andTitle:(NSString*)title
{
    
    
    UILabel* heading = [[UILabel alloc] initWithFrame:CGRectMake(25,0, 270, 30)];
    heading.text = title;
    heading.font = VYBE_FONT(16);
    heading.textColor = WHITE;
    
    float labelHeight = 30.0;
    int numRows = (int)((hashTags.count-1) / 3) + 1;
    
    float bgViewHeight = (labelHeight * numRows) + 10;
    
    UIView* hashTagBGView = [[UIView alloc] initWithFrame:CGRectMake(25,27,270,bgViewHeight)];
    hashTagBGView.layer.borderColor = UIColorFromRGB(0xffffff, .4).CGColor;
    hashTagBGView.layer.borderWidth = 2.0;
    hashTagBGView.layer.cornerRadius = 15;
    hashTagBGView.layer.masksToBounds = YES;
    
    UILabel* hashLabel;
    float labelWidth = hashTagBGView.bounds.size.width / 3;
    
    for(int i = 0; i < hashTags.count; i++)
    {
        int row = (i / 3);
        
        hashLabel = [[UILabel alloc] initWithFrame:CGRectMake(i*labelWidth, 5+(labelHeight * row), labelWidth, labelHeight)];
        hashLabel.font = VYBE_FONT_LT(18);
        hashLabel.textColor = [UIColor whiteColor];
        hashLabel.shadowColor = [UIColor whiteColor];
        hashLabel.shadowOffset = CGSizeMake(0, 1.0);
        hashLabel.text = [@"#" stringByAppendingString:hashTags[i]];
        hashLabel.textAlignment = NSTextAlignmentCenter;
        hashLabel.adjustsFontSizeToFitWidth = YES;
        [hashTagBGView addSubview:hashLabel];
        
        
    }
    
    float sectionHeight = heading.frame.size.height + bgViewHeight + 5;
    
    CGRect sectionRect = CGRectMake(origin.x, origin.y, 320, sectionHeight);
    UIView* sectionView = [[UIView alloc]initWithFrame:sectionRect];
    [sectionView addSubview:heading];
    [sectionView addSubview: hashTagBGView];
    
    return sectionView;
}


-(UIView*)hashtagRow:(CGRect)rect withHashTag:(NSString*)hashTag
{
    
    UIView* hashtagBackground = [[UIView alloc]initWithFrame:rect];
    hashtagBackground.backgroundColor = UIColorFromRGB(0xFFFFFF, .1);
    hashtagBackground.layer.cornerRadius = 15.0;
    hashtagBackground.layer.masksToBounds = YES;
    hashtagBackground.layer.borderColor = UIColorFromRGB(0xFFFFFF, .4).CGColor;
    hashtagBackground.layer.borderWidth = 1.0f;
    
    UILabel* hashtagLabel = [[UILabel alloc]initWithFrame:CGRectMake(SPACE_OFFSET, 0, rect.size.width-SPACE_OFFSET, rect.size.height)];
    
    //adjust for string length
    if(hashTag.length > 10)
        hashtagLabel.font = VYBE_FONT(19);
    else
        hashtagLabel.font = VYBE_FONT(22);
    hashtagLabel.textColor = WHITE;
    hashtagLabel.text = hashTag;
    
    [hashtagLabel setTextAlignment:NSTextAlignmentCenter];
    
    [hashtagBackground addSubview:hashtagLabel];
   
    UISwipeGestureRecognizer* swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedRight:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    UISwipeGestureRecognizer* swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedLeft:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    //If user! logged in || not at a bar || already rated this

    NSNumber* value = [self scoreFromUserForHashtag:[hashTag substringFromIndex:1]];
    if([value intValue] == 0 && [PFUser currentUser])
    {
        [hashtagBackground addGestureRecognizer:swipeLeft];
        [hashtagBackground addGestureRecognizer:swipeRight];
        
    }else if([value intValue] == -1){
        [self setUIView:hashtagBackground
                bgColor:DWNVOTED_BG
              textColor:DWNVOTED_TX
                animate:NO];
    }else{
        [self setUIView:hashtagBackground
                bgColor:UPVOTED_BG
              textColor:UPVOTED_TX
                animate:NO];
    }
    

    return hashtagBackground;
}



-(void)addSubmitNewHashTag
{
    
    if(![self checkTimeOfLastSubmission] || ![PFUser currentUser])
        return;
    
    UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(15, contentSize+SPACE_OFFSET, 290, 30)];
    UIButton* newReportButton = [UIButton buttonWithType:UIButtonTypeSystem];
    NSString* submitHashtagString = @"Doesn't quite cut it? Tell us how it is!";
    int fontSize = 16;
    if(sortedHashtagList.count == 0 ){
        submitHashtagString = @"No hashtags have been submitted yet. Be the first!";
        fontSize = 12;
    }
    [newReportButton.titleLabel setFont:VYBE_FONT(fontSize)];
    [newReportButton setTitle:submitHashtagString forState:UIControlStateNormal];
    [newReportButton sizeToFit];
    [newReportButton setTitleColor:WHITE forState:UIControlStateNormal];
    [newReportButton setCenter:bgView.center];
    [newReportButton setTitleShadowColor:UIColorFromRGB(CONCRETE, 1) forState:UIControlStateNormal];
    
    [newReportButton addTarget:self action:@selector(segueToUserReview) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scrollView addSubview:newReportButton];
    self.submitHashtagButton = newReportButton;
    contentSize += bgView.bounds.size.height + SPACE_OFFSET;
}

-(BOOL)checkTimeOfLastSubmission{
    
    NSString* barId = ((PFObject*)self.selectedBar[@"bar"]).objectId;
    NSDate* lastSubmission = [[NSUserDefaults standardUserDefaults] objectForKey:barId];
    if(!lastSubmission){
        return YES;
    }
    
    NSTimeInterval timeSinceLast = [[NSDate date] timeIntervalSinceDate:lastSubmission];
    
    if(timeSinceLast / 3600.0 > 12)
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:barId];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
    
    return NO;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.submittedHashtags = [[NSMutableArray alloc]init];
    sortedHashtagList = [self sortedHashTags:self.selectedBar];
    
    contentSize = 0.0;
    [self initTextSection];
    //Update bar stats was here
    [self initTypicalSection];
    [self initCurrentSection];
    [self addSubmitNewHashTag];
    [self.scrollView setContentSize:CGSizeMake(self.view.bounds.size.width, contentSize+NAVBAR_SIZE+15)];

}

#define IDENTIFIER @"httvc"
-(void)segueToUserReview
{
    [self performSegueWithIdentifier:@"tohashtaglist" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"tohashtaglist"]){
        HashtagTableViewController* httVC = (HashtagTableViewController*)[segue destinationViewController];
        [httVC setCaller:self];
        [httVC setBarId:((PFObject*)self.selectedBar[@"bar"]).objectId];
    }
}


//Make into dictionary globally?
-(NSString*) imageNameForBarType:(NSString*) venueType
{
    NSString* imageTitle;
    if([venueType isEqualToString:@"sports bar"]){
        imageTitle = @"sports-bar.jpg";
    }
    else if([venueType isEqualToString:@"dive bar"]){
        imageTitle = @"dive-bar.jpg";
    }
    else if([venueType isEqualToString:@"pub"]){
        imageTitle = @"pub.jpg";
    }
    else if([venueType isEqualToString:@"tap room"]){
        imageTitle = @"tap-room.jpg";
    }
    else{
        imageTitle = @"nightclub.jpg";
    }
    
    return imageTitle;
}

-(void)swipedRight:(UISwipeGestureRecognizer* )recognizer
{
    [self setUIView:[recognizer view]
            bgColor:UPVOTED_BG
          textColor:UPVOTED_TX
            animate:YES];
    
    
    for(UIView* subs in [[recognizer view]subviews])
    {
        if([subs isKindOfClass:[UILabel class]])
        {
            NSString* hashtag = [((UILabel*)subs).text substringFromIndex:1];
            [self submitNewRating:hashtag withScore:1];
        }
    }
    //[[recognizer view] removeGestureRecognizer:recognizer];
    
    
    
    
}
-(void)swipedLeft:(UISwipeGestureRecognizer* )recognizer
{
    [self setUIView:[recognizer view]
            bgColor:DWNVOTED_BG
          textColor:DWNVOTED_TX
            animate:YES];
    
    for(UIView* subs in [[recognizer view]subviews])
    {
        if([subs isKindOfClass:[UILabel class]])
        {
            NSString* hashtag = [((UILabel*)subs).text substringFromIndex:1];
            [self submitNewRating:hashtag withScore:-1];
        }
    }
    //[[recognizer view] removeGestureRecognizer:recognizer];
}



-(void)submitNewRating:(NSString*)hashtag withScore:(int)score
{
    NSArray* ratings = [self.selectedBar objectForKey:@"ratings"];
    NSString* barid = ((PFObject*)self.selectedBar[@"bar"]).objectId;
    
    NSString* htId;
    for(NSDictionary* rating in ratings){
        if([rating[@"hashtag"] isEqualToString:hashtag]){
            htId = rating[@"hashtagId"];
            break;
        }
    }
    if(!htId){
        NSLog(@"Hashtag wasn't found when searching list, SubmitNewRating BVC");
        return;
    }
    
    PFObject* newRating = [PFObject objectWithClassName:@"Rating"];
    newRating[@"user"] = [PFUser currentUser];
    newRating[@"bar"] = [PFObject objectWithoutDataWithClassName:@"Bar" objectId:barid];
    newRating[@"hashtag"] = [PFObject objectWithoutDataWithClassName:@"Hashtag" objectId:barid];
    newRating[@"score"] = [NSNumber numberWithInt:score];
    
    [newRating saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
       if(succeeded)
       {
           [self updateRatingsFromParse];
       }
       else{
           NSLog(@"Error saving new rating %@", [error userInfo]);
       }
    }];
    
    
}



-(void)setUIView:(UIView*)view bgColor:(UIColor*)bg textColor:(UIColor*)text animate:(BOOL)animated
{
    if(animated){
        [UIView animateWithDuration:1.0 animations:^{
            [view setBackgroundColor:bg];
            for(UIView* subview in [view subviews])
            {
                if([subview isKindOfClass:[UILabel class]])
                {
                    UILabel* lbl = (UILabel*)subview;
                    [lbl setTextColor: text];
                }
            }
        }];
    }else{
        [view setBackgroundColor:bg];
        for(UIView* subview in [view subviews])
        {
            if([subview isKindOfClass:[UILabel class]])
            {
                UILabel* lbl = (UILabel*)subview;
                [lbl setTextColor: text];
            }
        }
    }
}

-(void)returnFromHashtagSelect
{
    if([self.submittedHashtags count]){
        [self.submitHashtagButton setHidden:YES];
    }
}

-(NSArray*)sortedHashTags:(NSDictionary*) barDict{
    NSArray* ratings = [barDict objectForKey:@"ratings"];
    NSMutableDictionary* hashtagValues = [[NSMutableDictionary alloc]init];
    
    for(NSDictionary* rating in ratings){
        NSNumber* value;
        NSNumber* htValue = [hashtagValues objectForKey:rating[@"hashtag"]];
        if(htValue){
            value = [NSNumber numberWithInt:[htValue intValue] + [rating[@"score"] intValue]];
        }
        else{
            value = [NSNumber numberWithInt:[rating[@"score"]intValue]];
        }
        [hashtagValues setObject:value forKey:rating[@"hashtag"]];
    }
    NSArray* sortedKeys = [hashtagValues keysSortedByValueUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    return sortedKeys;

}

-(void)updateRatingsFromParse
{
    NSString* barId = ((PFObject*)self.selectedBar[@"bar"]).objectId;
    [PFCloud callFunctionInBackground:@"getRatings" withParameters:@{@"bar":barId} block:^(id object, NSError *error)
    {
            if(!error){
                NSArray* ratings = (NSArray*)object;
                [self.selectedBar setObject:ratings forKey:@"ratings"];
                [self clearAndReloadViews];
            }else{
                NSLog(@"%@",[error userInfo]);
            }
        
                                    
    }];
}

-(NSNumber*)scoreFromUserForHashtag:(NSString*)hashtag
{
    NSArray* ratings = self.selectedBar[@"ratings"];
    for(NSDictionary* rating in ratings)
    {
        if([rating[@"hashtag"] isEqualToString:hashtag] && [rating[@"user"] isEqualToString: [PFUser currentUser].objectId])
        {
           
            return rating[@"score"];
        }
    }
    
    return [NSNumber numberWithInt:0];
}





@end
