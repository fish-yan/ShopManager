//
//  IndexHeaderCollectionViewCell.h
//  ShopManager
//
//  Created by 张旭 on 18/10/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndexHeaderCollectionViewCell : UICollectionViewCell

@property (copy, nonatomic) void(^ buttonBlock)(NSInteger index);

@end
