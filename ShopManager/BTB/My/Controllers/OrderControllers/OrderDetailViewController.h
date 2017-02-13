//
//  OrderDetailViewController.h
//  Cjmczh
//
//  Created by cjm-ios on 15/12/28.
//  Copyright © 2015年 Cjm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Address.h"

@interface OrderDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (retain, nonatomic) NSString *orderState;
@property (nonatomic, strong) Address *address;

@end

