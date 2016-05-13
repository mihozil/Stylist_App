//
//  CreateLink.m
//  Styler_Signup
//
//  Created by Apple on 4/13/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "CreateLink.h"

@implementation CreateLink
+ (NSString *)linkwithUrl:(NSString *)url andParameters:(NSDictionary *)parameters{
    
    NSString *link =[NSString stringWithString:url];
    NSArray *allKeys = [NSArray arrayWithArray:parameters.allKeys];
    NSArray *allValues = [NSArray arrayWithArray:parameters.allValues];
    
    for (int i=0; i<parameters.count; i++){
        NSString *insertString = [NSString stringWithFormat:@"%@=%@",allKeys[i],allValues[i]];
        if (i<parameters.count-1) {
            insertString = [insertString stringByAppendingString:@"&"];
        }
        
        link = [link stringByAppendingString:insertString];
    }
    return link;
}

@end
