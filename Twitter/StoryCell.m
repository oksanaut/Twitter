//
//  StoryCell.m
//  Twitter
//
//  Created by Oksana Timonin on 30/10/2014.
//  Copyright (c) 2014 oksanaut. All rights reserved.
//

#import "StoryCell.h"
#import "UIImageView+AFNetworking.h"
#import "HomeViewController.h"
#import "ComposerViewController.h"
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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *storyTop;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
- (IBAction)handleReply:(id)sender;
- (IBAction)handleShare:(id)sender;
- (IBAction)handleFavorite:(id)sender;
- (IBAction)handleProfile:(id)sender;
@end

@implementation StoryCell

- (void)awakeFromNib {
    // Initialization code
    self.posterView.layer.cornerRadius = 6.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setStory:(Story *)story {
    _story = story;
    Story *source = self.story;
    if (self.story.source != nil) {
        self.typeLabel.text = [NSString stringWithFormat:@"%@ retweeted this %@ ago", self.story.author.name, self.story.date.shortTimeAgoSinceNow];
        source = [[Story alloc] initWithDictionary:self.story.source];
        [self.typeView setHidden:NO];
        self.storyTop.constant = 19;
    } else {
        [self.typeView setHidden:YES];
        self.storyTop.constant = 0;
    }
    [self.posterView setImageWithURL:[NSURL URLWithString:source.author.imageUrl]];
    self.nameLabel.text = source.author.name;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", source.author.login];
    self.storyLabel.text = [NSString stringWithFormat:@"%@ ", source.text];
    self.storyLabel.preferredMaxLayoutWidth = self.storyLabel.frame.size.width;
    self.dateLabel.text = [NSString stringWithFormat:@"%@ ago", source.date.shortTimeAgoSinceNow];
    
    [self.shareButton setTitle:[NSString stringWithFormat: @" %ld", self.story.shares] forState:UIControlStateNormal];
    [self.favoriteButton setTitle:[NSString stringWithFormat: @" %ld", self.story.favorites] forState:UIControlStateNormal];
    [self.favoriteButton setSelected:self.story.favorited];
    [self.shareButton setSelected:self.story.shared];
    [self.favoriteButton setContentMode:UIViewContentModeScaleAspectFit];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.storyLabel.preferredMaxLayoutWidth = self.storyLabel.frame.size.width;
}

- (IBAction)handleReply:(id)sender {
    [self.delegate storyCell:self onReply:self.story];
}

- (IBAction)handleShare:(id)sender {
    [self.story share:^(BOOL success, NSError *error) {
        if (success) {
            [self.shareButton setTitle:[NSString stringWithFormat: @" %ld", self.story.shares] forState:UIControlStateNormal];
            [self.shareButton setSelected:self.story.shared];
        }
    }];
}

- (IBAction)handleFavorite:(id)sender {
    [self.story favorite];
    [self.favoriteButton setTitle:[NSString stringWithFormat: @" %ld", self.story.favorites] forState:UIControlStateNormal];
    [self.favoriteButton setSelected:self.story.favorited];
}

- (IBAction)handleProfile:(id)sender {
    [self.delegate storyCell:self onProfile:self.story.author];
}


@end
