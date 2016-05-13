//
//  Receipt.h
//  Styler_Signup
//
//  Created by Apple on 3/13/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"

@interface Receipt : UIViewController<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewAvatar;
@property (weak, nonatomic) IBOutlet UITextView *servicesTextView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic, strong) NSDictionary *stylerData;

@property (strong, nonatomic) IBOutlet RateView *rateView;


@end
