//
//  SignUpVC4.m
//  Styler_Signup
//
//  Created by Apple on 3/4/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "SignUpVC4.h"
#import "ServiceRequest.h"
#import "SWRevealViewController.h"

@implementation SignUpVC4{
    NSString *method;
}
- (void)viewDidLoad{
    _creditCardTF.delegate = self;
    _expiredMonthTF.delegate = self;
    _expiredYearTF.delegate = self;
    _cvvTF.delegate = self;
    _postalCodeTF.delegate = self;
    
    
}
- (BOOL) someFieldisEmpty{
    
    if (([_creditCardTF.text isEqualToString:@""]) || ([_expiredMonthTF.text isEqualToString:@""]) ||([_expiredYearTF.text isEqualToString:@""]) || ([_cvvTF.text isEqualToString:@""]) ||  ([_postalCodeTF isEqual:@""]) ){
        return YES;
    }
    return  NO;
}

- (IBAction)confirmButton:(id)sender {
    
    if ([self someFieldisEmpty]) return;
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Register success" message:@"Congratulation! You have successfully register the Styler Account" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okActoin = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        self.navigationController.navigationBarHidden = YES;
        SWRevealViewController *swRevealVC  = [self.storyboard instantiateViewControllerWithIdentifier:@"swrevealvc"];
        swRevealVC.userAvataImage = _userPic;
        swRevealVC.userName = _userName;
        [self.navigationController setViewControllers:@[swRevealVC] animated:YES];
        

        
    }];
    [alertView addAction:okActoin];
    [self presentViewController:alertView animated:YES completion:nil];
    
    [self pushDatatoServe];
}
- (void) pushDatatoServe{
    method = @"1";
    NSString *urlString =[NSString stringWithFormat:@"http://styler.theammobile.com/CREATE_NEW_PAYMENT.php?idcustomer=%@&method=%@&ccnumber=%@&expmonth=%@&expyear=%@&cvv=%@&postalcode=%@",
                          _idCustomer,method,
                          _creditCardTF.text,
                          _expiredMonthTF.text,
                          _expiredYearTF.text,
                          _cvvTF.text,
                          _postalCodeTF.text];
    NSLog(@"urlString: %@",urlString);
    NSMutableURLRequest *request  = [[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:urlString]];
    request.HTTPMethod = @"Get";
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:^(NSData*data, NSURLResponse*respond, NSError*error){
        
        NSError *error2;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error2];
        NSLog(@"json: %@",json);
        
    }]resume];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
