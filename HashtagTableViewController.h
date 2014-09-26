//
//  HashtagTableViewController.h
//  Vybe
//
//  Created by Ryan Quinn on 7/11/14.
//  Copyright (c) 2014 vybe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarViewController.h"
#import "VybeUtil.h"

@interface HashtagTableViewController : UITableViewController
@property (strong,nonatomic) UIViewController* caller;
@property (strong,nonatomic) NSString* barId;
@end
