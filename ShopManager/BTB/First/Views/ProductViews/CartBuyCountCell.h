//
//  CartBuyCountCell.h
//  BTB
//
//  Created by 薛焱 on 16/2/17.
//  Copyright © 2016年 薛焱. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartBuyCountCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UITextField *countTF;

@end
