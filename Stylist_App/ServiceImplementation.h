//
//  ServiceImplementation.h
//  Stylist_App
//
//  Created by Apple on 4/21/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ServiceImplementation : UIViewController<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *arrivingStatus;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBt;

@end
