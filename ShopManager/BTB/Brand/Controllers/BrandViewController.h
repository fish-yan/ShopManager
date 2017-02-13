//
//  BrandViewController.h
//  Cjmczh
//
//  Created by cjm-ios on 15/12/31.
//  Copyright © 2015年 Cjm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrandViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate >

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleConstraint;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end
