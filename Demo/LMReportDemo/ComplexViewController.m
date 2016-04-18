//
//  ComplexViewController.m
//  LMReportDemo
//
//  Created by Chenly on 16/4/18.
//  Copyright © 2016年 Little Meaning. All rights reserved.
//

#import "ComplexViewController.h"
#import "LMReport.h"

@interface ComplexViewController () <LMReportViewDatasource>

@property (nonatomic, strong) LMReportView *reportView;
@property (nonatomic, strong) NSArray *generalDatas;

@end

@implementation ComplexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"复合表头";
    
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

- (NSArray *)generalDatas {
    if (_generalDatas) {
        return _generalDatas;
    }
    
    NSMutableArray *rows = [NSMutableArray array];
    for (NSInteger rowIndex = 0; rowIndex < 10; rowIndex++) {
        NSMutableArray *grids = [NSMutableArray array];
        NSInteger colIndex = 0;
        while (colIndex < 10) {
            LMRGrid *grid = [[LMRGrid alloc] init];
            grid.text = [NSString stringWithFormat:@"%ld-%ld", rowIndex, colIndex];
            if (rowIndex == 0 && colIndex == 0) {
                grid.rowspan = 2;
            }
            else if (rowIndex == 1 && colIndex == 0) {
                [grids addObject:[NSNull null]];
                colIndex++;
                continue;
            }
            if (rowIndex == 0) {
                switch (colIndex) {
                    case 1:
                        grid.colspan = 2;
                        break;
                    case 3:
                        grid.colspan = 3;
                        break;
                    case 6:
                        grid.colspan = 4;
                        break;
                    default:
                        break;
                }
            }
            [grids addObject:grid];
            for (NSInteger i = 0; i < grid.colspan - 1; i++) {
                [grids addObject:[NSNull null]];
            }
            colIndex += grid.colspan;
        }
        [rows addObject:grids];
    }
    _generalDatas = rows;
    return _generalDatas;
}

#pragma mark - <LMReportViewDatasource>

- (NSInteger)numberOfRowsInReportView:(LMReportView *)reportView {
    return self.generalDatas.count;
}

- (NSInteger)numberOfHeadRowsInReportView:(LMReportView *)reportView {
    return 2;
}

- (NSInteger)numberOfColsInReportView:(LMReportView *)reportView {
    return [self.generalDatas.lastObject count];
}

- (LMRGrid *)reportView:(LMReportView *)reportView gridAtIndexPath:(NSIndexPath *)indexPath {    
    LMRGrid *grid = self.generalDatas[indexPath.row][indexPath.col];
    return grid;
}

@end
