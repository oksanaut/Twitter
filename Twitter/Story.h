//
//  Story.h
//  Twitter
//
//  Created by Oksana Timonin on 28/10/2014.
//  Copyright (c) 2014 oksanaut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"
#import "TwitterClient.h"

extern NSString * const StoryAddedNotification;

@interface Story : NSObject
@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, strong) Person *author;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) BOOL favorited;
@property (nonatomic, assign) NSInteger favorites;
@property (nonatomic, assign) NSInteger shares;
@property (nonatomic, assign) BOOL shared;

@property (nonatomic, strong) NSDictionary *source;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *type;


+ (NSArray *)storiesWithArray:(NSArray *)array;
+ (void)create:(NSString *)status complete:(void (^)(BOOL success, NSError *error))complete;
- (id)initWithDictionary:(NSDictionary *)dictionary;
- (void)favorite;
- (void)reply:(NSString *)status complete:(void (^)(BOOL success, NSError *error))complete;
- (void)share:(void (^)(BOOL success, NSError *error))complete;

@end
