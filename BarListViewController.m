//
//  BarListViewController.m
//  Vybe
//
//  Created by Ryan Quinn on 3/14/14.
//  Copyright (c) 2014 vybe. All rights reserved.
//

#import "BarListViewController.h"

#define CELL_HEIGHT 168

@interface BarListViewController () <CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) CLLocation* location;
@property (strong, nonatomic) NSIndexPath* selectedRow;
@property (nonatomic, strong) TransitionDelegate *transitionController;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *logInButton;
@end

@implementation BarListViewController

Bar* selectedBar;

BarListStatus currentDisplayedCategory;

NSMutableDictionary* barTopHashtagMap;
UIActivityIndicatorView* indicator;



-(void)setNearbyBars:(NSArray *)nearbyBars
{
    _nearbyBars = nearbyBars;
    [self.tableView reloadData];
    //[((ListNavViewController *)self.navigationController) setNearbyBars:nearbyBars];
}
- (IBAction)liPressed:(id)sender {
    
    LoginViewController * loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
    [loginVC setTransitioningDelegate:self.transitionController];
    [loginVC setModalPresentationStyle:UIModalPresentationCustom];
    [self presentViewController:loginVC animated:YES completion:nil];
}


-(CLLocationManager*)locationManager
{
    if (!_locationManager) {
        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        
        _locationManager = locationManager;
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return _locationManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    barTopHashtagMap = [[NSMutableDictionary alloc]init];
    self.transitionController = [[TransitionDelegate alloc] init];
    [self.locationManager startUpdatingLocation];

    [self setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(CONCRETE, 1);
    self.navigationController.navigationBar.translucent = NO;
    CGRect rect = self.view.bounds;
    rect.size.height -= 65;
    self.tableView.frame = rect;
    self.tableView.backgroundColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor blackColor];
    self.selectedRow = nil;
    selectedBar = nil;
    [self queryForAllHashtags];
    
    // Might want to put this back in for ensuring that bars have been loaded.
    [self queryParseForBars];
    
    //Add to NSUserDefaults that user has used the app before
    //[PFUser logOut];
    
    //Check to see if logged in
    if([self checkUserToShowLogin]){
        //[PFUser logOut];
    }
}

-(BOOL)checkUserToShowLogin
{
    if([PFUser currentUser])
    {
        self.logInButton.customView = [[UIView alloc]initWithFrame:CGRectMake(0,0,0,0)];
        return YES;
    }
    return NO;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self queryParseForBars];
    [self.tableView reloadData];
    
   /* if([self.nearbyBars count] == 0)
    {
        NSString* noBarsMessage = @"Vybe couldn't find any bars near you that we currently support. Please try back soon.";
        UIAlertView* noBarAlert = [[UIAlertView alloc]initWithTitle:@"No nearby bars" message:noBarsMessage delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [noBarAlert show];
    }*/
    
    [self checkUserToShowLogin];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)menuPressed:(id)sender {
    [((ListNavViewController *)self.navigationController) menuPressed];
}


static NSString * CELL_IDENTIFIER = @"viewsCell";
static NSString * CELL_IDENTIFIER2 = @"detailCell";

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.selectedRow == nil){
         return self.nearbyBars.count;
    }
    return self.nearbyBars.count + 1;
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    // 5 different cases
    bool noSelectionPreviously = self.selectedRow == nil;
    bool didClickOnDetailRow = ![[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[BarViewCell class]];
    bool didClickOnSelectedRow = self.selectedRow && self.selectedRow.row == indexPath.row;
    bool didClickOnRowAboveSelection = self.selectedRow && self.selectedRow.row > indexPath.row;
    bool didClickOnRowBelowDetail = self.selectedRow && self.selectedRow.row + 1 < indexPath.row;
     [tableView beginUpdates];
    if(noSelectionPreviously)
    {
        self.selectedRow = [indexPath copy];
        NSArray* newDetail = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:0]];
        [tableView insertRowsAtIndexPaths:newDetail withRowAnimation:UITableViewRowAnimationTop];
    }
    else if(didClickOnDetailRow)
    {
        return;
    }
    else if(didClickOnSelectedRow)
    {
        self.selectedRow = nil;
        NSIndexPath* detailPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:0];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:detailPath] withRowAnimation:UITableViewRowAnimationTop];
    }
    else if(didClickOnRowAboveSelection)
    {
        NSArray* rowToDelete = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.selectedRow.row+1 inSection:0]];
        NSArray* rowToAdd = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:0]];
        self.selectedRow = [indexPath copy];
        [tableView deleteRowsAtIndexPaths:rowToDelete withRowAnimation:UITableViewRowAnimationTop];
        [tableView insertRowsAtIndexPaths:rowToAdd withRowAnimation:UITableViewRowAnimationTop];
    }
    else if(didClickOnRowBelowDetail)
    {
        NSArray* rowToDelete = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.selectedRow.row+1 inSection:0]];
        NSArray* rowToAdd = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
        self.selectedRow = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:0];
        [tableView deleteRowsAtIndexPaths:rowToDelete withRowAnimation:UITableViewRowAnimationTop];
        [tableView insertRowsAtIndexPaths:rowToAdd withRowAnimation:UITableViewRowAnimationBottom];
    }
    [tableView endUpdates];
    
    if(self.selectedRow)
        [tableView scrollToRowAtIndexPath:self.selectedRow atScrollPosition:UITableViewScrollPositionTop animated:UITableViewRowAnimationTop];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(self.selectedRow && self.selectedRow.row+1 == indexPath.row)
    {
        BarDetailTableViewCell * cell = (BarDetailTableViewCell* )[tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER2];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary* barSelected = self.nearbyBars[self.selectedRow.row];

        Bar* currentBar = [[Bar alloc]initWithPFOject:((PFObject*)barSelected[@"bar"])];
#define THRESHOLD .1
        
        CLLocation* barLocation = [[CLLocation alloc]initWithLatitude:currentBar.latitude longitude:currentBar.longitude];
        NSNumber* distance = [self userDistanceInMilesFromBar:barLocation];
        
        bool userAtBar = [distance doubleValue] <= THRESHOLD;
        
       /*  if(userAtBar){
             if([PFUser currentUser]){
               //User is logged in & at the bar, add image with link to bar page
             }else{
                 //Add link to bring up login page
             }
         }
         else{*/
             BarSummaryView* sumView = (BarSummaryView*)cell.customView;
             NSArray* hashes = [self sortedHashTags:barSelected];
             if([hashes count] > 6 )
                 hashes = [hashes subarrayWithRange:NSMakeRange(0, 6)];
             
             [sumView setHashtags:hashes];
             [sumView doDraw];
             [sumView.goButton addTarget:self action:@selector(performSegueToBar) forControlEvents:UIControlEventTouchUpInside];
         //}
       
        cell.clipsToBounds = YES;
        [cell setNeedsDisplay];
        return cell;
    }
    
    BarViewCell *cell = (BarViewCell*)[tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    NSInteger correctRow = indexPath.row;
    if(self.selectedRow){
        //A detail row is being shown
        if(self.selectedRow.row < indexPath.row){
            //This row is after the detail
            correctRow -= 1;
        }
        
    }
    
    Bar* currentBar = [[Bar alloc]initWithPFOject:(PFObject *)self.nearbyBars[correctRow][@"bar"]];
    NSString* imageTitle = [[NSString alloc]init];
    NSString* venueType = [NSString stringWithString:currentBar.object[@"venueType"]];
    cell.backgroundColor = [UIColor blackColor];
   
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
  
    UIImageView* cellImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageTitle]];
    cell.backgroundView = cellImage;
    cell.barNameLabel.text = [[@"  " stringByAppendingString:currentBar.name] uppercaseString];
    
    if([currentBar.name length] > 20)
        cell.barNameLabel.font = VYBE_FONT(16);
    else if([currentBar.name length] > 16)
        cell.barNameLabel.font = VYBE_FONT(18);
    else
        cell.barNameLabel.font = VYBE_FONT(20);
    
    cell.barNameLabel.adjustsFontSizeToFitWidth = YES;
    
    cell.barNameLabel.textColor = cell.distanceLabel.textColor = [UIColor whiteColor];
   // cell.barNameLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
    
    cell.distanceLabel.font = VYBE_FONT(16);
    cell.distanceLabel.adjustsFontSizeToFitWidth = YES;
   // cell.distanceLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
    
    NSDictionary* barRatings = self.nearbyBars[correctRow];
    NSString* topHashtag = [self getCurrentTopHashtag:barRatings];
    if([topHashtag isEqualToString:@""])
        cell.distanceLabel.text = @"";
    else
        cell.distanceLabel.text = [@"#" stringByAppendingString:topHashtag];
                               
    cell.distanceLabel.textAlignment = NSTextAlignmentRight;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    
    [cell setNeedsDisplay];
    return cell;
}


-(void)performSegueToBar
{
    [self performSegueWithIdentifier:@"toBar" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toBar"])
    {
        ((BarViewController*) segue.destinationViewController).selectedBar = self.nearbyBars[self.selectedRow.row];
    }
}

-(NSNumber*)userDistanceInMilesFromBar:(CLLocation*)bar
{
    CLLocationDistance distanceInMeters = [self.location distanceFromLocation:bar];
    return [NSNumber numberWithFloat:distanceInMeters/(1609.34) ];
}


- (void)drawerControllerWillOpen:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = NO;
}

- (void)drawerControllerDidClose:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = YES;
}


-(void)queryParseForBars
{
  /*if(self.location == nil){
        [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(queryParseForBars) userInfo:nil repeats:NO];
        return;
    }*/
    
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicator.center = CGPointMake(self.view.bounds.size.width/2,self.view.bounds.size.height/2);
    indicator.hidesWhenStopped = YES;
    [self.view addSubview:indicator];
    [indicator startAnimating];
   
    //PFGeoPoint* currentLocation = [PFGeoPoint geoPointWithLocation:self.location];
    //[query whereKey:@"location" nearGeoPoint:currentLocation withinMiles:3000];
    
    //Parameters will become geoLocation
    [PFCloud callFunctionInBackground:@"getData" withParameters:@{} block:^(id object, NSError *error) {
        
        if(!error){
            NSArray* bars = (NSArray*)object;
            [self setNearbyBars:bars];
            [indicator stopAnimating];
            [self fetchAllTimeTopHashtags];
            [self.tableView reloadData];
        }else{
           NSLog(@"Error: %@ %@",error, [error userInfo]);
        }
    }];
    
}

-(void)queryForAllHashtags
{
    PFQuery* query = [PFQuery queryWithClassName:@"Hashtag"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            
            NSMutableArray* temp = [[NSMutableArray alloc]init];
            NSMutableDictionary* tempHash;
            for(PFObject* o in objects){
                tempHash = [[NSMutableDictionary alloc]init];
                [tempHash setObject:o[@"name"] forKey:@"name"];
                [tempHash setObject:o.objectId forKey:@"objectId"];
                [temp addObject:tempHash];
            }
            NSArray* hashes = [NSArray arrayWithArray:temp];
            NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:hashes forKey:@"hashtags"];
            if(![userDefaults synchronize]){
                NSLog(@"Failed to store hashtags to NSUserDefaults");
            }
        }
        else{
            NSLog(@"Unable to grab hashtags Error:%@",[error userInfo]);
        }
        
    }];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.location = [locations lastObject];
    [self.tableView reloadData];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"ERRROOOR");
}

- (void)setLocation:(CLLocation *)location
{
    if (!_location) {
        _location = location;
    }
}

-(void)presentSignUpViewController
{
    SignUpViewController* signUpVC = [self.storyboard instantiateViewControllerWithIdentifier:@"signUpVC"];
    [self presentViewController:signUpVC animated:YES completion:nil];
}

//Gets you the top current hashtag
-(NSString*)getCurrentTopHashtag:(NSDictionary*)barDict{
    
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
    
    if(sortedKeys.count == 0)
        return @"";
    
    return [sortedKeys objectAtIndex:0];
}

-(void)fetchAllTimeTopHashtags
{
    for(NSMutableDictionary* bar in self.nearbyBars)
    {
        NSString* barId = ((PFObject*)bar[@"bar"]).objectId;
        [PFCloud callFunctionInBackground:@"getTopHashtags" withParameters:@{@"bar":barId} block:^(id object, NSError *error) {
           
            NSArray* topHashtags = (NSArray*)object;
            
            [barTopHashtagMap setObject:topHashtags forKey:barId];
            
            if([barTopHashtagMap allKeys].count == self.nearbyBars.count)
            {
                [[NSUserDefaults standardUserDefaults] setObject:barTopHashtagMap forKey:@"topHashtagsForBars"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }];
        
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







@end
