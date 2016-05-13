//
//  SignUpVC3.h
//  Styler_Signup
//
//  Created by Apple on 3/4/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpVC3 : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *userProfilePic;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@property (nonatomic, strong) NSMutableDictionary *userData;
@property (nonatomic, strong) NSString *signUpType;


@end
