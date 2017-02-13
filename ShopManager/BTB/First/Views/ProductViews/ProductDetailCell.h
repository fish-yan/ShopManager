//
//  ProductDetailCell.h
//  BTB
//
//  Created by 薛焱 on 16/2/18.
//  Copyright © 2016年 薛焱. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *productDetailButton;
@property (weak, nonatomic) IBOutlet UIButton *productParameterButton;
@property (weak, nonatomic) IBOutlet UIView *moveView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moveViewLeftMargin;

@end
