//
//  ShowAlertView.m
//  Stylist_App
//
//  Created by Apple on 4/21/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "ShowAlertView.h"
#import "UIAlertController+Window.h"


@interface ShowAlertView ()

@end

@implementation ShowAlertView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+(void)showAlertwithTitle:(NSString *)title andMessenge:(NSString *)messenge inViewController:(UIViewController *)viewController{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:messenge preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction: action];
//    [viewController presentViewController:alertController animated:YES completion:nil];
    [alertController show];
    
}
@end
