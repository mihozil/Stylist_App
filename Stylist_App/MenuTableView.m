//
//  MenuTableView.m
//  Stylist_App
//
//  Created by Apple on 4/23/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "MenuTableView.h"
#import "SignIn.h"

@interface MenuTableView ()

@end

@implementation MenuTableView{
    NSArray *menuArray;
    NSDictionary *stylerInfo;
}
- (void) initProject{
    menuArray = @[@"user",@"profile",@"history",@"notification"];
    _tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"0menuBg.png"]];
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initProject];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) return 120;
    return 70;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return menuArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:menuArray[indexPath.row] forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (IBAction)onSignoutBt:(id)sender {
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"stylerData"];
        
}


@end
