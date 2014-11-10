//
//  HomeViewController.m
//  Twitter
//
//  Created by Oksana Timonin on 30/10/2014.
//  Copyright (c) 2014 oksanaut. All rights reserved.
//

#import "HomeViewController.h"
#import "ComposerViewController.h"
#import "StoryViewController.h"
#import "ProfileViewController.h"
#import "StoryCell.h"
#import "Person.h"
#import "TwitterClient.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, StoryCellDelegate, StoryViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *stories;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation HomeViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self.stories = [[NSMutableArray alloc] init];
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[TwitterClient sharedInstance] timeline:nil complete:^(NSArray *stories, NSError *error) {
            if (!error) {
                [self.stories addObjectsFromArray:stories];
                [self.tableView reloadData];
            }
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserverForName:StoryAddedNotification object:nil queue:NSOperationQueuePriorityNormal usingBlock:^(NSNotification *note) {
            [self addLocalStory: note.userInfo[@"story"]];
    }];
    
    self.title = @"Home";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"StoryCell" bundle:nil] forCellReuseIdentifier:@"storyCell"];
    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];

    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(handleLogout)];
    self.navigationItem.leftBarButtonItem = logoutButton;
    UIBarButtonItem *updateButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onCreate)];
    self.navigationItem.rightBarButtonItem = updateButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.stories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StoryCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"storyCell"];
    cell.story = self.stories[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    StoryViewController *svc = [[StoryViewController alloc] init];
    Story *story = (Story *)self.stories[indexPath.row];
    if (story.source != nil) {
        Story *source = [[Story alloc] initWithDictionary:story.source];
        svc.story = source;
    } else {
        svc.story = story;
    }
    svc.delegate = self;
    [self.navigationController pushViewController:svc animated:YES];
    
}

- (void)onCreate {
    ComposerViewController *vc = [[ComposerViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion: nil];
}

- (void)handleLogout {
    [Person logout];
}

- (void)storyCell:(StoryCell *)viewController onCreate:(Story *)story {
    ComposerViewController *vc = [[ComposerViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion: nil];
}

- (void)storyCell:(StoryCell *)viewController onReply:(Story *)story {
    ComposerViewController *vc = [[ComposerViewController alloc] initWithStory:story];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion: nil];
}

- (void)storyCell:(StoryCell *)viewController onProfile:(Person *)person {
    ProfileViewController *vc = [[ProfileViewController alloc] init];
    vc.person = person;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addLocalStory:(Story *)story {
    [self.stories insertObject:story atIndex:0];
    [self.tableView reloadData];
}

- (void)onRefresh {
    [[TwitterClient sharedInstance] timeline:nil complete:^(NSArray *stories, NSError *error) {
        if (!error) {
            self.stories = [[NSMutableArray alloc] initWithArray:stories];
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
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
