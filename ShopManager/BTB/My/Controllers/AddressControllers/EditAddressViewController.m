//
//  EditAddressViewController.m
//  Cjmczh
//
//  Created by 张旭 on 12/17/15.
//  Copyright © 2015 Cjm. All rights reserved.
//

#import "EditAddressViewController.h"
#import "EditableTableViewCell.h"
#import "DetailTableViewCell.h"

@interface EditAddressViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (strong, nonatomic) NSDictionary *area;

@property (strong, nonatomic) NSMutableArray *pickerArray;
@property (strong, nonatomic) NSMutableArray *subPickerArray;
@property (strong, nonatomic) NSArray *thirdPickerArray;

@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@end

@implementation EditAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.tableView registerNib:[UINib nibWithNibName:@"EditableTableViewCell" bundle:nil] forCellReuseIdentifier:@"EditableTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"DetailTableViewCell"];
    
    [self.pickerView setHidden:YES];
    
    NSString *areaPath = [[NSBundle mainBundle] pathForResource:@"Area" ofType:@"plist"];
    self.area = [[NSDictionary alloc] initWithContentsOfFile:areaPath];
    
    self.pickerArray = [NSMutableArray array];
    self.subPickerArray = [NSMutableArray array];
    for (NSInteger i = 0; i < self.area.count; ++i) {
        [self.pickerArray addObject:[((NSDictionary *)[self.area objectForKey:[NSString stringWithFormat:@"%ld", (long)i]]).keyEnumerator nextObject]];
    }
    NSDictionary *province = [self.area objectForKey:@"0"];
    province = [province objectForKey:[self.pickerArray objectAtIndex:0]];
    NSDictionary *city = nil;
    for (NSInteger i = 0; i < province.count; ++i) {
        city = [province objectForKey:[NSString stringWithFormat:@"%ld", (long)i]];
        [self.subPickerArray addObject:[city.keyEnumerator nextObject]];
    }
    city = [province objectForKey:@"0"];
    self.thirdPickerArray = [city objectForKey:[self.subPickerArray objectAtIndex:0]];
}

- (IBAction)backButtonDidTouch:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveButtonDidTouch:(id)sender {
    if (self.type == NEWADDRESS) {
        if (self.address.name != nil && self.address.phone != nil && self.address.province != nil && self.address.city != nil && self.address.area != nil && self.address.addressDetail != nil) {
            [self.source addNewAddress:self.address];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.pickerView setHidden:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.address == nil) {
        self.address = [[Address alloc] init];
    }
    if (textField.tag == 0) {
        self.address.name = textField.text;
    } else if (textField.tag == 1) {
        self.address.phone = textField.text;
    } else if (textField.tag == 3) {
        self.address.addressDetail = textField.text;
    }
}


#pragma mark - UIPickerViewDelegate


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [self.pickerArray objectAtIndex:row];
    } else if (component == 1) {
        return [self.subPickerArray objectAtIndex:row];
    } else {
        return [self.thirdPickerArray objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        NSDictionary *province = [self.area objectForKey:[NSString stringWithFormat:@"%ld", (long)row]];
        province = [province objectForKey:[self.pickerArray objectAtIndex:row]];
        NSDictionary *city = nil;
        self.subPickerArray = [NSMutableArray array];
        for (NSInteger i = 0; i < province.count; ++i) {
            city = [province objectForKey:[NSString stringWithFormat:@"%ld", (long)i]];
            [self.subPickerArray addObject:[city.keyEnumerator nextObject]];
        }
        city = [province objectForKey:@"0"];
        self.thirdPickerArray = [city objectForKey:[self.subPickerArray objectAtIndex:0]];
        [pickerView selectRow:0 inComponent:1 animated:NO];
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:2 animated:NO];
        [pickerView reloadComponent:2];
    } else if (component == 1) {
        NSInteger selected = [pickerView selectedRowInComponent:0];
        NSDictionary *province = [self.area objectForKey:[NSString stringWithFormat:@"%ld", (long)selected]];
        province = [province objectForKey:[self.pickerArray objectAtIndex:selected]];
        NSDictionary *city = [province objectForKey:[NSString stringWithFormat:@"%ld", (long)row]];
        self.thirdPickerArray = [city objectForKey:[self.subPickerArray objectAtIndex:row]];
        [pickerView selectRow:0 inComponent:2 animated:NO];
        [pickerView reloadComponent:2];
    }
    
    DetailTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.selectedIndexPath];
    if (self.address == nil) {
        self.address = [[Address alloc] init];
    }
    self.address.province = [self.pickerArray objectAtIndex:[pickerView selectedRowInComponent:0]];
    self.address.city = [self.subPickerArray objectAtIndex:[pickerView selectedRowInComponent:1]];
    self.address.area = [self.thirdPickerArray objectAtIndex:[pickerView selectedRowInComponent:2]];
    NSString *address = [self.pickerArray objectAtIndex:[pickerView selectedRowInComponent:0]];
    address = [address stringByAppendingString:[self.subPickerArray objectAtIndex:[pickerView selectedRowInComponent:1]]];
    address = [address stringByAppendingString:[self.thirdPickerArray objectAtIndex:[pickerView selectedRowInComponent:2]]];
    cell.menuLabel.text = address;
}

- (UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel* label = (UILabel*)view;
    if (!label) {
        label = [[UILabel alloc] init];
    }
    [label setTextColor:[UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1.0]];
    [label setFont:[UIFont systemFontOfSize:15]];
    [label setTextAlignment:NSTextAlignmentCenter];
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return label;
}


#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [self.pickerArray count];
    } else if (component == 1) {
        return [self.subPickerArray count];
    } else {
        return [self.thirdPickerArray count];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;
    if (indexPath.row == 2) {
        [self.pickerView setHidden:NO];
        DetailTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (self.address == nil) {
            self.address = [[Address alloc] init];
        }
        self.address.province = [self.pickerArray objectAtIndex:[self.pickerView selectedRowInComponent:0]];
        self.address.city = [self.subPickerArray objectAtIndex:[self.pickerView selectedRowInComponent:1]];
        self.address.area = [self.thirdPickerArray objectAtIndex:[self.pickerView selectedRowInComponent:2]];
        NSString *address = [self.pickerArray objectAtIndex:[self.pickerView selectedRowInComponent:0]];
        address = [address stringByAppendingString:[self.subPickerArray objectAtIndex:[self.pickerView selectedRowInComponent:1]]];
        address = [address stringByAppendingString:[self.thirdPickerArray objectAtIndex:[self.pickerView selectedRowInComponent:2]]];
        cell.menuLabel.text = address;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        DetailTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DetailTableViewCell"];
        if (self.type == NEWADDRESS) {
            cell.menuLabel.text = @"省、市、区";
        } else {
            cell.menuLabel.text = [[self.address.province stringByAppendingString:self.address.city] stringByAppendingString:self.address.area];
        }
        return cell;
    }
    EditableTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"EditableTableViewCell"];
    cell.editText.tag = indexPath.row;
    if (indexPath.row == 0) {
        if (self.type == MODIFYADDRESS) {
            cell.editText.text = self.address.name;
        }
        cell.editText.placeholder = @"收货人姓名";
    } else if (indexPath.row == 1) {
        if (self.type == MODIFYADDRESS) {
            cell.editText.text = self.address.phone;
        }
        cell.editText.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        cell.editText.placeholder = @"联系方式";
    } else if (indexPath.row == 3) {
        if (self.type == MODIFYADDRESS) {
            cell.editText.text = self.address.addressDetail;
        }
        cell.editText.placeholder = @"详细地址";
    }
    cell.editText.delegate = self;
    return cell;
}

@end
