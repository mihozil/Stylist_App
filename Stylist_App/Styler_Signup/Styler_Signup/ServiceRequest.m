//
//  ServiceRequest.m
//  Styler_Signup
//
//  Created by Apple on 3/5/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "ServiceRequest.h"
#import "ServicePicking.h"
#import <Firebase/Firebase.h>
#import "ServiceImplementation.h"
#import "ShowAlertController.h"
#import "CreateLink.h"


@implementation ServiceRequest{
    CLLocationManager *locationManager;
    CLLocationCoordinate2D positionCoordinate;

    NSMutableArray *tableData;
    Firebase *ref;
    
    NSDictionary *userData;
    SPGooglePlacesAutocompleteQuery *query;
    MKPointAnnotation *selectedAnnotation;
    

}

- (void) initPrj{    
    
    NSDictionary *dic = @{@"email":@"minhnht05.sic@gmail.com", @"type":@"facebook"};
    
    NSString *link = [CreateLink linkwithUrl:@"http://styler.theammobile.com/CREATE_NEW_ACCOUNT_CUSTOMER_FACEBOOK.php?" andParameters:dic];

    positionCoordinate = CLLocationCoordinate2DMake(0, 0);

    
    SWRevealViewController *swRevealVC = self.revealViewController;
    if (swRevealVC){
        
        [self.menuBarBt setTarget:self.revealViewController];
        [self.menuBarBt setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    }

    userData = [[NSUserDefaults standardUserDefaults]objectForKey:@"userData"];
    
    query = [[SPGooglePlacesAutocompleteQuery alloc]init];
    query.radius = 100.0;
    
    self.searchDisplayController.searchBar.placeholder = @"Choose service Location";
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableData.count;
}


- (SPGooglePlacesAutocompletePlace *)placeAtIndexPath:(NSIndexPath *)indexPath {
    return [tableData objectAtIndex:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = [self placeAtIndexPath:indexPath].name;
    
    return cell;
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([searchText isEqualToString:@""]){
        return;
    }
    
    query.input = searchText;
    query.location = _mapView.userLocation.coordinate;
    [query fetchPlaces:^(NSArray *places, NSError*error){
        if (error) {
            SPPresentAlertViewWithErrorAndTitle(error, @"Could not fetch place");
        }else {
            tableData = [NSMutableArray arrayWithArray:places];
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
    }];
    
}

- (void) updateServiceLocation:(NSString*)searchText{
    //remove
    [self.mapView removeAnnotation:selectedAnnotation];
    selectedAnnotation = nil;
    
    MKPointAnnotation *addAnnotation = [[MKPointAnnotation alloc]init];
    addAnnotation.coordinate = positionCoordinate;
    addAnnotation.title = searchText;
    [self.mapView addAnnotation:addAnnotation];
    
    selectedAnnotation = addAnnotation;
    
    self.searchDisplayController.searchBar.placeholder = searchText;
    NSLog(@"come here");
    
}

- (void) dismissViewControllerWhileStayingActive{
    [self.searchDisplayController setActive:NO animated:YES];
}
- (void) recenterMap{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(positionCoordinate, 2000, 2000);
    [_mapView setRegion:region];
    [self availableStylersFinding];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *searchText = [self placeAtIndexPath:indexPath].name;
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    [geoCoder geocodeAddressString:searchText completionHandler:^(NSArray*placeMarks, NSError*error){
        CLPlacemark *placeMark  = [placeMarks lastObject];
        
        
        // recenter map
        positionCoordinate = placeMark.location.coordinate;
        [self recenterMap];
        
        [self updateServiceLocation:searchText];
        
        
        // muse update later then update place service
        
        [locationManager stopUpdatingLocation];
        _placeService = searchText;
        [self dismissViewControllerWhileStayingActive];
        [self.searchDisplayController.searchResultsTableView deselectRowAtIndexPath:indexPath animated:NO];
        [self updateServiceLocation:searchText];
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self initPrj];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    [_mapView setMapType:MKMapTypeStandard];
    
    // get user's current location
        locationManager = [CLLocationManager new];
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager requestWhenInUseAuthorization];
    
    [self availableStylersFinding];
    
    //set map region
}
-(void)viewWillAppear:(BOOL)animated{
        [locationManager startUpdatingLocation];
    if ((positionCoordinate.latitude!=0) || (positionCoordinate.longitude!=0)){
        [self availableStylersFinding];
    }
}



- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *searchText = searchBar.text;
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    [geoCoder geocodeAddressString:searchText completionHandler:^(NSArray*placeMarks, NSError*error){
        if (error){
            [searchBar resignFirstResponder];
            [ShowAlertController showAlertwithAlertTitle:@"Error" andMessenge:[NSString stringWithFormat:@"%@",error.description] inVC:self];
            return;
        }
        
        [locationManager stopUpdatingLocation];
        
        CLPlacemark *placeMark = [placeMarks lastObject];
        positionCoordinate = placeMark.location.coordinate;
        _placeService = searchText;
        
        [self recenterMap];
        [self dismissViewControllerWhileStayingActive];
        [self updateServiceLocation:searchText];
        
    }];
    
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    if ((positionCoordinate.latitude != 0) ||
        (positionCoordinate.longitude!= 0)) return;
    
    // current position
    
    
    CLLocation *userLocate = [locations lastObject];
    positionCoordinate = userLocate.coordinate;
    
    [self recenterMap];
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    [geoCoder reverseGeocodeLocation:userLocate completionHandler:^(NSArray*placeMarks, NSError*error){
        CLPlacemark *placeMark = [placeMarks lastObject];
        _placeService = placeMark.name;
        self.searchDisplayController.searchBar.placeholder= _placeService;
        
    }];
}
- (BOOL) checkNearbyLocationwithCoordinate:(CLLocationCoordinate2D)coordinate{
    CLLocation *userLocation = [[CLLocation alloc]initWithLatitude:positionCoordinate.latitude longitude:positionCoordinate.longitude];
    CLLocation *stylerPosition = [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    float distance = [userLocation distanceFromLocation:stylerPosition];
    if (distance<3000) {
        return YES;
    }
    
    return NO;
}
- (void) availableStylersFinding{
    [_mapView removeAnnotations:_mapView.annotations];
    // add styler to map
    ref = [[Firebase alloc]initWithUrl:@"https://fiery-inferno-2444.firebaseio.com/"];
    [ref observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot*snapShot){
        
        NSDictionary *room = snapShot.value;
        float lat = [room[@"status"][@"gps_lat1"] floatValue];
        float log = [room[@"status"][@"gps_log1"] floatValue];
        NSString *status1 = room[@"status"][@"status1"];
        NSString *idstyler = [NSString stringWithFormat:@"%@",room[@"idstylist"]];
        
        
        if ([status1 isEqualToString:@"open"]){
            if ([self checkNearbyLocationwithCoordinate:CLLocationCoordinate2DMake(lat, log)]){
                // make change of this
                [self addStylertoMapwithCoordinate:CLLocationCoordinate2DMake(lat, log) andID:idstyler];
            }
        }
    }];
    // update
    [ref observeEventType:FEventTypeChildChanged withBlock:^(FDataSnapshot*snapShot){
        Firebase *roomRef = snapShot.ref;
        [roomRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot*snapShot){
            NSDictionary *room = snapShot.value;
            float lat = [room[@"status"][@"gps_lat1"] floatValue];
            float log = [room[@"status"][@"gps_log1"] floatValue];
            NSString *status1 = room[@"status"][@"status1"];
            NSString *idstyler = [NSString stringWithFormat:@"%@",room[@"idstylist"]];
            
            [self updateStylerwithID:idstyler withCoordinate:CLLocationCoordinate2DMake(lat, log) andStatus1:status1];
            
        }];
    }];
}

- (void) updateStylerwithID:(NSString*)stylerID withCoordinate:(CLLocationCoordinate2D) updatedCoordinate andStatus1:(NSString *)status1{
    
    for (int i=0; i<_mapView.annotations.count; i++){
        MKPointAnnotation *annotation = _mapView.annotations[i];
        if ([annotation.title isEqualToString:stylerID]){
            
            // if move out or not open  -> close
            if ((![status1 isEqualToString:@"open"]) || (![self checkNearbyLocationwithCoordinate:updatedCoordinate])){
                [_mapView removeAnnotation:annotation];
                return;
            }
            
            annotation.coordinate = updatedCoordinate;
            return;
        }
    }
    if (([status1 isEqualToString:@"open"]) && ([self checkNearbyLocationwithCoordinate:updatedCoordinate])){
        [self addStylertoMapwithCoordinate:updatedCoordinate andID:stylerID];
    }

}

- (void) addStylertoMapwithCoordinate:(CLLocationCoordinate2D)stylerCoordinate andID:(NSString*)stylerid{
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
    
    annotation.coordinate = stylerCoordinate;
    annotation.title = stylerid;
    [_mapView addAnnotation:annotation];
    
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    MKAnnotationView *annotationView = nil;
    
    if (annotation!=mapView.userLocation){
        annotationView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"MapViewAnnotationCell"];
        
        if (annotationView == nil){
            annotationView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"MapViewAnnotationCell"];
        }
        annotationView.canShowCallout = YES;
        
        CLLocationCoordinate2D stylerPosition  = [annotation coordinate];
        UIImage *image;
        
        if ((stylerPosition.latitude == positionCoordinate.latitude) && (stylerPosition.longitude == positionCoordinate.longitude)){
            image = [UIImage imageNamed:@"userwaiting.png"];
        }else {
            image = [UIImage imageNamed:@"styler_waiting.png"];
        }
        
        image = [self imageWithImage:image converttoSize:CGSizeMake(45, 45)];
        annotationView.image = image;
        
    }
   
    return annotationView;
}
- (UIImage*) imageWithImage:(UIImage*)beginImage converttoSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [beginImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *desImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return desImage;
}



- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [locationManager stopUpdatingLocation]; // take care of this
}


- (IBAction)onSegmentedChange:(id)sender {
//    servicePicking.serviceLevel = _segmentedServiceLevel.selectedSegmentIndex;
    NSString *title = [sender titleForSegmentAtIndex:[sender selectedSegmentIndex]];
    title = [title lowercaseString];
    title = [title stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"serviceType"];
    [[NSUserDefaults standardUserDefaults]setObject:title forKey:@"serviceType"];
    
}
- (void) showAlertView{
    UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:@"Error" message:@"You are implementing service" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:alertAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (IBAction)confirmBt:(id)sender {
    
    [locationManager stopUpdatingLocation];
    
    NSString *implementing = [[NSUserDefaults standardUserDefaults]objectForKey:@"implementing"];
    
    if ([implementing isEqualToString:@"implementing"]) {
     [self showAlertView];
        return;
    }
    
    
    [[NSUserDefaults standardUserDefaults]setObject:_placeService forKey:@"placeService"];
    NSMutableDictionary *coordinate = [NSMutableDictionary new];
    
    NSNumber *lat= @(positionCoordinate.latitude);
    NSNumber *log = @(positionCoordinate.longitude);
    [coordinate setObject:lat forKey:@"lat"];
    [coordinate setObject:log forKey:@"log"];
    
    [[NSUserDefaults standardUserDefaults]setObject:coordinate forKey:@"positionCoordinate"];
    
    ServicePicking *servicePicking = [self.storyboard instantiateViewControllerWithIdentifier:@"servicepicking"];
    [self.navigationController pushViewController:servicePicking animated:YES];
    
    
}
// just temporaty update
- (IBAction)onCurrentLocationBt:(id)sender {
    // return the first init
    [self.mapView removeAnnotation:selectedAnnotation];
    positionCoordinate = CLLocationCoordinate2DMake(0, 0);
    
    [locationManager startUpdatingLocation];

}


@end
