//
//  SignUpVC2.h
//  Styler_Signup
//
//  Created by Apple on 3/3/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpVC2 : UIViewController <UITextFieldDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImgView;

@property (weak, nonatomic) IBOutlet UITextField *firstnameTF;
@property (weak, nonatomic) IBOutlet UITextField *lastnameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *repeatPasswordTF;

@property (nonatomic, strong) NSMutableDictionary *userData;




@end
