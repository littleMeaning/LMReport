//
//  FitViewController.m
//  LMReportDemo
//
//  Created by Chenly on 16/4/18.
//  Copyright © 2016年 Little Meaning. All rights reserved.
//

#import "FitViewController.h"
#import "LMReport.h"

@interface FitViewController () <LMReportViewDatasource>

@property (nonatomic, strong) LMReportView *reportView;

@end

@implementation FitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"行高自适应";
    
    self.reportView = [[LMReportView alloc] init];
    self.reportView.datasource = self;
    self.reportView.style.autoFitHeight = YES;
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
    return 10;
}

- (NSInteger)numberOfColsInReportView:(LMReportView *)reportView {
    return 10;
}

- (LMRGrid *)reportView:(LMReportView *)reportView gridAtIndexPath:(NSIndexPath *)indexPath {
    LMRGrid *grid = [[LMRGrid alloc] init];
    NSString *baseString = [NSString stringWithFormat:@"%ld-%ld", indexPath.row, indexPath.col];
    NSMutableString *text = [NSMutableString stringWithString:baseString];
    for (NSInteger i = 0; i < indexPath.row; i++) {
        [text appendString:@"\n"];
        [text appendString:baseString];
    }
    grid.text = text;
    return grid;
}

@end

