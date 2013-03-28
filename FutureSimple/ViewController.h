//
//  ViewController.h
//  FutureSimple
//
//  Created by Adrian Slawniak on 3/28/13.
//  Copyright (c) 2013 Adrian Slawniak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, strong) CLLocationManager *locManager;
@property (nonatomic, assign) CLLocationDegrees latitude;
@property (nonatomic, assign) CLLocationDegrees longitude;
@property (nonatomic, strong) NSMutableData *dataReceived;
@property (nonatomic, strong) UILabel *labTemp;
@property (nonatomic, strong) UILabel *labPress;
@end
