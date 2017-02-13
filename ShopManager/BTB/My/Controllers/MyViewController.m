//
//  MyViewController.m
//  Cjmczh
//
//  Created by 张旭 on 12/14/15.
//  Copyright © 2015 Cjm. All rights reserved.
//

#import "MyViewController.h"
#import "IconDetailTableViewCell.h"
#import "OrderStateViewController.h"
#import "UIButton+BadgeView.h"

@interface MyViewController () {
    NSString *orderState;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeightConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *messageButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *myOrderView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *orderButtons;

@property (assign, nonatomic) CGFloat topViewHeight;
@property (strong, nonatomic) NSArray *imageList;
@property (strong, nonatomic) NSArray *titleList;
@property (strong, nonatomic) UITapGestureRecognizer *orderTap;
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.topViewHeight = self.topHeightConstraint.constant;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self.tableView registerNib:[UINib nibWithNibName:@"IconDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"IconDetailTableViewCell"];
    self.imageList = [[NSArray alloc] initWithObjects:
                  [UIImage imageNamed:@"shoucang"],
                  [UIImage imageNamed:@"dizhi"],
                  [UIImage imageNamed:@"qingli"],
                  [UIImage imageNamed:@"fankui"],
                  [UIImage imageNamed:@"guanyuwomen"],
                  [UIImage imageNamed:@"banbenxinxi"], nil];
    self.titleList = [[NSArray alloc] initWithObjects:@"收藏", @"我的收货地址", @"清除缓存", @"意见反馈", @"关于我们",@"版本信息",nil];

    self.orderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(orderViewDidTap:)];
    [self.myOrderView addGestureRecognizer:self.orderTap];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)orderViewDidTap:(UITapGestureRecognizer *)gesture {
    [self performSegueWithIdentifier:@"orderState" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"orderState"]) {
            NSInteger tag = ((UIButton *)sender).tag;
            ((OrderStateViewController *)segue.destinationViewController).btnTag = tag;
            [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }
}

- (void)pushOrderStateViewController:(UIButton *)btn {
    [self performSegueWithIdentifier:@"orderState" sender:btn];
}

- (IBAction)readyClick:(id)sender {
    [self pushOrderStateViewController:sender];
}

- (IBAction)readyCancelClick:(id)sender {
    [self performSegueWithIdentifier:@"returnState" sender:self];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.titleList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IconDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IconDetailTableViewCell"];
    cell.iconImage.image = [self.imageList objectAtIndex:indexPath.row];
    cell.menuLabel.text = [self.titleList objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"MyStarSegue" sender:self];
    } else if (indexPath.row == 1) {
        [self performSegueWithIdentifier:@"AddressSegue" sender:self];
    } else if (indexPath.row == 2) {
        
    } else if (indexPath.row == 3) {
        
        [self performSegueWithIdentifier:@"ReplaySegue" sender:self];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }

    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }

    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.viewControllers.count == 1) {
        return NO;
    }
    return YES;
}

@end
