//
//  EditAddressViewController.h
//  Cjmczh
//
//  Created by 张旭 on 12/17/15.
//  Copyright © 2015 Cjm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Address.h"
#import "AddressViewController.h"

#define NEWADDRESS 0
#define MODIFYADDRESS 1

@interface EditAddressViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>
@property (strong, nonatomic) Address *address;
@property (assign, nonatomic) NSInteger type;
@property (weak, nonatomic) AddressViewController *source;
@end
