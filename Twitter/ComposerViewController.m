//
//  ComposerViewController.m
//  Twitter
//
//  Created by Oksana Timonin on 31/10/2014.
//  Copyright (c) 2014 oksanaut. All rights reserved.
//

#import "ComposerViewController.h"
#import "TwitterClient.h"

@interface ComposerViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textInput;
@property (weak, nonatomic) Story *story;
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
        self.textInput.text = [NSString stringWithFormat:@"@%@", self.story.author.login];
    }
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(handleCancel)];
    UIBarButtonItem *updateButton = [[UIBarButtonItem alloc] initWithTitle:buttonTitle style:UIBarButtonItemStylePlain target:self action:@selector(handleUpdate)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = updateButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleChange:(id)sender {
    NSString *text = self.textInput.text;
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
    NSMutableDictionary *story = [[NSMutableDictionary alloc] init];
    [story setValue:self.textInput.text forKey:@"status"];
    [story setValue:self.story.idStr forKey:@"in_reply_to_status_id"];
    [[TwitterClient sharedInstance] create:story complete:^(Story *story, NSError *error) {
        if (!error) {
            NSLog(@"success");
            [self dismissViewControllerAnimated:true completion:nil];
        } else {
            NSLog(@"success %@", error);
        }
    }];
    
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
