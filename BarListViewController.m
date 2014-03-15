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

@end

@implementation BarListViewController

-(void)setNearbyBars:(NSArray *)nearbyBars
{
    _nearbyBars = nearbyBars;
    [self.tableView reloadData];
    [((ListNavViewController *)self.navigationController) setNearbyBars:nearbyBars];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
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
    //dunno if you can send index path as arguement
    [self performSegueWithIdentifier:@"toBar" sender:indexPath];
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
    cell.textLabel.font = VYBE_FONT(14);
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showBar"]) {
        
        NSIndexPath* indexPath = (NSIndexPath*)sender;
        
        ((RateBarViewController*) segue.destinationViewController).selectedBar = self.nearbyBars[indexPath.row];
        
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
