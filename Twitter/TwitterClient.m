//
//  TwitterClient.m
//  Twitter
//
//  Created by Oksana Timonin on 28/10/2014.
//  Copyright (c) 2014 oksanaut. All rights reserved.
//

#import "TwitterClient.h"
#import "Story.h"

NSString * const kBaseUrl = @"https://api.twitter.com";
NSString * const kTwitterKey = @"mO4Ui4v4Obx6n07ujLIvOsukB";
NSString * const kTwitterSecret = @"jasylgJXAHSbJhxY80aERfLU5dy9YRgLf8zuBbhwAw4ajuDnfd";

@interface TwitterClient()
@property (nonatomic, strong) void (^loginComplete)(Person *person, NSError *error);
@end

@implementation TwitterClient
+ (TwitterClient *)sharedInstance {
    static TwitterClient *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl] consumerKey:kTwitterKey consumerSecret:kTwitterSecret];
        }
    });
    return instance;
}

- (void)login:(void (^)(Person *person, NSError *error))complete {
    self.loginComplete = complete;
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"otwitter://oauth"] scope:nil success:^(BDBOAuthToken *requestToken) {
        NSLog(@"Got the request token");
        NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
        [[UIApplication sharedApplication] openURL:authURL];
        
    } failure:^(NSError *error) {
        NSLog(@"Failed to get the request token %@", error);
        self.loginComplete(nil, error);
    }];
    
}
- (void)openURL:(NSURL *)url {
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuthToken tokenWithQueryString:url.query] success:^(BDBOAuthToken *accessToken) {
        NSLog(@"Received access token");
        [self.requestSerializer saveAccessToken:accessToken];
        
        [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            Person *person = [[Person alloc] initWithDictionary:responseObject];
            self.loginComplete(person, nil);
            [Person setUser:person];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            self.loginComplete(nil, error);
        }];
    } failure:^(NSError *error) {
        self.loginComplete(nil, error);
    }];
}
- (void)timeline:(NSDictionary *)params complete:(void (^)(NSArray *stories, NSError *error))complete {
    [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            NSArray *stories = [Story storiesWithArray:responseObject];
            complete(stories, nil);
        } else {
            // TODO: learn how to generate a useful NSError
            NSLog(@"responseObject is not NSArray");
            complete(nil, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        complete(nil, error);
    }];
}

- (void)create:(NSDictionary *)params complete:(void (^)(Story *story, NSError *error))complete {
    [self POST:@"1.1/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Story *story = [[Story alloc] initWithDictionary:responseObject];
        complete(story, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        complete(nil, error);
    }];
}

- (void)share:(NSString *)storyID complete:(void (^)(Story *story, NSError *error))complete {
    NSString *path = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", storyID];
    [self POST:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Story *story = [[Story alloc] initWithDictionary:responseObject];
        complete(story, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        complete(nil, error);
    }];
}

- (void)favorite:(NSString *)storyID complete:(void (^)(BOOL success, NSError *error))complete {
    NSString *path = [NSString stringWithFormat:@"1.1/favorites/create.json?id=%@", storyID];
    [self POST:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        complete(YES, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        complete(NO, error);
    }];
}

- (void)unfavorite:(NSString *)storyID complete:(void (^)(BOOL success, NSError *error))complete {
    NSString *path = [NSString stringWithFormat:@"1.1/favorites/destroy.json?id=%@", storyID];
    [self POST:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        complete(YES, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        complete(NO, error);
    }];
}
@end
