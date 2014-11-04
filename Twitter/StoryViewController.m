//
//  StoryViewController.m
//  Twitter
//
//  Created by Oksana Timonin on 31/10/2014.
//  Copyright (c) 2014 oksanaut. All rights reserved.
//

#import "StoryViewController.h"
#import "Story.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+DateTools.h"

@interface StoryViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *typeView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *storyTop;

@end

@implementation StoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    self.loginLabel.text = [NSString stringWithFormat:@"@%@", source.author.login];
    self.textLabel.text = [NSString stringWithFormat:@"%@ ", source.text];
    self.textLabel.preferredMaxLayoutWidth = self.textLabel.frame.size.width;
    self.dateLabel.text = [NSString stringWithFormat:@"%@ ago", source.date.shortTimeAgoSinceNow];
    
    [self.shareButton setTitle:[NSString stringWithFormat: @" %ld", self.story.shares] forState:UIControlStateNormal];
    [self.favoriteButton setTitle:[NSString stringWithFormat: @" %ld", self.story.favorites] forState:UIControlStateNormal];
    [self.favoriteButton setSelected:self.story.favorited];
    [self.shareButton setSelected:self.story.shared];
    
    self.posterView.layer.cornerRadius = 6.0;

    self.textLabel.preferredMaxLayoutWidth = self.textLabel.frame.size.width;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleReply:(id)sender {
    [self.delegate storyCell:self onReply:self.story];
}

- (IBAction)handleShare:(id)sender {
    [self.story share:^(BOOL success, NSError *error) {
        [self.shareButton setTitle:[NSString stringWithFormat: @" %ld", self.story.shares + 1] forState:UIControlStateNormal];
        [self.shareButton setSelected:self.story.shared];
    }];


}

- (IBAction)handleFavorite:(id)sender {
    [self.story favorite];
    [self.favoriteButton setTitle:[NSString stringWithFormat: @" %ld", self.story.favorites] forState:UIControlStateNormal];
    [self.favoriteButton setSelected:self.story.favorited];

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
