//
//  ServicesVC.m
//  Stylist_App
//
//  Created by Apple on 4/22/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "ServicesVC.h"
#import "RoomSingleton.h"
#import <Firebase/Firebase.h>
#import "ServiceInfo.h"

@interface ServicesVC ()

@end

@implementation ServicesVC{
    NSArray *customerServices;
    NSString *priceName;
    Firebase *roomRef;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage *photo = [UIImage imageNamed:@"2signinupBg.jpg"];
    
    _tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"2signinupBg.jpg"]];
    _tableView.contentMode = UIViewContentModeScaleAspectFill;
    
    NSDictionary *customerData = [[NSUserDefaults standardUserDefaults]objectForKey:@"customerData"];
    customerServices = customerData[@"customerServices"];
//    NSLog(@"customerData: %@",customerData);
    priceName = customerData[@"priceName"];
    NSLog(@"priceName: %@",priceName);
    [_tableView reloadData];
    self.title = @"Services";
    
    
}
- (IBAction)onDoneBt:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return customerServices.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = customerServices[indexPath.row][@"name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@$ ",customerServices[indexPath.row][priceName]];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
                                                
}



@end
