//
//  CustomPageControl.h
//  BTB
//
//  Created by 薛焱 on 16/2/23.
//  Copyright © 2016年 薛焱. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomPageControl : UIView
/**
 *  未选中颜色,默认lightGrayColor
 */
@property (nonatomic, strong) UIColor *tintColor;
/**
 *  当前page颜色,默认grayColor
 */
@property (nonatomic, strong) UIColor *currentPageColor;
/**
 *  page个数,默认2
 */
@property (nonatomic, assign) NSInteger pages;
/**
 *  当前page下标
 */
@property (nonatomic, assign) NSInteger currentPage;
/**
 *  每个page的size
 */
@property (nonatomic, assign) CGSize pageViewSize;


@end
