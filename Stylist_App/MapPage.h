//
//  MapPage.h
//  Stylist_App
//
//  Created by Apple on 4/21/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "RateView.h"
#import <Firebase/Firebase.h>

@interface MapPage : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UIImageView *stylerImage;
@property (weak, nonatomic) IBOutlet UILabel *stylerNameLabel;
@property (weak, nonatomic) IBOutlet RateView *rateView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBt;

@end
