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
@property (strong, nonatomic) UISegmentedControl* filterControl;
@property (strong,nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) CLLocation* location;
@property (strong, nonatomic) NSIndexPath* selectedRow;
@property (nonatomic, strong) TransitionDelegate *transitionController;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *logInButton;
@end

@implementation BarListViewController

Bar* selectedBar;

BarListStatus currentDisplayedCategory;

-(void)setNearbyBars:(NSArray *)nearbyBars
{
    _nearbyBars = nearbyBars;
    [self.tableView reloadData];
    [((ListNavViewController *)self.navigationController) setNearbyBars:nearbyBars];
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



-(void)segmentChanged
{
    currentDisplayedCategory = self.filterControl.selectedSegmentIndex;
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.transitionController = [[TransitionDelegate alloc] init];
    [self.locationManager startUpdatingLocation];

    [self setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(CONCRETE, 1);
    self.navigationController.navigationBar.translucent = NO;
    
    self.tableView.backgroundColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor blackColor];
    self.selectedRow = nil;
    selectedBar = nil;
    // Might want to put this back in for ensuring that bars have been loaded.
    //[self queryParseForBars];
    
    //Add to NSUserDefaults that user has used the app before
    
    //Check to see if logged in
    if([self checkUserToShowLogin]){
        
    }
    else{
        //Add UIElements for signing in
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
    [self queryParseForBars];
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
        NSLog(@"SelectedRow: %i, IP: %i",self.selectedRow.row,indexPath.row);
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
        NSString* barName = ((Bar*)self.nearbyBars[indexPath.row-1]).name;
        cell.label.text = [@"Details for " stringByAppendingString:barName];
        [cell setNeedsDisplay];
        return cell;
    }
    
    
    
    BarViewCell *cell = (BarViewCell*)[tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    
    int correctRow = indexPath.row;
    if(self.selectedRow){
        //A detail row is being shown
        if(self.selectedRow.row < indexPath.row){
            //This row is after the detail
            correctRow -= 1;
        }
        
    }
    
    Bar* currentBar = self.nearbyBars[correctRow];
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
    
    
    if([currentBar.name length] > 25)
        cell.barNameLabel.font = VYBE_FONT(18);
    else
        cell.barNameLabel.font = VYBE_FONT(20);
    
    cell.barNameLabel.textColor = [UIColor whiteColor];
    cell.distanceLabel.font = VYBE_FONT(18);
    cell.distanceLabel.textColor = [UIColor whiteColor];
    [cell setOpacityofLeftImage:1.0 andRight:1.0];
    
    cell.barNameLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
    
    
    [cell setVisibility:NO andDistanceLabel:YES];
    [cell setLeftImage:ATMOS_LOW_WHT andRight:ATMOS_HIGH_WHT];
    CGFloat atmosphereRating = [[currentBar.object objectForKey:@"avgAtmosphere"]floatValue]/100;
    if([[currentBar.object objectForKey:@"numRatings"]integerValue] == 0)
    {
        [cell setOpacityofLeftImage:.5 andRight:.5];
    }
    else
    {
        [cell setOpacityofLeftImage:(1-atmosphereRating) andRight:atmosphereRating];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setNeedsDisplay];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toBar"])
    {
        //should be ok but might need to adjust for anything above/below
        selectedBar = [self.nearbyBars objectAtIndex:self.selectedRow.row];
        NSNumber* distance = [self userDistanceInMilesFromBar:selectedBar];
        int walkingTime = [distance floatValue]*15;
        NSNumberFormatter* formatter = [[NSNumberFormatter alloc]init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setMaximumFractionDigits:1];
        NSString* numString = [formatter stringFromNumber:distance];
        NSString* disLabel;
        if([numString isEqualToString:@"1"])
            disLabel = [NSString stringWithFormat:@"%@ mile",numString];
        else
            disLabel = [NSString stringWithFormat:@"%@ miles",numString ];
        if(walkingTime <= 30)
            disLabel = [disLabel stringByAppendingString:[NSString stringWithFormat:@", %d minute walk",walkingTime]];
        else
            disLabel = [disLabel stringByAppendingString:@", Call a cab"];
        
        ((BarViewController*) segue.destinationViewController).selectedBar = selectedBar;
     //   ((BarViewController*) segue.destinationViewController).walkDistanceString = disLabel;
    }
}

-(NSNumber*)userDistanceInMilesFromBar:(Bar*)bar
{
    CLLocation* barsLoc = [[CLLocation alloc] initWithLatitude:bar.latitude longitude:bar.longitude];
    CLLocationDistance distanceInMeters = [self.location distanceFromLocation:barsLoc];
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
    
  /*  if(self.location == nil)
    {
        [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(queryParseForBars) userInfo:nil repeats:NO];
        return;
    }*/
    PFQuery *query = [PFQuery queryWithClassName:@"Bar"];

    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    indicator.center = CGPointMake(self.view.bounds.size.width/2,self.view.bounds.size.height/2);
    indicator.hidesWhenStopped = YES;
    [self.view addSubview:indicator];
    [indicator startAnimating];
   
    //PFGeoPoint* currentLocation = [PFGeoPoint geoPointWithLocation:self.location];
    

//    [query whereKey:@"location" nearGeoPoint:currentLocation withinMiles:3000];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
     if(!error)
     {
        NSMutableArray* temp_bars = [[NSMutableArray alloc]init];
         for(PFObject *obj in objects)
         {
             Bar* bar = [[Bar alloc] initWithPFOject:obj];
             [temp_bars addObject:bar];
         }
         [self setNearbyBars:[NSArray arrayWithArray:temp_bars]];
         [indicator stopAnimating];
     }
     else{
         NSLog(@"Error: %@ %@",error, [error userInfo]);
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






@end
