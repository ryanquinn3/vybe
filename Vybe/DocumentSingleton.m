//
//  DocumentSingleton.m
//  DoinLines
//
//  Created by Adriana Diakite on 10/26/13.
//  Copyright (c) 2013 DoinLines. All rights reserved.
//

#import "DocumentSingleton.h"

@implementation DocumentSingleton

// Either creates, opens or just uses the demo document
//   (actually, it will never "just use" it since it just creates the UIManagedDocument instance here;
//    the "just uses" case is just shown that if someone hands you a UIManagedDocument, it might already
//    be open and so you can just use it if it's documentState is UIDocumentStateNormal).
//
// Creating and opening are asynchronous, so in the completion handler we set our Model (managedObjectContext).

+ (void)getManagedObjectContext:(void (^)(NSManagedObjectContext *))callback
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"Demo Document"];
    static UIManagedDocument *document = nil;
    if (!document) document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        [document saveToURL:url
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
              if (success) {
                  callback(document.managedObjectContext);
              }
          }];
    } else if (document.documentState == UIDocumentStateClosed) {
        [document openWithCompletionHandler:^(BOOL success) {
            if (success) {
                callback(document.managedObjectContext);
            }
        }];
    } else {
        callback(document.managedObjectContext);
    }
}

@end
