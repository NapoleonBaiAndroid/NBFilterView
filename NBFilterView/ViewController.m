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


@interface ViewController ()<NBFilterViewDataSource,NBFilterViewDelegate>{
    NSArray *dataArray;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray = @[[[NBFilterModel alloc] initName:@"人物" withId:@"adsfadf" defaultImage:@"icon_down" selectedImage:@"icon_up" tag:0 childArray:@[[[NBFilterModel alloc] initName:@"小明" withId:@"adsfadf" defaultImage:@"icon_un_agree" selectedImage:@"icon_agree" tag:0 childArray:nil],[[NBFilterModel alloc] initName:@"小华" withId:@"adsfadf" defaultImage:@"icon_un_agree" selectedImage:@"icon_agree" tag:0 childArray:nil],[[NBFilterModel alloc] initName:@"小花" withId:@"adsfadf" defaultImage:@"icon_un_agree" selectedImage:@"icon_agree" tag:0 childArray:nil],[[NBFilterModel alloc] initName:@"小红" withId:@"adsfadf" defaultImage:@"icon_un_agree" selectedImage:@"icon_agree" tag:0 childArray:nil],[[NBFilterModel alloc] initName:@"小天" withId:@"adsfadf" defaultImage:@"icon_un_agree" selectedImage:@"icon_agree" tag:0 childArray:nil],[[NBFilterModel alloc] initName:@"凤姐" withId:@"adsfadf" defaultImage:@"icon_un_agree" selectedImage:@"icon_agree" tag:0 childArray:nil],[[NBFilterModel alloc] initName:@"犀利哥" withId:@"adsfadf" defaultImage:@"icon_un_agree" selectedImage:@"icon_agree" tag:0 childArray:nil],[[NBFilterModel alloc] initName:@"小马" withId:@"adsfadf" defaultImage:@"icon_un_agree" selectedImage:@"icon_agree" tag:0 childArray:nil]]],[[NBFilterModel alloc] initName:@"距离" withId:@"adsfadf" defaultImage:@"icon_down" selectedImage:@"icon_up" tag:0 childArray:@[[[NBFilterModel alloc] initName:@"1000" withId:@"adsfadf" defaultImage:@"icon_un_agree" selectedImage:@"icon_agree" tag:0 childArray:nil],[[NBFilterModel alloc] initName:@"2000" withId:@"adsfadf" defaultImage:@"icon_un_agree" selectedImage:@"icon_agree" tag:0 childArray:nil],[[NBFilterModel alloc] initName:@"3000" withId:@"adsfadf" defaultImage:@"icon_un_agree" selectedImage:@"icon_agree" tag:0 childArray:nil],[[NBFilterModel alloc] initName:@"4000" withId:@"adsfadf" defaultImage:@"icon_un_agree" selectedImage:@"icon_agree" tag:0 childArray:nil]]],[[NBFilterModel alloc] initName:@"类型" withId:@"adsfadf" defaultImage:@"icon_down" selectedImage:@"icon_up" tag:0 childArray:@[[[NBFilterModel alloc] initName:@"玫瑰" withId:@"adsfadf" defaultImage:@"icon_un_agree" selectedImage:@"icon_agree" tag:0 childArray:nil],[[NBFilterModel alloc] initName:@"百合" withId:@"adsfadf" defaultImage:@"icon_un_agree" selectedImage:@"icon_agree" tag:0 childArray:nil],[[NBFilterModel alloc] initName:@"配花" withId:@"adsfadf" defaultImage:@"icon_un_agree" selectedImage:@"icon_agree" tag:0 childArray:nil],[[NBFilterModel alloc] initName:@"包装纸" withId:@"adsfadf" defaultImage:@"icon_un_agree" selectedImage:@"icon_agree" tag:0 childArray:nil]]]];
    
    NBFilterView *filterView = [[NBFilterView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 50)];
    filterView.rowHeight = 40;
    [self.view addSubview:filterView];
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
    return 3;
}

- (UIEdgeInsets)filterView:(NBFilterView *)filterView paddingOfColumnsInSection:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (UIView *)filterView:(NBFilterView *)filterView viewOfSection:(NSInteger)section{
    NBFilterModel *filterModel = dataArray[section];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.showsTouchWhenHighlighted = YES;
    
    [button setImage:[UIImage imageNamed:filterModel.fSelectedDetailImage] forState:UIControlStateSelected];
    [button setImage:[UIImage imageNamed:filterModel.fDefaultDetailImage] forState:UIControlStateNormal];
    //这样可以设置无论是否选中状态,高亮图片都是同一张
    [button setImage:[UIImage imageNamed:filterModel.fSelectedDetailImage] forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button setTitle:filterModel.fName forState:UIControlStateNormal];
    
    return button;
}

- (UIView *)filterView:(NBFilterView *)filterView viewForRowAtIndexPath:(NBIndexPath)indexPath{
    
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
    
    return button;
}

- (void)filterView:(NBFilterView *)filterView didSelectedRowOfIndexPath:(NBIndexPath)indexPath{
    NSLog(@"=选中的是第===%ld===行 第=%ld=个",indexPath.section,indexPath.row);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
