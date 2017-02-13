//
//  IndexTendencyCollectionViewCell.h
//  ShopManager
//
//  Created by 张旭 on 18/10/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndexTendencyCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *subTitle1L;
@property (weak, nonatomic) IBOutlet UILabel *subTitle2L;
@property (weak, nonatomic) IBOutlet UILabel *num1L;
@property (weak, nonatomic) IBOutlet UILabel *num2L;
@property (weak, nonatomic) IBOutlet UIImageView *tendencyV;

@end
