//
//  CostOrderDescViewController.m
//  ShopManager
//
//  Created by 张旭 on 6/14/16.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "CostOrderDescViewController.h"
#import "HttpClient.h"
#import "ShopManager-Swift.h"
#import "CostDescHeadTableViewCell.h"
#import "CostDescContactTableViewCell.h"
#import "CostDescProjectTableViewCell.h"
#import "CostDescProductTableViewCell.h"
@import MBProgressHUD;

@interface CostOrderDescViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) CostOrderDesc *data;

@end

@implementation CostOrderDescViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self costDescRequest];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (IBAction)backButtonDidTouch:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 56;
    } else if (indexPath.section == 1) {
        return 76;
    } else if (indexPath.section == 2) {
        return 76;
    } else if (indexPath.section == 3) {
        return 117;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else if (section == 2 && _data.saleProjects.count == 0) {
        return 0;
    } else if (section == 3 && _data.saleProducts.count == 0) {
        return 0;
    }
    return 28;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 28)];
    view.backgroundColor = UIColorFromRGB(0xeeeeee);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-10, 28)];
    label.font = [UIFont systemFontOfSize:13];
    if (section == 1) {
        label.text = @"客户基本信息";
    } else if (section == 2) {
        label.text = @"项目服务";
    } else if (section == 3) {
        label.text = @"项目配件";
    }
    [view addSubview:label];
    return view;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_data == nil) {
        return 0;
    }
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_data == nil) {
        return 0;
    }
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return _data.saleProjects.count;
    } else if (section == 3) {
        return _data.saleProducts.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CostDescHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CostDescHeadCell"];
        cell.countL.text = [NSString stringWithFormat:@"数量总计  %.1f", _data.totalNum];
        cell.totalL.text = [NSString stringWithFormat:@"合计  ￥%.2f", _data.totalPay];
        cell.statusL.text = _data.status;
        return cell;
    } else if (indexPath.section == 1) {
        CostDescContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CostDescContactCell"];
        cell.licenL.text = _data.licenNum;
        cell.nameL.text = _data.memberName;
        cell.telL.text = _data.telNumber;
        return cell;
    } else if (indexPath.section == 2) {
        CostDescProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CostDescProjectCell"];
        cell.titleL.text = _data.saleProjects[indexPath.row].projectName;
        cell.numL.text = [NSString stringWithFormat:@"项目编码 %@", _data.saleProjects[indexPath.row].projectCode];
        cell.priceL.text = [NSString stringWithFormat:@"￥%.2f", _data.saleProjects[indexPath.row].totalPay];
        return cell;
    } else if (indexPath.section == 3) {
        CostDescProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CostDescProductCell"];
        cell.titleL.text = _data.saleProducts[indexPath.row].productName;
        cell.brandL.text = _data.saleProducts[indexPath.row].productSpecification;
        cell.codeL.text = _data.saleProducts[indexPath.row].productCode;
        cell.numL.text = [NSString stringWithFormat:@"%.1f", _data.saleProducts[indexPath.row].amount];
        cell.priceL.text = [NSString stringWithFormat:@"￥%.2f", _data.saleProducts[indexPath.row].totalPay];
        return cell;
    }
    return nil;
}

#pragma mark - Request

- (void)costDescRequest {
    [[HttpClient sharedHttpClient] getCostOrderDescWithId:_idStr completion:^(BOOL success, CostOrderDesc *desc) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success) {
            self.data = desc;
            [self.tableView reloadData];
        }
    } failure:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

@end
