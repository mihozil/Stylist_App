//
//  SignUpVC2.m
//  Styler_Signup
//
//  Created by Apple on 3/3/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "SignUpVC2.h"
#import "SignUpVC3.h"

@implementation SignUpVC2{
    UIImagePickerController *pickImg;
}
- (void) viewDidLoad{
    [super viewDidLoad];
    
    _firstnameTF.delegate = self;
    _lastnameTF.delegate = self;
    _passwordTF.delegate = self;
    _repeatPasswordTF.delegate = self;
    _passwordTF.secureTextEntry = YES;
    _repeatPasswordTF.secureTextEntry = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap)];
    tap.numberOfTapsRequired = 1;
    tap.enabled = YES;
    [_profileImgView addGestureRecognizer:tap];
}
-(void) onTap{
    pickImg = [[UIImagePickerController alloc]init];
    pickImg.delegate = self;
    pickImg.allowsEditing = YES;

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Choose Image" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *alertCamera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action){
        pickImg.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:pickImg animated:YES completion:nil];
    }];
    UIAlertAction *alertLibrary = [UIAlertAction actionWithTitle:@"Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action){
        pickImg.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:pickImg animated:YES completion:nil];
    }];
    [alertController addAction:alertCamera];
    [alertController addAction:alertLibrary];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    _profileImgView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)nextBt:(id)sender {
    if (([_firstnameTF.text  isEqualToString:@""]) || ([_lastnameTF.text isEqualToString:@""]) || ([_passwordTF.text isEqualToString:@""]) || ([_repeatPasswordTF.text isEqualToString:@""])){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"You must fill in all the fields" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction*alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:alertAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    if (![_passwordTF.text isEqualToString:_repeatPasswordTF.text]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Password not match" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction*alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:alertAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    SignUpVC3 *signupVC3 = [self.storyboard instantiateViewControllerWithIdentifier:@"signupVC3"];
    [self.navigationController pushViewController:signupVC3 animated:YES];
    
    [_userData setObject:_firstnameTF.text forKey:@"firstname"];
    [_userData setObject:_lastnameTF.text forKey:@"lastname"];
    [_userData setObject:_passwordTF.text forKey:@"password"];
    NSData *imgData = UIImagePNGRepresentation(_profileImgView.image);
    [_userData setObject:imgData forKey:@"image"];
    signupVC3.userData = _userData;
}

@end
