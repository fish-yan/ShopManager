//
//  RatingBar.m
//  testStar
//
//  Created by 薛焱 on 16/1/5.
//  Copyright © 2016年 薛焱. All rights reserved.
//

#import "RatingBar.h"

@interface RatingBar (){
    
    float starRating;
    float lastRating;
    
    float height;
    float width;
    
    UIImage *unSelectedImage;
    UIImage *halfSelectedImage;
    UIImage *fullSelectedImage;
}

@property (nonatomic,strong) UIImageView *s1;
@property (nonatomic,strong) UIImageView *s2;
@property (nonatomic,strong) UIImageView *s3;
@property (nonatomic,strong) UIImageView *s4;
@property (nonatomic,strong) UIImageView *s5;

@property (nonatomic,weak) id<RatingBarDelegate> delegate;


@end

@implementation RatingBar

/**
 *  初始化设置未选中图片、半选中图片、全选中图片，以及评分值改变的代理（可以用
 *  Block）实现
 *
 *  @param deselectedName   未选中图片名称
 *  @param halfSelectedName 半选中图片名称
 *  @param fullSelectedName 全选中图片名称
 *  @param delegate          代理
 */
-(void)setImageDeselected:(NSString *)deselectedName halfSelected:(NSString *)halfSelectedName fullSelected:(NSString *)fullSelectedName andDelegate:(id<RatingBarDelegate>)delegate{
    
    self.delegate = delegate;
    
    unSelectedImage = [UIImage imageNamed:deselectedName];
    halfSelectedImage = halfSelectedName == nil ? unSelectedImage : [UIImage imageNamed:halfSelectedName];
    fullSelectedImage = [UIImage imageNamed:fullSelectedName];
    
    if (self.frame.size.width < self.frame.size.height * 5) {
        width = self.frame.size.width / 5;
        height = self.frame.size.width / 5 * unSelectedImage.size.height / unSelectedImage.size.width;
    }else {
        height = self.frame.size.height;
        width = self.frame.size.width / 5 * unSelectedImage.size.width / unSelectedImage.size.height;
    }
    
    starRating = 0.0;
    lastRating = 0.0;
    
    CGFloat starX = (self.frame.size.width - width * 5) / 2;
    CGFloat starY = (self.frame.size.height - height) / 2;
    
    _s1 = [[UIImageView alloc] initWithImage:unSelectedImage];
    _s2 = [[UIImageView alloc] initWithImage:unSelectedImage];
    _s3 = [[UIImageView alloc] initWithImage:unSelectedImage];
    _s4 = [[UIImageView alloc] initWithImage:unSelectedImage];
    _s5 = [[UIImageView alloc] initWithImage:unSelectedImage];
    
    [_s1 setFrame:CGRectMake(starX,             starY, width, height)];
    [_s2 setFrame:CGRectMake(starX + width,     starY, width, height)];
    [_s3 setFrame:CGRectMake(starX + 2 * width, starY, width, height)];
    [_s4 setFrame:CGRectMake(starX + 3 * width, starY, width, height)];
    [_s5 setFrame:CGRectMake(starX + 4 * width, starY, width, height)];
    
    [_s1 setUserInteractionEnabled:NO];
    [_s2 setUserInteractionEnabled:NO];
    [_s3 setUserInteractionEnabled:NO];
    [_s4 setUserInteractionEnabled:NO];
    [_s5 setUserInteractionEnabled:NO];
    
    [self addSubview:_s1];
    [self addSubview:_s2];
    [self addSubview:_s3];
    [self addSubview:_s4];
    [self addSubview:_s5];
    
}

/**
 *  设置评分值
 *
 *  @param rating 评分值
 */
-(void)displayRating:(float)rating{
    [_s1 setImage:unSelectedImage];
    [_s2 setImage:unSelectedImage];
    [_s3 setImage:unSelectedImage];
    [_s4 setImage:unSelectedImage];
    [_s5 setImage:unSelectedImage];
    
    if (rating >= 0.5) {
        [_s1 setImage:halfSelectedImage];
    }
    if (rating >= 1) {
        [_s1 setImage:fullSelectedImage];
    }
    if (rating >= 1.5) {
        [_s2 setImage:halfSelectedImage];
    }
    if (rating >= 2) {
        [_s2 setImage:fullSelectedImage];
    }
    if (rating >= 2.5) {
        [_s3 setImage:halfSelectedImage];
    }
    if (rating >= 3) {
        [_s3 setImage:fullSelectedImage];
    }
    if (rating >= 3.5) {
        [_s4 setImage:halfSelectedImage];
    }
    if (rating >= 4) {
        [_s4 setImage:fullSelectedImage];
    }
    if (rating >= 4.5) {
        [_s5 setImage:halfSelectedImage];
    }
    if (rating >= 5) {
        [_s5 setImage:fullSelectedImage];
    }
    
    starRating = rating;
    lastRating = rating;
    [_delegate ratingChanged:rating];
}

/**
 *  获取当前的评分值
 *
 *  @return 评分值
 */
-(float)rating{
    return starRating;
}
//
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if (self.isIndicator) {
        return;
    }
    
    CGPoint point = [[touches anyObject] locationInView:self];
    int newRating = (int) (point.x / width) + 1;
    if (newRating > 5)
        return;
    
    if (point.x < 0) {
        newRating = 0;
    }
    
    if (newRating != lastRating){
        [self displayRating:newRating];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (self.isIndicator) {
        return;
    }
    
    CGPoint point = [[touches anyObject] locationInView:self];
    int newRating = (int) (point.x / width) + 1;
    if (newRating > 5)
        return;
    
    if (point.x < 0) {
        newRating = 0;
    }
    
    if (newRating != lastRating){
        [self displayRating:newRating];
    }
}

@end
