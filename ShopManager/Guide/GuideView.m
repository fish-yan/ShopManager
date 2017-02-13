//
//  GuideView.m
//  BTB
//
//  Created by 张旭 on 9/13/16.
//  Copyright © 2016 薛焱. All rights reserved.
//

#import "GuideView.h"

@interface GuideView () {
	UIView *view;
}

@property(weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation GuideView

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	[self xibSetup];
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	[self xibSetup];
	return self;
}

- (void)xibSetup {
	view = [self loadFromNib];
	view.frame = self.bounds;
	view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	[self addSubview:view];
	[self initGuides];
}

- (UIView *)loadFromNib {
	UINib *nib = [UINib nibWithNibName:@"GuideView" bundle:nil];
	UIView *xibView = [[nib instantiateWithOwner:self options:nil] firstObject];
	return xibView;
}

- (void)initGuides {
	NSArray *imageList = @[@"guide-1", @"guide-2", @"guide-3"];
	self.scrollView.contentSize = CGSizeMake(kScreenWidth*imageList.count, kScreenHeight);
	for (NSInteger i = 0; i < imageList.count; ++i) {
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*kScreenWidth, 0, kScreenWidth, kScreenHeight)];
		imageView.image = [UIImage imageNamed:imageList[i]];
		if (i == imageList.count-1) {
			imageView.userInteractionEnabled = YES;
			UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTap:)];
			[imageView addGestureRecognizer:tapGestureRecognizer];
		}
		[self.scrollView addSubview:imageView];
	}
}

- (void)imageViewDidTap:(UITapGestureRecognizer *)sender {
	[self hideWithTime:0.8];
}

- (void)show {
	NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
	NSInteger currentBuild = [appInfo[@"CFBundleVersion"] integerValue];
	NSInteger savedBuild = [[[NSUserDefaults standardUserDefaults] objectForKey:@"savedBuild"] integerValue];
	if (savedBuild != currentBuild) {
		self.alpha = 1;
		self.scrollView.contentOffset = CGPointMake(0, 0);
		[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:currentBuild] forKey:@"savedBuild"];
	} else {
		[self hideWithTime:0];
	}
}

- (void)hideWithTime:(NSInteger)time {
	[UIView animateWithDuration:time animations:^{
		self.alpha = 0;
	} completion:^(BOOL finished) {
		if (self.finishBlock) {
			self.finishBlock();
		}
	}];
}


@end
