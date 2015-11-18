//
//  NBFilterView.m
//  NBFilterView
//
//  Created by NapoleonBai on 15/11/18.
//  Copyright © 2015年 NapoleonBai. All rights reserved.
//

#import "NBFilterView.h"

@interface NBFilterView()

@property(nonatomic,weak)UIWindow *keyWindow;
@property(nonatomic,strong)UIView *childView;

@property(nonatomic,assign)UIEdgeInsets paddingOfSubTitleView;//子View间距
@property(nonatomic,assign)NSUInteger numberOfColumnsInRow;//每行显示多少个

@property(nonatomic,assign)NBIndexPath currentSelectedIndex;//当前选中项

@end

@implementation NBFilterView

- (instancetype)init{
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initData];
    }else
        return  nil;
    return self;
}

- (void)initData{
    //设置默认行高
    self.rowHeight = 44;
    //默认不选中任何一个
    _currentSelectedIndex.section = -1;
}

- (UIEdgeInsets)paddingOfSubTitleView{
    _paddingOfSubTitleView = UIEdgeInsetsMake(5, 5, 5, 0);
    if(self.datasource){
        _paddingOfSubTitleView = [self.datasource filterView:self paddingOfColumnsInSection:[self getCurrentSection]];
    }
    return _paddingOfSubTitleView;
}

- (NSUInteger)numberOfColumnsInRow{
    if (_numberOfColumnsInRow==0) {
        _numberOfColumnsInRow = 3;//默认为3
        if (self.datasource) {
            _numberOfColumnsInRow = [self.datasource filterView:self numberOfColumnsInSection:[self getCurrentSection]];
        }
    }
    return _numberOfColumnsInRow;
}


- (NSInteger)getCurrentSection{
    return self.currentSelectedIndex.section;
}

- (UIWindow *)keyWindow{
    if (!_keyWindow) {
        _keyWindow = [UIApplication sharedApplication].keyWindow;
    }
    return _keyWindow;
}

- (void)showSectionTitles{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (self.datasource) {
        float sectionsCount = [self.datasource numberOfSectionsForfilterView:self] * 1.0f;
        float buttonWidth = self.bounds.size.width / sectionsCount;
        for (int i = 0;i<sectionsCount ;i++) {
            NBFilterCell *headerView = [self.datasource filterView:self viewOfSection:i];
            headerView.sectionPosition = i;
            headerView.frame = CGRectMake(i*buttonWidth, 0, buttonWidth, self.bounds.size.height);
            [self addSubview:headerView];
            [headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTitles:)]];
        }
    }
}

- (void)setDataource:(id<NBFilterViewDataSource>)datasource{
    _datasource = datasource;
    [self reloadData];
}

- (void)reloadData{
    [self showSectionTitles];
}

- (void)clickTitles:(UITapGestureRecognizer *)tap{
    NSInteger section = ((NBFilterCell *)tap.view).sectionPosition;
    //如果当前section已经被选中
    if (_currentSelectedIndex.section == section) {
        return;
    }
    //设置当前选中的section
    _currentSelectedIndex.section = section;
    
    if (self.delegate) {
        [self.delegate filterView:self didSelectedSection:section];
    }
    
    //显示该分组下面的数据
    [self showChildView:[self.datasource filterView:self numberInSection:_currentSelectedIndex.section]];
}

- (void)clickSubTitles:(UITapGestureRecognizer *)tap{
    if (self.delegate) {
        //设置当前选中的数据(分组下面特定的)
        _currentSelectedIndex.row = ((NBFilterCell *)tap.view).rowPosition;
        //回执界面
        [self.delegate filterView:self didSelectedRowOfIndexPath:_currentSelectedIndex];
    }
}

- (NBIndexPath)indexPathForCell:(NBFilterCell *)cell{
    NBIndexPath indexPath;
    indexPath.section = cell.sectionPosition;
    indexPath.row = cell.rowPosition;
    return indexPath;
}

/**
 *  显示分组下的数据
 *
 *  @param numberOfSection 每个分组有多少个数据
 */
- (void)showChildView:(NSInteger)numberOfSection{
    [self.childView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (!self.childView) {
        CGRect rect=[self convertRect: self.bounds toView:self.keyWindow];
        self.childView = [[UIView alloc] initWithFrame:CGRectMake(0, rect.origin.y + rect.size.height, rect.size.width, ceilf(numberOfSection / (self.numberOfColumnsInRow / 1.0)) *(self.rowHeight + self.paddingOfSubTitleView.top + self.paddingOfSubTitleView.bottom))];
        self.childView.backgroundColor = [UIColor greenColor];
        [self.keyWindow addSubview:self.childView];
    }
    
    CGRect frame = self.childView.frame;
    if (frame.size.height != ceilf(numberOfSection / (self.numberOfColumnsInRow / 1.0)) *(self.rowHeight + self.paddingOfSubTitleView.top + self.paddingOfSubTitleView.bottom)) {
        frame.size.height =  ceilf(numberOfSection / (self.numberOfColumnsInRow / 1.0)) *(self.rowHeight + self.paddingOfSubTitleView.top + self.paddingOfSubTitleView.bottom);
        self.childView.frame = frame;
    }
    
    //得到每个控件宽度
    float buttonWidth = (self.childView.bounds.size.width - self.numberOfColumnsInRow*(self.paddingOfSubTitleView.left + self.paddingOfSubTitleView.right)) / self.numberOfColumnsInRow;
    for (int i = 0;i<numberOfSection ;i++) {
        NBIndexPath indexPath;
        indexPath.section = _currentSelectedIndex.section;
        indexPath.row = i;
        NBFilterCell *filterCell = [self.datasource filterView:self viewForRowAtIndexPath:indexPath];
        filterCell.rowPosition = i;
        filterCell.sectionPosition = _currentSelectedIndex.section;
        
        filterCell.frame = CGRectMake(self.paddingOfSubTitleView.left + i%self.numberOfColumnsInRow*(buttonWidth+self.paddingOfSubTitleView.left+self.paddingOfSubTitleView.right),self.paddingOfSubTitleView.top + i/self.numberOfColumnsInRow * (self.rowHeight+self.paddingOfSubTitleView.bottom+self.paddingOfSubTitleView.top), buttonWidth, self.rowHeight);
        [self.childView addSubview:filterCell];
        [filterCell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSubTitles:)]];
    }
}

@end