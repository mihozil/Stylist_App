//
//  SignIn.m
//  Stylist_App
//
//  Created by Apple on 4/21/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "SignIn.h"
#import "GoOnline.h"
#import "ShowAlertView.h"
#import "SWRevealViewController.h"
#import "ShowActivityIndicatorView.h"
#import "IOSRequest.h"
#import "CreateLink.h"

@interface SignIn ()

@end

@implementation SignIn{
    NSString *stylerId;
    NSMutableDictionary *stylerInfo;
    UIActivityIndicatorView *activityIndicatorView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    activityIndicatorView = [[UIActivityIndicatorView alloc]init];
    stylerInfo = [NSMutableDictionary new];
    self.navigationController.navigationBarHidden = YES;
    _passTF.secureTextEntry = YES;

}

- (IBAction)onNextBt:(id)sender {
    if (([_emailTF.text isEqualToString:@""]) || ([_passTF.text isEqualToString:@""])){
        [ShowAlertView showAlertwithTitle:@"Error" andMessenge:@"Fields are not allowed to be blank" inViewController:self];
    }else {
        [ShowActivityIndicatorView startActivityIndicator:activityIndicatorView inView:self.view];
        [self checkStylerLogin];
//        [self gotoGoOnline];
    }
}
- (void) checkStylerLogin{
    NSString *url = @"http://styler.theammobile.com/stylist/LOGIN_STYLIST.php?";
    NSDictionary *paras = @{@"email":_emailTF.text,@"pass":_passTF.text};
    NSString *urlString = [CreateLink linkwithUrl:url andParas:paras];
    [IOSRequest requestPath:urlString onCompletion:^(NSError*error, NSDictionary*json){
        if (!error){
            if ([json[@"success"] intValue]==0){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ShowAlertView showAlertwithTitle:@"Login Error" andMessenge:@"Error with account or password" inViewController:self];
                    [ShowActivityIndicatorView stopActivityIndicator:activityIndicatorView];
                });
        
            }else {
                stylerId = [NSString stringWithFormat:@"%@",json[@"id"]];
                [self getStylerData];
            }
        }else {
            [ShowActivityIndicatorView stopActivityIndicator:activityIndicatorView];
        }
    }];
    
}
- (void) getStylerData{
    [self getSylerDataBasic];
    [self getStylerDataServices];
}
- (void) getSylerDataBasic{
    NSString *url = @"http://styler.theammobile.com/stylist/GET_STYLIST_INFORMATION_BASIC.php?";
    NSDictionary *paras = @{@"idstylist":stylerId};
    NSString *urlString = [CreateLink linkwithUrl:url andParas:paras];
    [IOSRequest requestPath:urlString onCompletion:^(NSError*error, NSDictionary*json){
        if (!error){
            NSString *name = [NSString stringWithFormat:@"%@ %@",json[@"firstname"],json[@"lastname"]];
            [stylerInfo setObject:name forKey:@"name"];
            [stylerInfo setObject:stylerId forKey:@"idstylist"];
            
            NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:json[@"img"]]];
            [stylerInfo setObject:imgData forKey:@"img"];
            
            if (stylerInfo[@"rate"]){
                [self writeStylerData];
            }
        }
    }];
}
- (void) getStylerDataServices{
    NSString *url = @"http://styler.theammobile.com/stylist/GET_STYLIST_INFORMATION_SERVICES.php?";
    NSDictionary *paras = @{@"idstylist":stylerId};
    NSString *urlString = [CreateLink linkwithUrl:url andParas:paras];
    [IOSRequest requestPath:urlString onCompletion:^(NSError*error, NSDictionary*json){
        if (!error){
            [stylerInfo setObject:json[@"rate"] forKey:@"rate"];
            [stylerInfo setObject:json[@"services"] forKey:@"services"];
            
            if (stylerInfo[@"name"]){
                [self writeStylerData];
            }
        }
    }];
}
- (void) writeStylerData{
    [ShowActivityIndicatorView stopActivityIndicator:activityIndicatorView];
    [self gotoGoOnline];
    [[NSUserDefaults standardUserDefaults]setObject:stylerInfo forKey:@"stylerData"];
    
}
- (void) gotoGoOnline{
    dispatch_async(dispatch_get_main_queue(), ^{
        SWRevealViewController *swRevealVC = [self.storyboard instantiateViewControllerWithIdentifier:@"swrevealvc"];
        [self.navigationController pushViewController:swRevealVC animated:YES];
    });
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isFirstResponder]){
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([_emailTF isFirstResponder]) {
        [_emailTF resignFirstResponder];
    }
    if ([_passTF isFirstResponder]){
        [_passTF resignFirstResponder];
    }
}


@end
