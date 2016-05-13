//
//  IOSRequest.h
//  Stylist_App
//
//  Created by Apple on 5/10/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^onCompletionHandle)(NSError*error, NSDictionary*json);

@interface IOSRequest : NSObject
+(void) requestPath:(NSString*)path onCompletion:(onCompletionHandle)complete;


@end
