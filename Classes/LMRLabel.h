//
//  LMRLabel.h
//  LMReportView
//
//  Created by Chenly on 15/2/27.
//  Copyright (c) 2015年 Chenly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMRLabel : UILabel

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) NSInteger rowspan;
@property (nonatomic, assign) NSInteger colspan;
@property (nonatomic, assign) BOOL underline;
@property (nonatomic, retain) UIImage *image;

- (void)heightToFit;

@end
