//
//  RateView.m
//  Stylist_App
//
//  Created by Apple on 4/21/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "RateView.h"

@implementation RateView
- (void) setStarView{
    [self drawStars:0];
}
- (void) updateRating:(int)rateNo{
    for (UIImageView *starView in self.subviews){
        [starView removeFromSuperview];
    }
    [self drawStars:rateNo];
    
}
- (void) drawStars:(int)rateNo{
    float frameHeight = self.frame.size.height;
    float frameWidth = self.frame.size.width;
    float starsize = MIN(frameHeight, frameWidth/5);
    
    float x=(frameHeight-starsize)/2;
    float y=0;
    for (int i=0;i<5;i++){
        UIImageView *starView = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, starsize, starsize)];
        if (i<rateNo){
            starView.image = [UIImage imageNamed:@"star.png"];
        }else {
            starView.image = [UIImage imageNamed:@"starno.png"];
        }

        [self addSubview:starView];
        x=x+starsize;
    }
}


@end
