//
//  stylerVC.h
//  Styler_Signup
//
//  Created by Apple on 3/12/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/Corelocation.h>
#import <Firebase/Firebase.h>

@interface stylerVC : UIViewController 

@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *stylerInfo;
@property (weak, nonatomic) IBOutlet UIView *rateView;

@property (nonatomic, strong) NSMutableDictionary *stylerData;
@property (nonatomic, assign) CLLocationCoordinate2D locationGPS;
@end
