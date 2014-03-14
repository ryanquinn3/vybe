//
//  VybeAppDelegate.m
//  Vybe
//
//  Created by Adriana Diakite on 11/15/13.
//  Copyright (c) 2013 vybe. All rights reserved.
//
#import <Parse/Parse.h>

#import "VybeAppDelegate.h"
#import "VybeUtil.h"


@implementation VybeAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //TODO: set new Parse Api key
    [Parse setApplicationId:@"kzBHBoxTKlczUznz7Gs7WhSFEImczKd0WKUUCLCh"
                  clientKey:@"b7VxjVfbbgK7foPIL1jwu68yTO5JRqq0M1aqArst"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
    
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(CONCRETE, 1),NSForegroundColorAttributeName,VYBE_FONT(23),NSFontAttributeName,nil]];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(CONCRETE, 1),NSForegroundColorAttributeName,VYBE_FONT(23),NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    BarListViewController* listView = [mainStoryboard instantiateViewControllerWithIdentifier:@"BLVC"];
    
    SideMenuViewController* sideMenuView = [mainStoryboard instantiateViewControllerWithIdentifier:@"SMVC"];
    
    [sideMenuView setViewControllers:[[NSArray alloc] initWithObjects:listView,[mainStoryboard instantiateViewControllerWithIdentifier:@"BMVC"], nil]];
    
    
    
    
    ICSDrawerController *drawer = [[ICSDrawerController alloc]initWithLeftViewController:sideMenuView centerViewController:listView];
    
    
    self.window.rootViewController = drawer;
    
    [self.window makeKeyAndVisible];
    
    
    
    
    
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
