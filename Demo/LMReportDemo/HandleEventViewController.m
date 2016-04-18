//
//  HandleEventViewController.m
//  LMReportDemo
//
//  Created by Chenly on 16/4/18.
//  Copyright © 2016年 Little Meaning. All rights reserved.
//

#import "HandleEventViewController.h"
#import "LMReport.h"

@interface HandleEventViewController () <LMReportViewDatasource, LMReportViewDelegate>

@property (nonatomic, strong) LMReportView *reportView;
@property (nonatomic, strong) NSArray *generalDatas;

@end

@implementation HandleEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"响应事件";
    
    self.reportView = [[LMReportView alloc] init];
    self.reportView.datasource = self;
    self.reportView.delegate = self;
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
                grid.text = [NSString stringWithFormat:@"第%ld列", colIndex];
            }
            else {
                grid.text = @(arc4random() % 1000).stringValue;
            }
            [grids addObject:grid];
            colIndex++;
        }
        [rows addObject:grids];
    }
    _generalDatas = rows;
    return _generalDatas;
}

- (void)alertMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"系统提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (NSOrderedSet *)ascOrderedSetForSortedCol:(NSInteger)col {
    /*
     获取行索引的排序：先获取值的排序，然后一一对应到行索引的排序
     */
    NSMutableArray *sourceValues = [self.generalDatas mutableCopy];
    // 去掉第一行表头
    [sourceValues removeObjectAtIndex:0];
    //将列值数组从小到大排序
    NSArray *sortedValues = [sourceValues sortedArrayUsingComparator:^NSComparisonResult(NSArray *rows1, NSArray *rows2) {
        
        LMRGrid *grid1 = rows1[col];
        LMRGrid *grid2 = rows2[col];
        
        NSString *str1 = grid1.text;
        NSString *str2 = grid2.text;
        
        NSScanner *scanner = [NSScanner scannerWithString:str1];
        float floatValue;
        [scanner scanFloat:&floatValue];
        
        if ([scanner isAtEnd]) {
            //数字
            return str2.floatValue > str1.floatValue ? NSOrderedAscending : NSOrderedDescending;
        }
        else {
            //非数字
            UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
            
            NSInteger length = str1.length < str2.length ? str1.length : str2.length;
            NSInteger loc = 0;
            while (loc < length) {
                
                NSString *word1 = [str1 substringWithRange:NSMakeRange(loc, 1)];
                NSString *word2 = [str2 substringWithRange:NSMakeRange(loc, 1)];
                
                NSInteger section1 = [collation sectionForObject:word1 collationStringSelector:@selector(description)];
                NSInteger section2 = [collation sectionForObject:word2 collationStringSelector:@selector(description)];
                
                return section2 > section1 ? NSOrderedDescending : NSOrderedAscending;
            }
            return NSOrderedAscending;
        }
    }];
    //获取行索引的排序
    NSMutableOrderedSet *sortedIndexes = [NSMutableOrderedSet orderedSet];
    for (id value in sortedValues) {
        NSInteger index = [sourceValues indexOfObject:value];
        //相同的字符串指向同一个(@"0" == @"0")，所以要把索引过的移除掉，避免同一个索引被多次加入到索引数组中
        sourceValues[index] = [NSNull null];
        [sortedIndexes addObject:[NSNumber numberWithInteger:index + 1]];
    }
    return sortedIndexes;
}

#pragma mark - <LMReportViewDatasource>

- (NSInteger)numberOfRowsInReportView:(LMReportView *)reportView {
    return self.generalDatas.count;
}

- (NSInteger)numberOfColsInReportView:(LMReportView *)reportView {
    return [self.generalDatas.lastObject count];
}

- (LMRGrid *)reportView:(LMReportView *)reportView gridAtIndexPath:(NSIndexPath *)indexPath {
    LMRGrid *grid = self.generalDatas[indexPath.row][indexPath.col];
    return grid;
}

#pragma mark - <LMReportViewDelegate>

- (void)reportView:(LMReportView *)reportView didTapLabel:(LMRLabel *)label {
    if (label.indexPath.row == 0) {
        // 点击表头进行排序
        LMROrder order;
        if (reportView.sortedCol == label.indexPath.col && reportView.sortedOrder == LMROrderedDescending) {
            order = LMROrderedAscending;
        }
        else {
            order = LMROrderedDescending;
        }
        [reportView sortByCol:label.indexPath.col order:order];
    }
    else {
        [self alertMessage:[NSString stringWithFormat:@"点击 %ld-%ld", label.indexPath.row, label.indexPath.col]];
    }
}

- (void)reportView:(LMReportView *)reportView didLongPressLabel:(LMRLabel *)label {
    [self alertMessage:[NSString stringWithFormat:@"长按 %ld-%ld", label.indexPath.row, label.indexPath.col]];
}

- (NSOrderedSet *)reportView:(LMReportView *)reportView indexesSortedByCol:(NSInteger)col order:(LMROrder)order {
    if (order == LMROrderedAscending) {
        return [self ascOrderedSetForSortedCol:col];
    }
    else if (order == LMROrderedDescending) {
        return [[self ascOrderedSetForSortedCol:col] reversedOrderedSet];
    }
    else {
        return nil;
    }
}

@end
