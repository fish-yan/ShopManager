//
//  UIButton+BadgeView.m
//  Cjmczh
//
//  Created by 张旭 on 1/29/16.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "UIButton+BadgeView.h"

@implementation UIButton (BadgeView)

- (void)setBadgeCount:(NSInteger)count {
    if (self.subviews.count == 0) {
        BadgeView *view = [[BadgeView alloc] initWithFrame:self.bounds];
        [self addSubview:view];
    }
    BadgeView *badge = [self.subviews objectAtIndex:0];
    [badge setCount: count];
    if (count == 0) {
        [badge setHidden:YES];
    } else {
        [badge setHidden:NO];
    }
}

@end
