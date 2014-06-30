//
//  SignUpViewController.m
//  Vybe
//
//  Created by Ryan Quinn on 6/16/14.
//  Copyright (c) 2014 vybe. All rights reserved.
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>
@interface SignUpViewController ()
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *confirmPassField;



@end

@implementation SignUpViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)closePressed:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
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
- (IBAction)signUpPressed:(id)sender {
    if(![self verfiyFields])
    {
        return;
    }
    PFUser * newUser = [PFUser user];
    
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    newUser[@"phone"] = self.phoneNumberField.text;
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error)
        {
            NSLog(@"Error signing up: %@",error);
            return;
        }
        
        
        UIAlertView* successView = [[UIAlertView alloc]initWithTitle:@"Success"
                                                             message:@"You now have an account!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        
        [successView show];
        
        
        
       
        
    }];

}




-(bool)verfiyFields
{
    return YES;
}

-(void)alertViewCancel:(UIAlertView *)alertView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
