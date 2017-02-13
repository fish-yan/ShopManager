//
//  AddressViewController.m
//  Cjmczh
//
//  Created by 张旭 on 12/17/15.
//  Copyright © 2015 Cjm. All rights reserved.
//

#import "AddressViewController.h"
#import "AddressInfoTableViewCell.h"
#import "AddressButtonTableViewCell.h"
#import "EditAddressViewController.h"
#import "OrderDetailViewController.h"
#import "SubmitOrderViewController.h"

@interface AddressViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *addressArray;

@property (nonatomic, strong) Address *address;
@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 150;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.addressArray = [NSMutableArray new];
    Address *address = [[Address alloc] init];
    address.name = @"阿呆";
    address.phone = @"12345678910";
    address.province = @"湖北省";
    address.city = @"武汉市";
    address.area = @"硚口区";
    address.addressDetail = @"保利香饼国际10栋";
    address.isDefault = YES;
    [self.addressArray addObject:address];
    address = [[Address alloc] init];
    address.name = @"阿呆2";
    address.phone = @"10987654321";
    address.province = @"湖北省";
    address.city = @"武汉市";
    address.area = @"硚口区";
    address.addressDetail = @"保利香饼国际9栋";
    address.isDefault = NO;
    [self.addressArray addObject:address];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)addNewAddress:(Address *)addr {
    [self.addressArray addObject:addr];
}

- (IBAction)selectButtonDidTouch:(id)sender {
    NSInteger index = ((UIButton *)sender).tag;
    for (NSInteger i = 0; i < self.addressArray.count; ++i) {
        Address *addr = [self.addressArray objectAtIndex:i];
        if (i != index) {
            addr.isDefault = NO;
        } else {
            addr.isDefault = YES;
        }
    }
    [self.tableView reloadData];
}

- (IBAction)editButtonDidTouch:(id)sender {
    [self performSegueWithIdentifier:@"EditAddressSegue" sender:sender];
}

- (IBAction)deleteButtonDidTouch:(id)sender {
    NSInteger index = ((UIButton *)sender).tag;
    [self.addressArray removeObjectAtIndex:index];
    [self.tableView reloadData];
}

- (IBAction)addAddressButtonDidTouch:(id)sender {
    [self performSegueWithIdentifier:@"AddAddressSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EditAddressSegue"]) {
        UIButton *editButton = sender;
        EditAddressViewController *toView = segue.destinationViewController;
        toView.address = [self.addressArray objectAtIndex:editButton.tag];
        toView.type = MODIFYADDRESS;
    } else if ([segue.identifier isEqualToString:@"AddAddressSegue"]) {
        EditAddressViewController *toView = segue.destinationViewController;
        toView.source = self;
        toView.type = NEWADDRESS;
    } else if ([segue.identifier isEqualToString:@"unwindSubmint"]){
        SubmitOrderViewController *submintVC = segue.destinationViewController;
        submintVC.address = sender;
        
        
    } else if ([segue.identifier isEqualToString:@"unwindOrderDetail"]){
        OrderDetailViewController *orderVC = segue.destinationViewController;
        orderVC.address = sender;
    }
}

- (IBAction)backButtonDidTouch:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Address *addr = [self.addressArray objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"unwindSubmint" sender:addr];
        [self performSegueWithIdentifier:@"unwindOrderDetail" sender:addr];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 64;
    } else {
        return 40;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}


#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.addressArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Address *addr = [self.addressArray objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        AddressInfoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"AddressInfoCell"];
        cell.nameLabel.text = addr.name;
        cell.phoneLabel.text = addr.phone;
        NSString * addrString = [[[addr.province stringByAppendingString:addr.city] stringByAppendingString:addr.area] stringByAppendingString:addr.addressDetail];
        cell.addressLabel.text = addrString;
        
        return  cell;
    } else {
        AddressButtonTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"AddressButtonCell"];
        cell.selectButton.tag = indexPath.section;
        cell.editButton.tag = indexPath.section;
        cell.deleteButton.tag = indexPath.section;
        if (addr.isDefault) {
            [cell.selectButton setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        } else {
            [cell.selectButton setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        }
        return cell;
    }
}




@end
