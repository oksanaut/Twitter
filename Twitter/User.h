//
//  User.h
//  Twitter
//
//  Created by Oksana Timonin on 28/10/2014.
//  Copyright (c) 2014 oksanaut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *login;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *tagline;

- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
