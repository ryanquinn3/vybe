//
//  SideMenuViewController.h
//  Vybe
//
//  Created by Ryan Quinn on 3/14/14.
//  Copyright (c) 2014 vybe. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ICSDrawerController.h"

@interface SideMenuViewController : UIViewController <ICSDrawerControllerChild,ICSDrawerControllerPresenting, UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) ICSDrawerController * drawer;


-(id)initWithViewControllers:(NSArray*)vcs;
@end
