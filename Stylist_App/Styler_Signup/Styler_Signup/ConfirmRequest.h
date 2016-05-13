//
//  ConfirmRequest.h
//  Styler_Signup
//
//  Created by Apple on 3/10/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Firebase/Firebase.h>

@interface ConfirmRequest : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *placeServiceLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableViewServices;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UITextField *promotionCodeTF;


@property (nonatomic, assign) CLLocationCoordinate2D locationGPS;

@end
