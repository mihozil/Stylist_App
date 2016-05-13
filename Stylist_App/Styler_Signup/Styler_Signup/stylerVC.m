//
//  stylerVC.m
//  Styler_Signup
//
//  Created by Apple on 3/12/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "stylerVC.h"
#import "StylerProfile.h"
#import "ServiceImplementation.h"
#import "ConfirmRequest.h"

@implementation stylerVC{
    Firebase *ref;
    Firebase *roomRef;
    Firebase *statusRef;
    Firebase *status1Ref;
    CLLocation *userLocation;
    NSDictionary *userCoordinate;
    NSString *stylerId;
    NSDictionary *status;
    NSString*roomName;
    __weak IBOutlet UIButton *acceptBt;
}

- (void) initPrj{
    NSDictionary *positionCoordinate = [[NSUserDefaults standardUserDefaults]objectForKey:@"positionCoordinate"];
    userLocation = [[CLLocation alloc]initWithLatitude:[positionCoordinate[@"lat"] floatValue]
                                                         longitude:[positionCoordinate[@"log"] floatValue]];
    
    userCoordinate = @{@"GPS_lat2":positionCoordinate[@"lat"],@"GPS_long2":positionCoordinate[@"log"]};
    acceptBt.enabled = NO;
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self initPrj];
    _avatarImgView.image = [UIImage animatedImageNamed:@"tmp-" duration:2.0f];
    // get styler Data including name; distance; time; rate
    [self methodologyFindingRoom];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap)];
    tap.numberOfTapsRequired = 1;
    tap.enabled = YES;
    [_avatarImgView addGestureRecognizer:tap];
    
}



- (void) methodologyFindingRoom{
    ref = [[Firebase alloc]initWithUrl:@"https://fiery-inferno-2444.firebaseio.com"];
    
    // find the suitable value
    
    [ref observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot*snapShot){
        
        NSDictionary *rooms = snapShot.value;
        
        // methodology to pick room
        int index = arc4random()%rooms.count;
        
        NSString *keyString = rooms.allKeys[index];
        roomName = keyString;
        
        
        NSDictionary *room = rooms[keyString];
        stylerId = room[@"idstylist"];
        [_stylerData setObject:stylerId forKey:@"stylerid"];

        // ask if styler accept
        [self askStylerAccept:keyString];

        
        
    }];
}

- (void) askStylerAccept:(NSString *)roomName{
    
    roomRef = [ref childByAppendingPath:roomName];
    statusRef = [roomRef childByAppendingPath:@"status"];
    status1Ref = [statusRef childByAppendingPath:@"status1"];
    [self addClientInfotoRoom];
    [self checkIfStylerAccept];
}

- (void) checkIfStylerAccept{
    [statusRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot*snapShot) {
        status = snapShot.value;
        if ([status[@"status1"] isEqualToString:@"accept"]) {
            [self stylerAccept];
            [statusRef removeAllObservers];
        }
        if ([status[@"status1"] isEqualToString:@"reject"]){
            [self stylerReject];
            [statusRef removeAllObservers];
        }
    }];
}
- (void) stylerReject{
    [self methodologyFindingRoom];
}

- (void) stylerAccept{
    
    [self getStylerDataBasic];
    [self getStylerDataServices];
    
}

- (void) addClientInfotoRoom{
    
    [self addClientStaticInfo];
    [self addClientDynamicInfo];
}

- (void) addClientStaticInfo{
    Firebase *idCustomerRef = [roomRef childByAppendingPath:@"idcustomer"];
    // idcustomer
    NSString *idCustomer = [[NSUserDefaults standardUserDefaults]objectForKey:@"idCustomer"];
    [idCustomerRef setValue:idCustomer];
    
    // serviceCustomer
    [self addServiceClientInfo];
}

- (void) addServiceClientInfo{
    NSArray *clientServices = [[NSUserDefaults standardUserDefaults]objectForKey:@"servicesPicking"];
    NSMutableArray *keys = [NSMutableArray new];
    for (int i=0; i<clientServices.count;i++){
        [keys addObject:[NSString stringWithFormat:@"%d",i]];
    }
    NSDictionary *servicesDic = [NSDictionary dictionaryWithObjects:clientServices forKeys:keys];
    
    Firebase *servicesCustomerRef = [roomRef childByAppendingPath:@"services_customer"];
    [servicesCustomerRef setValue:servicesDic];
    
}
- (void) addClientDynamicInfo{
    // status
    [status1Ref setValue:@"waiting"];
    
    // GPS
    [statusRef updateChildValues:userCoordinate];
    
}

- (void) getStylerDataBasic{
    _stylerData = [NSMutableDictionary new];
    NSString *urlString = [NSString stringWithFormat:@"http://styler.theammobile.com/stylist/GET_STYLIST_INFORMATION_BASIC.php?idstylist=%@",stylerId];

    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    request.URL = [NSURL URLWithString:urlString];
    request.HTTPMethod = @"Get";
    
    NSURLSession *session = [NSURLSession sharedSession];
    
        
        [[session dataTaskWithRequest:request completionHandler:^(NSData*data, NSURLResponse*respond, NSError*error){
            
            if (error){
                
                [self ErrorNotify];
                return ;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                    acceptBt.enabled = YES;
            });
            
            
            NSError *error2;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error2];
            
            NSString *name = [NSString stringWithFormat:@"%@ %@",json[@"firstname"],json[@"lastname"]];
            [_stylerData setObject:name forKey:@"fullname"];
            
            NSString *phoneNo = [NSString stringWithFormat:@"%@",json[@"phonenumber"]];
            [_stylerData setObject:phoneNo forKey:@"phonenumber"];
            
            [_stylerData setObject:json[@"gender"] forKey:@"gender"];
            
            NSString *age = [NSString stringWithFormat:@"%@",json[@"age"]];
            [_stylerData setObject:age forKey:@"age"];
            
            NSString *urlImg = [NSString stringWithFormat:@"%@",json[@"img"]];
            [_stylerData setObject:urlImg forKey:@"image"];
            
            [self updateBasicInfo];
            
        }] resume];
    
    
    
}
- (float) calculateDistance{
    
    float lat = [status[@"gps_lat1"] floatValue];
    float log = [status[@"gps_log1"] floatValue];
    
    CLLocation *stylerLocation = [[CLLocation alloc]initWithLatitude:lat longitude:log];
    
    NSDictionary *positionCoordinate = [[NSUserDefaults standardUserDefaults]objectForKey:@"positionCoordinate"];
    
    CLLocation *userLocation = [[CLLocation alloc]initWithLatitude:[positionCoordinate[@"lat"] floatValue]
                                                         longitude:[positionCoordinate[@"log"] floatValue]];
    
    CLLocationDistance distance = [userLocation distanceFromLocation: stylerLocation];
    
    return distance;
    
}

- (void) updateBasicInfo{
    NSLog(@"basic info");
    NSString *name = [[_stylerData[@"fullname"] componentsSeparatedByString:@" "] objectAtIndex:0];
    float distance = [self calculateDistance];
    NSString *time = [NSString stringWithFormat:@"%2.1f min",distance/200];
    NSString *info = [NSString stringWithFormat:@"%@\n%2.1f km\n%@",name,distance/1000,time];
    NSData *imgData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:_stylerData[@"image"]]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _stylerInfo.text = info;
        _avatarImgView.image = [UIImage imageWithData:imgData];
        
    });
    
}
- (void) ErrorNotify{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please try again" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action){
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (void) getStylerDataServices{
    
    NSString *urlString = [NSString stringWithFormat:@"http://styler.theammobile.com/stylist/GET_STYLIST_INFORMATION_SERVICES.php?idstylist=%@",stylerId];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    request.URL = [NSURL URLWithString:urlString];
    request.HTTPMethod = @"Get";
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:^(NSData*data, NSURLResponse*respond, NSError*error){
        if (error){
            [self ErrorNotify];
            return;
        }
        
        NSError*error2;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error2];
//        NSLog(@"json: %@",json);
        
        NSString *rate = [NSString stringWithFormat:@"%@",json[@"count_rate"]];
        [_stylerData setObject:rate forKey:@"rate"];
        [self updateServicesInfo];
        
    }] resume];
}

- (void) updateServicesInfo{
    // rate
    NSLog(@"service info");
    float width = _rateView.frame.size.width;
    float height = _rateView.frame.size.height;
    float starSize = MIN(height, width/5);
    int rateNo = [_stylerData[@"rate"] intValue];
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        for (int i=0; i<5; i++){
            UIImageView *starView = [[UIImageView alloc]initWithFrame:CGRectMake(i*starSize, (height-starSize)/2, starSize, starSize)];
            if (i<rateNo){
                starView.image = [UIImage imageNamed:@"star.png"];
            }else {
                starView.image = [UIImage imageNamed:@"starno.png"];
            }
            [_rateView addSubview:starView];
            
            
        }
    });
    
}

- (void) onTap{
    StylerProfile *stylerProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"stylerprofile"];
//    stylerProfile.stylerData = stylerdata;
    [self.navigationController pushViewController:stylerProfile animated:YES];
    
}

- (IBAction)stylerDeclineBt:(id)sender {
    if (status1Ref){
        [status1Ref setValue:@"open"];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)stylerAcceptBt:(id)sender {
    [status1Ref setValue:@"doing"];
    
    ServiceImplementation *serviceImplementation = [self.storyboard instantiateViewControllerWithIdentifier:@"serviceimplementation"];
    
//    serviceImplementation.stylerRoom = _stylerRoom;
    serviceImplementation.stylerData = _stylerData;
    serviceImplementation.navigationItem.hidesBackButton = YES;
    serviceImplementation.roomName = roomName;
    [self.navigationController pushViewController:serviceImplementation animated:YES];
    
    
}

@end
