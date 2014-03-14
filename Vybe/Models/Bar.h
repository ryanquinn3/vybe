//
//  Bar.h
//  Vybe
//
//  Created by Adriana Diakite on 11/30/13.
//  Copyright (c) 2013 vybe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Bar : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) UIImage *photo;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic, strong) PFObject* object;


-(id)initWithPFOject:(PFObject*)obj;
@end
