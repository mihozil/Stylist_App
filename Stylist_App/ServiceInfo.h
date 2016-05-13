//
//  ServiceInfo.h
//  Stylist_App
//
//  Created by Apple on 5/11/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceInfo : NSObject
+(NSArray*) getServicesList:(NSString*)services;
+(NSString*) getPriceName:(NSString*) services;

@end
