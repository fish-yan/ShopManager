//
//  HeaderView.m
//  BTB
//
//  Created by 薛焱 on 16/2/3.
//  Copyright © 2016年 薛焱. All rights reserved.
//

#import "HeaderView.h"
#import "FirstSectionViewCell.h"
@interface HeaderView ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSTimer *timer;


@end

@implementation HeaderView 

- (void)awakeFromNib{
    self.headerScrollView.delegate = self;
    self.headerScrollView.contentOffset = CGPointMake(kScreenWidth * 2, 0);
    //
    self.headerPageControl.pages = 3;
    self.headerPageControl.tintColor = [UIColor colorWithWhite:1 alpha:0.5];
    self.headerPageControl.currentPageColor = [UIColor whiteColor];
    self.headerPageControl.pageViewSize = CGSizeMake(18, 5);
    //
    self.collectionPageControl.currentPageColor = UIColorFromRGB(0x049CD4);
    self.collectionPageControl.pageViewSize = CGSizeMake(18, 2);
    self.collectionPageControl.backgroundColor = [UIColor redColor];
    self.collectionPageControl.tintColor = UIColorFromRGB(0xc3c3c3);
    [self addTimer];
}

- (void)nextImage{
    [self.headerScrollView setContentOffset:CGPointMake(self.headerScrollView.contentOffset.x + self.bounds.size.width, 0) animated:YES];
}

- (void)addTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x == 0) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentSize.width - 2*kScreenWidth, 0) animated:NO];
    }else if (scrollView.contentOffset.x == scrollView.contentSize.width-kScreenWidth){
        [scrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:NO];
    }
    self.headerPageControl.currentPage = scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width - 1;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.timer invalidate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addTimer];
}


@end
