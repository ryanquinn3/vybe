//
//  DocumentSingleton.h
//  DoinLines
//
//  Created by Adriana Diakite on 10/26/13.
//  Copyright (c) 2013 DoinLines. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DocumentSingleton : NSObject
+ (void)getManagedObjectContext:(void (^)(NSManagedObjectContext *))callback;

@end
