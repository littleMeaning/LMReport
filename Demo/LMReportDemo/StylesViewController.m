//
//  StylesViewController.m
//  LMReportDemo
//
//  Created by Chenly on 16/4/18.
//  Copyright © 2016年 Little Meaning. All rights reserved.
//

#import "StylesViewController.h"
#import "LMReport.h"
#import "LMRStyle+Demo.h"

@interface StylesViewController () <LMReportViewDatasource>

@property (nonatomic, strong) LMReportView *reportView;
@property (nonatomic, assign) LMRStyleType currentStyle;

@end

@implementation StylesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"风格样式";
    
    LMRStyle *style = [LMRStyle blueStyle];
    
    self.reportView = [[LMReportView alloc] init];
    self.reportView.datasource = self;
    self.reportView.style = style;
    [self.view addSubview:self.reportView];
    
    self.currentStyle = LMRStyleTypeBlue;
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

- (IBAction)changeStyle:(id)sender {    
    UIAlertAction *actionBlue = [UIAlertAction actionWithTitle:@"蓝色" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setStyle:LMRStyleTypeBlue];
    }];
    UIAlertAction *actionGreen = [UIAlertAction actionWithTitle:@"绿色" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setStyle:LMRStyleTypeGreen];
    }];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"切换样式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:actionBlue];
    [alert addAction:actionGreen];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (void)setStyle:(LMRStyleType)style {
    if (self.currentStyle == style) {
        return;
    }
    self.reportView.style = style == LMRStyleTypeBlue ? [LMRStyle blueStyle] : [LMRStyle greenStyle];
    self.currentStyle = style;
    [UIView animateWithDuration:0.5 animations:^{
        [self.reportView reloadData];
    }];
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
