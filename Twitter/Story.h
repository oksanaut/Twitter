//
//  Story.h
//  Twitter
//
//  Created by Oksana Timonin on 28/10/2014.
//  Copyright (c) 2014 oksanaut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

@interface Story : NSObject
@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, strong) Person *author;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) BOOL favorited;
@property (nonatomic, assign) NSInteger favorites;
@property (nonatomic, assign) NSInteger retweets;
@property (nonatomic, strong) NSDictionary *source;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *type;


- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)storiesWithArray:(NSArray *)array;

@end
