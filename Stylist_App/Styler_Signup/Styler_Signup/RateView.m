//
//  RateView.m
//  Styler_Signup
//
//  Created by Apple on 3/13/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "RateView.h"

@implementation RateView{
    UITapGestureRecognizer *tap;
    float width, height, starSize;
}


- (void)setStarsView{
    [self baseInit];
    for (int i=0; i<5; i++){
        UIImageView *starView = [[UIImageView alloc]initWithFrame:CGRectMake(i*starSize, (height-starSize)/2, starSize, starSize)];
        if (i<_rateNo){
            starView.image = [UIImage imageNamed:@"star.png"];
        }else
        starView.image = [UIImage imageNamed:@"starno.png"];
        
        [self addSubview:starView];
    }
}
- (void) baseInit{
    width = self.frame.size.width;
    height = self.frame.size.height;
    starSize = MIN(height, width/5);
    for (int i=0; i<self.subviews.count; i++){
        [self.subviews[i] removeFromSuperview];
    }
    
}



@end
