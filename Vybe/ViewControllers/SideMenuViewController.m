//
//  SideMenuViewController.m
//  Vybe
//
//  Created by Ryan Quinn on 3/14/14.
//  Copyright (c) 2014 vybe. All rights reserved.
//

#import "SideMenuViewController.h"
#import "VybeUtil.h"

@interface SideMenuViewController () <CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *viewsTable;
@property (weak,nonatomic) CLLocationManager* locationManager;
@property (nonatomic) NSInteger locationErrorCode;
@property (nonatomic,strong) NSArray* viewControllers;
@property (strong,nonatomic) NSMutableArray* nearbyBars;
@property (nonatomic) NSInteger lastRowSelected;
@end


@implementation SideMenuViewController


NSArray* cellLabels;


-(void) setViewControllers:(NSArray *)viewControllers
{
    self.viewControllers = viewControllers;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    cellLabels = [[NSArray alloc] initWithObjects: @"List of bars",@"Map of bars", nil];
    self.lastRowSelected = 0;
    [self.locationManager startUpdatingLocation];
    self.nearbyBars = [[NSMutableArray alloc]init];
    [self queryParseForBars];

    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.location = [locations lastObject];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    self.locationErrorCode = error.code;
}


- (void)setLocation:(CLLocation *)location
{
    if (!_location) {
        _location = location;
        
    }
    
}

-(void)updateChildrenWithBars
{
    for(UIViewController* vc in self.viewControllers)
    {
        if([vc class] == [BarMapViewController class])
        {
            [(BarMapViewController*)vc setNearbyBars:[NSArray arrayWithArray:self.nearbyBars]];
        }
        else if ([vc class] == )
    }
}



#pragma mark - Table view data source

static NSString * CELL_IDENTIFIER = @"viewsCell";
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewControllers.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == self.lastRowSelected)
    {
        [self.drawer close];
    }
    else
    {
        [self.drawer replaceCenterViewControllerWithViewController:self.viewControllers[indexPath.row]];
    }
    self.lastRowSelected = indexPath.row;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELL_IDENTIFIER];
    }
    
    cell.backgroundColor = UIColorFromRGB(MIDNIGHT_BLUE, 1);
    cell.textLabel.text = cellLabels[indexPath.row];
    cell.textLabel.font = VYBE_FONT(14);
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}





-(void)queryParseForBars
{
    PFQuery *query = [PFQuery queryWithClassName:@"Bar"];
    [query whereKeyExists:@"name"];
    
    
    //does it in the background... wasn't working earlier
    /*
     [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
     if(!error)
     {
     for(PFObject *obj in objects)
     {
     Bar* bar = [[Bar alloc] initWithPFOject:obj];
     [self.nearbyBars addObject:bar];
     }
     }
     else{
     NSLog(@"Error: %@ %@",error, [error userInfo]);
     }
     
     
     }];*/
    
    
    NSArray* bars = [query findObjects];
    for(PFObject *obj in bars)
    {
        Bar* bar = [[Bar alloc] initWithPFOject:obj];
        [self.nearbyBars addObject:bar];
    }
    
    
}



#pragma mark -ICSDrawerControllerPresenting

-(void)drawerControllerDidClose:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = YES;
}
-(void)drawerControllerDidOpen:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = YES;
}
-(void)drawerControllerWillClose:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = NO;
}
-(void)drawerControllerWillOpen:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = NO;
}



- (UIStatusBarStyle)preferredStatusBarStyle
{
    // Even if this view controller hides the status bar, implementing this method is still needed to match the center view controller's
    // status bar style to avoid a flicker when the drawer is dragged and then left to open.
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}




@end
