//
//  TableViewCell.m
//  Stylist_App
//
//  Created by Apple on 5/10/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "TableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    NSDictionary *stylerData = [[NSUserDefaults standardUserDefaults]objectForKey:@"stylerData"];
  _userImg.image = [UIImage imageWithData:stylerData[@"img"]];
    _userImg.layer.cornerRadius = _userImg.frame.size.width/2;
    _userImg.clipsToBounds = YES;
    _userName.text = stylerData[@"name"];
}

@end
