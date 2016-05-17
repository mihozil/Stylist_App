//
//  GetRequest.m
//  Stylist_App
//
//  Created by Apple on 4/21/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "GetRequest.h"
#import "RoomSingleton.h"
#import <Firebase/Firebase.h>
#import "ServiceImplementation.h"
#import "ShowAlertView.h"
#import "ShowActivityIndicatorView.h"
#import "ServiceInfo.h"
#import "IOSRequest.h"
#import "GoOnline.h"

@interface GetRequest ()

@end

@implementation GetRequest{
    NSTimer *timer;
    int timeCount;
    Firebase *roomRef;
    NSDictionary *roomDic;
    CLLocationCoordinate2D userLocation;
    UIActivityIndicatorView *activityIndicator;
    NSArray *customerServices;
    NSString *priceName;
    NSMutableDictionary *customerData;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    customerData = [NSMutableDictionary new];
    
    _tableVIew.backgroundColor = [UIColor clearColor];
    _tableVIew.separatorStyle = UITableViewCellSeparatorStyleNone;
    roomRef = [[RoomSingleton shareSingleton]roomRef];
    _mapView.showsUserLocation = YES;
    activityIndicator = [UIActivityIndicatorView new];
    self.navigationController.navigationBarHidden = YES;
    [self createTimer];
    [self setMap];
}

- (void) setMap{
    [roomRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot*snapShot){
        roomDic = snapShot.value;
        float lat = [roomDic[@"status"][@"gps_lat2"] floatValue];
        float log = [roomDic[@"status"][@"gps_long2"] floatValue];
        NSString *services = roomDic[@"services_customer"];
        [self getServicesCustomer:services];
        [self getClientInfo:roomDic[@"idcustomer"]];
        userLocation = CLLocationCoordinate2DMake(lat, log);
        [self reCenterMap];
    }];
}
- (void) getClientInfo:(NSString*)idcustomer{
    // update client info here
    NSString *urlString = [NSString stringWithFormat:@"http://styler.theammobile.com/GET_CUSTOMER_INFORMATION_BASIC.php?idcustomer=%@",idcustomer];
    [IOSRequest requestPath:urlString onCompletion:^(NSError*error, NSDictionary*json){
        NSString *customerName = [NSString stringWithFormat:@"%@ %@",json[@"firstname"],json[@"lastname"]];
        [customerData setObject:customerName forKey:@"name"];
        [customerData setObject:json[@"phonenumber"] forKey:@"phonenumber"];
        // and add image
        
        // must remember to reopen this
//        [[NSUserDefaults standardUserDefaults]setObject:customerData forKey:@"customerData"];
    }];
}

- (void) getServicesCustomer:(NSString*)services{
    customerServices = [ServiceInfo getServicesList:services];
    priceName = [ServiceInfo getPriceName:services];
    
    [customerData setObject:customerServices forKey:@"customerServices"];
    [customerData setObject:priceName forKey:@"priceName"];
    
    [_tableVIew reloadData];
    float totalPrice=0;
    for (int i=0; i<customerServices.count; i++){
        totalPrice +=[customerServices[i][priceName] intValue];
    }
    _totalPriceLabel.text = [NSString stringWithFormat:@"%2.2f $",totalPrice];
    
}
- (void) reCenterMap{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation, 2000, 2000);
    [_mapView setRegion:region];
    [_mapView setMapType:MKMapTypeStandard];
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
    annotation.coordinate = userLocation;
    annotation.title = @"Service Place";
    [_mapView addAnnotation:annotation];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    MKAnnotationView *annView = nil;
    if (annotation!= mapView.userLocation){
        annView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"AnnotationView"];
        if (!annView){
            annView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"AnnotationView"];
        }
        annView.canShowCallout = YES;
        UIImage *photo = [self imageWithImage:[UIImage imageNamed:@"customerwait.png"] converttoSize:CGSizeMake(60, 60)];
        annView.image = photo;
    }
    return annView;
}

- (UIImage*) imageWithImage:(UIImage*)beginImage converttoSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [beginImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *desImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return desImage;
}

- (void) createTimer{
    NSNumber *timeRemain = [[NSUserDefaults standardUserDefaults]objectForKey:@"timeCount"];
    timeCount = [timeRemain intValue];
    _timeLabel.text = @"Time:\n30s";
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:true];
    
}
- (void) onTimer{
    timeCount-=1;
    _timeLabel.text = [NSString stringWithFormat:@"Time:\n%d",timeCount];
    if (timeCount==0){
        [timer invalidate];
//        [self.navigationController popViewControllerAnimated:YES];
        [self rejectRequest];
        [self gotoGoOnline];
    }
    
}
- (IBAction)acceptBt:(id)sender {
    [timer invalidate];
    [ShowActivityIndicatorView startActivityIndicator:activityIndicator inView:self.view];
    activityIndicator.frame = CGRectMake(0, 0, 80, 80);
    activityIndicator.center = CGPointMake(self.view.center.x, self.view.center.y-100);
    
    NSDictionary *status1=@{@"status1":@"accept"};
    [[roomRef childByAppendingPath:@"status"]updateChildValues:status1];
    [self updateClientRespond];
    
}
- (void) updateClientRespond{
    [[roomRef childByAppendingPath:@"status"]observeSingleEventOfType:FEventTypeChildChanged withBlock:^(FDataSnapshot*snapShot){
        // take care if snapshot.value not belong to NSString
        NSString *status1 = snapShot.value;
        if ([status1 isEqualToString:@"doing"]){
            [self gotoServiceImplementation];
            [ShowActivityIndicatorView stopActivityIndicator:activityIndicator];
            
        }else if ([status1 isEqualToString:@"open"]){
            [self clientReject];
            [ShowActivityIndicatorView stopActivityIndicator:activityIndicator];
        }
    }];
}

- (void) gotoServiceImplementation{
    ServiceImplementation *serviceImplementation = [self.storyboard instantiateViewControllerWithIdentifier:@"serviceimplementation"];
    serviceImplementation.navigationItem.hidesBackButton = YES;
    
    [self.navigationController pushViewController:serviceImplementation animated:YES];
}

- (void) clientReject{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Client Reject" message:@"Go back" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action){
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)declineBt:(id)sender {
    [timer invalidate];
    [self rejectRequest];
    [self gotoGoOnline];
    
}
- (void) gotoGoOnline{
    for (UIViewController *viewController in self.navigationController.viewControllers ){
        if ([viewController isKindOfClass:[GoOnline class]]){
            [self.navigationController popToViewController:viewController animated:YES];
            break;
        }
    };
}
- (void) rejectRequest{
    NSDictionary *status1 = @{@"status1":@"reject"};
    double timeStamp = [[NSDate date]timeIntervalSince1970];
    NSString *timeStampString = [NSString stringWithFormat:@"%2.2f",timeStamp];
    [[NSUserDefaults standardUserDefaults]setObject:timeStampString forKey:@"timeReject"];
    [[roomRef childByAppendingPath:@"status"]updateChildValues:status1];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return customerServices.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = (UITableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = customerServices[indexPath.row][@"name"];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@$ ",customerServices[indexPath.row][priceName]];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

@end
