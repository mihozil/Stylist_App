//
//  RoomSingleton.h
//  Stylist_App
//
//  Created by Apple on 4/21/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>

@interface RoomSingleton : NSObject
@property (nonatomic, strong)Firebase *roomRef;
+(id) shareSingleton;
@end
