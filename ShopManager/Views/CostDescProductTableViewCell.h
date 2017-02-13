//
//  CostDescProductTableViewCell.h
//  ShopManager
//
//  Created by 张旭 on 6/15/16.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CostDescProductTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *brandL;
@property (weak, nonatomic) IBOutlet UILabel *codeL;
@property (weak, nonatomic) IBOutlet UILabel *numL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;

@end
