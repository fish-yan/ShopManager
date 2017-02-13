//
//  CostOrderListViewController.m
//  ShopManager
//
//  Created by 张旭 on 6/14/16.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "CostOrderListViewController.h"
@import MJRefresh;
@import DateTools;
#import "HttpClient.h"
#import "ShopManager-Swift.h"
#import "CostOrderTableViewCell.h"
#import "CostOrderDescViewController.h"
#import "StoreSelectView.h"

@interface CostOrderListViewController ()<UITableViewDelegate, UITableViewDataSource> {
    NSInteger pageIndex;
    NSInteger pageSize;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *storeNameL;

@property (strong, nonatomic) NSMutableArray<CostOrderItem *> *data;

@property (strong, nonatomic) StoreSelectView *storeSelectView;

@end

@implementation CostOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _costObjectName;
	self.storeNameL.text = self.storeName;
    pageIndex = 1;
    pageSize = 20;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self headerRequest];
    }];
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self footerRequest];
    }];
    
    [_tableView.mj_header beginRefreshing];
}

- (StoreSelectView *)storeSelectView {
	if (_storeSelectView == nil) {
		_storeSelectView = [[StoreSelectView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
		__weak typeof(self) weakSelf = self;
		_storeSelectView.confirmBlock = ^(NSString *name, NSString *idStr) {
			weakSelf.storeName = name;
			weakSelf.storeId = idStr;
			weakSelf.storeNameL.text = weakSelf.storeName;
			[weakSelf.tableView.mj_header beginRefreshing];
		};
		[self.view addSubview:_storeSelectView];
	}
	return _storeSelectView;
}

- (IBAction)menuButtonDidTouch:(id)sender {
	[self.storeSelectView show];
}

- (IBAction)backButtonDidTouch:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"OrderDescSegue"]) {
        CostOrderDescViewController *vc = segue.destinationViewController;
        NSIndexPath *indexPath = sender;
        CostOrderItem *item = _data[indexPath.row];
        vc.idStr = item.saleId;
    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"OrderDescSegue" sender:indexPath];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_data == nil) {
        return 0;
    }
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CostOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CostOrderCell"];
    CostOrderItem *item = _data[indexPath.row];
    cell.titleL.text = item.orderName;
    cell.serviceManL.text = [NSString stringWithFormat:@"顾问：%@", item.serviceConsultant];
    cell.licenL.text = [NSString stringWithFormat:@"客户车辆：%@", item.licenNum];
    cell.totalL.text = [NSString stringWithFormat:@"总计：￥%@", item.taxSaleTotal];
    cell.orderSnL.text = item.mentNo;
    cell.timeL.text = item.createDate;
    return cell;
}

#pragma mark - Request

- (void)headerRequest {
    pageIndex = 1;
	NSDate *date = [NSDate date];
	NSString *dateString = nil;
	if (_selectedIndex != -1) {
		dateString = [NSString stringWithFormat:@"%ld-%02ld-%02ld", date.year, date.month, _selectedIndex+1];
	} else {
		dateString = [NSString stringWithFormat:@"%ld-%02ld-%02ld", date.year, date.month, date.day];
	}
	[[HttpClient sharedHttpClient] getCostOrderListWithName:_costObjectName storeId:self.storeId dateString:dateString pageIndex:pageIndex pageSize:pageSize completion:^(BOOL success, NSArray *data) {
        if (success) {
            if (data.count > 0) {
                self.data = [data mutableCopy];
                pageIndex += 1;
                [self.tableView.mj_footer resetNoMoreData];
            } else {
                self.data = nil;
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
    } failure:^{
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
}

- (void)footerRequest {
	NSDate *date = [NSDate date];
	NSString *dateString = nil;
	if (_selectedIndex != -1) {
		dateString = [NSString stringWithFormat:@"%ld-%02ld-%02ld", date.year, date.month, _selectedIndex+1];
	} else {
		dateString = [NSString stringWithFormat:@"%ld-%02ld-%02ld", date.year, date.month, date.day];
	}
	[[HttpClient sharedHttpClient] getCostOrderListWithName:_costObjectName storeId:self.storeId dateString:dateString pageIndex:pageIndex pageSize:pageSize completion:^(BOOL success, NSArray *data) {
        if (success) {
            if (data.count > 0) {
                [self.data addObjectsFromArray:[data mutableCopy]];
                pageIndex += 1;
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            [self.tableView reloadData];
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^{
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
}

@end
