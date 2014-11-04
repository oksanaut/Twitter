//
//  StoryCell.h
//  Twitter
//
//  Created by Oksana Timonin on 30/10/2014.
//  Copyright (c) 2014 oksanaut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Story.h"

@class StoryCell;

@protocol StoryCellDelegate <NSObject>
- (void)storyCell:(StoryCell *)viewController onCreate:(Story *)story;
- (void)storyCell:(StoryCell *)viewController onReply:(Story *)story;
@end

@interface StoryCell : UITableViewCell
@property (nonatomic, strong) Story *story;
@property (nonatomic, weak) id<StoryCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

- (IBAction)handleReply:(id)sender;
- (IBAction)handleShare:(id)sender;
- (IBAction)handleFavorite:(id)sender;
@end
