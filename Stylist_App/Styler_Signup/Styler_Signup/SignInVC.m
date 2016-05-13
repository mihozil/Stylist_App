//
//  SignInVC.m
//  Styler_Signup
//
//  Created by Apple on 3/4/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "SignInVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "SWRevealViewController.h"
#import "CreateLink.h"
#import "SignUpVC3.h"
#import "CheckLoginFacebook.h"
#import "ActivityIndicator.h"

@implementation SignInVC{
    FBSDKLoginManager *login;
    NSString *userId;
    NSMutableDictionary *userData;
    UIActivityIndicatorView *activityIndicatorView;
}
- (void)viewDidLoad{

    
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate = self;
    
    _emailTextField.delegate = self;
    _passwordTextField.delegate = self;
    _passwordTextField.secureTextEntry = YES;
    
    userData = [NSMutableDictionary dictionary];
    
    activityIndicatorView = [[UIActivityIndicatorView alloc]init];
    [ActivityIndicator addActivity:activityIndicatorView toView:self.view];
    
    
}
- (IBAction)loginGoogleBt:(id)sender {
   [[GIDSignIn sharedInstance]signOut];
    [[GIDSignIn sharedInstance]signIn];
    
}

-  (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error{
    [ActivityIndicator startAnimatingActivity:activityIndicatorView];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.googleapis.com/oauth2/v1/userinfo?alt=json&access_token=%@",user.authentication.accessToken]];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    __block NSDictionary *json;
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               
                               [ActivityIndicator stopAnimatingActivity:activityIndicatorView];
                               if (data ==nil) {
                                   NSLog(@"ERROR DATA NIL");return ;
                               }
                               json = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0
                                                                        error:nil];
                               
                               NSURL *imgUrl = [NSURL  URLWithString:[json objectForKey:@"picture"]];
                               NSData *data2 = [NSData dataWithContentsOfURL:imgUrl];
                               UIImage *profileImg = [UIImage imageWithData:data2];
                               
                               [userData setObject:data2 forKey:@"image"];
                               [userData setObject:json[@"given_name"] forKey:@"firstname"];
                               [userData setObject:json[@"family_name"] forKey:@"lastname"];
                               [userData setObject:user.profile.email forKey:@"email"];
                               
                               CheckLoginFacebook *check = [CheckLoginFacebook new];
                               [check checkLogin:@"Google" withData:userData onCompletion:^(NSError*error){
                                   
                               }];
                               check.viewController = self;
                               
                           }];
}


- (IBAction)loginFacebookBt:(id)sender {
    login = [[FBSDKLoginManager alloc]init];
    [login logOut];
    
    [login logInWithReadPermissions:@[@"public_profile",@"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult*result, NSError*error){
        if (error){
            NSLog(@"Error");
        }else if (result.isCancelled){
            NSLog(@"Cancel");
        }else {
            NSLog(@"Log in");
            [ActivityIndicator startAnimatingActivity:activityIndicatorView];
            
            FBSDKGraphRequest *requestMe = [[FBSDKGraphRequest alloc]
                                          initWithGraphPath:@"/me"
                                          parameters:@{ @"fields": @"id,name,email,first_name,last_name",}
                                          HTTPMethod:@"GET"];
            
            FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc]init];
            [connection addRequest:requestMe completionHandler:^(FBSDKGraphRequestConnection*connection, id result, NSError*error){

                if (result){
                    
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",[result objectForKey:@"id"]]];
                    NSData *data = [NSData dataWithContentsOfURL:url];
                    UIImage *photo = [UIImage imageWithData:data];
                    [userData setObject:data forKey:@"image"];
                    [userData setObject:result[@"first_name"] forKey:@"firstname"];
                    [userData setObject:result[@"last_name"] forKey:@"lastname"];
                    [userData setObject:result[@"email"] forKey:@"email"];
                    NSLog(@"userData: %@",userData);
                    
                    CheckLoginFacebook *check = [CheckLoginFacebook new];
                    [check checkLogin:@"Facebook" withData:userData onCompletion:^(NSError*error){
                        [ActivityIndicator stopAnimatingActivity:activityIndicatorView];
                    }];
                    check.viewController = self;
                
                } else {
                    [ActivityIndicator stopAnimatingActivity:activityIndicatorView];
                }
            }];
            [connection start];
        }
    }];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)loginBt:(id)sender {
    [ActivityIndicator startAnimatingActivity:activityIndicatorView];
    
    NSString *urlString = [NSString stringWithFormat:@"http://styler.theammobile.com/LOGIN_CUSTOMER.php?email=%@&password=%@",_emailTextField.text,_passwordTextField.text];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    request.HTTPMethod = @"Get";
    request.URL = [NSURL URLWithString:urlString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:^(NSData*data, NSURLResponse*respond, NSError*error){
        [ActivityIndicator stopAnimatingActivity:activityIndicatorView];
        
        NSError*error2;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error2];
        
        int success = [json[@"success"] intValue];
        if (success ==1) {
            userId = [NSString stringWithFormat:@"%@",json[@"id"]];
            
            [self loginSuccess];
        }else {
            [self loginFail];
        }
    }]resume];
}
- (void) gotoHome{
    dispatch_async(dispatch_get_main_queue(), ^{
        SWRevealViewController *revealVC = [self.storyboard instantiateViewControllerWithIdentifier:@"swrevealvc"];
        [self.navigationController pushViewController:revealVC animated:YES];
        self.navigationController.navigationBarHidden = YES;
    });
    
    
}
- (void) loginSuccess{
    [userData setObject:_emailTextField.text forKey:@"email"];
    
    NSString *urlString = [NSString stringWithFormat:@"http://styler.theammobile.com/GET_CUSTOMER_INFORMATION_BASIC.php?idcustomer=%@",userId];
    [[NSUserDefaults standardUserDefaults]setObject:userId forKey:@"idCustomer"];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    request.HTTPMethod = @"Get";
    request.URL = [NSURL URLWithString:urlString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:^(NSData*data, NSURLResponse*respond, NSError*error){
        
        NSError *error2;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error2];
    
        [userData setObject:json[@"firstname"] forKey:@"firstname"];
        [userData setObject:json[@"lastname"] forKey:@"lastname"];
        
        NSString *phoneNo = [NSString stringWithFormat:@"%@",json[@"phonenumber"]];
        [userData setObject:phoneNo forKey:@"phonenumber"];
        
        [userData setObject:json[@"avatar"] forKey:@"image"];
        [userData setObject:userId forKey:@"idcustomer"];
        
        [self updateUserData];
        
    }]resume];
    [self gotoHome];
    
}
- (void) updateUserData{
    [[NSUserDefaults standardUserDefaults]setObject:userData forKey:@"userData"];
    
}
- (void) loginFail{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please reenter your email and password" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction: action];
        [self presentViewController:alertController animated:YES completion:nil];
        

    });
  }

@end
