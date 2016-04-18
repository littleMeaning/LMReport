//
//  DetailingViewController.m
//  LMReportDemo
//
//  Created by Chenly on 16/4/18.
//  Copyright © 2016年 Little Meaning. All rights reserved.
//

#import "DetailingViewController.h"
#import "LMReport.h"

@interface DetailingViewController () <LMReportViewDatasource>

@property (nonatomic, strong) LMReportView *reportView;
@property (nonatomic, strong) NSArray *generalDatas;

@end

@implementation DetailingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"单元格样式设置";
    
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
            
            if (rowIndex == 0) {
                switch (colIndex) {
                    case 0:
                        grid.text = @"下划线";
                        break;
                    case 1:
                        grid.text = @"文字";
                        break;
                    case 2:
                        grid.text = @"颜色";
                        break;
                    case 3:
                        grid.text = @"图片";
                        break;
                    default:
                        break;
                }
            }
            else {
                switch (colIndex) {
                    case 0:
                        grid.underline = YES;
                        break;
                    case 1:
                        grid.textColor = [UIColor orangeColor];
                        grid.font = [UIFont boldSystemFontOfSize:15.f];
                        grid.textAlignment = NSTextAlignmentRight;
                        break;
                    case 2:
                        grid.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1];
                        break;
                    case 3:
                        grid.image = [UIImage imageNamed:[NSString stringWithFormat:@"image-%ld", rowIndex]];
                        break;
                    default:
                        break;
                }
                grid.text = [NSString stringWithFormat:@"%ld-%ld", rowIndex, colIndex];
            }
            [grids addObject:grid];
            colIndex++;
        }
        [rows addObject:grids];
    }
    _generalDatas = rows;
    return _generalDatas;
}

#pragma mark - <LMReportViewDatasource>

- (NSInteger)numberOfRowsInReportView:(LMReportView *)reportView {
    return 4;
}

- (NSInteger)numberOfColsInReportView:(LMReportView *)reportView {
    return 4;
}

- (CGFloat)reportView:(LMReportView *)reportView heightOfRow:(NSInteger)row {
    if (row == 0) {
        return 30;
    }
    else {
        return 60;
    }
}
- (CGFloat)reportView:(LMReportView *)reportView widthOfCol:(NSInteger)col {
    if (col == 3) {
        return 60;
    }
    else {
        return 80;
    }
}

- (LMRGrid *)reportView:(LMReportView *)reportView gridAtIndexPath:(NSIndexPath *)indexPath {
    LMRGrid *grid = self.generalDatas[indexPath.row][indexPath.col];
    return grid;
}

@end

