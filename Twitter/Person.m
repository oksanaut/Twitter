//
//  Person.m
//  Twitter
//
//  Created by Oksana Timonin on 29/10/2014.
//  Copyright (c) 2014 oksanaut. All rights reserved.
//

#import "Person.h"
@implementation Person
- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.data = dictionary;
        self.name = dictionary[@"name"];
        self.login = dictionary[@"screen_name"];
        self.imageUrl = dictionary[@"profile_image_url"];
        self.tagline = dictionary[@"description"];
    }
    return self;
}

static Person *_user = nil;
NSString * const kUserKey = @"kUserKey";

+ (Person *)user {
    if (_user == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kUserKey];
        if (data != nil) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            _user = [[Person alloc] initWithDictionary:dictionary];
        }
    }
    return _user;
}

+ (void)setUser:(Person *)person {
    _user = person;
    if (_user != nil) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:person.data options:0 error:NULL];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kUserKey];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kUserKey];
    }
}
@end
