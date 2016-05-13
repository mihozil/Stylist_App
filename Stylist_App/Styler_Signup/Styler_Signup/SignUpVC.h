//
//  SignUpVC.h
//  Styler_Signup
//
//  Created by Apple on 3/2/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleSignIn/GoogleSignIn.h>

@interface SignUpVC : UIViewController <GIDSignInUIDelegate,GIDSignInDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet GIDSignInButton *signInButton;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;

@property (nonatomic, strong) NSMutableDictionary *userData;

@end
