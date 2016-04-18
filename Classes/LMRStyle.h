//
//  LMRStyle.h
//  LMReportView
//
//  Created by Chenly on 15/2/27.
//  Copyright (c) 2015年 Chenly. All rights reserved.
//

#import <UIKit/UIKit.h>

// LMRStyleSettings
extern NSString *const LMRHeightOfHeaderRowSettingName;
extern NSString *const LMRHeightOfRowSettingName;
extern NSString *const LMRWidthOfFirstColSettingName;
extern NSString *const LMRWidthOfColSettingName;
extern NSString *const LMRAutoFitHeightSettingName;
extern NSString *const LMRBackgroundColorSettingName;
extern NSString *const LMRBackgroundColorOfHeaderSettingName;
extern NSString *const LMRTextColorSettingName;
extern NSString *const LMRTextColorOfHeaderSettingName;
extern NSString *const LMRFontSettingName;
extern NSString *const LMRFontOfHeaderSettingName;
extern NSString *const LMRTextAlignmentSettingName;
extern NSString *const LMRTextAlignmentOfHeaderSettingName;
extern NSString *const LMRSpacingSettingName;
extern NSString *const LMRBorderColorSettingName;
extern NSString *const LMRBorderInsetsSettingName;
extern NSString *const LMRTrimWidthSpaceSettingName;
extern NSString *const LMRTrimHeightSpaceSettingName;
extern NSString *const LMRStripeBackgroundColorSettingName;
extern NSString *const LMRStripeTextColorSettingName;


/**
 *  LMRStyle 对应报表整体的风格样式
 */
@interface LMRStyle : NSObject
/**
 *  表头行高，为0时返回heightOfRow，默认为0。
 */
@property (nonatomic, assign) CGFloat heightOfHeaderRow;
/**
 *  行高，默认为0。
 */
@property (nonatomic, assign) CGFloat heightOfRow;
/**
 *  第一列宽度，为0时返回widthOfCol，默认为0。
 */
@property (nonatomic, assign) CGFloat widthOfFirstCol;
/**
 *  列宽，默认为0。
 */
@property (nonatomic, assign) CGFloat widthOfCol;
/**
 *  表头是否自适应行高，当一行中的某个单元格文字较多超出所设置的行高时，是否自动调整行高使文字全部显示，默认为No。(在datasource实现heightOfRow方法时无效)
 */
@property (nonatomic, assign, getter=isAutoFitHeight) BOOL autoFitHeight;
/**
 *  表头背景颜色，为空时返回下面属性background的值，默认为nil。
 */
@property (nonatomic, strong) UIColor *backgroundColorOfHeader;
/**
 *  背景颜色，默认为[UIColor whiteColor]
 */
@property (nonatomic, strong) UIColor *backgroundColor;
/**
 *  表头字体颜色，为空时返回下面属性textColor的值，默认为nil。
 */
@property (nonatomic, strong) UIColor *textColorOfHeader;
/**
 *  字体颜色，默认为[UIColor blackColor]。
 */
@property (nonatomic, strong) UIColor *textColor;
/**
 *  表头字体，为空时返回下面属性font的值，默认为nil。
 */
@property (nonatomic, strong) UIFont *fontOfHeader;
/**
 *  字体，默认为[UIFont systemFontOfSize:17.f]。
 */
@property (nonatomic, strong) UIFont *font;
/**
 *  表头对齐方式，未设置时返回textAlignment。
 */
@property(nonatomic, assign) NSTextAlignment textAlignmentOfHeader;
/**
 *  对齐方式，默认为NSTextAlignmentCenter。
 */
@property(nonatomic, assign) NSTextAlignment textAlignment;
/**
 *  单元格间距（表格线宽），默认为1。
 */
@property (nonatomic, assign) CGFloat spacing;
/**
 *  边界线，默认为{1，1，1，1}。
 */
@property (nonatomic, assign) UIEdgeInsets borderInsets;
/**
 *  边界线颜色，默认为[UIColor grayColor]。
 */
@property (nonatomic, strong) UIColor *borderColor;
/**
 *  切除多余，默认为YES。
 */
@property (nonatomic, assign, getter=isTrimWidthSpace) BOOL trimWidthSpace;
/**
 *  当实际表格高度小于设置的Frame时候调整单元格高度
 */
@property (nonatomic, assign, getter=isTrimHeightSpace) BOOL trimHeightSpace;
/**
 *  条纹背景色(设置表格奇偶行不一致背景色增加对比度)，默认为nil。
 */
@property (nonatomic, strong) UIColor *stripeBackgroundColor;
/**
 *  条纹字体颜色，默认为nil。
 */
@property (nonatomic, strong) UIColor *stripeTextColor;

+ (instancetype)defaultStyle;
+ (instancetype)styleWithSettings:(NSDictionary *)settings;
- (instancetype)initWithSettings:(NSDictionary *)settings;

@end
