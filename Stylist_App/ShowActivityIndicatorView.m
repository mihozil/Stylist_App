//
//  ShowActivityIndicatorView.m
//  Stylist_App
//
//  Created by Apple on 5/10/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "ShowActivityIndicatorView.h"

@implementation ShowActivityIndicatorView
+(void)startActivityIndicator:(UIActivityIndicatorView *)activityIndicatorView inView:(UIView *)view{
    activityIndicatorView.frame = CGRectMake(0, 0, 80, 80);
    activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    activityIndicatorView.center = view.center;
    [view addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    [[UIApplication sharedApplication]beginIgnoringInteractionEvents];
}
+(void) stopActivityIndicator:(UIActivityIndicatorView *)activityIndicatorView{
    [activityIndicatorView stopAnimating];
    dispatch_async(dispatch_get_main_queue(), ^{
      [activityIndicatorView removeFromSuperview];
    });
    
    [[UIApplication sharedApplication]endIgnoringInteractionEvents];
}

@end
