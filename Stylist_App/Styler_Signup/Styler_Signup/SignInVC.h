//
//  SignInVC.h
//  Styler_Signup
//
//  Created by Apple on 3/4/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleSignIn/GoogleSignIn.h>

@interface SignInVC : UIViewController <GIDSignInDelegate, GIDSignInUIDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;


@end
