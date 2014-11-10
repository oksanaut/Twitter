//
//  ProfileViewController.m
//  Twitter
//
//  Created by Oksana Timonin on 04/11/2014.
//  Copyright (c) 2014 oksanaut. All rights reserved.
//

#import "ProfileViewController.h"
#import "PersonViewController.h"
#import "StoryViewController.h"
#import "TwitterClient.h"
#import "StoryCell.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *authorHeight;
@property (weak, nonatomic) IBOutlet UITableView *storiesView;
@property (weak, nonatomic) IBOutlet UIView *authorView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *stories;
@end

@implementation ProfileViewController 
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
//    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    if (self.person == nil) {
        self.person = [Person user];
    }
    // Do any additional setup after loading the view from its nib.
    
    PersonViewController *pvc = [[PersonViewController alloc] init];
    pvc.person = self.person;
    UIView *pvcv = pvc.view;
    
    self.stories = [[NSMutableArray alloc] init];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.tableView registerNib:[UINib nibWithNibName:@"StoryCell" bundle:nil] forCellReuseIdentifier:@"profileStoryCell"];
    
    self.tableView.contentInset =  UIEdgeInsetsMake(120, 0, 0, 0);
    
    [self.authorView addSubview:pvcv];
    NSDictionary *views = NSDictionaryOfVariableBindings(pvcv);
    [self.authorView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[pvcv]|" options:0 metrics:nil views:views]];
    [self.authorView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[pvcv]|" options:0 metrics:nil views:views]];
    
    
//    if ([self.requestType isEqual:@"mentions"]) {
//        [[TwitterClient sharedInstance] mentions:nil complete:^(NSArray *stories, NSError *error) {
//            if (!error) {
//                [self.stories addObjectsFromArray:stories];
//                [self.tableView reloadData];
//            }
//        }];
//    } else if (!self.requestType || [self.requestType isEqual:@"profile"]) {
//        NSDictionary *params = @{@"screen_name": self.person.login};
//        [[TwitterClient sharedInstance] profile:params complete:^(NSArray *stories, NSError *error) {
//            if (!error) {
//                [self.stories addObjectsFromArray:stories];
//                [self.tableView reloadData];
//            }
//        }];
//    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.stories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StoryCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"profileStoryCell"];
    cell.story = self.stories[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView =  [UIView new];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    StoryViewController *svc = [[StoryViewController alloc] init];
    svc.story = self.stories[indexPath.row];
    [self.navigationController pushViewController:svc animated:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    double viewTop = MAX(MIN(self.authorHeight.constant - scrollView.contentOffset.y / 30, 120), 50);
    [UIView animateWithDuration:0 animations:^{
        self.authorHeight.constant = viewTop;
        self.tableView.contentInset = UIEdgeInsetsMake(viewTop, 0, 0, 0);
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
