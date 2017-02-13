//
//  DueAnalyseTableViewCell.h
//  ShopManager
//
//  Created by 张旭 on 08/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DueAnalyseTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UILabel *settledMoneyL;
@property (weak, nonatomic) IBOutlet UILabel *unsettledMoneyL;

@end
