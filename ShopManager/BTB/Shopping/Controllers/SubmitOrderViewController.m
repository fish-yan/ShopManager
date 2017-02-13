//
//  SubmitOrderViewController.m
//  Cjmczh
//
//  Created by cjm-ios on 15/12/23.
//  Copyright © 2015年 Cjm. All rights reserved.
//

#import "SubmitOrderViewController.h"
#import "ReceivingAddressTableViewCell.h"
#import "ItemOrderTableViewCell.h"
#import "OrderMsgTableViewCell.h"
#import "TotalPriceTableViewCell.h"
#import "LeaveMsgTableViewCell.h"
#import "SupplierNameCell.h"
#import "OrderDetailViewController.h"
#import "AddressViewController.h"

@interface SubmitOrderViewController () {
    NSMutableArray *itemArray;
    NSMutableDictionary *itemDict;
}


@end

@implementation SubmitOrderViewController

- (void)initData {
    itemArray = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3", nil];
    itemDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:itemArray,@"3M",itemArray,@"美其林", nil];
}

- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    UINib *receivNib = [UINib nibWithNibName:@"ReceivingAddressTableViewCell" bundle:nil];
    [_tableView registerNib:receivNib forCellReuseIdentifier:receivCell];
    UINib *itemONib = [UINib nibWithNibName:@"ItemOrderTableViewCell" bundle:nil];
    [_tableView registerNib:itemONib forCellReuseIdentifier:itemOCell];
    UINib *orderMONib = [UINib nibWithNibName:@"OrderMsgTableViewCell" bundle:nil];
    [_tableView registerNib:orderMONib forCellReuseIdentifier:orderMCell];
    UINib *totalPONib = [UINib nibWithNibName:@"TotalPriceTableViewCell" bundle:nil];
    [_tableView registerNib:totalPONib forCellReuseIdentifier:totalPCell];
    UINib *leaveMNib = [UINib nibWithNibName:@"LeaveMsgTableViewCell" bundle:nil];
    [_tableView registerNib:leaveMNib forCellReuseIdentifier:leaveMCell];
    UINib *supplierNNib = [UINib nibWithNibName:@"SupplierNameCell" bundle:nil];
    [_tableView registerNib:supplierNNib forCellReuseIdentifier:supplierNCell];
}

- (IBAction)commitClick:(id)sender {

    [self performSegueWithIdentifier:@"CashierSegue" sender:self];
}

- (IBAction)unwindToSubmitOrderViewController:(UIStoryboardSegue *)sender{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
}


#pragma mark -UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
        return 1+itemDict.allKeys.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
        if (section == 0) {
            return 1;
        }else{
            NSString *key = itemDict.allKeys[section-1];
            NSArray *array = itemDict[key];
            return array.count+4;
        }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        if (indexPath.section == 0) {
            ReceivingAddressTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:receivCell];
            if (self.address != nil) {
                cell.personL.text = self.address.name;
                cell.phoneL.text = self.address.phone;
                cell.addressL.text = [[[self.address.province stringByAppendingString:self.address.city] stringByAppendingString:self.address.area] stringByAppendingString:self.address.addressDetail];
            }
            
            return cell;
        }else {
            NSString *key = itemDict.allKeys[indexPath.section-1];
            NSArray *array = itemDict[key];
            if (indexPath.row == 0) {
                SupplierNameCell *cell = [_tableView dequeueReusableCellWithIdentifier:supplierNCell];
                return cell;
            } else if (indexPath.row < array.count+1) {
                ItemOrderTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:itemOCell];
                return cell;
            }else if (indexPath.row == array.count+1) {
                OrderMsgTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:orderMCell];
                return cell;
            }else if (indexPath.row == array.count+2) {
                LeaveMsgTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:leaveMCell];
                return cell;
            }else if (indexPath.row == array.count+3) {
                TotalPriceTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:totalPCell];
                return cell;
            }
        }
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
        if (section  == 0) {
            return 30;
        }else{
            return 7;
        }

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:[UIColor clearColor]];
        return view;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        if (indexPath.section == 0) {
            return 76;
        }else {
            NSString *key = itemDict.allKeys[indexPath.section-1];
            NSArray *array = itemDict[key];
            if (indexPath.row == 0) {
                return 48;
            } else if (indexPath.row < array.count+1) {
                return 80;
            }else if (indexPath.row == array.count+1){
                return 36;
            }else if (indexPath.row == array.count+2) {
                return 41;
            }else if (indexPath.row == array.count+3) {
                return 37;
            }
        }
        return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"My" bundle:nil];
        AddressViewController *addressVC = [storyboard instantiateViewControllerWithIdentifier:@"AddressViewController"];
        [self.navigationController showViewController:addressVC sender:self];
    }
}


@end
