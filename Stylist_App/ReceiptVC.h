//
//  ReceiptVC.h
//  Stylist_App
//
//  Created by Apple on 4/23/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"

@interface ReceiptVC : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *clientImage;
@property (weak, nonatomic) IBOutlet UITextView *serviceTextView;
@property (weak, nonatomic) IBOutlet UILabel *clientNameLabel;
@property (weak, nonatomic) IBOutlet RateView *rateView;

@end
