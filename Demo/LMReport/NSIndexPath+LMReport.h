//
//  NSIndexPath+LMReport.h
//  LMReportViewDemo
//
//  Created by Chenly on 15/3/17.
//  Copyright (c) 2015年 Chenly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSIndexPath (LMReport)

@property (nonatomic, readonly) NSInteger row;
@property (nonatomic, readonly) NSInteger col;
+ (NSIndexPath *)indexPathForCol:(NSInteger)col inRow:(NSInteger)row;

@end
