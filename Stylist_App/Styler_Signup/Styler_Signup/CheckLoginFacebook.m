//
//  CheckLoginFacebook.m
//  Styler_Signup
//
//  Created by Apple on 4/13/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "CheckLoginFacebook.h"
#import "SignUpVC3.h"
#import "CreateLink.h"
#import "SWRevealViewController.h"
#import "ShowAlertController.h"
#import "SignUpVC.h"

@interface CheckLoginFacebook ()

@end

@implementation CheckLoginFacebook

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)checkLogin:(NSString *)type withData:(NSMutableDictionary *)userData onCompletion:(onCheckComplition )complete{
    NSString *url = @"http://styler.theammobile.com/LOGIN_CUSTOMER_FACEBOOK.php?";
    NSDictionary*dic =@{@"email":userData[@"email"],
                        @"type":type};
    NSString *urlString = [CreateLink linkwithUrl:url andParameters:dic];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    request.HTTPMethod =@"Get";
    [request setURL:[NSURL URLWithString:urlString]]; // notice this stuff
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:^(NSData*data, NSURLResponse*respond, NSError*error){
        NSError *error2;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error2];
        
        // later remember to check
        int success = [json[@"success"] intValue];
        if (success == 0){
            
            [self gotoRegister:type withData:userData];
        }
        else if (success == 1){
            NSString *userId = [NSString stringWithFormat:@"%@",json[@"id"]];
            [userData setObject:userId forKey:@"idcustomer"];
            
            [self updateUserData:userData];
            [self gotoHome];
        } else if (success ==2 ) {
            // email already Used
            dispatch_async(dispatch_get_main_queue(), ^{
            [ShowAlertController showAlertwithAlertTitle:@"Error" andMessenge:@"Email is used" inVC:self.viewController];
            });
            
            
        }
        
        if (complete) {
         complete(error2);
        }
        
        
    }]resume];
    
}

- (void) gotoRegister:(NSString*)type withData:(NSDictionary*)userData{
    dispatch_async(dispatch_get_main_queue(), ^{
        SignUpVC3 *signupVC3 = [_viewController.storyboard instantiateViewControllerWithIdentifier:@"signupVC3"];
        [_viewController.navigationController pushViewController:signupVC3 animated:YES];
        signupVC3.userData = [NSMutableDictionary dictionaryWithDictionary:userData];
        signupVC3.signUpType = type;
        
    });
    
}

- (void) updateUserData:(NSDictionary*)userData{
    [[NSUserDefaults standardUserDefaults]setObject:userData forKey:@"userData"];
    
}

- (void) gotoHome{
    dispatch_async(dispatch_get_main_queue(), ^{
        SWRevealViewController *revealVC = [_viewController.storyboard instantiateViewControllerWithIdentifier:@"swrevealvc"];
        [_viewController.navigationController pushViewController:revealVC animated:YES];
        _viewController.navigationController.navigationBarHidden = YES;
    });
    
    
}


@end
