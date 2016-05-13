//
//  ServiceImplementation.m
//  Styler_Signup
//
//  Created by Apple on 3/12/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "ServiceImplementation.h"
#import "ServiceRequest.h"
#import "StylerProfile.h"
#import "Receipt.h"
#import "RateView.h"
#import <QuartzCore/QuartzCore.h>
#import "SWRevealViewController.h"
#import "ServiceRequest.h"
#import "ShowAlertController.h"

@implementation ServiceImplementation{
    NSTimer *timer;
    int remainingTime;
    Firebase*ref;
    Firebase *roomRef;
    Firebase *status1Ref;
    CLLocationCoordinate2D locationGPS;
    
    NSString *status1;
    
    
}
@synthesize timeLabel;
- (void) getUserLocation{
    NSDictionary *coordinate = [[NSUserDefaults standardUserDefaults]objectForKey:@"positionCoordinate"];
    locationGPS.latitude = [coordinate[@"lat"] floatValue];
    locationGPS.longitude = [coordinate[@"log"] floatValue];
}
- (void) updateStatus1{
    ref = [[Firebase alloc]initWithUrl:@"https://fiery-inferno-2444.firebaseio.com"];
    roomRef = [ref childByAppendingPath:_roomName];
    status1Ref = [roomRef childByAppendingPath:@"status/status1"];
    [status1Ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot*snapShot){
        status1 = snapShot.value;
        if ([status1 isEqualToString:@"close"]){
            [self gotoReceipt];
            [status1Ref removeAllObservers];
        }
    }];
    
}
- (void) gotoReceipt{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Service completed" message:@"Go to Receipt" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action){
        Receipt *receipt = [self.storyboard instantiateViewControllerWithIdentifier:@"receipt"];
        receipt.stylerData = _stylerData;
        receipt.navigationItem.hidesBackButton = YES;
        
        [self.navigationController pushViewController:receipt animated:YES];
    }];
    [alertController addAction:alertAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (void) initMenu{
    SWRevealViewController *revealVC = self.revealViewController;
    if (revealVC){
        [_menuBt setTarget:self.revealViewController];
        [_menuBt setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    }
}
- (void)viewDidLoad{
    [super viewDidLoad];
    [self initMenu];
    [self updateStatus1];
    [self getUserLocation];
    [self createMapView];
    _timeBg.image = [UIImage imageNamed:@"circle.png"];
    
    timeLabel.text = [NSString stringWithFormat:@"5m\nfor\nFree Cancel"];
    remainingTime = 20;
    
    [self createLabel];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
}

- (void) createMapView{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(locationGPS, 2000, 2000);
    [_mapView setRegion:region];
    [_mapView setMapType:MKMapTypeStandard];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
    
    annotation.coordinate = locationGPS;
    annotation.title = @"Service Location";
    [_mapView addAnnotation:annotation];
    
    [self stylerLocation];
}

- (void) stylerLocation{

    [ref observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot*snapShot){
        NSDictionary *child = snapShot.value;
        NSString *idroom = [NSString stringWithFormat:@"%@",_stylerData[@"stylerid"]];
        NSString *idchild = [NSString stringWithFormat:@"%@",child[@"idstylist"]];
        
        NSLog(@"idroom - id child: %@ - %@",idroom, idchild);
        if ([ idroom isEqualToString: idchild]){
            roomRef = snapShot.ref;
            [self stylerPosition];
            [self updateStylerGPS];
            [ref removeAllObservers];
        }
    }];
    
}

- (void) stylerPosition{

    [roomRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot*snapShot){
        NSDictionary *room = snapShot.value;
        NSDictionary *status = room[@"status"];
        [self createStylerAnnotation:status];
    }];
    
    
}
- (void) createStylerAnnotation:(NSDictionary*)status{
    float lat = [status[@"gps_lat1"]  floatValue] ;
    float log = [status[@"gps_log1"] floatValue];
    NSLog(@"add styler to map");
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
    annotation.coordinate = CLLocationCoordinate2DMake(lat, log);
    annotation.title = @"Styler Moving";
    [_mapView addAnnotation:annotation];
}

- (void) updateStylerGPS{
    [roomRef observeEventType:FEventTypeChildChanged withBlock:^(FDataSnapshot*snapShot){
        NSDictionary *newStatus = snapShot.value;
        float lat = [newStatus[@"gps_lat1"] floatValue];
        float log = [newStatus[@"gps_log1"] floatValue];
        
        for (int i=0; i<_mapView.annotations.count; i++){
            MKPointAnnotation *annotation = _mapView.annotations[i];
            if ([annotation.title isEqualToString:@"Styler Moving"]){
                annotation.coordinate = CLLocationCoordinate2DMake(lat, log);
                break;
            }
        }
    }];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    MKAnnotationView *annView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"AnnotationViewCell"];
    if (annView ==nil){
        annView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"AnnotationViewCell"];
    }
    CLLocationCoordinate2D coordinate = [annotation coordinate];
    
    UIImage *img;
    if ((coordinate.latitude = locationGPS.latitude)&& (coordinate.longitude == locationGPS.longitude)){
        
        img = [UIImage imageNamed:@"userwaiting.png"];
        NSLog(@"user");
    }else {
        img = [UIImage imageNamed:@"car.png"];
        NSLog(@"styler");
    }
                        
    img = [self imageWithImage:img converttoSize:CGSizeMake(45, 45)];
    annView.image = img;
    annView.canShowCallout = YES;
    
    
    return annView;
}

- (UIImage*) imageWithImage:(UIImage*)beginImage converttoSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [beginImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *desImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return desImage;
}


- (void) createLabel{
    self.timeLabel.layer.cornerRadius = self.timeLabel.frame.size.width/2;
    self.timeLabel.layer.masksToBounds = YES;
    
    
}

- (void) onTimer{
    remainingTime-=1;
    int min = (int)remainingTime/60;
    int second = remainingTime%60;
    timeLabel.text = [NSString stringWithFormat:@"%dm:%ds\nfor\nFree Cancel",min,second];
    if (remainingTime ==0 ) {
        NSLog(@"Timer invalidate");
     [timer invalidate];
        [self.timeLabel removeFromSuperview];
        _timeBg.image = nil;
        
    }
    
                 
}
- (void) alertTimeOut{
    UIAlertController*alertController = [UIAlertController alertControllerWithTitle:@"Cancel invalid" message:@"You will be charged 10$ for cancelling the service now" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction*alertAction = [UIAlertAction actionWithTitle:@"Cancel Service" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action){
        SWRevealViewController *swRevealVC = [self.storyboard instantiateViewControllerWithIdentifier:@"swrevealvc"];
        [self.navigationController pushViewController:swRevealVC animated:YES];
        self.navigationItem.hidesBackButton = YES;
    }];
    [alertController addAction:alertAction];
    
    UIAlertAction *alertNotCancel = [UIAlertAction actionWithTitle:@"Don't Cancel" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:alertNotCancel];
    
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
    
}

- (void) alreadyBeginService{
    [ShowAlertController showAlertwithAlertTitle:@"Cancel invalid" andMessenge:@"The service had been started" inVC:self];
    
}

- (IBAction)cancelBt:(id)sender {
    
    // if styler press begin
    if ([status1 isEqualToString:@"begin"]){
        [self alreadyBeginService];return;
    }
    if ([status1 isEqualToString:@"close"]){
        return;
    }
    
    // if styler press end
    
    if (remainingTime ==0){
        [self alertTimeOut];
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Cancel Service" message:@"Do you want to cancel Your Serivce" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action){
            NSArray *viewControllers = [self.navigationController viewControllers];
            for (int i=0; i<viewControllers.count; i++){
                id obj = [viewControllers objectAtIndex:i];
                if ([obj isKindOfClass:[ServiceRequest class]]){
                    [self.navigationController popToViewController:obj animated:YES];
                }
            }
            
        }];
        [alertController addAction:alertAction];
        
        UIAlertAction *alertNoAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:alertNoAction];
    
    
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (IBAction)contactBt:(id)sender {
    StylerProfile *stylerProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"stylerprofile"];
    stylerProfile.stylerData = _stylerData;
    [self.navigationController pushViewController:stylerProfile animated:YES];
    
}


//- (IBAction)homeButton:(id)sender {
    
  //  ServiceRequest *serviceRequest = [self.storyboard instantiateViewControllerWithIdentifier:@"servicerequest"];serviceRequest.navigationItem.hidesBackButton = YES;
   // [self.navigationController pushViewController:serviceRequest animated:YES];
//    NSString *implementing =@"implementing";
//    [[NSUserDefaults standardUserDefaults]setObject:implementing forKey:@"implementing"];

//    UINavigationController *nav = self.navigationController;


    
//}

@end
