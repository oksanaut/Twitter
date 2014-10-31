//
//  Person.h
//  Twitter
//
//  Created by Oksana Timonin on 29/10/2014.
//  Copyright (c) 2014 oksanaut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *login;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *tagline;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (Person *)user;
+ (void)setUser:(Person *)person;

@end
