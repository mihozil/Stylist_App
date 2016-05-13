//
//  CheckLoginFacebook.h
//  Styler_Signup
//
//  Created by Apple on 4/13/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^onCheckComplition)(NSError*error);

@interface CheckLoginFacebook : UIViewController

@property (nonatomic, strong) UIViewController *viewController;
- (void) checkLogin:(NSString*)type withData:(NSMutableDictionary*)userData onCompletion:(onCheckComplition)complete;

@end
