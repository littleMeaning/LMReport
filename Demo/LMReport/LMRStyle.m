//
//  LMRStyle.m
//  LMReportView
//
//  Created by Chenly on 15/2/27.
//  Copyright (c) 2015年 Chenly. All rights reserved.
//

#import "LMRStyle.h"

NSString *const LMRHeightOfHeaderRowSettingName = @"LMRHeightOfHeaderRow";
NSString *const LMRHeightOfRowSettingName = @"LMRHeightOfRow";
NSString *const LMRWidthOfFirstColSettingName = @"LMRWidthOfFirstCol";
NSString *const LMRWidthOfColSettingName = @"LMRWidthOfCol";
NSString *const LMRAutoFitHeightSettingName = @"LMRAutoFitHeight";
NSString *const LMRBackgroundColorSettingName = @"LMRBackgroundColor";
NSString *const LMRBackgroundColorOfHeaderSettingName = @"LMRBackgroundColorOfHeader";
NSString *const LMRTextColorSettingName = @"LMRTextColor";
NSString *const LMRTextColorOfHeaderSettingName = @"LMRTextColorOfHeader";
NSString *const LMRFontSettingName = @"LMRFont";
NSString *const LMRFontOfHeaderSettingName = @"LMRFontOfHeader";
NSString *const LMRTextAlignmentSettingName = @"LMRTextAlignment";
NSString *const LMRTextAlignmentOfHeaderSettingName = @"LMRTextAlignmentOfHeader";
NSString *const LMRSpacingSettingName = @"LMRSpacing";
NSString *const LMRBorderColorSettingName = @"LMRBorderColor";
NSString *const LMRBorderInsetsSettingName = @"LMRBorderInsets";
NSString *const LMRTrimWidthSpaceSettingName = @"LMRTrimWidthSpace";
NSString *const LMRTrimHeightSpaceSettingName = @"LMRTrimHeightSpace";
NSString *const LMRStripeBackgroundColorSettingName = @"LMRStripeBackgroundColor";
NSString *const LMRStripeTextColorSettingName = @"LMRStripeTextColor";

@implementation LMRStyle
{
    BOOL _isTextAlignmentOfHeaderOrigin;
}

@synthesize textAlignmentOfHeader = _textAlignmentOfHeader;

- (instancetype)init {
    return [self initWithSettings:nil];
}

- (instancetype)initWithSettings:(NSDictionary *)settings {
    if (self = [super init]) {
        _heightOfHeaderRow = 0.f;
        _heightOfRow = 0.f;
        _widthOfFirstCol = 0.f;
        _widthOfCol = 0.f;
        _backgroundColor = [UIColor whiteColor];
        _backgroundColorOfHeader = nil;
        _textColor = [UIColor blackColor];
        _textColorOfHeader = nil;
        _font = [UIFont systemFontOfSize:17.f];
        _fontOfHeader = nil;
        _textAlignment = NSTextAlignmentCenter;
        _isTextAlignmentOfHeaderOrigin = YES;
        _spacing = 1.f;
        _borderColor = [UIColor grayColor];
        _borderInsets = UIEdgeInsetsMake(1.f, 1.f, 1.f, 1.f);
        _trimWidthSpace = YES;
        _trimHeightSpace = YES;
        _stripeBackgroundColor = nil;
        _stripeTextColor = nil;
        
        if (settings) {
            id obj;
            if ((obj = [settings objectForKey:LMRHeightOfHeaderRowSettingName])) _heightOfHeaderRow = [obj floatValue];
            if ((obj = [settings objectForKey:LMRHeightOfRowSettingName])) _heightOfRow = [obj floatValue];
            if ((obj = [settings objectForKey:LMRWidthOfFirstColSettingName])) _widthOfFirstCol = [obj floatValue];
            if ((obj = [settings objectForKey:LMRWidthOfColSettingName])) _widthOfCol = [obj floatValue];
            if ((obj = [settings objectForKey:LMRAutoFitHeightSettingName])) _autoFitHeight = [obj boolValue];
            if ((obj = [settings objectForKey:LMRBackgroundColorSettingName])) _backgroundColor = obj;
            if ((obj = [settings objectForKey:LMRBackgroundColorOfHeaderSettingName])) _backgroundColorOfHeader = obj;
            if ((obj = [settings objectForKey:LMRTextColorSettingName])) _textColor = obj;
            if ((obj = [settings objectForKey:LMRTextColorOfHeaderSettingName])) _textColorOfHeader = obj;
            if ((obj = [settings objectForKey:LMRFontSettingName])) _font = obj;
            if ((obj = [settings objectForKey:LMRFontOfHeaderSettingName])) _fontOfHeader = obj;
            if ((obj = [settings objectForKey:LMRTextAlignmentSettingName])) _textAlignment = [obj integerValue];
            if ((obj = [settings objectForKey:LMRTextAlignmentOfHeaderSettingName])) self.textAlignmentOfHeader = [obj floatValue];
            if ((obj = [settings objectForKey:LMRSpacingSettingName])) _spacing = [obj floatValue];
            if ((obj = [settings objectForKey:LMRBorderColorSettingName])) _borderColor = obj;
            if ((obj = [settings objectForKey:LMRBorderInsetsSettingName])) _borderInsets = [obj UIEdgeInsetsValue];
            if ((obj = [settings objectForKey:LMRTrimWidthSpaceSettingName])) _trimWidthSpace = [obj boolValue];
            if ((obj = [settings objectForKey:LMRTrimHeightSpaceSettingName])) _trimHeightSpace = [obj boolValue];
            if ((obj = [settings objectForKey:LMRStripeBackgroundColorSettingName])) _stripeBackgroundColor = obj;
            if ((obj = [settings objectForKey:LMRStripeTextColorSettingName])) _stripeTextColor = obj;
        }
    }
    return self;
}

+ (instancetype)defaultStyle {
    NSDictionary *settings = @{
                               LMRBackgroundColorOfHeaderSettingName: [UIColor colorWithRed:104/255.f green:173/255.f blue:213/255.f alpha:1.f],
                               LMRBorderColorSettingName: [UIColor colorWithRed:170/255.f green:200/255.f blue:230/255.f alpha:1.f],
                               LMRBackgroundColorSettingName: [UIColor whiteColor],
                               LMRHeightOfHeaderRowSettingName: @36.f,
                               LMRHeightOfRowSettingName: @36.f,
                               LMRWidthOfFirstColSettingName: @74.f,
                               LMRWidthOfColSettingName: @75.f,
                               LMRFontOfHeaderSettingName: [UIFont systemFontOfSize:13.f],
                               LMRFontSettingName: [UIFont systemFontOfSize:13.f],
                               LMRTextColorSettingName: [UIColor blackColor],
                               LMRTextColorOfHeaderSettingName: [UIColor whiteColor],
                               LMRBorderInsetsSettingName: [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(1.f, 1.f, 1.f, 1.f)]
                               };
    return [LMRStyle styleWithSettings:settings];
}

+ (instancetype)styleWithSettings:(NSDictionary *)settings {
    return [[LMRStyle alloc] initWithSettings:settings];
}

- (UIColor *)backgroundOfHeader {
    return _backgroundColorOfHeader ?: _backgroundColor;
}

- (void)setTextAlignmentOfHeader:(NSTextAlignment)textAlignmentOfHeader {
    _textAlignmentOfHeader = textAlignmentOfHeader;
    _isTextAlignmentOfHeaderOrigin = NO;
}

- (NSTextAlignment)textAlignmentOfHeader {
    return _isTextAlignmentOfHeaderOrigin ? _textAlignment : _textAlignmentOfHeader;
}

- (UIFont *)fontOfHeader {
    return _fontOfHeader ?: _font;
}

- (UIColor *)textColorOfHeader {
    return _textColorOfHeader ?: _textColor;
}

- (CGFloat)widthOfFirstCol {
    return _widthOfFirstCol > 0 ? _widthOfFirstCol : _widthOfCol;
}

- (CGFloat)heightOfHeaderRow {
    return _heightOfHeaderRow > 0 ? _heightOfHeaderRow : _heightOfRow;
}

@end