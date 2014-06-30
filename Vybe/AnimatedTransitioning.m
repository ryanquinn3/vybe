//
//  AnimatedTransitioning.m
//  Vybe
//
//  Created by Ryan Quinn on 6/16/14.
//  Copyright (c) 2014 vybe. All rights reserved.
//

#import "AnimatedTransitioning.h"
#import "LoginViewController.h"
#import "BarListViewController.h"

@implementation AnimatedTransitioning


- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIView *inView = [transitionContext containerView];
    LoginViewController *toVC = (LoginViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    BarListViewController *fromVC = (BarListViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [inView addSubview:toVC.view];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [toVC.view setFrame:CGRectMake(0, screenRect.size.height, fromVC.view.frame.size.width, fromVC.view.frame.size.height)];
    
    [UIView animateWithDuration:0.25f
                     animations:^{
                         
                         [toVC.view setFrame:CGRectMake(0, 0, fromVC.view.frame.size.width, fromVC.view.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];
}

@end
