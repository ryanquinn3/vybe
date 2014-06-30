//
//  LoginViewController.m
//  Vybe
//
//  Created by Ryan Quinn on 6/16/14.
//  Copyright (c) 2014 vybe. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet VybeLoginForm *loginForm;
@property (strong, nonatomic) IBOutlet UIButton *dismiss;
@property (strong, nonatomic) IBOutlet UIButton *signInPressed;
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    if(IS_IPHONE_4)
    {
        CGRect formRect = self.loginForm.bounds;
        formRect.origin.y -= 30;
        self.loginForm.bounds = formRect;
    }
    
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)dismissPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)signUpPressed:(id)sender {
    
    
   
    ICSDrawerController* icsDC = (ICSDrawerController*)self.presentingViewController;
    ListNavViewController* lnVC = (ListNavViewController*)icsDC.centerViewController;
    BarListViewController* blVC = (BarListViewController*)[lnVC.viewControllers objectAtIndex:[lnVC.viewControllers count]-1];
     
    //BarListViewController* blVC = (BarListViewController*)self.presentingViewController;
    [self dismissViewControllerAnimated:YES completion:^{
         [blVC presentSignUpViewController];
    }];
   

    
    
}
- (IBAction)signInPressed:(id)sender {
    UIAlertView* errorAlert = [self verifyFields];
    if(errorAlert){
        [errorAlert show];
    }
    else{
        
        [PFUser logInWithUsernameInBackground:self.usernameField.text
                                     password:self.passwordField.text
                                        block:^(PFUser *user, NSError *error) {
            if(user)
            {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else{
                
                if(error.code == 101)
                {
                    UIAlertView *loginError =  [[UIAlertView alloc]initWithTitle:@"Oops"
                                                                        message:@"Invalid Credentials"
                                                                       delegate:self
                                                              cancelButtonTitle:@"Try again"
                                                              otherButtonTitles:@"Forgot Password?", nil];
                    loginError.backgroundColor = [UIColor blackColor];
                    loginError.tintColor = [UIColor whiteColor];
                    [loginError show];
                }
                
                NSLog(@"%@",error);
            }
        }];
    }
}

-(UIAlertView*) verifyFields{
    
    NSString* usernameInput = self.usernameField.text;
    NSString* passwordInput = self.passwordField.text;
    
    if([usernameInput length] == 0 || [passwordInput length] == 0){
        UIAlertView* bothFieldsRequired = [[UIAlertView alloc]initWithTitle:@"Oops!"
                                                                    message:@"Both fields are required"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Okay"
                                                          otherButtonTitles:nil];
        return bothFieldsRequired;
    }
    
    return nil;
    
    
    
    
    
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
