//
//  IndexHeaderView.m
//  ShopManager
//
//  Created by 张旭 on 18/10/2016.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "IndexHeaderView.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface IndexHeaderView ()<UIWebViewDelegate> {
	UIView *view;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation IndexHeaderView

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
	[self addSubview:view];
	[self initExtra];
}

- (UIView *)loadFromNib {
	UIView *xibView = [[[UINib nibWithNibName:@"IndexHeaderView" bundle:nil] instantiateWithOwner:self options:nil] firstObject];
	return xibView;
}

- (void)initExtra {
	NSString *path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"html"];
	NSURL *url = [NSURL URLWithString:path];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[self.webView loadRequest:request];
	self.webView.scrollView.scrollEnabled = NO;
}

- (void)setJsStr:(NSString *)jsStr {
	_jsStr = jsStr;
	[self.webView reload];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
	context[@"clickIndex"] = ^() {

		NSArray *args = [JSContext currentArguments];
		JSValue *jsVal = args[0];
		NSInteger index = [jsVal toInt32];

		dispatch_async(dispatch_get_main_queue(), ^{
			if (self.chartBlock) {
				self.chartBlock(index);
			}
		});
	};
	[self.webView stringByEvaluatingJavaScriptFromString:self.jsStr];
	[UIView animateWithDuration:0.5 animations:^{
		self.webView.alpha = 1;
	}];
}

@end
