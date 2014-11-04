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

NSString * const StoryAddedNotification = @"StoryAddedNotification";

@implementation Story
- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.idStr = dictionary[@"id_str"];
        self.author = [[Person alloc] initWithDictionary:dictionary[@"user"]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.date = [formatter dateFromString:dictionary[@"created_at"]];
        self.favorited = [dictionary[@"favorited"] boolValue];
        self.favorites = [dictionary[@"favorite_count"] integerValue];
        self.shares = [dictionary[@"retweet_count"] integerValue];
        self.shared = [dictionary[@"retweeted"] boolValue];
        self.source = dictionary[@"retweeted_status"];
        if (self.source != nil) {
            self.type = @"share";
        } else {
            self.type = @"story";
        }
        self.text = dictionary[@"text"];
        NSLog(@"dictionary for story %@", dictionary);
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

- (void)share:(void (^)(BOOL success, NSError *error))complete {
    [[TwitterClient sharedInstance] share:self.idStr complete:^(Story *story, NSError *error) {
        if (story != nil) {
            NSDictionary *dictionary = [NSDictionary dictionaryWithObject:story forKey:@"story"];
            [[NSNotificationCenter defaultCenter] postNotificationName:StoryAddedNotification object:nil userInfo:dictionary];
        } else {
            NSLog(@"Sharing error %@", error);
        }
    }];
}

- (void)favorite {
    if (self.favorited) {
        [[TwitterClient sharedInstance] unfavorite:self.idStr complete:^(BOOL success, NSError *error) {
            if (success) {
                self.favorited = NO;
                self.favorites = self.favorites - 1;
            }
        }];
    } else {
        [[TwitterClient sharedInstance] favorite:self.idStr complete:^(BOOL success, NSError *error) {
            if (success) {
                self.favorited = YES;
                self.favorites = self.favorites + 1;
            }
        }];
    }
}

- (void)reply:(NSString *)status complete:(void (^)(BOOL success, NSError *error))complete {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:status forKey:@"status"];
    [params setValue:self.idStr forKey:@"in_reply_to_status_id"];
    [[TwitterClient sharedInstance] create:params complete:^(Story *story, NSError *error) {
        if (!error) {
            complete(story, nil);
            NSDictionary *dictionary = [NSDictionary dictionaryWithObject:story forKey:@"story"];
            [[NSNotificationCenter defaultCenter] postNotificationName:StoryAddedNotification object:nil userInfo:dictionary];
        } else {
            complete(nil, error);
        }
    }];
    
}

+ (void)create:(NSString *)status complete:(void (^)(BOOL success, NSError *error))complete {
    // create a new element here
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:status forKey:@"status"];
    
    [[TwitterClient sharedInstance] create:params complete:^(Story *story, NSError *error) {
        if (!error) {
            NSDictionary *dictionary = [NSDictionary dictionaryWithObject:story forKey:@"story"];
            [[NSNotificationCenter defaultCenter] postNotificationName:StoryAddedNotification object:nil userInfo:dictionary];
        } else {
            complete(nil, error);
        }
    }];
}

@end
