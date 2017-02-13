//
//  OrderStateViewController.m
//  Cjmczh
//  订单状态列表页
//  Created by cjm-ios on 15/12/25.
//  Copyright © 2015年 Cjm. All rights reserved.
//

#import "OrderStateViewController.h"
#import "PriceDetailTableViewCell.h"
#import "ItemOrderTableViewCell.h"
#import "OrderActionTableViewCell.h"
#import "OrderDetailViewController.h"

@interface OrderStateViewController () {
    NSMutableArray *itemArray;
    NSMutableArray *btnArray;
    NSString *orderType;
}

@end

@implementation OrderStateViewController

- (void)initData {
    btnArray = [[NSMutableArray alloc] initWithObjects:_allStateL,_readyCheck,_readyPayL,_readySendL,_readyReceivingL, nil];
    switch (_btnTag) {
        case 1:
            orderType = ReadyCheck ;
            break;
        case 2:
            orderType = ReadyPay ;
            break;
        case 3:
            orderType = ReadySend ;
            break;
        case 4:
            orderType = ReadyRecev;
            break;
        default:
            break;
    }
    UIButton *btn = btnArray[_btnTag];
    [self changeOrMoveTitle:btn];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self request];
    }];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    // Do any additional setup after loading the view.
    itemArray = [[NSMutableArray alloc] initWithObjects:@"1",@"2", nil];
    UINib *itemONib = [UINib nibWithNibName:@"ItemOrderTableViewCell" bundle:nil];
    [_tableView registerNib:itemONib forCellReuseIdentifier:itemOCell];
    UINib *priceDNib = [UINib nibWithNibName:@"PriceDetailTableViewCell" bundle:nil];
    [_tableView registerNib:priceDNib forCellReuseIdentifier:priceDCell];
    UINib *orderANib = [UINib nibWithNibName:@"OrderActionTableViewCell" bundle:nil];
    [_tableView registerNib:orderANib forCellReuseIdentifier:orderACell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeOrMoveTitle:(UIButton *)btn {
    for (UIButton *cbtn in btnArray) {
        if (btn == cbtn) {
            [btn setTitleColor:UIColorFromRGB(0x049CD4) forState:UIControlStateNormal];
            
        }else {
            [cbtn setTitleColor:UIColorFromRGB(0x949494) forState:UIControlStateNormal];
        }
    }
    NSInteger tag = btn.tag;
    switch (tag) {
        case 0:
            orderType = AllOrder;
            break;
        case 1:
            orderType = ReadyCheck;
            break;
        case 2:
            orderType = ReadyPay;
            break;
        case 3:
            orderType = ReadySend;
            break;
        case 4:
            orderType = ReadyRecev;
            break;
        default:
            break;
    }
    float width = CGRectGetWidth([UIScreen mainScreen].bounds);
    float btnWidth = width/btnArray.count;
    [UIView animateWithDuration:0.8 animations:^{
        _moveLeftConstraint.constant = (tag) * btnWidth;
        [_moveLineV layoutIfNeeded];
        [_tableView reloadData];
    }];
}

- (IBAction)backButtonDidTouch:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)stateClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [self changeOrMoveTitle:btn];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"orderDetail"]) {
        
        ((OrderDetailViewController *)segue.destinationViewController).orderState = sender;
    }
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderActionTableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1+itemArray.count inSection:indexPath.section]];
    
    if (indexPath.row > 0 && indexPath.row < 1+itemArray.count) {
        
        [self performSegueWithIdentifier:@"orderDetail" sender:cell.orderType];
    }
}

#pragma mark -UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([orderType isEqualToString:AllOrder]) {
        return 5;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1+itemArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *orderTypeArray = @[ReadyCheck, ReadyPay, ReadySend, ReadyRecev, ReadyEvaluate];
    if (indexPath.row == 0) {
        PriceDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:priceDCell];
        cell.contentL.text = @"共2件商品";
        cell.contentL.font = [UIFont systemFontOfSize:12];
        cell.contentL.textColor = UIColorFromRGB(0x333333);
        if ([orderType isEqualToString:AllOrder]) {
            cell.priceL.text = orderTypeArray[indexPath.section];
        }else{
         cell.priceL.text = orderType;
        }
        return cell;
    }else if (indexPath.row <= itemArray.count) {
        ItemOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemOCell];
        return cell;
    }else {
        OrderActionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderACell];
        if ([orderType isEqualToString:AllOrder]) {
            cell.orderType = orderTypeArray[indexPath.section];
        }else{
            cell.orderType = orderType;
        }
        [cell.commitBtn addTarget:self action:@selector(commitBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        return cell;
    }
    
}

- (void)commitBtnAction:(UIButton *)sender{
    if ([sender.titleLabel.text isEqualToString:@"付款"]) {
        NSLog(@"付款");
    }else if ([sender.titleLabel.text isEqualToString:@"确认收货"]) {
        NSLog(@"确认收货");
    }else if ([sender.titleLabel.text isEqualToString:@"提醒发货"]) {
        NSLog(@"提醒发货");
    }else if ([sender.titleLabel.text isEqualToString:@"待审核"]) {
        NSLog(@"待审核");
    }else{
        [self performSegueWithIdentifier:@"valuate" sender:self];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 30;
    }else if (indexPath.row <= itemArray.count) {
        return 80;
    }else {
        return 43;
    }
}

#pragma mark - request
- (void)request {
    [_tableView.mj_header endRefreshing];
}

@end
