//
//  ActivityIndicator.h
//  Styler_Signup
//
//  Created by Apple on 4/14/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ActivityIndicator : NSObject
+(void) addActivity:(UIActivityIndicatorView*)activityIndicator toView:(UIView*) view;
+(void) startAnimatingActivity:(UIActivityIndicatorView*)activityIndicator;
+(void) stopAnimatingActivity:(UIActivityIndicatorView*)activityIndicator;

@end
