//
//  FrontReportDetailViewController.m
//  ShopManager
//
//  Created by 张旭 on 10/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "FrontReportDetailViewController.h"
#import "FrontReportDetailTableViewCell.h"

#define itemCell @"itemCell"

@interface FrontReportDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FrontReportDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self.tableView registerNib:[UINib nibWithNibName:@"FrontReportDetailTableViewCell" bundle:nil] forCellReuseIdentifier:itemCell];
}

- (IBAction)backButtonDidTouch:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 173;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	UIView *footerView = [[UIView alloc] init];
	footerView.backgroundColor = [UIColor clearColor];
	return footerView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.viewModel.listDataSource == nil) {
		return 0;
	}
	return self.viewModel.listDataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	FrontReportDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCell];
	FrontReportItemVM *item = self.viewModel.listDataSource[indexPath.section];
	cell.nameL.text = item.name;
	cell.moneyL.text = [NSString stringWithFormat:@"%.2f", item.xkCount+item.gzCount];
	cell.xkL.text = [NSString stringWithFormat:@"%.2f", item.xkCount];
	cell.txkL.text = [NSString stringWithFormat:@"%.2f", item.txkCount];
	cell.gzL.text = [NSString stringWithFormat:@"%.2f", item.gzCount];
	cell.tgzL.text = [NSString stringWithFormat:@"%.2f", item.tgzCount];
	return cell;
}



@end
