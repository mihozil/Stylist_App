//
//  ShareService.h
//  Styler_Signup
//
//  Created by Apple on 3/14/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "RateView.h"

@interface ShareService : UIViewController <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet RateView *rateView;
@property int rateNo;


@end
