//
//  StylersList.m
//  Styler_Signup
//
//  Created by Apple on 3/11/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "StylersList.h"

@implementation StylersList
- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    _stylerData = [[NSMutableArray alloc]init];
    NSDictionary *dic = @{@"imgName":@"styler0.jpg",@"stylerName":@"Styler 1",@"rate":@"3"};
    [_stylerData addObject:dic];
    NSDictionary *dic1 = @{@"imgName":@"styler1.png",@"stylerName":@"Styler 2",@"rate":@"4"};
    [_stylerData addObject:dic1];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _stylerData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    UILabel *label = (UILabel*)[cell viewWithTag:101];
    label.text = _stylerData[indexPath.row][@"stylerName"];
    
    UIImageView *imgView = (UIImageView*)[cell viewWithTag:100];
    imgView.image = [UIImage imageNamed:_stylerData[indexPath.row][@"imgName"]];
    
    UIView *rateView = (UIView*)[cell viewWithTag:102];
    int rateNo = [_stylerData[indexPath.row][@"rate"] intValue];
    
    float width = rateView.frame.size.width;
    float height =rateView.frame.size.height;
    float starsize = MIN(rateView.frame.size.height, rateView.frame.size.width/5);
    
    for (int i =0;i<5; i++){
        UIImageView *star = [[UIImageView alloc]initWithFrame:CGRectMake(starsize*i, (height-starsize)/2, starsize, starsize)];
        if (i< rateNo){
            star.image = [UIImage imageNamed:@"star.png"];
        }else {
            star.image = [UIImage imageNamed:@"starno.png"];
        }
        [rateView addSubview:star];
    }

    
    return cell;
}

@end
