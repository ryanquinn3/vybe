//
//  BarListViewController.m
//  Vybe
//
//  Created by Ryan Quinn on 3/14/14.
//  Copyright (c) 2014 vybe. All rights reserved.
//

#import "BarListViewController.h"

@interface BarListViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UISegmentedControl* filterControl;

@end

@implementation BarListViewController

Bar* selectedBar;

-(void)setNearbyBars:(NSArray *)nearbyBars
{
    _nearbyBars = nearbyBars;
    [self.tableView reloadData];
    [((ListNavViewController *)self.navigationController) setNearbyBars:nearbyBars];
}
-(void)initFilterControl
{
    NSArray* items = [NSArray arrayWithObjects:@"Atmos",@"Crowd",@"Ratio",@"Wait",@"Cover",@"Nearby",nil];
    
    
    self.filterControl = [[UISegmentedControl alloc]initWithItems:items];
    self.filterControl.frame = CGRectMake(-4, 449, 328, 55);
    self.filterControl.selectedSegmentIndex = 0;
    [self.filterControl setTintColor:UIColorFromRGB(MIDNIGHT_BLUE, 1)];
    
    [self.filterControl setImage:[UIImage imageNamed:ATMOS_CAT_IMG] forSegmentAtIndex:0];
    [self.filterControl setImage:[UIImage imageNamed:CROWD_CAT_IMG] forSegmentAtIndex:1];
    [self.filterControl setImage:[UIImage imageNamed:RATIO_CAT_IMG] forSegmentAtIndex:2];
    [self.filterControl setImage:[UIImage imageNamed:WAIT_CAT_IMG] forSegmentAtIndex:3];
    [self.filterControl setImage:[UIImage imageNamed:COVER_CAT_IMG] forSegmentAtIndex:4];
    [self.filterControl setImage:[UIImage imageNamed:NEARBY_CAT_IMG] forSegmentAtIndex:5];
    
    NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:VYBE_FONT(16),NSFontAttributeName, nil];
    [self.filterControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [self.view addSubview:self.filterControl];

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initFilterControl];
    
   
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(MIDNIGHT_BLUE, 1);
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(CONCRETE, 1);
    self.navigationController.navigationBar.translucent = NO;
    
    self.tableView.backgroundColor = UIColorFromRGB(MIDNIGHT_BLUE, 1);
    self.view.backgroundColor = UIColorFromRGB(CONCRETE, 1);
    
    selectedBar = nil;
    [self queryParseForBars];
	// Do any additional setup after loading the view.
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.nearbyBars.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedBar = self.nearbyBars[indexPath.row];
    [self performSegueWithIdentifier:@"toBar" sender:self];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELL_IDENTIFIER];
    }
    Bar* currentBar = self.nearbyBars[indexPath.row];
    cell.backgroundColor = UIColorFromRGB(MIDNIGHT_BLUE, 1);
    cell.textLabel.text = currentBar.name;
    cell.textLabel.font = VYBE_FONT(20);
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toBar"]) {
        
        ((BarViewController*) segue.destinationViewController).selectedBar = selectedBar;
        
    }
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
    NSMutableArray* temp_bars = [[NSMutableArray alloc]init];
    for(PFObject *obj in bars)
    {
        Bar* bar = [[Bar alloc] initWithPFOject:obj];
        [temp_bars addObject:bar];
    }
    [self setNearbyBars:[NSArray arrayWithArray:temp_bars]];
    
}





@end
