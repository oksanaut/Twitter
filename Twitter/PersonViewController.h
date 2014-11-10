//
//  PersonViewController.h
//  Twitter
//
//  Created by Oksana Timonin on 04/11/2014.
//  Copyright (c) 2014 oksanaut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

@interface PersonViewController : UIViewController
@property (nonatomic, strong) Person *person;
- (UIColor *)colorFromHexString:(NSString *)hex;
@end
