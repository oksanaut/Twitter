//
//  StoryViewController.h
//  Twitter
//
//  Created by Oksana Timonin on 31/10/2014.
//  Copyright (c) 2014 oksanaut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Story.h"

@class StoryViewController;
@protocol StoryViewControllerDelegate <NSObject>
- (void)storyCell:(StoryViewController *)viewController onCreate:(Story *)story;
- (void)storyCell:(StoryViewController *)viewController onReply:(Story *)story;
@end

@interface StoryViewController : UIViewController
@property(nonatomic, weak) Story* story;
@property (nonatomic, weak) id<StoryViewControllerDelegate> delegate;
@end
