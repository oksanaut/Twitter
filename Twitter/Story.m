//
//  Story.m
//  Twitter
//
//  Created by Oksana Timonin on 28/10/2014.
//  Copyright (c) 2014 oksanaut. All rights reserved.
//

#import "Story.h"
#import "TwitterClient.h"
#import "HomeViewController.h"


@implementation Story
- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.idStr = dictionary[@"id_str"];
        self.author = [[Person alloc] initWithDictionary:dictionary[@"user"]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.date = [formatter dateFromString:dictionary[@"created_at"]];
        self.favorited = dictionary[@"favorited"];
        self.favorites = [dictionary[@"favorite_count"] integerValue];
        self.retweets = [dictionary[@"retweet_count"] integerValue];
        
        self.source = dictionary[@"retweeted_status"];
        if (self.source != nil) {
            NSLog(@"self is shared, %@", self.source);
            self.type = @"share";
        } else {
            self.type = @"story";
        }
        self.text = dictionary[@"text"];
    }
    
    return self;
}
+ (NSArray *)storiesWithArray:(NSArray *)array {
    NSMutableArray *stories = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
        [stories addObject:[[Story alloc] initWithDictionary:dictionary]];
    }
    return stories;
}

- (void)share {
    [[TwitterClient sharedInstance] share:self.idStr complete:^(Story *story, NSError *error) {
       
        NSLog(@"shared response story %@", story);
    }];
}

- (void)favorite {
    [[TwitterClient sharedInstance] favorite:self.idStr complete:^(BOOL success, NSError *error) {
        if (success) {
            self.favorited = YES;
            self.favorites = self.favorites + 1;
        }
    }];
}

- (void)reply:(NSDictionary *)dictionary {
    // build a reply here
    
}

- (void)create:(NSDictionary *)dictionary  {
    // create a new element here
    
}

@end
