//
//  LoadView.m
//  Stylist_App
//
//  Created by Apple on 4/21/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "LoadView.h"
#import "GoOnline.h"
#import "SignIn.h"
#import "SWRevealViewController.h"
#import "IOSRequest.h"
#import "ShowActivityIndicatorView.h"


@interface LoadView ()

@end

@implementation LoadView{
    UIActivityIndicatorView *activityIndicatorView;
}

- (void)viewDidLoad {

    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    activityIndicatorView = [[UIActivityIndicatorView alloc]init];
    [ShowActivityIndicatorView startActivityIndicator:activityIndicatorView inView:self.view];
    
    NSString *urlString = @"http://styler.theammobile.com/GET_PRODUCT.php?";
    [IOSRequest requestPath:urlString onCompletion:^(NSError*error, NSDictionary*json){
        if (!error){
            NSArray *services = json[@"product"];
            [[NSUserDefaults standardUserDefaults]setObject:services forKey:@"services"];
            NSDictionary *stylerData = [[NSUserDefaults standardUserDefaults]objectForKey:@"stylerData"];
            if (stylerData){
                [self gotoGoOnline];
            }else {
                [self gotoSignIn];
            }
        }
        [ShowActivityIndicatorView stopActivityIndicator:activityIndicatorView];
        
    }];
    
    
}

- (void) gotoGoOnline{
    dispatch_async(dispatch_get_main_queue(), ^{
        SWRevealViewController *swRevealVC = [self.storyboard instantiateViewControllerWithIdentifier:@"swrevealvc"];
        [self.navigationController pushViewController:swRevealVC animated:YES];
    });
}
- (void) gotoSignIn{
    dispatch_async(dispatch_get_main_queue(), ^{
        SignIn *signIn = [self.storyboard instantiateViewControllerWithIdentifier:@"signin"];
        [self.navigationController pushViewController:signIn animated:YES];
    });
    

}



@end
