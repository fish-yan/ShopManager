//
//  CostOrderTableViewCell.h
//  ShopManager
//
//  Created by 张旭 on 6/14/16.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CostOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *serviceManL;
@property (weak, nonatomic) IBOutlet UILabel *licenL;
@property (weak, nonatomic) IBOutlet UILabel *totalL;
@property (weak, nonatomic) IBOutlet UILabel *orderSnL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;

@end
