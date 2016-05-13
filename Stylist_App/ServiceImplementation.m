//
//  ServiceImplementation.m
//  Stylist_App
//
//  Created by Apple on 4/21/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "ServiceImplementation.h"
#import "RoomSingleton.h"
#import <Firebase/Firebase.h>
#import "ServicesVC.h"
#import "ShowAlertView.h"
#import "ReceiptVC.h"
#import "SWRevealViewController.h"
#import "GoOnline.h"

@interface ServiceImplementation ()

@end

@implementation ServiceImplementation{
    CLLocationCoordinate2D userPosition;
    MKPointAnnotation *stylerAnnotation;
    Firebase *roomRef;
    NSString *status;
    NSString *phoneNo;
    
}
- (void) initProject{
    _mapView.showsUserLocation = true;
    status = @"Arriving";
    self.navigationController.navigationBarHidden = NO;
    
    SWRevealViewController *revealVC = self.revealViewController;
    if (revealVC){
        [_menuBt setTarget:self.revealViewController];
        [_menuBt setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    }
    
    NSDictionary *customerData = [[NSUserDefaults standardUserDefaults]objectForKey:@"customerData"];
    phoneNo = [NSString stringWithFormat:@"tel:%@",customerData[@"phonenumber"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initProject];
    
    [self setMap];
}
- (void) setMap{
    roomRef = [[RoomSingleton shareSingleton]roomRef];
    [self updateClientCancel];
    [roomRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot*snapShot){
        // userposition
        NSDictionary *dic = snapShot.value;
        float userLat = [dic[@"status"][@"gps_lat2"] floatValue];
        float userLog = [dic[@"status"][@"gps_long2"] floatValue];
        userPosition = CLLocationCoordinate2DMake(userLat, userLog);
        [self recenterMap];
        [self addAnnotation];
    }];
}

- (void) updateClientCancel{
    [[[roomRef childByAppendingPath:@"status"]childByAppendingPath:@"status1"] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot*snapShot){
        NSString *status1 = snapShot.value;
        NSLog(@"status1: %@",status1);
        if ([status1 isEqualToString:@"cancel"]){
            [ShowAlertView showAlertwithTitle:@"Service cancelled" andMessenge:@"Client has cancelled the service" inViewController:self];
            [self serviceCancelled];
        }
    }];
}

- (void) recenterMap{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userPosition, 2000, 2000);
    [_mapView setRegion:region];
}
- (void) addAnnotation{
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
    annotation.coordinate = userPosition;
    annotation.title = @"Service Place";
    [_mapView addAnnotation:annotation];
    
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    MKAnnotationView *annView = nil;
    if (annotation!=_mapView.userLocation){
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


- (IBAction)onArrivingBt:(id)sender {
    if ([status isEqualToString:@"Arriving"]){
        status = @"Begin Service";
        [_arrivingStatus setTitle:status forState:UIControlStateNormal];
    }else
    if ([status isEqualToString:@"Begin Service"]){
        [self confirmBeginService];
    }else 
    if ([status isEqualToString:@"End Service"]){
        [self closeService];
    }
    
}
- (void) closeService{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Close service" message:@"The service is completed" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action){
        [[[roomRef childByAppendingPath:@"status"]childByAppendingPath:@"status1"]setValue:@"complete"];
        [self gotoReceipt];
    }];
    UIAlertAction *actionNo = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
    }];
    [alertController addAction:actionYes];
    [alertController addAction:actionNo];
    
    [self presentViewController:alertController animated:YES completion:nil];
    [self gotoReceipt];
}
- (void) gotoReceipt{
    ReceiptVC *receiptVC = [self.storyboard instantiateViewControllerWithIdentifier:@"receiptvc"];
    
    [self.navigationController pushViewController:receiptVC animated:YES];
    
}

- (void) confirmBeginService{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Do you want to begin Service" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *YesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action){
        [self serviceBegun];
    }];
    UIAlertAction *NoAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:YesAction];
    [alertController addAction:NoAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void) serviceBegun{
    status = @"End Service";
    [_arrivingStatus setTitle:status forState:UIControlStateNormal];
    [[[roomRef childByAppendingPath:@"status"]childByAppendingPath:@"status1"] setValue:@"begin"];
    
}


- (IBAction)onServices:(id)sender {
    ServicesVC *services = [self.storyboard instantiateViewControllerWithIdentifier:@"servicesvc"];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:services];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)onCancelService:(id)sender {
    // can not cancel when the service has ben started
    if ([status isEqualToString:@"End Service"]) return;
    
    [self showAlertCancelAction];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void) showAlertCancelAction{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Do you want to cancel" message:@"You should communicate with client first" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"Call client" style:UIAlertActionStyleDestructive handler:^(UIAlertAction*action){
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:phoneNo]];
    }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Client no show" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action){
        // push cancel to serve
        [self serviceCancelled];
        
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Cancel by styler's reason" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action){
       
        [self serviceCancelled];
        // and deduct 10$
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"Don't cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action){
        // push cancel to serve
        
    }];
        
    [alertController addAction:action0];
    [alertController addAction:action1];[alertController addAction:action2];[alertController addAction:action3];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void) serviceCancelled{
    [[[roomRef childByAppendingPath:@"status"]childByAppendingPath:@"status1"]setValue:@"cancel" withCompletionBlock:^(NSError*error, Firebase*ref){
        [roomRef removeAllObservers];
        for (UIViewController *vc in self.navigationController.viewControllers){
            if ([vc isKindOfClass:[GoOnline class]]){
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
        // take care of this because i can remove it
        
    }];
    
}


@end
