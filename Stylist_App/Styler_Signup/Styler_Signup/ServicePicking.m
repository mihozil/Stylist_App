//
//  ServicePicking.m
//  Styler_Signup
//
//  Created by Apple on 3/10/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "ServicePicking.h"
#import "ConfirmRequest.h"
#import "ActivityIndicator.h"

@implementation ServicePicking{
    int countTap;
    int servicePrice;
    NSMutableArray *services;
    NSMutableArray *buttonServices;
    NSMutableArray *labelServices;
    NSMutableArray *servicesPicking;
    float height, distance, margin, labelWidth, frameWidth,frameHeight,navigationbarHeight;
    UITapGestureRecognizer *tap;
    UIActivityIndicatorView *activityIndicatorView;
}

- (void) initProject{
    countTap = 0;
    frameHeight = self.view.bounds.size.height;
    frameWidth = self.view.bounds.size.width;
    navigationbarHeight = self.navigationController.navigationBar.frame.size.height;

}
- (void) ErrorNotify{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please try again" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action){
            [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];

    
}
- (void) initLoading{
    activityIndicatorView = [UIActivityIndicatorView new];
    [ActivityIndicator addActivity:activityIndicatorView toView:self.view];
    [ActivityIndicator startAnimatingActivity:activityIndicatorView];
}
- (void) getServicesFromServe{
    [self initLoading];
    
    NSString *urlString = @"http://styler.theammobile.com/GET_PRODUCT.php";
    
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    request.HTTPMethod = @"Get";
    request.URL = [NSURL URLWithString:urlString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:^(NSData*data, NSURLResponse*respond, NSError*error){
        NSError*error2;
        [ActivityIndicator stopAnimatingActivity:activityIndicatorView];
        if (error){
            [self ErrorNotify];
            return;
            
        }
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error2];
        
        services = [NSMutableArray new];

        services = json[@"product"];
        dispatch_async(dispatch_get_main_queue(), ^{
        [self setServicetoView];
        });

        
    }]resume];
}

- (void) setServicetoView{
    buttonServices = [NSMutableArray new];
    labelServices = [NSMutableArray new];
    
    height = 50;
    margin = 10;
    
    distance = 50;
    labelWidth = frameWidth/2 - margin - height - margin - margin;
    
    
    NSString *savedCategory = @"";
    int beginPosition = 0;
    
    float x,y;
    y=0;
    
    for (int i=0; i<services.count; i++){

            NSString *categoryName = services[i][@"category"];
        
            if (![categoryName isEqualToString:savedCategory]){
                x= margin; y+=distance + height;
                beginPosition = i;
                savedCategory = categoryName;
                
                    [self createCategory:categoryName withx:x andy:y];
                y= y -distance/2;
            }
                
                x = ((i-beginPosition)%2) * (frameWidth/2) + margin;
                
        if ((i-beginPosition)%2==0){
            y=y+height+distance;
        }
        
                    [self addButtonwithx:x andy:y];
                    [self addlabelwithx:x+height+margin andy:y - margin];

    }
    _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, y+distance+height+90);
    
    
}
- (void) createCategory:(NSString*) category withx:(float)x andy:(float)y{
    UILabel *categoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, frameWidth-margin*2, height)];
    categoryLabel.text = category;
    
    categoryLabel.font = [UIFont fontWithName:@"Baskerville-Bold" size:25];
    [self.scrollView addSubview:categoryLabel];
    
}
- (void) addButtonwithx:(float)x andy:(float)y{
    UIButton *bt = [[UIButton alloc]initWithFrame:CGRectMake(x, y, height, height)];
    bt.tag = buttonServices.count;
    [_scrollView addSubview:bt];
    [buttonServices addObject:bt];
    
    [[bt layer]setBorderWidth:2.0f];
    [[bt layer]setBorderColor:[UIColor purpleColor].CGColor];
    [bt addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    
}



- (void) onButton:(id)sender{
    
    if (![sender imageForState:UIControlStateNormal]){
        [sender setImage:[UIImage imageNamed:@"tick.png"] forState:UIControlStateNormal];
        [servicesPicking addObject:services[[sender tag]]];
    }else {
        [sender setImage:nil forState:UIControlStateNormal];
        [servicesPicking removeObject:services[[sender tag]]];
    }
    
}


- (void) addlabelwithx:(float)x andy:(float)y{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(x, y, labelWidth, height+margin*2)];
    [_scrollView addSubview:label];
    [labelServices addObject:label];
    
    NSDictionary *serice = services[labelServices.count-1];
    label.text = serice[@"name"];
    label.numberOfLines = 3;
    label.font = [UIFont fontWithName:@"Baskerville" size:17];
    
    
}

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    _scrollView.frame = CGRectMake(0, 0, frameWidth, frameHeight- 90);
//    [_nextButton setTitle:@"Next" forState:UIControlStateNormal];
//
//    
//}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    _scrollView.frame = CGRectMake(0, 0, frameWidth, frameHeight);
    [_nextButton setTitle:@"" forState:UIControlStateNormal];
    [_nextButton setEnabled:NO];
    
    
}

- (void) createScrollView{

    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, (frameHeight - 90))];
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height*2);
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
  
}
- (void) addGestureRecognize{
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap)];
    tap.numberOfTapsRequired=1;
    tap.delegate = self;
    tap.enabled = YES;
    [_nextView addGestureRecognizer:tap];
    [self.view bringSubviewToFront:_nextView];
    [self.view bringSubviewToFront:_nextButton];
}

- (void) onTap{
    NSLog(@"ontap");
    _scrollView.frame = CGRectMake(0, 0, frameWidth, frameHeight- 90);
    [_nextButton setTitle:@"Next" forState:UIControlStateNormal];
    [_nextButton setEnabled:YES];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    [self initProject];
    [self createScrollView];
    
    servicesPicking = [NSMutableArray new];
    
    [self getServicesFromServe];
    [self addGestureRecognize];
  
}

- (IBAction)onNextButton:(id)sender {
    [[NSUserDefaults standardUserDefaults]setObject:servicesPicking forKey:@"servicesPicking"];
    ConfirmRequest *confirmRequest = [self.storyboard instantiateViewControllerWithIdentifier:@"confirmrequest"];
    [self.navigationController pushViewController:confirmRequest animated:YES];
    
}


@end
