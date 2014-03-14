//
//  BarCDTVC.m
//  Vybe
//
//  Created by Adriana Diakite on 11/15/13.
//  Copyright (c) 2013 vybe. All rights reserved.
//

#import "BarTVC.h"
#import "DocumentSingleton.h"
#import "BarViewController.h"
#import "Bar.h"
#import "VybeUtil.h"


@interface BarTVC ()
@end

@implementation BarTVC

static NSString *INPUT_PATH = @"lyrics";
static NSString *INPUT_TYPE = @"plist";

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(MIDNIGHT_BLUE, 1);
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
    if ([[UIApplication sharedApplication] canOpenURL:
         [NSURL URLWithString:@"comgooglemaps://"]]) {
        [[UIApplication sharedApplication] openURL:
         [NSURL URLWithString:@"comgooglemaps://?center=40.765819,-73.975866&zoom=14&views=traffic"]];
    } else {
        NSLog(@"Can't use comgooglemaps://");
    }
}

-(NSMutableArray *)nearbyBars
{
    if (!_nearbyBars) {
        _nearbyBars = [[NSMutableArray alloc] init];
       // [self queryGooglePlaces];
        [self queryParseForBars];
    }
    [self.mvc showTable];
    return _nearbyBars;
}

#define RADIUS 3500.0



-(void)queryParseForBars
{
    PFQuery *query = [PFQuery queryWithClassName:@"Bar"];
    [query whereKeyExists:@"name"];
    /*
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
       if(!error)
       {
           for(PFObject *obj in objects)
           {
               Bar* bar = [[Bar alloc] initWithPFOject:obj];
               bar.photo = [[UIImage alloc] initWithContentsOfFile:MASCOT_IMG];
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
        bar.photo = [UIImage imageNamed:MASCOT_IMG];
        [self.nearbyBars addObject:bar];
    }
    

}




- (void)queryGooglePlaces
{
    //TODO: get a google places api key
    if (!self.mvc.location) return;
    
#define API_KEY @"AIzaSyBsDuf8Xb-ZPIvjtJGl1LMKAJoIZZ7ELgQ"
    
#define KEY @"AIzaSyBICFlJOjrCgUc8gHbDfGlWZZzoQL26LL4"
    
    NSString *query = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=37.44483,-122.161307&radius=500&types=bar&sensor=false&key=%@",KEY];
    if (self.mvc.location) {
        query = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=3000&types=bar&sensor=false&key=%@", self.mvc.location.coordinate.latitude, self.mvc.location.coordinate.longitude,KEY];
    }
    
    
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:query]];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    NSDictionary *locationResults = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSArray *bars = [locationResults objectForKey:@"results"];
   // NSLog(@"%@",locationResults);
    for (NSDictionary *bar in bars) {
        Bar *barObject = [[Bar alloc] init];
        barObject.name = bar[@"name"];
        barObject.address = bar[@"vicinity"];
      

        barObject.latitude = [bar[@"geometry"][@"location"][@"lat"] doubleValue];
        barObject.longitude = [bar[@"geometry"][@"location"][@"lng"] doubleValue];
        
        
        PFQuery *query = [PFQuery queryWithClassName:@"Bar"];
        
        [query whereKey:@"name" equalTo:barObject.name];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(error)
            {
                NSLog(@"%@",error);
                
                
                
            }else if([objects count] == 0)
            {
                NSLog(@"%@%@",@"Adding ",barObject.name);
                PFObject *parseBar = [PFObject objectWithClassName:@"Bar"];
                parseBar[@"name"] = barObject.name;
                parseBar[@"address"] = barObject.address;
                parseBar[@"address"] = barObject.address;
                parseBar[@"location"] = [PFGeoPoint geoPointWithLatitude:barObject.latitude
                                                               longitude:barObject.longitude];
                
                [parseBar saveInBackground];
            }
        }];
    
        
        
        
        
        
        
        //image stuff
        //image stuff
        NSString *imageQuery = @"https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=CnRwAAAACkstFlzfoEcx5p5VqXB7713cSovpkOviMsyDKsmPUsgX6uPlwNBNl2bhmXfE0qE4WVDX_AtYpK67NbPIs-4d41HO8HAS9Kht7rwXDY1q27pZdhXYqHGqnHSOfga042QD-y_8lLl2nPwz-G03k4TflxIQDANUll5Lo2OAadx53tiKnxoU5_7Xmxg4gkhZYtcIgptvKEZWIvA&sensor=false&key=AIzaSyBICFlJOjrCgUc8gHbDfGlWZZzoQL26LL4";
        imageQuery = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=%@&sensor=false&key=AIzaSyBICFlJOjrCgUc8gHbDfGlWZZzoQL26LL4", bar[@"photos"][0][@"photo_reference"]];
       
        NSURLRequest * urlRequest2 = [NSURLRequest requestWithURL:[NSURL URLWithString:imageQuery]];
        NSURLResponse * response2 = nil;
        NSError * error2 = nil;
        NSData * data2 = [NSURLConnection sendSynchronousRequest:urlRequest2
                                              returningResponse:&response2
                                                          error:&error2];

        

        if(!error2){
           barObject.photo = [[UIImage alloc] initWithData:data2];
        }
        else{
            barObject.photo = [[UIImage alloc] initWithContentsOfFile:MASCOT_IMG];
        }

        [self.nearbyBars addObject:barObject];
    }
    
    
  
}


static NSString * CELL_IDENTIFIER = @"barCell";



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.nearbyBars.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.mvc performSegueWithIdentifier:@"showBar" sender:self];
    self.mvc.dvc.selectedBar = [self.nearbyBars objectAtIndex:indexPath.row];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELL_IDENTIFIER];
    }
    Bar *bar = [self.nearbyBars objectAtIndex:indexPath.row];
    cell.backgroundColor = UIColorFromRGB(MIDNIGHT_BLUE, 1);
    cell.textLabel.font = VYBE_FONT(14);
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = bar.name;
    cell.detailTextLabel.text = @"5 min walk";
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.font = VYBE_FONT(10);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}







@end
