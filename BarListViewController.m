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
    self.nearbyBars = nearbyBars;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)menuPressed:(id)sender {
    [self.drawer open];
}


static NSString * CELL_IDENTIFIER = @"viewsCell";
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.nearbyBars.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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




@end
