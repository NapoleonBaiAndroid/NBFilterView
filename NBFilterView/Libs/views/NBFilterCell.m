//
//  NBFilterCell.m
//  NBFilterView
//
//  Created by NapoleonBai on 15/11/18.
//  Copyright © 2015年 NapoleonBai. All rights reserved.
//

#import "NBFilterCell.h"

@implementation NBFilterCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init{
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
    }else{
        return nil;
    }
    return self;
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    UIView *resultView = [super hitTest:point withEvent:event];
//    for (UIView *view in self.subviews) {
//        if ([view isKindOfClass:[UIButton class]]) {
//            CGPoint buttonPoint = [view convertPoint:point fromView:self];
//            if ([view pointInside:buttonPoint withEvent:event]) {
//                return view;
//            }
//        }
//    }
//    return resultView;
//}
//
//
//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
//    return YES;
//}

@end
