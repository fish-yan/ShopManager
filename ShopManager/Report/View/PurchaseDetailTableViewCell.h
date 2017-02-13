//
//  PurchaseDetailTableViewCell.h
//  ShopManager
//
//  Created by 张旭 on 07/11/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PurchaseDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *numL;
@property (weak, nonatomic) IBOutlet UILabel *orderTypeL;
@property (weak, nonatomic) IBOutlet UILabel *settleTypeL;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;

@end
