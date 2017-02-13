//
//  MicroCommunityViewController.m
//  ShopManager
//
//  Created by 张旭 on 2/23/16.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "MicroCommunityViewController.h"
#import "HttpClient.h"
#import "ShopManager-Swift.h"
#import "BBSTableViewCell.h"
#import "BBSDetailViewController.h"

@import MBProgressHUD;

@interface MicroCommunityViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *shequArray;
@property (assign, nonatomic) NSIndexPath *selectedIndex;

@end

@implementation MicroCommunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self shequListRequest];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (IBAction)backButtonDidTouch:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"BBSDetailSegue"]) {
        BBSDetailViewController *toView = segue.destinationViewController;
        SheQuList *item = [self.shequArray objectAtIndex:self.selectedIndex.row];
        toView.idStr = item.idStr;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedIndex = indexPath;
    [self performSegueWithIdentifier:@"BBSDetailSegue" sender:self];
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.shequArray == nil ? 0 : self.shequArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BBSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSCell"];
    SheQuList *item = [self.shequArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = item.title;
    cell.timeLabel.text = item.addDate;
    [cell.viewButton setTitle:item.clickNum forState:UIControlStateNormal];
    [cell.commentButton setTitle:item.replyNum forState:UIControlStateNormal];
    return cell;
}

#pragma mark - Request

- (void)shequListRequest {
    [[HttpClient sharedHttpClient] getSheQuListWithCompletion:^(BOOL success, NSArray *data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success) {
            self.shequArray = data;
            [self.tableView reloadData];
        }
    } failure:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

@end
