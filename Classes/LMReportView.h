
#import <UIKit/UIKit.h>

@class LMReportView;
@class LMRGrid;
@class LMRLabel;
@class LMRStyle;

typedef NS_ENUM(NSInteger, LMROrder) {
    LMROrderedAscending = -1,
    LMROrderedNature,
    LMROrderedDescending
};

@protocol LMReportViewDatasource <NSObject>

@required
- (NSInteger)numberOfRowsInReportView:(LMReportView *)reportView;
- (NSInteger)numberOfColsInReportView:(LMReportView *)reportView;
- (LMRGrid *)reportView:(LMReportView *)reportView gridAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (NSInteger)numberOfHeadRowsInReportView:(LMReportView *)reportView; // 表头行数，默认为1
- (CGFloat)reportView:(LMReportView *)reportView heightOfRow:(NSInteger)row; // 某一行的高度，如果未实现则取style中的heightOfHeaderRow/heightOfRow的值
- (CGFloat)reportView:(LMReportView *)reportView widthOfCol:(NSInteger)col; // 某一列的宽度，如果未实现则取style中的widthOfFirstCol/widthOfCol的值

@end

@protocol LMReportViewDelegate <NSObject>

@optional
- (void)reportView:(LMReportView *)reportView didTapLabel:(LMRLabel *)label;
- (void)reportView:(LMReportView *)reportView didLongPressLabel:(LMRLabel *)label;
- (NSOrderedSet *)reportView:(LMReportView *)reportView indexesSortedByCol:(NSInteger)col order:(LMROrder)order;

@end

@interface LMReportView : UIView

@property (nonatomic, weak) id<LMReportViewDatasource> datasource;
@property (nonatomic, weak) id<LMReportViewDelegate> delegate;

@property (nonatomic, readonly) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, readonly) UILongPressGestureRecognizer *longPressGestureRecognizer; // 默认minimumPressDuration = 1.0。

@property (nonatomic, strong) LMRStyle *style; // 报表整体风格样式，在报表已加载过的情况下(didMoveToSuperview)，需要调用手动reloadData来刷新样式。

@property (nonatomic, assign) NSInteger sortedCol;
@property (nonatomic, assign) LMROrder sortedOrder;

- (instancetype)initWithFrame:(CGRect)frame; // 在frame.size.width/height == 0 时候，会自动拉伸至内容所需宽度/长度
- (void)reloadData;
- (void)sortByCol:(NSInteger)col order:(LMROrder)order;

- (NSInteger)numberOfRows;
- (NSInteger)numberOfCols;
- (NSInteger)numberOfHeadRows;
- (LMRGrid *)gridAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)heightOfRow:(NSInteger)row;
- (CGFloat)widthOfCol:(NSInteger)col;

@end
