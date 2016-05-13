//
//  GoOnline.h
//  Stylist_App
//
//  Created by Apple on 4/21/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface GoOnline : UIViewController<CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *stylerImage;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBt;

@end
