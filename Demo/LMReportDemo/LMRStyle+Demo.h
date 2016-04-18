//
//  LMRStyle+Demo.h
//  LMReportDemo
//
//  Created by Chenly on 16/4/18.
//  Copyright © 2016年 Little Meaning. All rights reserved.
//

#import "LMRStyle.h"

typedef NS_ENUM(NSUInteger, LMRStyleType) {
    LMRStyleTypeDefault,
    LMRStyleTypeBlue,
    LMRStyleTypeGreen,
};

@interface LMRStyle (Demo)

+ (instancetype)blueStyle;
+ (instancetype)greenStyle;

@end
