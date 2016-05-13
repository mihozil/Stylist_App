//
//  SignUpVC3.m
//  Styler_Signup
//
//  Created by Apple on 3/4/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "SignUpVC3.h"
#import "SignUpVC4.h"
#import "CreateLink.h"
#import "ActivityIndicator.h"

#define postLink @"http://styler.theammobile.com/CREATE_NEW_ACCOUNT_CUSTOMER.php?email=%@&pass=%@&lastname=%@&firstname=%@";

@implementation SignUpVC3{
    NSString *idCustomer;
    UIActivityIndicatorView *activityIndicatorView;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    UIImage *photo = [UIImage imageWithData:_userData[@"image"]];
    _userProfilePic.image = photo;
    _userName.text = [NSString stringWithFormat:@"%@ %@",_userData[@"firstname"],_userData[@"lastname"]];
    
    [_phoneTF setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    _phoneTF.delegate = self;
    
    _codeTF.delegate = self;
    
    activityIndicatorView = [[UIActivityIndicatorView alloc]init];
    [ActivityIndicator addActivity:activityIndicatorView toView:self.view];
}

- (void) alertPhoneNo{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Invalid Phone Number" message:@"Please reenter your phone number" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:alertAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (NSString*) linkPost{
    NSString*link;
    NSDictionary *dic;
    NSString*url;
    if (([_signUpType isEqualToString:@"Facebook"]) || ([_signUpType isEqualToString:@"Google"])){
        dic = @{@"email":_userData[@"email"],
                              @"firstname":_userData[@"firstname"],
                              @"lastname":_userData[@"lastname"],
                              @"type":_signUpType};
        url = @"http://styler.theammobile.com/CREATE_NEW_ACCOUNT_CUSTOMER_FACEBOOK.php?";
    }else {
        dic = @{@"email":_userData[@"email"],
                              @"firstname":_userData[@"firstname"],
                              @"lastname":_userData[@"lastname"],
                              @"password":_userData[@"password"]};
        url = @"http://styler.theammobile.com/CREATE_NEW_ACCOUNT_CUSTOMER.php?";
    }
    link = [CreateLink linkwithUrl:url andParameters:dic];
    
    return link;
}

- (IBAction)confirmButton:(id)sender {
        // post data to serve
    if ([_phoneTF.text isEqualToString:@""]){
        [self alertPhoneNo];
        return;
    }
    
    // post data to serve
    [ActivityIndicator startAnimatingActivity:activityIndicatorView];
    
    NSString *urlString = [self linkPost];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    request.HTTPMethod = @"Get";
    request.URL  = [NSURL URLWithString:urlString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:^(NSData*data, NSURLResponse*respond, NSError*error){
        
        [ActivityIndicator stopAnimatingActivity:activityIndicatorView];
        NSError*error2;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error2];
        
        NSLog(@"json: %@",json);

        idCustomer = [NSString stringWithFormat:@"%@",json[@"id"]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            SignUpVC4 *vc4 = [self.storyboard instantiateViewControllerWithIdentifier:@"signupVC4"];
            [self.navigationController pushViewController:vc4 animated:YES];
            
            vc4.idCustomer = idCustomer;
            
            [_userData setObject:_phoneTF.text forKey:@"phonenumber"];
            [_userData setObject:idCustomer forKey:@"idcustomer"];
            vc4.userData = _userData;
            vc4.navigationItem.hidesBackButton = YES;
            

        });
        
        [self saveUserData];
        
    }]resume];
    
    // update User data
}
- (void) postImagetoServe{
   
}
- (void) saveUserData{
    NSData *imgData = UIImagePNGRepresentation(_userProfilePic.image);
    [_userData setObject:imgData forKey:@"image"];
    
    [[NSUserDefaults standardUserDefaults]setValue:_userData forKey:@"userData"];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}

@end
