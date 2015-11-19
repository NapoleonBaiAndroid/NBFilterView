//
//  NBFilterCell.h
//  NBFilterView
//
//  Created by NapoleonBai on 15/11/18.
//  Copyright © 2015年 NapoleonBai. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  此文件暂不实现
 */
@interface NBFilterCell : UIView

/**
 *  记录当前所在分组
 */
@property(nonatomic,assign)NSInteger sectionPosition;

/**
 *  具体位置
 */
@property(nonatomic,assign)NSInteger rowPosition;

@end
