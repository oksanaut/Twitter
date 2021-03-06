//
//  StoryCell.h
//  Twitter
//
//  Created by Oksana Timonin on 30/10/2014.
//  Copyright (c) 2014 oksanaut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Story.h"
#import "Person.h"

@class StoryCell;

@protocol StoryCellDelegate <NSObject>
- (void)storyCell:(StoryCell *)viewController onCreate:(Story *)story;
- (void)storyCell:(StoryCell *)viewController onReply:(Story *)story;
- (void)storyCell:(StoryCell *)viewController onProfile:(Person *)person;
@end

@interface StoryCell : UITableViewCell
@property (nonatomic, strong) Story *story;
@property (nonatomic, weak) id<StoryCellDelegate> delegate;


@end
