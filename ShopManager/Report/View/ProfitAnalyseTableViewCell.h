//
//  ProfitAnalyseTableViewCell.h
//  ShopManager
//
//  Created by 张旭 on 20/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfitAnalyseTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UILabel *ratioL;
@property (weak, nonatomic) IBOutlet UILabel *percentL;

@end
