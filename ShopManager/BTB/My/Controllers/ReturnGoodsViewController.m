//
//  ReturnGoodsViewController.m
//  Cjmczh
//  退货详情页
//  Created by cjm-ios on 15/12/25.
//  Copyright © 2015年 Cjm. All rights reserved.
//

#import "ReturnGoodsViewController.h"
#import "PriceDetailTableViewCell.h"
#import "ItemOrderTableViewCell.h"
#import "OrderActionTableViewCell.h"
#import "TotalPriceTableViewCell.h"
#import "OrderMsgTableViewCell.h"

@interface ReturnGoodsViewController () {
    NSMutableArray *orderArray;
}

@end

@implementation ReturnGoodsViewController

- (void)initData {
    orderArray = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3", nil];
    UINib *itemONib = [UINib nibWithNibName:@"ItemOrderTableViewCell" bundle:nil];
    [_tableView registerNib:itemONib forCellReuseIdentifier:itemOCell];
    UINib *priceDNib = [UINib nibWithNibName:@"PriceDetailTableViewCell" bundle:nil];
    [_tableView registerNib:priceDNib forCellReuseIdentifier:priceDCell];
    UINib *orderANib = [UINib nibWithNibName:@"OrderActionTableViewCell" bundle:nil];
    [_tableView registerNib:orderANib forCellReuseIdentifier:orderACell];
    UINib *totalPNib = [UINib nibWithNibName:@"TotalPriceTableViewCell" bundle:nil];
    [_tableView registerNib:totalPNib forCellReuseIdentifier:totalPCell];
    UINib *orderDNib = [UINib nibWithNibName:@"OrderMsgTableViewCell" bundle:nil];
    [_tableView registerNib:orderDNib forCellReuseIdentifier:orderMCell];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonDidTouch:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return orderArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *type = orderArray[indexPath.section];
    if (indexPath.row == 0) {
        PriceDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:priceDCell];
        cell.contentL.text = @"共2件商品";
        cell.contentL.font = [UIFont systemFontOfSize:12];
        cell.contentL.textColor = UIColorFromRGB(0x333333);
        if ([type isEqualToString:@"1"]) {
            cell.priceL.text = @"请退货";
        }else if ([type isEqualToString:@"2"]) {
            cell.priceL.text = @"退款审核中";
        }else {
            cell.priceL.text = @"退款成功";
        }
        return cell;
    }else if (indexPath.row == 1) {
        ItemOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemOCell];
        return cell;
    }else {
        if ([type isEqualToString:@"1"]) {
            OrderActionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderACell];
            cell.cancelBtn.hidden = YES;
            cell.commitBtn.layer.borderWidth = 0.5;
            cell.commitBtn.layer.borderColor = [[UIColor grayColor] CGColor];
            [cell.commitBtn setTitle:@"填写物流" forState:UIControlStateNormal];
            [cell.commitBtn setBackgroundColor:[UIColor whiteColor]];
            return cell;
        }else if ([type isEqualToString:@"2"]) {
            OrderMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderMCell];
            cell.titleL.hidden = YES;
            cell.contentL.text = @"交易金额：￥0.0";
            return cell;
        }else {
            TotalPriceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:totalPCell];
            cell.totalItemNumL.text = @"交易金额：￥0.0   退款金额:";
            return cell;
        }
    }
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section >0) {
        return 7;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_tableView.frame), 7)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 30;
    }else if (indexPath.row == 1) {
        return 80;
    }else {
        NSString *type = orderArray[indexPath.section];
        if ([type isEqualToString:@"1"]) {
            return 43;
        }else if ([type isEqualToString:@"2"]) {
            return 35;
        }else {
            return 37;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
