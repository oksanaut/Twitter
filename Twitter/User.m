//
//  User.m
//  Twitter
//
//  Created by Oksana Timonin on 28/10/2014.
//  Copyright (c) 2014 oksanaut. All rights reserved.
//

#import "User.h"

@implementation User
- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.name = dictionary[@"name"];
        self.login = dictionary[@"screen_name"];
        self.imageUrl = dictionary[@"profile_image_url"];
        self.tagline = dictionary[@"description"];
    }
    return self;
}
@end
