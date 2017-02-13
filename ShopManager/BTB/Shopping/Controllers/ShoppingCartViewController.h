//
//  ShoppingCartViewController.h
//  Cjmczh
//
//  Created by cjm-ios on 15/12/21.
//  Copyright © 2015年 Cjm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingCartViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>;

@property (weak, nonatomic) IBOutlet UIButton *goBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *dataView;
@property (weak, nonatomic) IBOutlet UIView *emptyView;
@end
