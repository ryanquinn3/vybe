//
//  ListNavViewController.m
//  Vybe
//
//  Created by Ryan Quinn on 3/14/14.
//  Copyright (c) 2014 vybe. All rights reserved.
//

#import "ListNavViewController.h"

@interface ListNavViewController ()

@end

@implementation ListNavViewController

-(void)setNearbyBars:(NSArray *)nearbyBars
{
    _nearbyBars = nearbyBars;
    [(SideMenuViewController*)self.drawer.leftViewController setNearbyBars:nearbyBars];
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


-(void) menuPressed
{
    [self.drawer open];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
