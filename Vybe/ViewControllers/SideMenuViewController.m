//
//  SideMenuViewController.m
//  Vybe
//
//  Created by Ryan Quinn on 3/14/14.
//  Copyright (c) 2014 vybe. All rights reserved.
//

#import "SideMenuViewController.h"
#import "VybeUtil.h"

@interface SideMenuViewController () 
@property (strong, nonatomic) IBOutlet UITableView *viewsTable;

@property (nonatomic,strong) NSArray* viewControllers;

@property (nonatomic) NSInteger lastRowSelected;
@end


@implementation SideMenuViewController


NSArray* cellLabels;


-(void) setViewControllers:(NSArray *)viewControllers
{
    _viewControllers = viewControllers;
    
}
-(void)setNearbyBars:(NSArray *)nearbyBars
{
    _nearbyBars = nearbyBars;
   
    [self updateChildrenWithBars];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    cellLabels = [[NSArray alloc] initWithObjects: @"NEARBY BARS",@"MAP", nil];
    self.lastRowSelected = 0;
    //self.nearbyBars = [[NSMutableArray alloc]init];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.viewsTable.backgroundColor = [UIColor blackColor];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)updateChildrenWithBars
{
    for(UIViewController* vc in self.viewControllers)
    {
        if([vc class] == [MapNavViewController class])
        {
            [(MapNavViewController*)vc setNearbyBars:[NSArray arrayWithArray:self.nearbyBars]];
        }
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
    
    cell.backgroundColor = [UIColor blackColor];
    cell.textLabel.text = cellLabels[indexPath.row];
    cell.textLabel.font = VYBE_FONT(25);
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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




@end
