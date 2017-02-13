//
//  OrderDetailViewController.m
//  Cjmczh
//  订单状态详情页
//  Created by cjm-ios on 15/12/28.
//  Copyright © 2015年 Cjm. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderMsgTableViewCell.h"
#import "ReceivingAddressTableViewCell.h"
#import "PriceDetailTableViewCell.h"
#import "TotalPriceTableViewCell.h"
#import "ItemOrderTableViewCell.h"
#import "AddressViewController.h"
#import "ProductViewController.h"

@interface OrderDetailViewController () {
    NSMutableArray *itemArray;
    NSMutableDictionary *itemDict;
}


@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    itemArray = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3", nil];
    itemDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:itemArray,@"3M",itemArray,@"美其林", nil];
    UINib *receivNib = [UINib nibWithNibName:@"ReceivingAddressTableViewCell" bundle:nil];
    [_tableView registerNib:receivNib forCellReuseIdentifier:receivCell];
    UINib *orderMONib = [UINib nibWithNibName:@"OrderMsgTableViewCell" bundle:nil];
    [_tableView registerNib:orderMONib forCellReuseIdentifier:orderMCell];
    UINib *itemONib = [UINib nibWithNibName:@"ItemOrderTableViewCell" bundle:nil];
    [_tableView registerNib:itemONib forCellReuseIdentifier:itemOCell];
    UINib *promotionDNib = [UINib nibWithNibName:@"PromotionTableViewCell" bundle:nil];
    [_tableView registerNib:promotionDNib forCellReuseIdentifier:promotionCell];
    UINib *priceDNib = [UINib nibWithNibName:@"PriceDetailTableViewCell" bundle:nil];
    [_tableView registerNib:priceDNib forCellReuseIdentifier:priceDCell];
    UINib *totalPONib = [UINib nibWithNibName:@"TotalPriceTableViewCell" bundle:nil];
    [_tableView registerNib:totalPONib forCellReuseIdentifier:totalPCell];
    [self setOrderBtn];
}

- (IBAction)unwindToOrderDetailViewController:(UIStoryboardSegue *)sender{
    NSIndexPath *indepath = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indepath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)commitClick:(id)sender {
    if ([_orderState isEqualToString:ReadyPay]) {
        NSLog(@"付款");
    }else if ([_orderState isEqualToString:ReadySend]) {
        NSLog(@"提醒发货");
    }else if ([_orderState isEqualToString:ReadyRecev]) {
        NSLog(@"确认收货");
    }else if ([_orderState isEqualToString:ReadyCheck]){
        NSLog(@"待审核");
    }else{
        [self performSegueWithIdentifier:@"valuate" sender:self];
    }
}

- (IBAction)backButtonDidTouch:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelClick:(id)sender {
    if ([_orderState isEqualToString:ReadyPay]) {
        NSLog(@"取消订单");
    }else {
        NSLog(@"查看物流");
    }
}

- (void)setOrderBtn {
    _cancelBtn.layer.cornerRadius = 3;
    _commitBtn.layer.cornerRadius = 3;
    [_commitBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [_commitBtn setBackgroundColor:UIColorFromRGB(0x049CD4)];
    _cancelBtn.layer.borderWidth = 0.5;
    _cancelBtn.layer.borderColor = UIColorFromRGB(0xdddddd).CGColor;
    if ([_orderState isEqualToString:ReadyPay]) {
        [_commitBtn setTitle:@"付款" forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    }else if ([_orderState isEqualToString:ReadySend]) {
        _commitBtn.layer.borderColor = UIColorFromRGB(0xdddddd).CGColor;
        _cancelBtn.hidden = YES;
        [_commitBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_commitBtn setTitle:@"提醒发货" forState:UIControlStateNormal];
    }else if ([_orderState isEqualToString:ReadyRecev]) {
        [_commitBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"查看物流" forState:UIControlStateNormal];
    }else if ([_orderState isEqualToString:ReadyCheck]){
        [_commitBtn setTitle:@"待审核" forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    } else {
        [_commitBtn setTitle:@"去评价" forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"查看物流" forState:UIControlStateNormal];
    }
}


- (NSString *)getOrderMsg {
    if ([_orderState isEqualToString:ReadyPay]) {
        return @"等待买家付款";
    }else if ([_orderState isEqualToString:ReadySend]) {
        return @"店小二即将为您发货";
    }else if ([_orderState isEqualToString:ReadyRecev]) {
        return @"店小二已为您发货";
    }else if ([_orderState isEqualToString:ReadyCheck]) {
        return @"等待审核";
    }else {
        return @"交易成功";
    }
}

- (NSString *)getOrderTime {
    if ([_orderState isEqualToString:ReadyPay]) {
        return @"剩2天23小时自动关闭";
    }else if ([_orderState isEqualToString:ReadySend]) {
        return @"";
    }else if ([_orderState isEqualToString:ReadyRecev]) {
        return @"剩6天23小时自动确认收货";
    }else if ([_orderState isEqualToString:ReadyCheck]) {
        return @"等待审核";
    }else {
        return @"交易成功";
    }
}

#pragma mark -UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 + itemDict.allKeys.count + 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else if (section <= itemDict.allKeys.count) {
        NSString *key = itemDict.allKeys[section - 1];
        NSArray *array = itemDict[key];
        return 1 + array.count;
    }else if (section == itemDict.allKeys.count + 1) {
        return 3;
    }else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            OrderMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderMCell];
            //cell.contentL.hidden = YES;
            cell.lineV.hidden = YES;
            cell.contentL.hidden = NO;
            cell.contentL.text = [self getOrderTime];
            cell.contentL.font = [UIFont systemFontOfSize:10];
            cell.contentL.textColor = UIColorFromRGB(0xFFFFFF);
            cell.titleL.text = [self getOrderMsg];
            cell.titleL.font = [UIFont systemFontOfSize:13];
            cell.titleL.textColor = UIColorFromRGB(0xFFFFFF);
            cell.bgView.backgroundColor = UIColorFromRGB(0x2880C6);
            return cell;
        }else {
            ReceivingAddressTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:receivCell];
            if (self.address != nil) {
                cell.personL.text = self.address.name;
                cell.phoneL.text = self.address.phone;
                cell.addressL.text = [[[self.address.province stringByAppendingString:self.address.city] stringByAppendingString:self.address.area] stringByAppendingString:self.address.addressDetail];
            }
            
            return cell;
        }
    }else if (indexPath.section <= itemDict.allKeys.count) {
        NSString *key = itemDict.allKeys[indexPath.section - 1];
        NSArray *array = itemDict[key];
        if (indexPath.row == 0) {
            PriceDetailTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:priceDCell];
            cell.contentL.text = @"车杰盟有限公司";
            cell.priceL.hidden = YES;
            return cell;
        }else {
            ItemOrderTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:itemOCell];
            if (![_orderState isEqualToString:ReadyPay] && ![_orderState isEqualToString:ReadyCheck]) {
                cell.drawbackButton.hidden = NO;
                [cell.drawbackButton addTarget:self action:@selector(drawbackButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
                cell.numL.hidden = YES;
            }
            if ([_orderState isEqualToString:ReadyEvaluate]) {
                [cell.drawbackButton setTitle:@"申请售后" forState:(UIControlStateNormal)];
            }
            return cell;
        }
    }else if (indexPath.section == itemDict.allKeys.count + 1) {
        PriceDetailTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:priceDCell];
        cell.contentL.text = @"商品金额（含总运费）";
        cell.priceL.text = @"0.0";
        cell.priceL.hidden = NO;
        cell.lineV.hidden = YES;
        return cell;
    }else {
        OrderMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderMCell];
        cell.titleL.text = @"订单编号：1366473522";
        cell.contentL.hidden = YES;
        cell.lineV.hidden = YES;
        cell.titleL.font = [UIFont systemFontOfSize:12];
        cell.titleL.textColor = UIColorFromRGB(0x848484);
        cell.bgView.backgroundColor = UIColorFromRGB(0xffffff);
        return cell;
    }
    return nil;
}

- (void)drawbackButtonAction:(UIButton *)sender{
    if ([sender.titleLabel.text isEqualToString:@"退款"]) {
        [self performSegueWithIdentifier:@"drawback" sender:self];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section > 0) {
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
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 36;
        }else {
            return 77;
        }
    }else if (indexPath.section <= itemDict.allKeys.count) {
        NSString *key = itemDict.allKeys[indexPath.section - 1];
        NSArray *array = itemDict[key];
        if (indexPath.row == 0) {
            return 40;
        }else {
            return 80;
        }
    }else if (indexPath.section == itemDict.allKeys.count + 1) {
        return 30;
    }else {
        return 30;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 ) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"My" bundle:nil];
        AddressViewController *addressVC = [storyboard instantiateViewControllerWithIdentifier:@"AddressViewController"];
        [self.navigationController showViewController:addressVC sender:self];
    } else if (indexPath.section <= itemDict.allKeys.count){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ProductViewController *productVC = [storyboard instantiateViewControllerWithIdentifier:@"detail"];
        [self.navigationController pushViewController:productVC animated:YES];
    }
}

@end
