//
//  ShareService.m
//  Styler_Signup
//
//  Created by Apple on 3/14/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "ShareService.h"
#import "SWRevealViewController.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
@import SafariServices;
#import <Social/Social.h>

@interface ShareService ()

@end

@implementation ShareService{
    UITapGestureRecognizer *tap;
    FBSDKShareButton *shareFacebook;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _rateView.rateNo = _rateNo;
    [_rateView setStarsView];
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap)];
    tap.numberOfTapsRequired = 1;
    tap.enabled = YES;
    [_rateView addGestureRecognizer:tap];
    
    self.navigationController.navigationBarHidden = YES;
    
    
    
}
- (void) onTap{
    float starSize = MIN(_rateView.frame.size.height, _rateView.frame.size.width/5);
    CGPoint tapPoint = [tap locationInView:_rateView];
    
    int position = (int) tapPoint.x/starSize+1;
    _rateView.rateNo = position;
    [_rateView setStarsView];
}
- (IBAction)closeButton:(id)sender {
    SWRevealViewController *swRevealVC = [self.storyboard instantiateViewControllerWithIdentifier:@"swrevealvc"];
    [self.navigationController pushViewController:swRevealVC animated:YES];
}

- (IBAction)submitButton:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Submit successfully" message:@"Thanh you for using our service" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"Home" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        SWRevealViewController *swRevealVC = [self.storyboard instantiateViewControllerWithIdentifier:@"swrevealvc"];
        [self.navigationController pushViewController:swRevealVC animated:YES];
    }];
    [alertController addAction:alertAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)shareFacebookBt:(id)sender {
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc]init];
    content.contentURL = [NSURL URLWithString:@"http://soha.vn/giai-tri/a-hau-huyen-my-xinh-dep-bat-ngo-sau-thoi-gian-o-an-20160325111216867.htm"];
    [FBSDKShareDialog showFromViewController:self withContent:content delegate:nil];
    
}

- (IBAction)shareGoogleBt:(id)sender {
    NSURL *shareUrl = [NSURL URLWithString:@"http://soha.vn/giai-tri/a-hau-huyen-my-xinh-dep-bat-ngo-sau-thoi-gian-o-an-20160325111216867.htm"];
    
    NSURLComponents *urlComponent = [[NSURLComponents alloc]initWithString:@"https://plus.google.com/share"];
    
    urlComponent.queryItems = @[[[NSURLQueryItem alloc]
                                  initWithName:@"url"
                                  value:[shareUrl absoluteString]]];
    NSURL *url = [urlComponent URL];
    
    if ([SFSafariViewController class]){

        SFSafariViewController *safariController = [[SFSafariViewController alloc]initWithURL:url];
        safariController.delegate = self;
        [self presentViewController:safariController animated:YES completion:nil];
        
    }else {
        [[UIApplication sharedApplication]openURL:url];
    }
    
}

- (IBAction)shareTwitter:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        NSURL *url = [NSURL URLWithString:@"http://soha.vn/giai-tri/a-hau-huyen-my-xinh-dep-bat-ngo-sau-thoi-gian-o-an-20160325111216867.htm"];
        [tweetSheet addURL:url];
        [self presentViewController:tweetSheet animated:YES completion:nil];
        
    }
    
}

@end
