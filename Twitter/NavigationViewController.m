//
//  NavigationViewController.m
//  Twitter
//
//  Created by Oksana Timonin on 05/11/2014.
//  Copyright (c) 2014 oksanaut. All rights reserved.
//

#import "NavigationViewController.h"
#import "NavigationViewCell.h"
#import "PersonViewController.h"
#import "HomeViewController.h"
#import "ProfileViewController.h"
#import "Person.h"

@interface NavigationViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) Person *person;
@property (nonatomic, strong) NSArray *sections;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, assign) CGPoint containerFrame;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeight;
@property (weak, nonatomic) IBOutlet UIView *personView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation NavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[UIScrollView appearance] setBackgroundColor:[UIColor clearColor]];
    self.sections = @[
                      @{@"key":@"profile", @"vc": [ProfileViewController class], @"title":@"PROFILE", @"request": @"person"},
                      @{@"key":@"home", @"vc": [HomeViewController class], @"title":@"HOME", @"request": @"timeline"},
                      @{@"key":@"mentions", @"vc": [ProfileViewController class], @"title":@"MENTIONS",  @"request": @"mentions"}
                      ];
    self.person = [Person user];

    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset =  UIEdgeInsetsMake(120, 0, 0, 0);
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NavigationViewCell" bundle:nil] forCellReuseIdentifier:@"viewCell"];
    // Do any additional setup after loading the view from its nib.
    

    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleContainerPan:)];
    [self.containerView addGestureRecognizer:panGestureRecognizer];
    
    // setup person view
    PersonViewController *pvc = [[PersonViewController alloc] init];
    pvc.person = self.person;
    UIView *pvcv = pvc.view;
    [self.personView addSubview:pvcv];
    NSDictionary *views = NSDictionaryOfVariableBindings(pvcv);
    [self.personView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[pvcv]|" options:0 metrics:nil views:views]];
    [self.personView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[pvcv]|" options:0 metrics:nil views:views]];
    [pvcv setNeedsUpdateConstraints];
    [pvcv setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    
    // setup initial view
    HomeViewController *cvc = [[HomeViewController alloc] init];
    [self.containerView addSubview:cvc.view];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *section = self.sections[indexPath.row];
    NavigationViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"viewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView =  [UIView new];
    cell.titleLabel.text = section[@"title"];
    cell.iconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", section[@"key"]]];
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    double viewTop = MAX(MIN(self.headerHeight.constant - scrollView.contentOffset.y / 30, 140), 50);
//    [UIView animateWithDuration:0 animations:^{
//        self.headerHeight.constant = viewTop;
//        self.tableView.contentInset = UIEdgeInsetsMake(viewTop, 0, 0, 0);
//    }];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Class ViewController = self.sections[indexPath.row][@"vc"];
    UIViewController *vc = [[ViewController alloc] init];
    UIView *vcView = vc.view;
    self.title = self.sections[indexPath.row][@"title"];
    
    [self.containerView addSubview:vcView];
    [self.containerView bringSubviewToFront:vcView];
    [UIView animateWithDuration:0.5f animations:^{
        CGRect frame = self.containerView.frame;
        frame.origin.x = self.view.frame.origin.x;
        self.containerView.frame = frame;
    }];
    [vcView setNeedsUpdateConstraints];
    [vcView setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (IBAction)handleContainerPan:(UIPanGestureRecognizer *)sender {
    CGPoint velocity = [sender velocityInView:self.view];
    CGPoint translation = [sender translationInView:self.view];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.containerFrame = self.containerView.frame.origin;
        
    }  else if (sender.state == UIGestureRecognizerStateChanged) {
        CGRect frame = self.containerView.frame;
        frame.origin.x = self.containerFrame.x + translation.x;
        self.containerView.frame = frame;
        
    }  else if (sender.state == UIGestureRecognizerStateEnded) {
        
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = self.containerView.frame;
            if (velocity.x > 0) {
                frame.origin.x = self.view.frame.size.width - self.view.frame.size.width / 10;
                
            } else if (velocity.x < 0) {
                frame.origin.x = self.view.frame.origin.x;
            }
            self.containerView.frame = frame;
            
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
