//
//  OrderActionTableViewCell.h
//  Cjmczh
//
//  Created by cjm-ios on 15/12/25.
//  Copyright © 2015年 Cjm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderActionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (nonatomic, copy) NSString *orderType;

@end
