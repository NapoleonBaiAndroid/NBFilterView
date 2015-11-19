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
@property(nonatomic,strong)UIView *sectionRowView;
@property(nonatomic,strong)UIControl *maskView;

@property(nonatomic,assign)UIEdgeInsets paddingOfSubTitleView;//子View间距
@property(nonatomic,assign)NSUInteger numberOfColumnsInRow;//每行显示多少个

@property(nonatomic,assign)NBIndexPath currentSelectedIndex;//当前选中项


@property(nonatomic,assign)float sectionViewWidth;//分组视图的宽度

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

- (UIControl *)maskView{
    if (!_maskView) {
        _maskView = [UIControl new];
        _maskView.layer.masksToBounds = YES;
        _maskView.backgroundColor = [UIColor clearColor];
        [_maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch)]];
    }
    return _maskView;
}

- (void)initData{
    _isScreenWidth = YES;
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
        //_keyWindow = [[[UIApplication sharedApplication] delegate]window];
        _keyWindow = [UIApplication sharedApplication].keyWindow;
    }
    return _keyWindow;
}

- (void)touch{
    if (self.delegate) {
        [self.delegate resignFirstResponder:self];
    }
    
    self.sectionRowView.transform = CGAffineTransformMakeTranslation(self.sectionRowView.bounds.origin.x, 0);
    [UIView animateWithDuration:.3 animations:^{
        self.sectionRowView.transform = CGAffineTransformMakeTranslation(self.sectionRowView.bounds.origin.x, -self.sectionRowView.bounds.size.height);
    } completion:^(BOOL finished) {
        _currentSelectedIndex.section = -1;
        [self.maskView removeFromSuperview];
        self.maskView = nil;
        [self.sectionRowView removeFromSuperview];
        self.sectionRowView = nil;
    }];
}

- (void)showSectionTitles{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (self.datasource) {
        float sectionsCount = [self.datasource numberOfSectionsForfilterView:self] * 1.0f;
        _sectionViewWidth = self.bounds.size.width / sectionsCount;
        for (int i = 0;i<sectionsCount ;i++) {
            NBFilterCell *headerView = [self.datasource filterView:self viewOfSection:i];
            headerView.sectionPosition = i;
            headerView.frame = CGRectMake(i*_sectionViewWidth, 0, _sectionViewWidth, self.bounds.size.height);
            [self addSubview:headerView];
            [headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSection:)]];
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

- (void)clickSection:(UITapGestureRecognizer *)tap{
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
    [self showsectionRowView:[self.datasource filterView:self numberInSection:_currentSelectedIndex.section]];
}

- (void)clickRowCell:(UITapGestureRecognizer *)tap{
    if (self.delegate) {
        //设置当前选中的数据(分组下面特定的)
        _currentSelectedIndex.row = ((NBFilterCell *)tap.view).rowPosition;
        //回执界面
        [self.delegate filterView:self didSelectedRowOfIndexPath:_currentSelectedIndex];
    }
    [self touch];
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
- (void)showsectionRowView:(NSInteger)numberOfSection{
    [self.sectionRowView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (!self.sectionRowView) {
        [self.keyWindow addSubview:self.maskView];
        CGRect rect=[self convertRect: self.bounds toView:self.keyWindow];
        
        _maskView.frame = CGRectMake(0, rect.origin.y + rect.size.height, self.bounds.size.width, self.keyWindow.bounds.size.height - rect.origin.y - rect.size.height);//[UIScreen mainScreen].bounds;

        self.sectionRowView = [[UIView alloc] initWithFrame:CGRectMake(_isScreenWidth?0:_currentSelectedIndex.section*_sectionViewWidth + self.paddingOfSubTitleView.left, 0,_isScreenWidth?rect.size.width:_sectionViewWidth, ceilf(numberOfSection / (self.numberOfColumnsInRow / 1.0)) *(self.rowHeight + self.paddingOfSubTitleView.top + self.paddingOfSubTitleView.bottom))];
        [self.sectionRowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionRowViewTap)]];
    
        [self.maskView addSubview:self.sectionRowView];
        
        self.sectionRowView.backgroundColor = [UIColor whiteColor];
        if (!_isScreenWidth) {
            self.sectionRowView.layer.shadowColor = [UIColor grayColor].CGColor;
            self.sectionRowView.layer.shadowOpacity = .8f;
        }
        
        self.sectionRowView.transform = CGAffineTransformMakeTranslation(self.sectionRowView.bounds.origin.x, -self.sectionRowView.bounds.size.height);
        [UIView animateWithDuration:.3 animations:^{
              self.sectionRowView.transform = CGAffineTransformMakeTranslation(self.sectionRowView.bounds.origin.x, 0);
        }];
    }
    
    CGRect frame = self.sectionRowView.frame;

    if (!self.isScreenWidth) {
        //这里需要设置X坐标
        frame.origin.x = _currentSelectedIndex.section*_sectionViewWidth;
        self.sectionRowView.frame = frame;
        if (frame.origin.x > self.bounds.size.width/2) {
            self.sectionRowView.layer.shadowOffset = CGSizeMake(-5, 5);
        }else{
            self.sectionRowView.layer.shadowOffset = CGSizeMake(5, 5);
        }
    }
    
    if (frame.size.height != ceilf(numberOfSection / (self.numberOfColumnsInRow / 1.0)) *(self.rowHeight + self.paddingOfSubTitleView.top + self.paddingOfSubTitleView.bottom)) {
        frame.size.height =  ceilf(numberOfSection / (self.numberOfColumnsInRow / 1.0)) *(self.rowHeight + self.paddingOfSubTitleView.top + self.paddingOfSubTitleView.bottom);
        self.sectionRowView.frame = frame;
    }
    
    //得到每个控件宽度
    float buttonWidth = (self.sectionRowView.bounds.size.width - self.numberOfColumnsInRow*(self.paddingOfSubTitleView.left + self.paddingOfSubTitleView.right)) / self.numberOfColumnsInRow;
    for (int i = 0;i<numberOfSection ;i++) {
        NBIndexPath indexPath;
        indexPath.section = _currentSelectedIndex.section;
        indexPath.row = i;
        NBFilterCell *filterCell = [self.datasource filterView:self viewForRowAtIndexPath:indexPath];
        filterCell.rowPosition = i;
        filterCell.sectionPosition = _currentSelectedIndex.section;
        
        filterCell.frame = CGRectMake(self.paddingOfSubTitleView.left + i%self.numberOfColumnsInRow*(buttonWidth+self.paddingOfSubTitleView.left+self.paddingOfSubTitleView.right),self.paddingOfSubTitleView.top + i/self.numberOfColumnsInRow * (self.rowHeight+self.paddingOfSubTitleView.bottom+self.paddingOfSubTitleView.top), buttonWidth, self.rowHeight);
        [self.sectionRowView addSubview:filterCell];
        [filterCell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickRowCell:)]];
    }
}

- (void)sectionRowViewTap{
    //暂时不做任何操作
    return;
}

@end