//
//  OrderStateViewController.h
//  Cjmczh
//
//  Created by cjm-ios on 15/12/25.
//  Copyright © 2015年 Cjm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderStateViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *allStateL;
@property (weak, nonatomic) IBOutlet UIButton *readyPayL;
@property (weak, nonatomic) IBOutlet UIButton *readySendL;
@property (weak, nonatomic) IBOutlet UIButton *readyReceivingL;
@property (weak, nonatomic) IBOutlet UIButton *readyCheck;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moveLeftConstraint;
@property (assign, nonatomic) NSInteger btnTag;
@property (weak, nonatomic) IBOutlet UIView *moveLineV;
@end
