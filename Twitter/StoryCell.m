//
//  StoryCell.m
//  Twitter
//
//  Created by Oksana Timonin on 30/10/2014.
//  Copyright (c) 2014 oksanaut. All rights reserved.
//

#import "StoryCell.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+DateTools.h"

@interface StoryCell ()
@property (weak, nonatomic) IBOutlet UIView *typeView;
@property (weak, nonatomic) IBOutlet UIImageView *typeIcon;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIView *storyView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *storyLabel;
@property (weak, nonatomic) IBOutlet UIView *cellView;
@end

@implementation StoryCell

- (void)awakeFromNib {
    // Initialization code
    self.posterView.layer.cornerRadius = 3.0;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setStory:(Story *)story {
    _story = story;
    Story *source = self.story;
    CGRect frame = self.storyView.frame;
    if (self.story.source != nil) {
        self.typeLabel.text = [NSString stringWithFormat:@"%@ retweeted %@ ago", self.story.author.name, self.story.date.shortTimeAgoSinceNow];
        source = [[Story alloc] initWithDictionary:self.story.source];
        [self.typeView setHidden:NO];
        frame.origin.y = 17.0f;
    } else {
        [self.typeView setHidden:YES];
        frame.origin.y = 0.0f;
    }
    [self.posterView setImageWithURL:[NSURL URLWithString:source.author.imageUrl]];
    self.nameLabel.text = source.author.name;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", source.author.login];
    self.storyLabel.text = source.text;
    self.dateLabel.text = source.date.shortTimeAgoSinceNow;
    self.storyView.frame = self.contentView.frame;
}

- (IBAction)handleReply:(id)sender {
}

- (IBAction)handleShare:(id)sender {
}

- (IBAction)handleFavorite:(id)sender {
}

@end
