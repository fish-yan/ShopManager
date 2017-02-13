//
//  SubmitOrderViewController.h
//  Cjmczh
//
//  Created by cjm-ios on 15/12/23.
//  Copyright © 2015年 Cjm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Address.h"

@interface SubmitOrderViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) Address *address;

@end
