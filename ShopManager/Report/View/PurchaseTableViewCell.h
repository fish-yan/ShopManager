//
//  PurchaseTableViewCell.h
//  ShopManager
//
//  Created by 张旭 on 07/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PurchaseTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *inCountL;
@property (weak, nonatomic) IBOutlet UILabel *backCountL;
@property (weak, nonatomic) IBOutlet UILabel *totalCountL;

@end
