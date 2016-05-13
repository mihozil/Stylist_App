//
//  IOSRequest.m
//  Stylist_App
//
//  Created by Apple on 5/10/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "IOSRequest.h"
#import "ShowAlertView.h"

@implementation IOSRequest
+(void)requestPath:(NSString *)path onCompletion:(onCompletionHandle)complete{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    request.URL = [NSURL URLWithString:path];
    request.HTTPMethod = @"Get";
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:^(NSData*data, NSURLResponse*respond, NSError*error){
        
        if (error){
            if (complete) complete(error,nil);
            [ShowAlertView showAlertwithTitle:@"Error" andMessenge:@"Request Error" inViewController:nil];
        }else {
            NSDictionary*json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if (complete) complete(error,json);
        }
    }]resume];
    
}

@end
