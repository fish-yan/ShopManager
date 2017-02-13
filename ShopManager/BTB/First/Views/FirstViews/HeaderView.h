//
//  HeaderView.h
//  BTB
//
//  Created by 薛焱 on 16/2/3.
//  Copyright © 2016年 薛焱. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPageControl.h"

@interface HeaderView : UIView 
@property (weak, nonatomic) IBOutlet UIScrollView *headerScrollView;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *headerImage;
@property (weak, nonatomic) IBOutlet CustomPageControl *headerPageControl;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet CustomPageControl *collectionPageControl;


@end
