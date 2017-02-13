//
//  StarCollectionViewCell.h
//  ShopManager
//
//  Created by 张旭 on 2/24/16.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StarCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starWidthConstraint;
@property (assign, nonatomic) CGFloat starWidth;

@end
