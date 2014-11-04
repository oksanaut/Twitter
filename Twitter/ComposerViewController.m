//
//  ComposerViewController.m
//  Twitter
//
//  Created by Oksana Timonin on 31/10/2014.
//  Copyright (c) 2014 oksanaut. All rights reserved.
//

#import "ComposerViewController.h"
#import "TwitterClient.h"
#import "UIImageView+AFNetworking.h"

@interface ComposerViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *authorView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) Story *story;
@property (weak, nonatomic) Person *person;
@end

@implementation ComposerViewController
- (id)initWithStory:(Story *)story {
    if (self = [super init]) {
        self.story = story;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Create New";
    NSString *buttonTitle = @"Tweet";
    if (self.story != nil) {
        buttonTitle = @"Reply";
        self.textView.text = [NSString stringWithFormat:@"@%@ ", self.story.author.login];
    } else {
        self.textView.text = @"";
    }
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(handleCancel)];
    UIBarButtonItem *updateButton = [[UIBarButtonItem alloc] initWithTitle:buttonTitle style:UIBarButtonItemStylePlain target:self action:@selector(handleUpdate)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = updateButton;
    
    self.nameLabel.text = [Person user].name;
    self.loginLabel.text = [NSString stringWithFormat:@"@%@", [Person user].login];
    [self.authorView setImageWithURL:[NSURL URLWithString:[Person user].imageUrl]];
    self.authorView.layer.cornerRadius = 6.0;
    
    [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleChange:(id)sender {
    NSString *text = self.textView.text;
    if (self.story != nil) {
        NSRange range = [text rangeOfString:[NSString stringWithFormat:@"@%@", self.story.author.login]];
        if (range.location != NSNotFound) {
            self.navigationItem.rightBarButtonItem.title = @"Reply";
        } else {
            self.navigationItem.rightBarButtonItem.title = @"Tweet";
        }
    }
}

- (void)handleCancel {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)handleUpdate {
    NSString *status = self.textView.text;
    if (self.story != nil) {
    [self.story reply:status complete:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"success");
            [self dismissViewControllerAnimated:true completion:nil];
        } else {
            NSLog(@"success %@", error);
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }];
    } else {
        [Story create:status complete:^(BOOL success, NSError *error){
            if (success) {
                NSLog(@"success");
                [self dismissViewControllerAnimated:true completion:nil];
            } else {
                NSLog(@"success %@", error);
                [self dismissViewControllerAnimated:true completion:nil];
            }
        }];
    }
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
