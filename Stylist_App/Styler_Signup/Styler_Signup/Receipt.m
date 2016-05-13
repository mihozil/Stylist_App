//
//  Receipt.m
//  Styler_Signup
//
//  Created by Apple on 3/13/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "Receipt.h"
#import "ShareService.h"

@implementation Receipt{
    UITapGestureRecognizer *tap;
    NSArray *servicesPicking;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    servicesPicking = [NSArray arrayWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"servicesPicking"]];
    
    [self getTime];
    [self getServices];
    [self getUser];
    [self setTap];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"implementing"];

}
- (void) setTap{
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap)];
    tap.numberOfTapsRequired = 1;
    tap.enabled = YES;
    [self.rateView addGestureRecognizer:tap];
}

- (void) onTap{
    if (_rateView.rateNo>0) return; // already pick
    CGPoint tapPoint = [tap locationInView:_rateView];
    float starSize = MIN(_rateView.frame.size.width/5, _rateView.frame.size.height);
    int position = (int) tapPoint.x/starSize + 1 ;
    _rateView.rateNo = position;
    [_rateView setStarsView];
    [self pushRatetoServe];
    [self performSelector:@selector(gotoShareService) withObject:nil afterDelay:2];
}

- (void) pushRatetoServe{
    NSString *stylerId = [NSString stringWithFormat:@"%@",_stylerData[@"stylerid"]];
    NSString *stylerRate = [NSString stringWithFormat:@"%d",_rateView.rateNo];
    NSString *urlString =[NSString stringWithFormat:@"http://styler.theammobile.com/stylist/UPDATE_STYLIST_INFORMATION_SERVICES_RATE.php?idstylist=%@&rate=%@",stylerId,stylerRate];
    
    NSLog(@"urlstring: %@",urlString);
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]init];
    request.URL = [NSURL URLWithString:urlString];
    request.HTTPMethod = @"Get";
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:^(NSData*data, NSURLResponse*respond, NSError*error){
        NSError*error2;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error2];
        NSLog(@"json: %@",json);
    }]resume];
    
}

- (void) gotoShareService{
    ShareService *shareService = [self.storyboard instantiateViewControllerWithIdentifier:@"shareservice"];
    shareService.rateNo = _rateView.rateNo;
    [self.navigationController pushViewController:shareService animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self.rateView setStarsView];
    
}
- (float) priceCounting{
    float totalPrice =0;
    NSString *keyPrice = [NSString stringWithFormat:@"price_%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"serviceType"]];
    
    for (int i=0; i<servicesPicking.count; i++){
        NSDictionary *service = servicesPicking[i];
        totalPrice+= [service[keyPrice] floatValue];
    }
    
    return totalPrice;
}
- (void) getUser{

    _imgViewAvatar.layer.cornerRadius = 30;
    _imgViewAvatar.layer.masksToBounds = YES;
    
    NSString *imgUrl = _stylerData[@"image"];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
    _imgViewAvatar.image = [UIImage imageWithData:data];
    _nameLabel.text = _stylerData[@"fullname"];
    
    float totalPrice = [self priceCounting];
     _priceLabel.text = [NSString stringWithFormat:@"Price: %2.1f$",totalPrice];
}

- (void) getServices{
    NSString *serviceTextView = [NSString new];
    for (int i=0;i< servicesPicking.count; i++){
        NSString *service = servicesPicking[i][@"name"];
        serviceTextView = [serviceTextView stringByAppendingString:[NSString stringWithFormat:@"%@\n",service]];
    }
    
    _servicesTextView.text = serviceTextView;
    _servicesTextView.editable = NO;
}

- (void) getTime{
    NSLocale *locale = [NSLocale currentLocale];
    NSString *dateString = [[NSDate date]descriptionWithLocale:locale];
    
    NSArray *dateArray = [dateString componentsSeparatedByString:@" at"];
    _dateLabel.text = dateArray[0];
    
    
}


@end
