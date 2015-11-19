//
//  ViewController.m
//  NBFilterView
//
//  Created by NapoleonBai on 15/11/18.
//  Copyright © 2015年 NapoleonBai. All rights reserved.
//

#import "ViewController.h"

#import "NBFilterModel.h"
#import "NBFilterView.h"
#import "SectionTitleView.h"


@interface ViewController ()<NBFilterViewDataSource,NBFilterViewDelegate>{
    NSArray *dataArray;
    NSInteger currentSelectSection;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    currentSelectSection = -1;
    
    dataArray = @[[[NBFilterModel alloc] initName:@"人物" withId:@"adsfadf" defaultImage:@"icon_down" selectedImage:@"icon_up" tag:0 childArray:@[[[NBFilterModel alloc] initName:@"小明" withId:@"adsfadf" defaultImage:@"icon_un_agree" selectedImage:@"icon_agree" tag:0 childArray:nil],[[NBFilterModel alloc] initName:@"小华" withId:@"adsfadf" defaultImage:@"icon_un_agree" selectedImage:@"icon_agree" tag:0 childArray:nil],[[NBFilterModel alloc] initName:@"小花" withId:@"adsfadf" defaultImage:@"icon_un_agree" selectedImage:@"icon_agree" tag:0 childArray:nil],[[NBFilterModel alloc] initName:@"小红" withId:@"adsfadf" defaultImage:@"icon_un_agree" selectedImage:@"icon_agree" tag:0 childArray:nil],[[NBFilterModel alloc] initName:@"小天" withId:@"adsfadf" defaultImage:@"icon_un_agree" selectedImage:@"icon_agree" tag:0 childArray:nil],[[NBFilterModel alloc] initName:@"凤姐" withId:@"adsfadf" defaultImage:@"icon_un_agree" selectedImage:@"icon_agree" tag:0 childArray:nil],[[NBFilterModel alloc] initName:@"犀利哥" withId:@"adsfadf" defaultImage:@"icon_un_agree" selectedImage:@"icon_agree" tag:0 childArray:nil],[[NBFilterModel alloc] initName:@"小马" withId:@"adsfadf" defaultImage:@"icon_un_agree" selectedImage:@"icon_agree" tag:0 childArray:nil]]],[[NBFilterModel alloc] initName:@"距离" withId:@"adsfadf" defaultImage:@"icon_down" selectedImage:@"icon_up" tag:0 childArray:@[[[NBFilterModel alloc] initName:@"1000" withId:@"adsfadf" defaultImage:@"icon_un_agree" selectedImage:@"icon_agree" tag:0 childArray:nil],[[NBFilterModel alloc] initName:@"2000" withId:@"adsfadf" defaultImage:@"icon_un_agree" selectedImage:@"icon_agree" tag:0 childArray:nil],[[NBFilterModel alloc] initName:@"3000" withId:@"adsfadf" defaultImage:@"icon_un_agree" selectedImage:@"icon_agree" tag:0 childArray:nil],[[NBFilterModel alloc] initName:@"4000" withId:@"adsfadf" defaultImage:@"icon_un_agree" selectedImage:@"icon_agree" tag:0 childArray:nil]]],[[NBFilterModel alloc] initName:@"类型" withId:@"adsfadf" defaultImage:@"icon_down" selectedImage:@"icon_up" tag:0 childArray:@[[[NBFilterModel alloc] initName:@"玫瑰" withId:@"adsfadf" defaultImage:@"icon_un_agree" selectedImage:@"icon_agree" tag:0 childArray:nil],[[NBFilterModel alloc] initName:@"百合" withId:@"adsfadf" defaultImage:@"icon_un_agree" selectedImage:@"icon_agree" tag:0 childArray:nil],[[NBFilterModel alloc] initName:@"配花" withId:@"adsfadf" defaultImage:@"icon_un_agree" selectedImage:@"icon_agree" tag:0 childArray:nil],[[NBFilterModel alloc] initName:@"包装纸" withId:@"adsfadf" defaultImage:@"icon_un_agree" selectedImage:@"icon_agree" tag:0 childArray:nil]]]];
    
    NBFilterView *filterView = [[NBFilterView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 50)];
    filterView.backgroundColor = [UIColor redColor];
    filterView.rowHeight = 40;
    [self.view addSubview:filterView];
    filterView.isScreenWidth = NO;
    filterView.datasource = self;
    filterView.delegate = self;
}

- (NSInteger)numberOfSectionsForfilterView:(NBFilterView *)filterView{
    return dataArray.count;
}

- (NSInteger)filterView:(NBFilterView *)filterView numberInSection:(NSInteger)section{
    NBFilterModel *filterModel = dataArray[section];
    return filterModel.fChildArray.count;
}


- (NSInteger)filterView:(NBFilterView *)filterView numberOfColumnsInSection:(NSInteger)section{
    return 1;
}

- (UIEdgeInsets)filterView:(NBFilterView *)filterView paddingOfColumnsInSection:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (NBFilterCell *)filterView:(NBFilterView *)filterView viewOfSection:(NSInteger)section{
    NBFilterCell *filterCell = [NBFilterCell new];
    NBFilterModel *filterModel = dataArray[section];
    
    SectionTitleView *titleView = [SectionTitleView new];
    titleView.titleLable.text = filterModel.fName;
    if (filterModel.isSelected) {
        titleView.detailImageView.image = [UIImage imageNamed:filterModel.fSelectedDetailImage];
    }else{
        titleView.detailImageView.image = [UIImage imageNamed:filterModel.fDefaultDetailImage];
    }
    [filterCell addSubview:titleView];

    NSDictionary *views = NSDictionaryOfVariableBindings(titleView);
    titleView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [filterCell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[titleView]-0-|" options:0 metrics:nil views:views]];
    [filterCell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[titleView]-0-|" options:0 metrics:nil views:views]];
    return filterCell;
}

- (void)resignFirstResponder:(NBFilterView *)filterView{
    if (currentSelectSection >= 0) {
        NBFilterModel *mModel = dataArray[currentSelectSection];
        mModel.isSelected = NO;
    }
    currentSelectSection = -1;
    [filterView reloadData];
}

- (void)filterView:(NBFilterView *)filterView didSelectedSection:(NSInteger)section{
    NSLog(@"点击了section === %ld",section);
    
    NBFilterModel *mModel = dataArray[section];
    mModel.isSelected = YES;
    if (currentSelectSection >= 0) {
        NBFilterModel *mModel = dataArray[currentSelectSection];
        mModel.isSelected = NO;
    }
    currentSelectSection = section;
    [filterView reloadData];
}

- (NBFilterCell *)filterView:(NBFilterView *)filterView viewForRowAtIndexPath:(NBIndexPath)indexPath{
    NBFilterCell *filterCell = [NBFilterCell new];
    NBFilterModel *filterModel = dataArray[indexPath.section];
    NBFilterModel *mModel = filterModel.fChildArray[indexPath.row];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.borderColor = [UIColor yellowColor].CGColor;
    button.layer.borderWidth = 1;
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button setTitle:mModel.fName forState:UIControlStateNormal];
    button.showsTouchWhenHighlighted = YES;
    [filterCell addSubview:button];
    button.enabled = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(button);
    button.translatesAutoresizingMaskIntoConstraints = NO;
    
    [filterCell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[button]-0-|" options:0 metrics:nil views:views]];
    [filterCell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[button]-0-|" options:0 metrics:nil views:views]];

    return filterCell;
}

- (void)filterView:(NBFilterView *)filterView didSelectedRowOfIndexPath:(NBIndexPath)indexPath{
    NBFilterModel *filterModel = dataArray[indexPath.section];
    NBFilterModel *mModel = filterModel.fChildArray[indexPath.row];
    NSLog(@"=选中的是第===%ld===行 第=%ld=个 ,数据是: ===%@",indexPath.section,indexPath.row,mModel.fName);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
