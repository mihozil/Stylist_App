//
//  LoadingView.m
//  Styler_Signup
//
//  Created by Apple on 4/19/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "LoadingView.h"
#import "SWRevealViewController.h"
#import "SignInUpVC.h"

@interface LoadingView ()

@end

@implementation LoadingView{
    UIImageView *animationView;

    NSMutableArray *imgArray;
    NSMutableDictionary *userData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self addImgView];
    [self getTheFirstData];
    
}
- (void) getTheFirstData{
    userData = [[NSUserDefaults standardUserDefaults]objectForKey:@"userData"];
    if (userData){
        [self updateUserData];
    }else {
        [self gotoSigninUp];
    }
}
- (void) gotoSigninUp{
    SignInUpVC *signInUp = [self.storyboard instantiateViewControllerWithIdentifier:@"signinupvc"];
    signInUp.navigationItem.hidesBackButton = YES;
    [self.navigationController pushViewController:signInUp animated:YES];
    
}

- (void) updateUserData{
    NSString *idcustomer = userData[@"idcustomer"];
    NSString *url = @"http://styler.theammobile.com/GET_CUSTOMER_INFORMATION_BASIC.php";
    NSDictionary *paras = [NSDictionary dictionaryWithObject:idcustomer forKey:@"idcustomer"];
    
    NSString *urlString = [CreateLink linkwithUrl:url andParameters:paras];
    
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    request.HTTPMethod = @"Get";
    request.URL = [NSURL URLWithString:urlString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:^(NSData*data, NSURLResponse*respond, NSError*error){
        NSError *error2;
    
        userData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error2];
        [userData removeObjectForKey:@"success"];
        [userData setObject:idcustomer forKey:@"idcustomer"];
        [[NSUserDefaults standardUserDefaults]objectForKey:@"userData"];
        [self gotoHome];
    }]resume];
    
}
- (void) gotoHome{
    dispatch_async(dispatch_get_main_queue(), ^{
        SWRevealViewController *revealVC = [self.storyboard instantiateViewControllerWithIdentifier:@"swrevealvc"];
        [self.navigationController pushViewController:revealVC animated:YES];
    });
   
}
- (void) addImgView{
    animationView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:animationView];
    
    [self setImageAnimation];
}
- (void) setImageAnimation{
    imgArray = [NSMutableArray new];
    for (int i=0; i<12; i++){
        
        NSString *imgName = [NSString stringWithFormat:@"styler%d.jpg",i];
        UIImage *photo = [UIImage imageNamed:imgName];
        [imgArray insertObject:photo atIndex:0];

        if ((i==0)|| (i==11)){
            for (int j=0; j<8; j++){
                NSString *imgName = [NSString stringWithFormat:@"styler%d.jpg",i];
                UIImage *photo = [UIImage imageNamed:imgName];
                [imgArray insertObject:photo atIndex:0];

            }
        }
    }
    
    animationView.animationImages = imgArray;
    animationView.animationDuration = 8;
    animationView.contentMode = UIViewContentModeScaleAspectFill;
    
    [animationView startAnimating];

}

@end
