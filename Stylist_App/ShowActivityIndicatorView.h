//
//  ShowActivityIndicatorView.h
//  Stylist_App
//
//  Created by Apple on 5/10/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ShowActivityIndicatorView : NSObject
+(void) startActivityIndicator:(UIActivityIndicatorView*)activityIndicatorView inView:(UIView*)view;
+(void) stopActivityIndicator:(UIActivityIndicatorView*)activityIndicatorView;

@end
