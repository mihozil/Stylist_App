//
//  StylersList.h
//  Styler_Signup
//
//  Created by Apple on 3/11/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StylersList : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray*stylerData;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
