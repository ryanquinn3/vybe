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
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *confirmPWField;




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
    NSArray* fields = [NSArray arrayWithObjects:self.usernameField,self.passwordField,self.confirmPWField, nil];
    
    for(UITextField* field in fields){
        field.layer.cornerRadius = 8.0f;
        field.layer.masksToBounds = YES;
        field.layer.borderColor = UIColorFromRGB(-1, .4).CGColor;
        field.layer.borderWidth = 1.0f;
        [field setValue:WHITE forKeyPath:@"_placeholderLabel.textColor"];
        [field setFont:VYBE_FONT(18)];
    }
    
    
    [self.usernameField becomeFirstResponder];
    
    
    
    
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)signUpPressed:(id)sender {
    NSString* errorString = [self verfiyFields];
    if(errorString)
    {
        UIAlertView* errorView = [[UIAlertView alloc]initWithTitle:@"Error"
                                                           message:errorString
                                                          delegate:nil
                                                 cancelButtonTitle:@"Okay"
                                                 otherButtonTitles: nil];
        [errorView show];
        return;
    }
    PFUser * newUser = [PFUser user];
    
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;

    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error)
        {
            NSLog(@"Error signing up: %@",error);
            return;
        }
        
        
        UIAlertView* successView = [[UIAlertView alloc]initWithTitle:@"Success"
                                                             message:@"You now have an account!"
                                                            delegate:self
                                                   cancelButtonTitle:@"Okay"
                                                   otherButtonTitles: nil];
        
        [successView show];
        
    }];

}




-(NSString*)verfiyFields
{
    NSString* phone = self.usernameField.text;
    NSString* pw = self.passwordField.text;
    NSString* pwc = self.confirmPWField.text;
    
    if([pw length] == 0 || [phone length] == 0 || [pwc length] == 0){
        return @"All fields are required!";
    }
    
    if(![pw isEqualToString:pwc]){
        return @"Passwords must match!";
    }
    if(![self isPhoneValid:phone]){
        return @"Phone number is invalid. Should be 10 digits";
    }
    
    return nil;
}

-(BOOL)isPhoneValid:(NSString*)phone
{
    if([phone length] != 10 || [phone containsString:@"."]) return NO;
    return YES;
}



-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
