//
//  PersonViewController.m
//  Twitter
//
//  Created by Oksana Timonin on 04/11/2014.
//  Copyright (c) 2014 oksanaut. All rights reserved.
//

#import "PersonViewController.h"
#import "UIImageView+AFNetworking.h"

@interface PersonViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bannerView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *cardView;
@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self.view setNeedsUpdateConstraints];
    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];

    // Banner View
    [self.view setBackgroundColor:[self colorFromHexString:self.person.color]];
    [self.bannerView setImageWithURL:[NSURL URLWithString:self.person.bannerUrl]];
    
    // Poster View
    [self.posterView setImageWithURL:[NSURL URLWithString:self.person.imageUrl]];
    [self.posterView.layer setBorderWidth:2.0f];
    [self.posterView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [self.posterView.layer setCornerRadius:6.0];
    
    // setup card
    // Texts
    self.nameLabel.text = self.person.name;
    self.loginLabel.text = [NSString stringWithFormat:@"@%@", self.person.login];
    self.descriptionLabel.text = self.person.tagline;
    
    [self.cardView setFrame:self.view.bounds];
    self.descriptionLabel.preferredMaxLayoutWidth = self.descriptionLabel.frame.size.width;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"View will appear");
    [self.view setNeedsUpdateConstraints];
    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"View did appear");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIColor *)colorFromHexString:(NSString *)hex {
    unsigned rgb = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hex];
    [scanner scanHexInt:&rgb];
    return [UIColor colorWithRed:((rgb & 0xFF0000) >> 16)/255.0 green:((rgb & 0xFF00) >> 8)/255.0 blue:(rgb & 0xFF)/255.0 alpha:1.0];
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
