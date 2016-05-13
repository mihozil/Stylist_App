//
//  ServiceRequest.h
//  Styler_Signup
//
//  Created by Apple on 3/5/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SWRevealViewController.h"

#import "SPGooglePlacesAutocompletePlace.h"
#import "SPGooglePlacesAutocompleteQuery.h"
#import "SPGooglePlacesAutocompleteUtilities.h"
#import "SPGooglePlacesPlaceDetailQuery.h"


@interface ServiceRequest : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)NSString *placeService;


@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic , strong) NSMutableArray *arrayData;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedServiceLevel;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBarBt;


@end
