//
//  SimpleViewController.m
//  LMReportDemo
//
//  Created by Chenly on 16/4/18.
//  Copyright © 2016年 Little Meaning. All rights reserved.
//

#import "SimpleViewController.h"
#import "LMReport.h"

@interface SimpleViewController () <LMReportViewDatasource>

@property (nonatomic, strong) LMReportView *reportView;

@end

@implementation SimpleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"简单使用";
    
    self.reportView = [[LMReportView alloc] init];
    self.reportView.datasource = self;
    [self.view addSubview:self.reportView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGRect rect = self.view.bounds;
    rect = CGRectInset(rect, 16, 16);
    rect.origin.y += 60;
    rect.size.height -= 64;
    self.reportView.frame = rect;
}

#pragma mark - <LMReportViewDatasource>

- (NSInteger)numberOfRowsInReportView:(LMReportView *)reportView {
    return 20;
}

- (NSInteger)numberOfColsInReportView:(LMReportView *)reportView {
    return 10;
}

- (LMRGrid *)reportView:(LMReportView *)reportView gridAtIndexPath:(NSIndexPath *)indexPath {
    LMRGrid *grid = [[LMRGrid alloc] init];
    grid.text = [NSString stringWithFormat:@"%ld-%ld", indexPath.row, indexPath.col];
    return grid;
}

@end
