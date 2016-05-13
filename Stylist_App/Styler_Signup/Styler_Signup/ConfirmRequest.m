//
//  ConfirmRequest.m
//  Styler_Signup
//
//  Created by Apple on 3/10/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "ConfirmRequest.h"
#import "StylersList.h"
#import "stylerVC.h"


@implementation ConfirmRequest{
    Firebase *ref;
    NSArray *servicesPicking;
    NSString *priceKey;
    BOOL confirmPress;
}
- (float) totalPrice{
    float price =0;
    for (int i=0; i<servicesPicking.count; i++){
        NSDictionary *service = servicesPicking[i];
        float servicePrice = [service[priceKey] floatValue];
        price+=servicePrice;
    }
    return price;
}
- (void)viewDidLoad{
    
    servicesPicking = [NSArray arrayWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"servicesPicking"]];
    priceKey =[NSString stringWithFormat:@"price_%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"serviceType"]];
    
    _tableViewServices.backgroundColor = [UIColor clearColor];
    float totalPrice = [self totalPrice];
    
    _totalPriceLabel.text = [NSString stringWithFormat:@"Total Price: %2.1f$",totalPrice];
    _totalPriceLabel.textColor = [UIColor whiteColor];
    
    _placeServiceLabel.text = [NSString stringWithFormat:@"Location: %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"placeService"]];
    
    _promotionCodeTF.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Enter Promotion code" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    _promotionCodeTF.delegate = self;
    
    _tableViewServices.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return servicesPicking.count;
  
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    NSDictionary *service = servicesPicking[indexPath.row];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = service[@"name"];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ $",service[priceKey]];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    return cell;
}
- (void)viewWillAppear:(BOOL)animated{
    confirmPress = NO;
}
- (IBAction)ConfirmBt:(id)sender {
    if (confirmPress) return;
    confirmPress = YES;
    
    stylerVC *stylervc = [self.storyboard instantiateViewControllerWithIdentifier:@"stylerVC"];
    
            [self.navigationController pushViewController:stylervc animated:YES];
    stylervc.navigationItem.hidesBackButton = YES;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([_promotionCodeTF isFirstResponder]){
        [_promotionCodeTF resignFirstResponder];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_promotionCodeTF resignFirstResponder];
    return YES;
}


@end
