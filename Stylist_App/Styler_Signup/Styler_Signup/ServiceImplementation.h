//
//  ServiceImplementation.h
//  Styler_Signup
//
//  Created by Apple on 3/12/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Firebase/Firebase.h>

@interface ServiceImplementation : UIViewController <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic , strong) NSMutableDictionary*stylerData;
@property (nonatomic, strong)NSString *roomName;

@property (weak, nonatomic) IBOutlet UIImageView *timeBg;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBt;
@end
