//
//  HashtagTableViewController.m
//  Vybe
//
//  Created by Ryan Quinn on 7/11/14.
//  Copyright (c) 2014 vybe. All rights reserved.
//

#import "HashtagTableViewController.h"

@interface HashtagTableViewController ()
@property (strong,nonatomic) NSMutableArray* selectedHashtags;
@property (strong,nonatomic) NSArray* hashtagList;
@end

@implementation HashtagTableViewController


- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getAllHashtags];
    self.tableView.allowsMultipleSelection = YES;
    self.selectedHashtags = [[NSMutableArray alloc]init];
    self.tableView.backgroundColor = BLACK;
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#define LIVE

-(void)viewWillDisappear:(BOOL)animated{
    //Wont need below
#ifdef LIVE
    [(BarViewController*)self.caller setSubmittedHashtags:self.selectedHashtags];
    [self submitNewRating];
#endif
    [(BarViewController*)self.caller returnFromHashtagSelect];
    //NSLog(@"HTT: %@",self.selectedHashtags);

}

-(void)getAllHashtags
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    self.hashtagList = [NSArray arrayWithArray:((NSArray*)[userDefaults objectForKey:@"hashtags"])];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.hashtagList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hashtagIdentifier" forIndexPath:indexPath];
    
    NSMutableDictionary* hashtag = [self.hashtagList objectAtIndex:indexPath.row];
    cell.textLabel.text = [@"#" stringByAppendingString:[hashtag objectForKey:@"name"]];
    cell.backgroundColor = BLACK;
    cell.textLabel.font = VYBE_FONT_LT(18);
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = UIColorFromRGB(0xffffff, .8);
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = BLACK;
    NSString* hashTag = [cell.textLabel.text substringFromIndex:1];
    [self.selectedHashtags addObject:hashTag];
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = UIColorFromRGB(0xffffff, .8);
    NSString* hashTag = [cell.textLabel.text substringFromIndex:1];
    [self.selectedHashtags removeObject:hashTag];
}


-(void)submitNewRating{
    
    PFObject* bar = [PFObject objectWithoutDataWithClassName:@"Bar" objectId:self.barId];
    PFObject* user = [PFUser currentUser];
    
    if(self.barId == nil || !user)
    {
        NSLog(@"barId not set, or user not logged in");
        return;
    }
    
    if([self.selectedHashtags count] > 0){
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSDate date] forKey:self.barId];
        [defaults synchronize];
    }
    
    for(NSString* ht in self.selectedHashtags){
        PFObject* rating = [PFObject objectWithClassName:@"Rating"];
        NSString* hashtagId = [self objectIdForHashtag:ht];
        PFObject* hashtag = [PFObject objectWithoutDataWithClassName:@"Hashtag" objectId:hashtagId];
    
        if(!hashtagId){
            NSLog(@"Bar objectId couldn't be located");
            break;
        }
        
        rating[@"bar"] = bar;
        rating[@"user"] = user;
        rating[@"hashtag"] = hashtag;
        rating[@"score"] = [NSNumber numberWithInt:1];
        
       
        [rating saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(succeeded){
                [(BarViewController*)self.caller updateRatingsFromParse];
            }
            else{
                NSLog(@"Error saving rating: %@",[error userInfo]);
            }
        }];
    }
    
}

-(NSString*)objectIdForHashtag:(NSString*)hashtag{
    for(NSDictionary* htEntry in self.hashtagList){
        if([hashtag isEqualToString:htEntry[@"name"]]){
            return htEntry[@"objectId"];
        }
    }
    return nil;
}


@end



/*
 NSMutableDictionary* alreadySubmitted = [defaults objectForKey:KEY_USR_SUBM];
 //Has never been made before
 if(!alreadySubmitted){
 NSMutableDictionary* outerDict = [[NSMutableDictionary alloc]init];
 NSMutableArray* userIds = [[NSMutableArray alloc] init];
 [userIds addObject:user.objectId];
 [outerDict setObject:userIds forKey:self.barId];
 [defaults setObject:outerDict forKey:KEY_USR_SUBM];
 [defaults synchronize];
 }else{
 NSMutableArray* userIds = [alreadySubmitted objectForKey:self.barId];
 if(!userIds){
 
 }
 }

 */
