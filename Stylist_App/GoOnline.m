//
//  GoOnline.m
//  Stylist_App
//
//  Created by Apple on 4/21/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "GoOnline.h"
#import <Firebase/Firebase.h>
#import "MapPage.h"
#import "ShowActivityIndicatorView.h"
#import "RoomSingleton.h"
#import "SWRevealViewController.h"
#import "ShowAlertView.h"


@interface GoOnline ()

@end

@implementation GoOnline{
    Firebase *ref;
    Firebase *roomRef;
    CLLocationCoordinate2D stylerPosition;
    CLLocationManager *locationManager;
    UIActivityIndicatorView *activityIndicatorView;
    NSDictionary *roomStatus;
}

- (void) initProject{
    ref = [[Firebase alloc]initWithUrl:@"https://stylerapplication.firebaseio.com"];
    stylerPosition = CLLocationCoordinate2DMake(0, 0);
    
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
        [locationManager requestWhenInUseAuthorization];
    }
    activityIndicatorView = [[UIActivityIndicatorView alloc]init];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initProject];
    [self initMenuBt];
    
}
- (void) initMenuBt{
    SWRevealViewController *revealVC = self.revealViewController;
    if (revealVC){
        [_menuBt setTarget:self.revealViewController];
        [_menuBt setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    }
    
}
- (void)viewWillAppear:(BOOL)animated{
    [locationManager startUpdatingLocation];
    _statusLabel.text = @"Offline";
//    if (roomRef){
//        [roomRef removeValue];
//        roomRef = nil;
//    }
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [locationManager stopUpdatingLocation];
    [[RoomSingleton shareSingleton]setRoomRef:roomRef];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocationCoordinate2D newCoordinate = [locations lastObject].coordinate;
    if ((stylerPosition.latitude!=newCoordinate.latitude) || (stylerPosition.longitude!=newCoordinate.longitude)){
            stylerPosition = newCoordinate;
            [self updateStylistStatus];
    }
    
}

- (void) updateStylistStatus{
    
    NSString *latStr = [NSString stringWithFormat:@"%f",stylerPosition.latitude];
    NSString *logStr = [NSString stringWithFormat:@"%f",stylerPosition.longitude];
    roomStatus = @{@"gps_lat1":latStr,@"gps_long1":logStr,@"status1":@"open"};

}


- (IBAction)onGoOnlineBt:(id)sender {
    if (![self checkOnlineValid]) return;
    _statusLabel.text = @"Accessing";
    [ShowActivityIndicatorView startActivityIndicator:activityIndicatorView inView:self.view];
    [self CreateNewStylerRoom];
    
}
- (BOOL) checkOnlineValid{
    NSString *timeStampString = [[NSUserDefaults standardUserDefaults]objectForKey:@"timeReject"];
    if (!timeStampString) return YES;
    
    double currentTimeStamp = [[NSDate date]timeIntervalSince1970];
    double previousTimeStamp = [timeStampString doubleValue];
    if (currentTimeStamp>previousTimeStamp+600) return YES;
    else {
        [ShowAlertView showAlertwithTitle:@"Go online invalid" andMessenge:@"You must wait till 10 minutes end" inViewController:self];
        return NO;
    }
}
- (void) CreateNewStylerRoom{
    NSDictionary *stylerData = [[NSUserDefaults standardUserDefaults]objectForKey:@"stylerData"];
    
    // create stylistid
       roomRef = [ref childByAutoId];
    
    NSDictionary *room = @{@"idstylist":stylerData[@"idstylist"],@"services_stylist":stylerData[@"services"],@"rate":stylerData[@"rate"],@"status":roomStatus};
    
    __weak typeof(self) weakSelf =self;
    [roomRef setValue:room withCompletionBlock:^(NSError*error, Firebase*ref){
        [weakSelf gotoMapPage];
    }];
}
- (void) gotoMapPage{
    MapPage *mapPage = [self.storyboard instantiateViewControllerWithIdentifier:@"mappage"];
    [self.navigationController pushViewController:mapPage animated:YES];
    [ShowActivityIndicatorView stopActivityIndicator:activityIndicatorView];
}


@end
