//
//  RoomSingleton.m
//  Stylist_App
//
//  Created by Apple on 4/21/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "RoomSingleton.h"

@implementation RoomSingleton

+(id)shareSingleton{
    static RoomSingleton *roomSingleton = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken,^{
        roomSingleton = [[self alloc]init];
        
    });
    return roomSingleton;
}
- (id) init{
    if (self == [super init]){
        _roomRef = [[Firebase alloc]init];
    }
    return self;
}

@end
