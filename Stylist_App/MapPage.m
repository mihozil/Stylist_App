//
//  MapPage.m
//  Stylist_App
//
//  Created by Apple on 4/21/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "MapPage.h"
#import "RoomSingleton.h"
#import "GetRequest.h"
#import "UIAlertController+Window.h"
#import "ServiceImplementation.h"
#import <AudioToolbox/AudioServices.h>
#import "SWRevealViewController.h"


// incase of just reject

@interface MapPage ()

@end

@implementation MapPage{
    CLLocationCoordinate2D stylerPostition;
    CLLocationManager *locationManager;
    NSDictionary *stylerData;
    Firebase *roomRef;
    
    NSTimer *timer;
    int timeCout;
    
}
- (void) initProject{
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager requestAlwaysAuthorization];
    
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    
    SWRevealViewController *revealVC = self.revealViewController;
    if (revealVC){
        [_menuBt setTarget:self.revealViewController];
        [_menuBt setAction:@selector(revealToggle:)];
         [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initProject];
    [self getStylerData];
    
}
- (void) updateRequest{
    roomRef = [[RoomSingleton shareSingleton]roomRef];
    
    [roomRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot*snapShot){
        if (snapShot.value!=[NSNull null]){
            NSDictionary *dic = snapShot.value;
                if ([dic[@"status"][@"status1"] isEqualToString:@"waiting"]){
                    [self customerRequest];
                    [roomRef removeAllObservers];
                    
                    NSLog(@"it didcome");
            }
        }
    }];
}
- (void) customerRequest{
//    [self gotoGetRequest];
    UILocalNotification *localNotification = [[UILocalNotification alloc]init];
    localNotification.alertBody = @"New Request: You have 30 seconds to get the request";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.fireDate = [NSDate date];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication]scheduleLocalNotification:localNotification];
    
    [self createTimer];
}
- (void) createTimer{
    timeCout = 30;
       timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:true];
    
}
- (void) onTimer{
    [[NSUserDefaults standardUserDefaults]setObject:@(timeCout) forKey:@"timeCount"];
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive){
        [self gotoGetRequest];
        [timer invalidate];
    }else{
        timeCout -=1;
        if (timeCout == 0){
            [timer invalidate];
            [self rejectRequest];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}
- (void) rejectRequest{
    NSDictionary *status1 = @{@"status1":@"reject"};
    double timeStamp = [[NSDate date]timeIntervalSince1970];
    NSString *timeStampString = [NSString stringWithFormat:@"%2.2f",timeStamp];
    [[NSUserDefaults standardUserDefaults]setObject:timeStampString forKey:@"timeReject"];
    [[roomRef childByAppendingPath:@"status"]updateChildValues:status1];
}

- (void) gotoGetRequest{
    GetRequest *getRequest = [self.storyboard instantiateViewControllerWithIdentifier:@"getrequest"];
    [self.navigationController pushViewController:getRequest animated:YES];
}

- (void) getStylerData{
    stylerData = [[NSUserDefaults standardUserDefaults]objectForKey:@"stylerData"];
    _stylerNameLabel.text = stylerData[@"name"];
    int rateNo = [stylerData[@"rate"] intValue];
    [_rateView updateRating:rateNo];
    
    _stylerImage.image = [UIImage imageWithData:stylerData[@"img"]];
}

- (void)viewWillAppear:(BOOL)animated{
    [locationManager startUpdatingLocation];
    stylerPostition = CLLocationCoordinate2DMake(0, 0);
    [self updateRequest];
}
- (void)viewWillDisappear:(BOOL)animated{
    [locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocationCoordinate2D coordinate = [locations lastObject].coordinate;
    
    if ((stylerPostition.latitude==0) && (stylerPostition.longitude ==0)){
        stylerPostition = coordinate;
        [self reCenterMapView];
    }
}

- (void) reCenterMapView{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(stylerPostition, 2000, 2000);
    [self.mapView setRegion:region];
    _mapView.mapType = MKMapTypeStandard;
}

- (IBAction)onGoOfflineBt:(id)sender {
    [roomRef removeAllObservers];
    [roomRef removeValue];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
