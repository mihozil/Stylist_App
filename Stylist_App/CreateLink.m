//
//  CreateLink.m
//  Stylist_App
//
//  Created by Apple on 5/10/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "CreateLink.h"

@implementation CreateLink

+(NSString *)linkwithUrl:(NSString *)url andParas:(NSDictionary *)paras{
    NSArray *allKeys = paras.allKeys;
    NSArray *allValues = paras.allValues;
    for (int i=0;i<allKeys.count; i++){
        NSString *addedString = [NSString stringWithFormat:@"%@=%@",allKeys[i],allValues[i]];
        if (i<allKeys.count-1) addedString = [addedString stringByAppendingString:@"&"];
        url = [url stringByAppendingString:addedString];
    }
    return url;
}

@end
