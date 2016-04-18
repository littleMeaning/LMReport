//
//  NSIndexPath+LMR.m
//  LMReportViewDemo
//
//  Created by Chenly on 15/3/17.
//  Copyright (c) 2015年 Chenly. All rights reserved.
//

#import "NSIndexPath+LMReport.h"

@implementation NSIndexPath (LMReport)

+ (NSIndexPath *)indexPathForCol:(NSInteger)col inRow:(NSInteger)row {
    return [NSIndexPath indexPathForRow:row inSection:col];
}

- (NSInteger)col {
    return self.section;
}

@end
