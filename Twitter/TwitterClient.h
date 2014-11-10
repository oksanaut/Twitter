//
//  TwitterClient.h
//  Twitter
//
//  Created by Oksana Timonin on 28/10/2014.
//  Copyright (c) 2014 oksanaut. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "Person.h"

@class Story;

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)sharedInstance;
- (void)login:(void (^)(Person *person, NSError *error))complete;
- (void)openURL:(NSURL *)url;
- (void)timeline:(NSDictionary *)params complete:(void (^)(NSArray *stories, NSError *error))complete;
- (void)mentions:(NSDictionary *)params complete:(void (^)(NSArray *stories, NSError *error))complete;
- (void)profile:(NSDictionary *)params complete:(void (^)(NSArray *stories, NSError *error))complete;
- (void)create:(NSDictionary *)params complete:(void (^)(Story *story, NSError *error))complete;
- (void)share:(NSString *)storyID complete:(void (^)(Story *story, NSError *error))complete;
- (void)favorite:(NSString *)storyID complete:(void (^)(BOOL success, NSError *error))complete;
- (void)unfavorite:(NSString *)storyID complete:(void (^)(BOOL success, NSError *error))complete;
@end
