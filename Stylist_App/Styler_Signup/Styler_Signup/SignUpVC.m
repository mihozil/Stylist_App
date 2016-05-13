//
//  SignUpVC.m
//  Styler_Signup
//
//  Created by Apple on 3/2/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "SignUpVC.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "SignUpVC2.h"
#import "SignUpVC3.h"
#import <FBSDKCoreKit/FBSDKGraphRequestConnection.h>
#import "CheckLoginFacebook.h"
#import "ActivityIndicator.h"


static NSString * const kClientID =
@"201321149686-si2mshb8aikg5pa0099e5imn4k9rrc06.apps.googleusercontent.com";

static NSString *APIKey=@"AIzaSyAPTQG9pGSYZL44ouk9rd2u7a0mSU6atFM";


@implementation SignUpVC{
    FBSDKLoginManager*login;
    BOOL checkBtPress;
    UIActivityIndicatorView *activityIndicatorView;
}

- (void)viewDidLoad{
    _userData = [[NSMutableDictionary alloc]init];
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate = self;
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    
    activityIndicatorView = [[UIActivityIndicatorView alloc]init];
    [ActivityIndicator addActivity:activityIndicatorView toView:self.view];

}
- (void)viewWillAppear:(BOOL)animated{
    checkBtPress = NO;
}


- (IBAction)googleLoginBt:(id)sender {
    [[GIDSignIn sharedInstance]signOut]; // take care of this
    [[GIDSignIn sharedInstance]signIn];
    
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.googleapis.com/oauth2/v1/userinfo?alt=json&access_token=%@",user.authentication.accessToken]];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    __block NSDictionary *json;
    [ActivityIndicator startAnimatingActivity:activityIndicatorView];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               json = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0
                                                                        error:nil];
                               
                               
                               [_userData setObject:user.profile.email forKey:@"email"];
                               [_userData setObject:json[@"given_name"] forKey:@"firstname"];
                               [_userData setObject:json[@"family_name"] forKey:@"lastname"];
                               
                               NSURL *imgUrl = [NSURL  URLWithString:[json objectForKey:@"picture"]];
                               NSData *data2 = [NSData dataWithContentsOfURL:imgUrl];
//                               UIImage *profileImg = [UIImage imageWithData:data2];
                               [_userData setObject:data2 forKey:@"image"];


                               CheckLoginFacebook *check = [CheckLoginFacebook new];
                               [check checkLogin:@"Google" withData:_userData onCompletion:^(NSError*error){
                                   [ActivityIndicator stopAnimatingActivity:activityIndicatorView];

                               }];
                               check.viewController = self;
                               
                           }];
    
}


- (IBAction)facebookLoginBt:(id)sender {
    login = [[FBSDKLoginManager alloc]init];

    [login logInWithReadPermissions:@[@"public_profile",@"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError*error){
        if (error){
            NSLog(@"Error");
        }else
            
            if (result.isCancelled){
                NSLog(@"Is Cancelled");
                // take careof this
            }else {

                [ActivityIndicator startAnimatingActivity:activityIndicatorView];
                
                FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                              initWithGraphPath:@"/me"
                                              parameters:@{ @"fields": @"id,name,email,first_name,last_name",}
                                              HTTPMethod:@"GET"];
                [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                    // Insert your code here
                    if (result){
                        
                        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",[result objectForKey:@"id"]]];
                        
                        NSData *data = [NSData dataWithContentsOfURL:url];
//                        UIImage *photo = [UIImage imageWithData:data];
                        [_userData setObject:data forKey:@"image"];
                        [_userData setObject:result[@"first_name"] forKey:@"firstname"];
                        [_userData setObject:result[@"last_name"] forKey:@"lastname"];
                        [_userData setObject:result[@"email"] forKey:@"email"];

                        CheckLoginFacebook *check = [CheckLoginFacebook new];
                        [check checkLogin:@"Facebook" withData:_userData onCompletion:^(NSError*error){
                            [ActivityIndicator stopAnimatingActivity:activityIndicatorView];
                        }];
                        
                        check.viewController = self;
                    }else {
                        [ActivityIndicator stopAnimatingActivity:activityIndicatorView];
                    }

                }];

            }
        
    }];
}


- (IBAction)nextButton:(id)sender {
    if (checkBtPress) return;
    checkBtPress = YES;
    
    if ([self checkValidEmail:_emailTF.text]){
        [self checkEmailnotUsed:_emailTF.text];
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Invalid Email" message:@"Please reenter your email" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction*action){
        checkBtPress = NO;
    }];
    [alertController addAction:alertAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void) checkEmailnotUsed:(NSString*)email{
    
    
    NSString *urlString = [NSString stringWithFormat:@"http://styler.theammobile.com/CHECK_EMAIL_IS_ALREADY_USED.php?email=%@",email];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"Get"];
    
    [ActivityIndicator startAnimatingActivity:activityIndicatorView];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:^(NSData*data,NSURLResponse*respond,NSError*error){
        
        [ActivityIndicator stopAnimatingActivity:activityIndicatorView];
        
        NSLog(@"end activity indicator");
        NSError *error2;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error2];
        
        // email already used
        NSNumber *index = json[@"success"];
        if ([index intValue] != 0){
            
            dispatch_async(dispatch_get_main_queue(),^{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Email Used" message:@"Please reenter your email Adress"   preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:alertAction];
                
                [self presentViewController:alertController animated:YES completion:nil];
                
                checkBtPress = NO;
            });

            return;
        }
        
        dispatch_async(dispatch_get_main_queue(),^{
            SignUpVC2 *signUpVC2 = [self.storyboard instantiateViewControllerWithIdentifier:@"signupVC2"];
            [self.navigationController pushViewController:signUpVC2 animated:YES];
            [_userData setObject:_emailTF.text forKey:@"email"];
            signUpVC2.userData = _userData;
        });
        
        
    }] resume];

}
-(BOOL) checkValidEmail:(NSString*)checkString{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([_emailTF isFirstResponder]){
        [_emailTF resignFirstResponder];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
