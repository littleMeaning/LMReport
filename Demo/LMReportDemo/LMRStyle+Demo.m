//
//  LMRStyle+Demo.m
//  LMReportDemo
//
//  Created by Chenly on 16/4/18.
//  Copyright © 2016年 Little Meaning. All rights reserved.
//

#import "LMRStyle+Demo.h"

@implementation LMRStyle (Demo)

+ (NSDictionary *)defaultLayoutSettings {
    return @{
             LMRHeightOfHeaderRowSettingName: @36.f,
             LMRHeightOfRowSettingName: @36.f,
             LMRWidthOfFirstColSettingName: @74.f,
             LMRWidthOfColSettingName: @75.f,
             LMRFontOfHeaderSettingName: [UIFont systemFontOfSize:13.f],
             LMRFontSettingName: [UIFont systemFontOfSize:13.f],
             LMRBorderInsetsSettingName: [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(1.f, 1.f, 1.f, 1.f)]
             };
}

+ (instancetype)blueStyle {
    NSMutableDictionary *settings = [[self defaultLayoutSettings] mutableCopy];
    [settings addEntriesFromDictionary:@{
                                         LMRBackgroundColorOfHeaderSettingName: [UIColor colorWithRed:57/255.0 green:152/255.0 blue:216/255.0 alpha:1],
                                         LMRBorderColorSettingName: [UIColor colorWithRed:46/255.0 green:128/255.0 blue:182/255.0 alpha:1],
                                         LMRTextColorOfHeaderSettingName: [UIColor whiteColor],
                                         }];
    return [LMRStyle styleWithSettings:settings];
}

+ (instancetype)greenStyle {
    NSMutableDictionary *settings = [[self defaultLayoutSettings] mutableCopy];
    [settings addEntriesFromDictionary:@{
                                         LMRBackgroundColorOfHeaderSettingName: [UIColor colorWithRed:0.086 green:0.627 blue:0.521 alpha:1],
                                         LMRBorderColorSettingName: [UIColor colorWithRed:0.2 green:0.7 blue:0.6 alpha:1],
                                         LMRTextColorOfHeaderSettingName: [UIColor whiteColor],
                                         LMRTextColorSettingName: [UIColor colorWithWhite:0.25 alpha:1],
                                         LMRStripeTextColorSettingName: [UIColor colorWithRed:0.8 green:0 blue:0 alpha:1],
                                         }];
    return [LMRStyle styleWithSettings:settings];
}

@end
