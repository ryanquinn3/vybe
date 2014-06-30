//
//  TransitionDelegate.m
//  Vybe
//
//  Created by Ryan Quinn on 6/16/14.
//  Copyright (c) 2014 vybe. All rights reserved.
//

#import "TransitionDelegate.h"
#import "AnimatedTransitioning.h"

@implementation TransitionDelegate


- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    AnimatedTransitioning *controller = [[AnimatedTransitioning alloc]init];
    controller.isPresenting = YES;
    return controller;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    //I will fix it later.
    //    AnimatedTransitioning *controller = [[AnimatedTransitioning alloc]init];
    //    controller.isPresenting = NO;
    //    return controller;
    return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
    return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    return nil;
}

@end
