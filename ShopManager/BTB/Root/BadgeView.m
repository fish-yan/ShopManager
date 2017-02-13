//
//  BadgeView.m
//  Cjmczh
//
//  Created by 张旭 on 1/29/16.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "BadgeView.h"

@interface BadgeView()

@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation BadgeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.count = 0;
    self.frame = CGRectMake(frame.size.width/2+5, 5, 16, 16);
    self.layer.cornerRadius = 8;
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    self.imageView.image = [UIImage imageNamed:@"shuliang"];
    [self addSubview:self.imageView];
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    [self.contentLabel setFont:[UIFont systemFontOfSize:11]];
    [self.contentLabel setTextColor:[UIColor whiteColor]];
    self.contentLabel.text = [NSString stringWithFormat:@"%ld", (long)self.count];
    [self.contentLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.contentLabel];
    return self;
}

- (void)setCount:(NSInteger)count {
    _count = count;
    self.contentLabel.text = [NSString stringWithFormat:@"%ld", (long)self.count];
}

@end
