//
//  CustomPageControl.m
//  BTB
//
//  Created by 薛焱 on 16/2/23.
//  Copyright © 2016年 薛焱. All rights reserved.
//

#import "CustomPageControl.h"

@interface CustomPageControl ()

@property (nonatomic, strong) NSMutableArray *pageViews;

@end

@implementation CustomPageControl

- (UIColor *)tintColor{
    if (_tintColor == nil) {
        return [UIColor lightGrayColor];
    }
    return _tintColor;
}
- (UIColor *)currentPageColor{
    if (_currentPageColor == nil) {
        [UIColor grayColor];
    }
    return _currentPageColor;
}
- (NSInteger)pages{
    if (_pages == 0) {
        return 2;
    }
    return _pages;
}
- (CGSize)pageViewSize{
    if (_pageViewSize.height == 0 || _pageViewSize.width == 0) {
        return CGSizeMake(18, 5);
    }
    return _pageViewSize;
}

- (void)awakeFromNib{
    self.pageViews = [NSMutableArray array];
    self.backgroundColor = [UIColor clearColor];
    [self creatPageView];
    [self addObserver:self forKeyPath:@"currentPage" options:(NSKeyValueObservingOptionNew) context:nil];
}

- (void)creatPageView{
    for (int i = 0; i < self.pages; i++ ) {
        UIView *pageView = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width / 2 - (self.pageViewSize.width * self.pages + (self.pages - 1) * 5) / 2 + (self.pageViewSize.width + 5) * i, self.frame.size.height / 2 - self.pageViewSize.height / 2, self.pageViewSize.width, self.pageViewSize.height)];
        pageView.tag = i;
        if (pageView.tag == self.currentPage) {
            pageView.backgroundColor = self.currentPageColor;
        }else{
            pageView.backgroundColor = self.tintColor;
        }
        [self addSubview:pageView];
        [self.pageViews addObject:pageView];
    }
    self.bounds = CGRectMake(0, 0, self.pageViewSize.width * self.pages + 5 * (self.pages - 1), self.pageViewSize.height);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"currentPage"]) {
        for (UIView *pageView in self.pageViews) {
            if (pageView.tag == [change[@"new"] integerValue]) {
                pageView.backgroundColor = self.currentPageColor;
            }else{
                pageView.backgroundColor = self.tintColor;
            }
        }
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
