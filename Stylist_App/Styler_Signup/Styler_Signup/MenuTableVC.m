//
//  MenuTableVC.m
//  Styler_Signup
//
//  Created by Apple on 3/16/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "MenuTableVC.h"

@interface MenuTableVC ()

@end

@implementation MenuTableVC{
    NSArray *menuArray;
    NSDictionary *userData;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    menuArray = @[@"user",@"profile",@"payment",@"history",@"promotions",@"notifications"];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"0menuBg.png"]];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    userData = [[NSUserDefaults standardUserDefaults]objectForKey:@"userData"];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return menuArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:menuArray[indexPath.row] forIndexPath:indexPath];
    
    if ([menuArray[indexPath.row] isEqualToString:@"user"] ){
        UIImageView *imgView = (UIImageView*)[cell viewWithTag:100];
        imgView.layer.cornerRadius = imgView.frame.size.height/2;
        imgView.layer.masksToBounds = YES;
        
        UILabel *nameLabel = (UILabel*)[cell viewWithTag:101];
        if (userData) {
            if (userData[@"image"]){
//                NSData *imgData = [userData objectForKey:@"image"];
//                imgView.image = [UIImage imageWithData:imgData];
                
            }
            nameLabel.text = [NSString stringWithFormat:@"%@ %@",userData[@"firstname"],userData[@"lastname"]];
        }
        
        
        
}
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==0) return 130;
    else return 70;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
