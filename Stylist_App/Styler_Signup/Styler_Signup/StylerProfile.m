//
//  StylerProfile.m
//  Styler_Signup
//
//  Created by Apple on 3/12/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "StylerProfile.h"

@implementation StylerProfile
@synthesize stylerData;
-(void)viewDidLoad{
    [super viewDidLoad];
    
    NSString *imgUrl = stylerData[@"image"];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
    UIImage *photo = [UIImage imageWithData:data];
    
    _avatarImg.image = photo;
    _nameLabel.text = stylerData[@"fullname"];
    
    int rateNo = [stylerData[@"rate"] intValue];
    float width = _rateView.frame.size.width;
    float height = _rateView.frame.size.height;
    float starSize = MIN(height, width/5);
    
    for (int i=0; i<5; i++){
        UIImageView *starView = [[UIImageView alloc]initWithFrame:CGRectMake(i*starSize, (height-starSize)/2, starSize, starSize)];
        if (i<rateNo){
            starView.image = [UIImage imageNamed:@"star.png"];
        }else {
            starView.image = [UIImage imageNamed:@"starno.png"];
        }
        [_rateView addSubview:starView];
    }
    
    _stylerTextView.text = @"I am a styler";
    _stylerTextView.editable = NO;

}

- (IBAction)callButton:(id)sender {
    NSString *phoneNo = @"0968856480";
    NSString *phoneString = [[NSString alloc]initWithFormat:@"tel:%@",phoneNo];
    NSURL *phoneUrl = [[NSURL alloc] initWithString:phoneString];
    [[UIApplication sharedApplication]openURL:phoneUrl];
    
}

@end
