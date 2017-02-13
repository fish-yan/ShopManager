//
//  BBSDetailViewController.m
//  ShopManager
//
//  Created by 张旭 on 2/24/16.
//  Copyright © 2016 Cjm. All rights reserved.
//

#import "BBSDetailViewController.h"
#import "BBSContentTableViewCell.h"
#import "BBSCommentTableViewCell.h"
#import "BBSTitleTableViewCell.h"
#import "HttpClient.h"
#import "ShopManager-Swift.h"

@import MBProgressHUD;

@interface BBSDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (strong, nonatomic) BBSDetail *bbsData;
@end

@implementation BBSDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 150;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self bbsDetailRequest];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}


- (IBAction)backButtonDidTouch:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendButtonDidTouch:(id)sender {
    [self replyRequestWithId:self.idStr content:self.textField.text];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (UIImage *)resizeImage:(UIImage *)image scale:(CGFloat)scale {
	CGSize newSize = CGSizeMake(image.size.width*scale, image.size.height*scale);
	CGRect rect = CGRectMake(0, 0, newSize.width, newSize.height);
	UIGraphicsBeginImageContextWithOptions(newSize, NO, 3.0);
	[image drawInRect:rect];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.bbsData == nil) {
		return 0;
	}
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return self.bbsData == nil ? 1 : self.bbsData.answerList.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"BBSTitleCell"];
            ((BBSTitleTableViewCell *)cell).titleLabel.text = self.bbsData.title;
            ((BBSTitleTableViewCell *)cell).dateLabel.text = self.bbsData.addDate;
            return cell;
        }
        cell = [tableView dequeueReusableCellWithIdentifier:@"BBSContentCell"];
        NSMutableAttributedString *attributedString =
        [[NSMutableAttributedString alloc] initWithData:[self.bbsData.brief dataUsingEncoding:NSUTF8StringEncoding]
                                         options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)}
                              documentAttributes:nil error:nil];
		[attributedString enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attributedString.length) options:NSAttributedStringEnumerationReverse usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
			NSTextAttachment *attatchment = value;
			UIImage *image = [attatchment imageForBounds:attatchment.bounds textContainer:[[NSTextContainer alloc] init] characterIndex:range.location];
			if (image == nil) {
				return;
			}
			if (image.size.width > kScreenWidth-20) {
				UIImage *newImage = [self resizeImage:image scale:(kScreenWidth-20)/image.size.width];
				NSTextAttachment *newAttachment = [[NSTextAttachment alloc] init];
				newAttachment.image = newImage;
				[attributedString addAttribute:NSAttachmentAttributeName value:newAttachment range:range];
			}
		}];
		((BBSContentTableViewCell *)cell).contentLabel.attributedText = attributedString;
        return cell;
    }
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"BBSCommentHeadCell"];
        return cell;
    }
    cell = [tableView dequeueReusableCellWithIdentifier:@"BBSCommentCell"];
    Answer *answer = [self.bbsData.answerList objectAtIndex:indexPath.row-1];
    ((BBSCommentTableViewCell *)cell).nameLabel.text = answer.userName;
    ((BBSCommentTableViewCell *)cell).timeLabel.text = answer.addDate;
    ((BBSCommentTableViewCell *)cell).commentLabel.text = answer.content;
    return cell;
}

#pragma mark - Request

- (void)bbsDetailRequest {
    [[HttpClient sharedHttpClient] getBBSDetailWithID:self.idStr completion:^(BOOL success, BBSDetail *data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success) {
            self.bbsData = data;
			self.bbsData.brief = [self.bbsData.brief stringByReplacingOccurrencesOfString:@"\n" withString:@""];
			self.bbsData.brief = [self.bbsData.brief stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            [self.tableView reloadData];
            
        }
    } failure:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)replyRequestWithId:(NSString *)idStr content:(NSString *)content {
    [[HttpClient sharedHttpClient] replyWithId:idStr Text:content completion:^(BOOL success) {
        if (success) {
            [self.textField setText:@""];
            [self bbsDetailRequest];
        }
    } failure:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

@end
