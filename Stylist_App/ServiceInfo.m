//
//  ServiceInfo.m
//  Stylist_App
//
//  Created by Apple on 5/11/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "ServiceInfo.h"

@implementation ServiceInfo
+ (NSArray *)getServicesList:(NSString *)services{
    
    NSArray *allServices = [[NSUserDefaults standardUserDefaults]objectForKey:@"services"];
    NSMutableArray *customerServices = [NSMutableArray new];
    
    do {
        int value = [services intValue];
        NSString*valueString = [NSString stringWithFormat:@"%d",value];
        NSInteger valueLength = [valueString length];
        services = [services substringWithRange:NSMakeRange(valueLength+1, [services length]-valueLength-1)];
        
        [customerServices addObject:allServices[value/3+1]];
        
    } while (![services isEqualToString:@""]);
    return customerServices;
}

+ (NSString *)getPriceName:(NSString *)services{
    int firstValue = [services intValue];
    switch (firstValue%3) {
        case 0:
            return @"price_junior";
            break;
        case 1:
            return @"price_senior";
            break;
        case 2:
            return @"price_superstar";
            break;
            
        default:
            break;
    }
    return nil;
}

@end
