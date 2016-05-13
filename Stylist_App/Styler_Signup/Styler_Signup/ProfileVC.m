//
//  ProfileVC.m
//  Styler_Signup
//
//  Created by Apple on 4/5/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "ProfileVC.h"
#import "SignInUpVC.h"
#import "SWRevealViewController.h"

@interface ProfileVC ()

@end

@implementation ProfileVC{
    NSDictionary *userData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    userData = [[NSUserDefaults standardUserDefaults]objectForKey:@"userData"];
    NSLog(@"userdatahere: %@",userData);
    
    _userName.text = [NSString stringWithFormat:@"%@ %@",userData[@"firstname"],userData[@"lastname"]];
    _userEmail.text = userData[@"email"];
    _userphone.text = userData[@"phonenumber"];
    
    NSData *data = userData[@"image"];
    if (data){
//        UIImage *photo = [UIImage imageWithData:data];
//        _userImage.image = photo;
        
    }
    
//    NSData *imgData = userData[@"image"];
//    _userImage.image = [UIImage imageWithData:imgData];

}
- (void) gotoHome{
    SWRevealViewController *swRevealVC = [self.storyboard instantiateViewControllerWithIdentifier:@"swrevealvc"];
    [self.navigationController pushViewController:swRevealVC animated:YES];
    self.navigationController.navigationBarHidden = YES;
}


- (IBAction)signoutBt:(id)sender {
    
//    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
//    NSDictionary *dics = [defs dictionaryRepresentation];
//    for (id key in dics){
//        [defs removeObjectForKey:key];
//    }
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userData"];
    [self displayAlert];
}
- (void) gotoSignInUp{
    SignInUpVC *signInUp = [self.storyboard instantiateViewControllerWithIdentifier:@"signinupvc"];
    [self.navigationController pushViewController:signInUp animated:YES];
    signInUp.navigationItem.hidesBackButton = YES;
    
}
- (void) displayAlert{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Signed out" message:@"You already signed out" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action){
        [self gotoSignInUp];
    }];
    [alertController addAction:alertAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)onStopBt:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
