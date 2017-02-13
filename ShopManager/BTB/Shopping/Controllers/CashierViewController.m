//
//  CashierViewController.m
//  Cashier
//
//  Created by 薛焱 on 16/1/21.
//  Copyright © 2016年 薛焱. All rights reserved.
//

#import "CashierViewController.h"
#import "PriceTableViewCell.h"
#import "PayStyleTableViewCell.h"

@interface CashierViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *CashierTableView;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, assign) CGFloat allPrice;//总价

@property (strong, nonatomic) NSArray *payMethodImage;
@end

@implementation CashierViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.CashierTableView.tableFooterView = [[UIView alloc]init];
    self.allPrice = 395.99;
    
    self.payMethodImage = [NSArray arrayWithObjects:[UIImage imageNamed:@"wepay"],
                           [UIImage imageNamed:@"alipay"],
                           [UIImage imageNamed:@"cardpay"],
                           [UIImage imageNamed:@"friendpay"], nil];
}

- (IBAction)backButtonDidTouch:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
        default:
            return 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *payStyleArray = @[@"微信支付",@"支付宝",@"银行卡快捷支付",@"朋友代付"];
    if (indexPath.section == 0) {
        PriceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PriceTableViewCell" forIndexPath:indexPath];
        cell.allPriceLabel.text = [NSString stringWithFormat:@"%.2f", self.allPrice];
        return cell;
    }else{
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.textColor = UIColorFromRGB(0x3c3c3c);
            cell.textLabel.text = @"支付方式";
            return cell;
        }
            PayStyleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayStyleTableViewCell" forIndexPath:indexPath];
            cell.payStyleTitleLabel.text = payStyleArray[indexPath.row - 1];
            cell.payStyleImage.image = [self.payMethodImage objectAtIndex:indexPath.row - 1];
            return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]init];
    return footView;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 62.5;
    }else {
        if (indexPath.row == 0) {
            return 30;
        }
        return 42.5;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 7;
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
