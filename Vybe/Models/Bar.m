//
//  Bar.m
//  Vybe
//
//  Created by Adriana Diakite on 11/30/13.
//  Copyright (c) 2013 vybe. All rights reserved.
//

#import "Bar.h"

@implementation Bar

-(id)initWithPFOject:(PFObject*)obj
{
    self = [super init];
    if(self)
    {
        self.object = obj;
        self.name = obj[@"name"];
        self.address = obj[@"address"];
        self.longitude = [(PFGeoPoint*)obj[@"location"] longitude];
        self.latitude = [(PFGeoPoint*)obj[@"location"] latitude];
    }
    return self;
}

@end
