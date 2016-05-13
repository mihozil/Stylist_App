//
//  ServicePicking.h
//  Styler_Signup
//
//  Created by Apple on 3/10/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ServicePicking : UIViewController<UIScrollViewDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property int serviceLevel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *nextView;

@end
