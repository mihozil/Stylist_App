//
//  ReceiptVC.m
//  Stylist_App
//
//  Created by Apple on 4/23/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "ReceiptVC.h"

@interface ReceiptVC ()<UIGestureRecognizerDelegate>

@end

@implementation ReceiptVC{
    UITapGestureRecognizer *tap;
    int rateNo;
    NSDictionary *customerData;
}
- (void) initPrj{
    self.navigationController.navigationBarHidden = YES;
    customerData = [[NSUserDefaults standardUserDefaults]objectForKey:@"customerData"];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initPrj];
    [self setDate];
    [self setPrice];
    [self setServices];
    [self setClientInfo];
    [self setRate];
    
}
- (void) setDate{
    NSLocale *locale = [NSLocale currentLocale];
    NSString *dateString = [[NSDate date]descriptionWithLocale:locale];
    
    NSArray *dateArray = [dateString componentsSeparatedByString:@" at"];
    _dateLabel.text = dateArray[0];
    
}
- (void) setPrice{
    
}
- (void) setServices{
    NSString *servicesString = [NSString new];
    NSArray *servicesCustomer = customerData[@"customerServices"];
    NSString *priceName = customerData[@"priceName"];
    
    float totalPrice = 0;
    for (int i=0; i<servicesCustomer.count; i++){
        NSDictionary *service = servicesCustomer[i];
         servicesString= [servicesString stringByAppendingString:service[@"name"]];
        servicesString = [servicesString stringByAppendingString:@"\n"];
        
        totalPrice+=[service[priceName] floatValue];
    }
    _serviceTextView.text = servicesString;
    _priceLabel.text = [NSString stringWithFormat:@"Total Price: %2.2f$",totalPrice];
    
}
- (void) setClientInfo{
    NSDictionary *customerData = [[NSUserDefaults standardUserDefaults]objectForKey:@"customerData"];
    _clientNameLabel.text = customerData[@"name"];
    
}
- (void) setRate{
    [_rateView setStarView];
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap:)];
    tap.numberOfTapsRequired = 1;
    tap.enabled = true;
    [_rateView addGestureRecognizer:tap];
    
}
- (void) onTap:(UITapGestureRecognizer*)tapp{
    float starSize = MIN(_rateView.frame.size.height, _rateView.frame.size.width/5);
    CGPoint tapLocation = [tapp locationInView:_rateView];
    rateNo = (int) tapLocation.x/starSize+1;
    [_rateView updateRating:rateNo];
    
}

- (IBAction)onSubmitBt:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Submit successfully" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Home" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
    
}


@end
