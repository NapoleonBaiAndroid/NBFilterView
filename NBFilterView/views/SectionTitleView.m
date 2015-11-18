//
//  SectionTitleView.m
//  NBFilterView
//
//  Created by NapoleonBai on 15/11/18.
//  Copyright © 2015年 NapoleonBai. All rights reserved.
//

#import "SectionTitleView.h"

@implementation SectionTitleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init{
    self = [super init];
    if (!self) {
        return nil;
    }
    [self initView];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView{
    self.titleLable = [UILabel new];
    self.titleLable.textAlignment = NSTextAlignmentCenter;
    self.detailImageView = [UIImageView new];
    [self addSubview:self.titleLable];
    [self addSubview:self.detailImageView];
    
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_titleLable,_detailImageView);
    self.titleLable.translatesAutoresizingMaskIntoConstraints = NO;
    self.detailImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[_titleLable]-10-[_detailImageView(25)]-10-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_titleLable(25)]" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_detailImageView(25)]" options:0 metrics:nil views:views]];
    
    //垂直居中
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLable attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.detailImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];

}

@end
