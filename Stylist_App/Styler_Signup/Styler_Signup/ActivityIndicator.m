//
//  ActivityIndicator.m
//  Styler_Signup
//
//  Created by Apple on 4/14/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "ActivityIndicator.h"

@implementation ActivityIndicator
+(void)addActivity:(UIActivityIndicatorView *)activityIndicator toView:(UIView *)view{
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    activityIndicator.frame = CGRectMake(0, 0, 60, 60);
    activityIndicator.center = view.center;
    [view addSubview:activityIndicator];
}
+ (void)startAnimatingActivity:(UIActivityIndicatorView *)activityIndicator{
    [activityIndicator startAnimating];
    [[UIApplication sharedApplication]beginIgnoringInteractionEvents];
}
+ (void)stopAnimatingActivity:(UIActivityIndicatorView *)activityIndicator{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [activityIndicator stopAnimating];
        [[UIApplication sharedApplication]endIgnoringInteractionEvents];
    });
}

@end
