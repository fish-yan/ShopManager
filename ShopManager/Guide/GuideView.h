//
//  GuideView.h
//  BTB
//
//  Created by 张旭 on 9/13/16.
//  Copyright © 2016 薛焱. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuideView : UIView

@property (copy, nonatomic) void(^ finishBlock)();

- (void)show;

@end
