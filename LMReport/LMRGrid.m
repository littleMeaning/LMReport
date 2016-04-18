//
//  LMRGrid.m
//  LMReportView
//
//  Created by Chenly on 15/2/27.
//  Copyright (c) 2015年 Chenly. All rights reserved.
//

#import "LMRGrid.h"

@implementation LMRGrid

- (instancetype)init {
    if (self = [super init]) {
        _rowspan = 1;
        _colspan = 1;
        _isTextAlignmentOriginal = YES;
    }
    return self;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    _textAlignment = textAlignment;
    _isTextAlignmentOriginal = NO;
}

@end
