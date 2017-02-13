//
//  AdViewController.m
//  BTB
//
//  Created by 张旭 on 9/6/16.
//  Copyright © 2016 薛焱. All rights reserved.
//

#import "AdViewController.h"
#import "LoginViewController.h"
#import "AdDetailViewController.h"
#import "AdViewModel.h"

@interface AdViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *containerView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;

@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger countDown;
@property (assign, nonatomic) BOOL timeIsUp;
@property (assign, nonatomic) BOOL isVisible;

@property (strong, nonatomic) AdViewModel *viewModel;

@end

@implementation AdViewController

- (void)initAd {
	if (!self.viewModel.shouldSkip) {
		NSInteger imageCount = self.viewModel.adImageList.count;
		if (imageCount == 1) {
			self.pageControl.hidden = YES;
		} else {
			self.pageControl.numberOfPages = imageCount;
		}
		self.containerView.contentSize = CGSizeMake(kScreenWidth*imageCount, kScreenHeight);
		for (int i = 0; i < imageCount; ++i) {
			UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*kScreenWidth, 0, kScreenWidth, kScreenHeight)];
			imageView.image = self.viewModel.adImageList[i];
			imageView.tag = i;
			imageView.userInteractionEnabled = YES;
			UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTap:)];
			[imageView addGestureRecognizer:tapGestureRecognizer];
			[self.containerView addSubview:imageView];
		}
	}
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.countDown = 10;
	self.timeIsUp = NO;
	[self.skipButton setTitle:[NSString stringWithFormat:@"%ld秒后跳过", self.countDown] forState:UIControlStateNormal];
	[self initAd];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	self.isVisible = YES;
	if (!self.timeIsUp) {
		self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeElapsed) userInfo:nil repeats:YES];
	}
	if (self.viewModel.shouldSkip || self.timeIsUp) {
		[self.timer invalidate];
		LoginViewController *vc = [[UIStoryboard storyboardWithName:@"ShopManager" bundle:nil] instantiateInitialViewController];
		[self presentViewController:vc animated:NO completion:nil];
	}
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	self.isVisible = NO;
}

- (AdViewModel *)viewModel {
	if (_viewModel == nil) {
		_viewModel = [[AdViewModel alloc] init];
	}
	return _viewModel;
}

- (void)timeElapsed {
	self.countDown -= 1;
	[self.skipButton setTitle:[NSString stringWithFormat:@"%ld秒后跳过", self.countDown] forState:UIControlStateNormal];
	if (self.countDown == 0) {
		[self.timer invalidate];
		self.timeIsUp = YES;
		if (self.isVisible) {
			LoginViewController *vc = [[UIStoryboard storyboardWithName:@"ShopManager" bundle:nil] instantiateInitialViewController];
			[self presentViewController:vc animated:NO completion:nil];
		}
	}
}

- (BOOL)prefersStatusBarHidden {
	return YES;
}

- (IBAction)skipButtonDidTouch:(id)sender {
	[self.timer invalidate];
	LoginViewController *vc = [[UIStoryboard storyboardWithName:@"ShopManager" bundle:nil] instantiateInitialViewController];
	[self presentViewController:vc animated:NO completion:nil];
}

- (void)imageViewDidTap:(UITapGestureRecognizer *)sender {
	if (![self.viewModel.adURLList[sender.view.tag] isEqualToString:@""]) {
		AdDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AdDetailVC"];
		vc.url = self.viewModel.adURLList[sender.view.tag];
		[self.navigationController pushViewController:vc animated:YES];
	}
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	NSInteger  index = (scrollView.contentOffset.x+kScreenWidth/2)/kScreenWidth;
	[self.pageControl setCurrentPage:index];
}

@end
