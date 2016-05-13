//
//  ShowAlertController.m
//  Styler_Signup
//
//  Created by Apple on 4/13/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "ShowAlertController.h"

@interface ShowAlertController ()

@end

@implementation ShowAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+(void)showAlertwithAlertTitle:(NSString *)alertTitle andMessenge:(NSString *)messenge inVC:(UIViewController *)viewController{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle message:messenge preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:alertAction];
    [viewController presentViewController:alertController animated:YES completion:nil];
}

@end
