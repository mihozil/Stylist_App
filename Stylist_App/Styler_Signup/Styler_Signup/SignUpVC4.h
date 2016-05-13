//
//  SignUpVC4.h
//  Styler_Signup
//
//  Created by Apple on 3/4/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpVC4 : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *creditCardTF;
@property (weak, nonatomic) IBOutlet UITextField *expiredMonthTF;

@property (weak, nonatomic) IBOutlet UITextField *expiredYearTF;
@property (weak, nonatomic) IBOutlet UITextField *cvvTF;
@property (weak, nonatomic) IBOutlet UITextField *postalCodeTF;

@property (nonatomic, strong) NSMutableDictionary *userData;
@property (nonatomic, strong) NSString *idCustomer;

@property (nonatomic, strong) UIImage *userPic;
@property (nonatomic, strong) NSString* userName;

@end
