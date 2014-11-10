//
//  ProfileViewController.h
//  Twitter
//
//  Created by Oksana Timonin on 04/11/2014.
//  Copyright (c) 2014 oksanaut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

@interface ProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, weak) Person* person;
@property(nonatomic, weak) NSString* requestType;

@end
