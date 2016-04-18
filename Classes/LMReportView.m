//
//  LMReportView.m
//  LMReportView
//
//  Created by Chenly on 15/2/27.
//  Copyright (c) 2015年 Chenly. All rights reserved.
//

#import "LMReportView.h"
#import "LMRGrid.h"
#import "LMRLabel.h"
#import "LMRStyle.h"
#import "NSIndexPath+LMReport.h"

typedef NS_ENUM(NSUInteger, LMRPart) {
    LMRPartTopLeft,
    LMRPartTopRight,
    LMRPartBottomLeft,
    LMRPartBottomRight,
};

@interface LMReportView () <UIScrollViewDelegate>
{
    UIScrollView *_topRightScroll;
    UIScrollView *_bottomRightScroll;
    UIScrollView *_bottomLeftScroll;
    UIView *_topLeftView;
    UIView *_topRightView;
    UIView *_bottomLeftView;
    UIView *_bottomRightView;
    
    NSInteger _numberOfRows;
    NSInteger _numberOfCols;
    NSInteger _numberOfHeadRows;
    
    struct {
        unsigned int numberOfHeadRows   : 1;
        unsigned int heightOfRow        : 1;
        unsigned int widthOfCol         : 1;
    } _datasourceFlags;
    
    struct {
        unsigned int didTapLabel        : 1;
        unsigned int didLongPressLabel  : 1;
        unsigned int indexesSorted      : 1;
    } _delegateFlags;
}
@end

@implementation LMReportView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self p_setupViews];
        [self p_setupGestureRecognizers];
        _style = [LMRStyle defaultStyle];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self p_setupViews];
        [self p_setupGestureRecognizers];
        _style = [LMRStyle defaultStyle];
    }
    return self;
}

- (void)p_setupViews {
    _topRightScroll = [[UIScrollView alloc] init];
    _topRightScroll.backgroundColor = [UIColor clearColor];
    _topRightScroll.scrollEnabled = NO;
    
    _bottomLeftScroll = [[UIScrollView alloc] init];
    _bottomLeftScroll.backgroundColor = [UIColor clearColor];
    _bottomLeftScroll.scrollEnabled = NO;
    
    _bottomRightScroll = [[UIScrollView alloc] init];
    _bottomRightScroll.backgroundColor = [UIColor clearColor];
    _bottomRightScroll.bounces = NO;
    _bottomRightScroll.directionalLockEnabled = YES;
    _bottomRightScroll.delegate = self;
    
    UIView *(^createContentView)(void) = ^{
        UIView *contentView = [[UIView alloc] init];
        contentView.backgroundColor = [UIColor clearColor];
        contentView.clipsToBounds = YES;
        return contentView;
    };    
    _topLeftView = createContentView();
    _topRightView = createContentView();
    _bottomLeftView = createContentView();
    _bottomRightView = createContentView();
    
    [_topRightScroll addSubview:_topRightView];
    [_bottomLeftScroll addSubview:_bottomLeftView];
    [_bottomRightScroll addSubview:_bottomRightView];
    
    [self addSubview:_topLeftView];
    [self addSubview:_topRightScroll];
    [self addSubview:_bottomLeftScroll];
    [self addSubview:_bottomRightScroll];
}

- (void)p_setupGestureRecognizers {
    _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(p_handleLongPressGR:)];
    _longPressGestureRecognizer.minimumPressDuration = 1.0;
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_handleTapGR:)];
    [_tapGestureRecognizer requireGestureRecognizerToFail:_longPressGestureRecognizer];
    [self addGestureRecognizer:_longPressGestureRecognizer];
    [self addGestureRecognizer:_tapGestureRecognizer];
}

- (void)didMoveToSuperview {
    if (!self.superview) {
        return;
    }
    [super didMoveToSuperview];
    [self reloadData];
}

#pragma mark - load

- (void)reloadData {
    @autoreleasepool {
        [_topLeftView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_topRightView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_bottomLeftView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_bottomRightView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    if (!_datasource) {
        return;
    }

    self.backgroundColor = _style.borderColor;
    
    _numberOfRows = [_datasource numberOfRowsInReportView:self];
    _numberOfCols = [_datasource numberOfColsInReportView:self];
    if (_numberOfRows * _numberOfCols == 0) {
        return;
    }
    _numberOfHeadRows = [_datasource respondsToSelector:@selector(numberOfHeadRowsInReportView:)] ? [_datasource numberOfHeadRowsInReportView:self] : 1;
    
    _datasourceFlags.numberOfHeadRows = [_datasource respondsToSelector:@selector(numberOfHeadRowsInReportView:)];
    _datasourceFlags.heightOfRow = [_datasource respondsToSelector:@selector(reportView:heightOfRow:)];
    _datasourceFlags.widthOfCol = [_datasource respondsToSelector:@selector(reportView:widthOfCol:)];
    
    _delegateFlags.didTapLabel = [_delegate respondsToSelector:@selector(reportView:didTapLabel:)];
    _delegateFlags.didLongPressLabel = [_delegate respondsToSelector:@selector(reportView:didLongPressLabel:)];
    _delegateFlags.indexesSorted = [_delegate respondsToSelector:@selector(reportView:indexesSortedByCol:order:)];
    _sortedCol = 0;
    _sortedOrder = LMROrderedNature;
    
    [self p_loadTopLeft];
    [self p_loadTopRight];
    [self p_loadBottomLeft];
    [self p_loadBottomRight];
    [self setNeedsLayout];
}

- (void)p_loadTopLeft {
    CGRect rect = CGRectZero;
    rect.size.width = _datasourceFlags.widthOfCol ? [_datasource reportView:self widthOfCol:0] : _style.widthOfFirstCol;
    
    NSInteger row = 0;
    while (row < _numberOfHeadRows) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForCol:0 inRow:row];
        LMRGrid *grid = [_datasource reportView:self gridAtIndexPath:indexPath];
        if (!grid) {
            row ++;
            continue;
        }
        grid.indexPath = indexPath;
        LMRLabel *label;
        [self p_getLabel:&label forGrid:grid inPart:LMRPartTopLeft];
        label.indexPath = indexPath;
        
        if (_datasourceFlags.heightOfRow) {
            CGFloat height = 0;
            for (NSInteger i = row; i < row + grid.rowspan; i ++) {
                height += [_datasource reportView:self heightOfRow:i];
            }
            height += _style.spacing * (grid.rowspan - 1);
            rect.size.height = height;
        }
        else {
            rect.size.height = (_style.heightOfHeaderRow + _style.spacing) * grid.rowspan - _style.spacing;
        }
        label.frame = rect;
        if (_style.isAutoFitHeight && label.rowspan == 1) {
            [label heightToFit];
        }
        rect = label.frame;
        
        [_topLeftView addSubview:label];
        row += grid.rowspan;
        rect.origin.y = CGRectGetMaxY(rect) + _style.spacing;
    }
    rect.size.height = rect.origin.y - _style.spacing;
    rect.origin = CGPointMake(_style.borderInsets.left, _style.borderInsets.top);
    _topLeftView.frame = rect;
}

- (void)p_loadTopRight {
    CGRect rect = CGRectZero;
    NSInteger row = 0;
    while (row < _numberOfHeadRows) {
        rect.origin = CGPointZero;
        rect.origin.y = 0;        
        for (NSInteger i = 0; i < row; i ++) {
            if (_datasourceFlags.heightOfRow) {
                rect.origin.y += [_datasource reportView:self heightOfRow:i] + _style.spacing;
            }
            else {
                rect.origin.y += _style.heightOfHeaderRow + _style.spacing;
            }
        }
        NSInteger col = 1;
        while (col < _numberOfCols) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForCol:col inRow:row];
            LMRGrid *grid = [_datasource reportView:self gridAtIndexPath:indexPath];
            if (!grid) {
                rect.origin.x += (_datasourceFlags.widthOfCol ? [_datasource reportView:self widthOfCol:col] : _style.widthOfCol) + _style.spacing;
                col ++;
                continue;
            }
            grid.indexPath = indexPath;
            LMRLabel *label;
            [self p_getLabel:&label forGrid:grid inPart:LMRPartTopRight];
            label.indexPath = indexPath;
            
            if (_datasourceFlags.widthOfCol) {
                CGFloat width = 0;
                for (NSInteger i = col; i < col + grid.colspan; i ++) {
                    width += [_datasource reportView:self widthOfCol:i];
                }
                width += _style.spacing * (grid.colspan - 1);
                rect.size.width = width;
            }
            else {
                rect.size.width = (_style.widthOfCol + _style.spacing) * grid.colspan - _style.spacing;
            }
            if (_datasourceFlags.heightOfRow) {
                CGFloat height = 0;
                for (NSInteger i = row; i < row + grid.rowspan; i ++) {
                    height += [_datasource reportView:self heightOfRow:i];
                }
                height += _style.spacing * (grid.rowspan - 1);
                rect.size.height = height;
            }
            else {
                rect.size.height = (_style.heightOfHeaderRow + _style.spacing) * grid.rowspan - _style.spacing;
            }
            label.frame = rect;
            if (_style.isAutoFitHeight && label.rowspan == 1) {
                [label heightToFit];
            }
            rect = label.frame;
            
            [_topRightView addSubview:label];
            col += grid.colspan;
            rect.origin.x = CGRectGetMaxX(rect) + _style.spacing;
        }
        row ++;
    }
    rect.size.width = rect.origin.x - _style.spacing;
    rect.size.height = CGRectGetMaxY(rect);
    rect.origin = CGPointZero;
    _topRightView.frame = rect;
    _topRightScroll.contentSize = rect.size;
}

- (void)p_loadBottomLeft {
    CGRect rect = CGRectZero;
    rect.size.width = _datasourceFlags.widthOfCol ? [_datasource reportView:self widthOfCol:0] : _style.widthOfFirstCol;
    
    NSInteger row = _numberOfHeadRows;
    while (row < _numberOfRows) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForCol:0 inRow:row];
        LMRGrid *grid = [_datasource reportView:self gridAtIndexPath:indexPath];
        if (!grid) {
            rect.origin.x +=  _style.widthOfCol + _style.spacing;
            row ++;
            continue;
        }
        grid.indexPath = indexPath;
        LMRLabel *label;
        [self p_getLabel:&label forGrid:grid inPart:LMRPartBottomLeft];
        label.indexPath = indexPath;
        
        if (_datasourceFlags.heightOfRow) {
            CGFloat height = 0;
            for (NSInteger i = row; i < row + grid.rowspan; i ++) {
                height += [_datasource reportView:self heightOfRow:i];
            }
            height += _style.spacing * (grid.rowspan - 1);
            rect.size.height = height;
        }
        else {
            rect.size.height = (_style.heightOfRow + _style.spacing) * grid.rowspan - _style.spacing;
        }
        label.frame = rect;
        if (_style.isAutoFitHeight && label.rowspan == 1) {
            [label heightToFit];
        }
        rect = label.frame;
        
        [_bottomLeftView addSubview:label];
        row += grid.rowspan;
        rect.origin.y = CGRectGetMaxY(rect) + _style.spacing;
    }
    rect.size.height = rect.origin.y - _style.spacing;
    rect.origin = CGPointZero;
    _bottomLeftView.frame = rect;
    _bottomLeftScroll.contentSize = rect.size;
}

- (void)p_loadBottomRight {
    CGRect rect = CGRectZero;
    NSInteger row = _numberOfHeadRows;
    while (row < _numberOfRows) {
        rect.origin = CGPointZero;
        rect.origin.y = 0;
        for (NSInteger i = _numberOfHeadRows; i < row; i ++) {
            if (_datasourceFlags.heightOfRow) {
                rect.origin.y += [_datasource reportView:self heightOfRow:i] + _style.spacing;
            }
            else {
                rect.origin.y += _style.heightOfRow + _style.spacing;
            }
        }
        NSInteger col = 1;
        while (col < _numberOfCols) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForCol:col inRow:row];
            LMRGrid *grid = [_datasource reportView:self gridAtIndexPath:indexPath];
            if (!grid) {
                rect.origin.x += (_datasourceFlags.widthOfCol ? [_datasource reportView:self widthOfCol:col] : _style.widthOfCol) + _style.spacing;
                col ++;
                continue;
            }
            grid.indexPath = indexPath;
            LMRLabel *label;
            [self p_getLabel:&label forGrid:grid inPart:LMRPartBottomRight];
            label.indexPath = indexPath;
            
            if (_datasourceFlags.widthOfCol) {
                CGFloat width = 0;
                for (NSInteger i = col; i < col + grid.colspan; i ++) {
                    width += [_datasource reportView:self widthOfCol:i];
                }
                width += _style.spacing * (grid.colspan - 1);
                rect.size.width = width;
            }
            else {
                rect.size.width = (_style.widthOfCol + _style.spacing) * grid.colspan - _style.spacing;
            }
            if (_datasourceFlags.heightOfRow) {
                CGFloat height = 0;
                for (NSInteger i = row; i < row + grid.rowspan; i ++) {
                    height += [_datasource reportView:self heightOfRow:i];
                }
                height += _style.spacing * (grid.rowspan - 1);
                rect.size.height = height;
            }
            else {
                rect.size.height = (_style.heightOfRow + _style.spacing) * grid.rowspan - _style.spacing;
            }
            label.frame = rect;
            if (_style.isAutoFitHeight && label.rowspan == 1) {
                [label heightToFit];
            }
            rect = label.frame;
            
            [_bottomRightView addSubview:label];
            col += grid.colspan;
            rect.origin.x = CGRectGetMaxX(rect) + _style.spacing;
        }
        row ++;
    }
    rect.size.width = rect.origin.x - _style.spacing;
    rect.size.height = CGRectGetMaxY(rect);
    rect.origin = CGPointZero;
    _bottomRightView.frame = rect;
    _bottomRightScroll.contentSize = rect.size;
}

- (void)p_getLabel:(LMRLabel **)label forGrid:(LMRGrid *)grid inPart:(LMRPart)part {
    LMRLabel *theLabel = [LMRLabel new];
    switch (part) {
        case LMRPartTopLeft:
        case LMRPartTopRight:
        {
            theLabel.font = grid.font ? : _style.fontOfHeader;
            theLabel.textColor = grid.textColor ? : _style.textColorOfHeader;
            theLabel.backgroundColor = grid.backgroundColor ? : _style.backgroundColorOfHeader;
            theLabel.textAlignment = grid.isTextAlignmentOriginal ? _style.textAlignmentOfHeader : grid.textAlignment;
            break;
        }
        case LMRPartBottomLeft:
        case LMRPartBottomRight:
        {
            theLabel.font = grid.font ? : _style.font;
            UIColor *textColor = grid.textColor;
            if (!textColor) {
                textColor = _style.textColor;
                if (_style.stripeTextColor && (grid.indexPath.row - _numberOfHeadRows) % 2 == 1) {
                    textColor = _style.stripeTextColor;
                }
            }
            theLabel.textColor = textColor;
            UIColor *backgroundColor = grid.backgroundColor;
            if (!backgroundColor) {
                backgroundColor = _style.backgroundColor;
                if (_style.stripeBackgroundColor && (grid.indexPath.row - _numberOfHeadRows) % 2 == 1) {
                    backgroundColor = _style.stripeBackgroundColor;
                }
            }
            theLabel.backgroundColor = backgroundColor;
            theLabel.textAlignment = grid.isTextAlignmentOriginal ? _style.textAlignment : grid.textAlignment;
            break;
        }
    }
    theLabel.rowspan = grid.rowspan;
    theLabel.colspan = grid.colspan;
    theLabel.image = grid.image;
    theLabel.text = grid.text;
    theLabel.lineBreakMode = NSLineBreakByCharWrapping;
    theLabel.numberOfLines = 0;
    theLabel.underline = grid.underline;
    *label = theLabel;
}

#pragma mark - layout

- (void)layoutSubviews {
    if (!_datasource) {
        return;
    }
    
    if (_style.isAutoFitHeight) {
        [self p_fitHeight];
    }
    
    CGFloat frameWidth = CGRectGetWidth(self.frame);
    CGFloat frameHeight = CGRectGetHeight(self.frame);
    CGFloat contentWidth = CGRectGetMaxX(_topLeftView.frame) + _style.spacing + _bottomRightScroll.contentSize.width + _style.borderInsets.right;
    CGFloat contentHeight = CGRectGetMaxY(_topLeftView.frame) + _style.spacing + _bottomRightScroll.contentSize.height + _style.borderInsets.bottom;
    if (frameWidth == contentWidth && frameHeight == contentHeight) {
        return;
    }
    
    //frameWidth设为0的时候自动拉伸到内容实际宽度
    if (frameWidth == 0) {
        frameWidth = contentWidth;
    }
    //frameHeight设为0的时候自动拉伸到内容实际高度
    if (frameHeight == 0) {
        frameHeight = contentHeight;
    }
    
    if (contentWidth < frameWidth && _style.isTrimWidthSpace) {
        frameWidth = contentWidth;
    }
    if (contentHeight < frameHeight && _style.isTrimHeightSpace) {
        frameHeight = contentHeight;
    }
    
    CGRect rect = self.frame;
    rect.size.width = frameWidth;
    rect.size.height = frameHeight;
    self.frame = rect;
    
    rect = _topLeftView.frame;
    rect.origin.x = CGRectGetMaxX(rect) + _style.spacing;
    rect.size.width = CGRectGetWidth(self.frame) - _style.borderInsets.right - rect.origin.x;
    _topRightScroll.frame = rect;
    
    rect = _topLeftView.frame;
    rect.origin.y = CGRectGetMaxY(rect) + _style.spacing;
    rect.size.height = CGRectGetHeight(self.frame) - _style.borderInsets.bottom - rect.origin.y;
    _bottomLeftScroll.frame = rect;
    
    rect.origin.x = CGRectGetMinX(_topRightScroll.frame);
    rect.origin.y = CGRectGetMinY(_bottomLeftScroll.frame);
    rect.size.width = CGRectGetWidth(_topRightScroll.frame);
    rect.size.height = CGRectGetHeight(_bottomLeftScroll.frame);
    _bottomRightScroll.frame = rect;
}

- (NSArray *)p_suitableHeights {
    NSMutableArray *heights = [NSMutableArray arrayWithCapacity:_numberOfRows];
    for (int i = 0; i <_numberOfRows; i ++) {
        [heights addObject:@(0)];
    }
    for (UIView *contentView in @[_topLeftView, _topRightView, _bottomLeftView, _bottomRightView]) {
        for (LMRLabel *label in contentView.subviews) {
            if (label.rowspan > 1) {
                continue;
            }
            CGFloat maxHeight = [heights[label.indexPath.row] floatValue];
            CGFloat currentHeight = CGRectGetHeight(label.frame);
            if (currentHeight > maxHeight) {
                heights[label.indexPath.row] = @(currentHeight);
            }
        }
    }
    return [heights copy];
}

- (void)p_fitHeight {
    NSArray *heights = [self p_suitableHeights];
    for (UIView *contentView in @[_topLeftView, _topRightView, _bottomLeftView, _bottomRightView]) {
        for (LMRLabel *label in contentView.subviews) {
            CGRect rect = label.frame;
            rect.origin.y = 0;
            
            NSInteger i = (contentView == _topLeftView || contentView == _topRightView) ? 0 : _numberOfHeadRows;
            while (i < label.indexPath.row) {
                rect.origin.y += [heights[i] floatValue] + _style.spacing;
                i ++;
            }
            rect.size.height = 0;
            for (int i = 0; i < label.rowspan; i ++) {
                rect.size.height += [heights[label.indexPath.row + i] floatValue];
            }
            label.frame = rect;
        }
    }

    void (^frameSet)(UIView *) = ^(UIView *view){
        CGRect rect = view.frame;
        rect.size.height = CGRectGetMaxY([[view.subviews lastObject] frame]);
        view.frame = rect;
    };
    frameSet(_topLeftView);
    frameSet(_topRightView);
    frameSet(_bottomLeftView);
    frameSet(_bottomRightView);
    
    CGRect rect;
    _topRightScroll.contentSize = _topRightView.frame.size;
    rect = _topRightScroll.frame;
    rect.size.height = CGRectGetHeight(_topLeftView.frame);
    _topRightScroll.frame = rect;
    
    _bottomLeftScroll.contentSize = _bottomLeftView.frame.size;
    rect = _bottomLeftScroll.frame;
    rect.origin.y = CGRectGetMaxY(_topLeftView.frame) + _style.spacing;
    rect.size.height = CGRectGetHeight(_bottomLeftView.frame);
    _bottomLeftScroll.frame = rect;
    
    _bottomRightScroll.contentSize = _bottomRightView.frame.size;
    rect = _bottomRightScroll.frame;
    rect.origin.x = CGRectGetMinX(_topRightScroll.frame);
    rect.origin.y = CGRectGetMinY(_bottomLeftScroll.frame);
    rect.size.width = CGRectGetWidth(_topRightScroll.frame);
    rect.size.height = CGRectGetHeight(_bottomLeftScroll.frame);
    _bottomRightScroll.frame = rect;
}

#pragma mark - ScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _bottomRightScroll) {
        _topRightScroll.contentOffset = CGPointMake(_bottomRightScroll.contentOffset.x, 0);
        _bottomLeftScroll.contentOffset = CGPointMake(0, _bottomRightScroll.contentOffset.y);
    }
}

#pragma mark - handle gesture recognizer

- (LMRLabel *)p_touchedLabelWithGesture:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:self];
    UIView *inView;
    for (UIView *view in @[_topLeftView, _topRightView, _bottomLeftView, _bottomRightView]) {
        CGRect rect = [view convertRect:view.bounds toView:self];
        if (CGRectContainsPoint(rect, point)) {
            inView = view;
            break;
        }
    }
    if (!inView) {
        return nil;
    }
    LMRLabel *label;
    for (UIView *subview in inView.subviews) {
        if ([subview isKindOfClass:[LMRLabel class]]) {
            CGRect rect = [subview convertRect:subview.bounds toView:self];
            if (CGRectContainsPoint(rect, point)) {
                label = (LMRLabel *)subview;
                break;
            }
        }
    }
    return label;
}

- (void)p_handleLongPressGR:(UILongPressGestureRecognizer *)longPressGR {
    if (longPressGR.state != UIGestureRecognizerStateBegan) {
        return;
    }
    if (_delegateFlags.didLongPressLabel) {
        LMRLabel *label = [self p_touchedLabelWithGesture:longPressGR];
        if (label) {
            [_delegate reportView:self didLongPressLabel:[self p_touchedLabelWithGesture:longPressGR]];
        }
    }
}

- (void)p_handleTapGR:(UILongPressGestureRecognizer *)tapGR {
    if (_delegateFlags.didTapLabel) {
        LMRLabel *label = [self p_touchedLabelWithGesture:tapGR];
        if (label) {
            [_delegate reportView:self didTapLabel:label];
        }
    }
}

#pragma mark - 

- (NSInteger)numberOfRows {
    return _numberOfRows;
}

- (NSInteger)numberOfCols {
    return _numberOfCols;
}

- (NSInteger)numberOfHeadRows {
    return _numberOfHeadRows;
}

- (LMRGrid *)gridAtIndexPath:(NSIndexPath *)indexPath {
    return [_datasource reportView:self gridAtIndexPath:indexPath];
}

- (CGFloat)heightOfRow:(NSInteger)row {
    if (_datasourceFlags.heightOfRow) {
        return [_datasource reportView:self heightOfRow:row];
    }
    else {
        return row < _numberOfHeadRows ? _style.heightOfHeaderRow : _style.heightOfRow;
    }
}

- (CGFloat)widthOfCol:(NSInteger)col {
    if (_datasourceFlags.widthOfCol) {
        return [_datasource reportView:self widthOfCol:col];
    }
    else {
        return col == 0 ? _style.widthOfFirstCol : _style.widthOfCol;
    }
}

#pragma mark - sort

- (void)sortByCol:(NSInteger)col order:(LMROrder)order {
    if (!_delegateFlags.indexesSorted) {
        return;
    }
    
    if (_sortedOrder != LMROrderedNature) {
        LMRLabel *label;
        if (_sortedCol == 0) {
            label = _topLeftView.subviews[0];
        }
        else {
            label = _topRightView.subviews[_sortedCol - 1];
        }
        label.text = [label.text substringToIndex:label.text.length - 1];
    }
    _sortedCol = col;
    _sortedOrder = order;
    LMRLabel *label;
    if (col == 0) {
        label = _topLeftView.subviews[0];
    }
    else {
        label = _topRightView.subviews[_sortedCol - 1];
    }
    NSOrderedSet *indexes;
    switch (order) {
        case LMROrderedAscending:
        {
            label.text = [label.text stringByAppendingString:@"↑"];
            indexes = [self.delegate reportView:self indexesSortedByCol:col order:order];
            break;
        }
        case LMROrderedNature:
        {
            NSMutableOrderedSet *tempIndexes = [[NSMutableOrderedSet alloc] initWithCapacity:_numberOfRows - 1];
            NSInteger i = 1;
            while (i < _numberOfRows) {
                [tempIndexes addObject:@(i)];
                i ++;
            }
            indexes = [tempIndexes copy];
            break;
        }
        case LMROrderedDescending:
        {
            label.text = [label.text stringByAppendingString:@"↓"];
            indexes = [self.delegate reportView:self indexesSortedByCol:col order:order];
            break;
        }
    }
    NSMutableArray *yOrigins = [NSMutableArray arrayWithCapacity:_numberOfRows - 1];
    CGFloat y = 0;
    for (NSNumber *index in indexes) {
        [yOrigins addObject:@(y)];
        LMRLabel *label = _bottomLeftView.subviews[index.integerValue - 1];
        CGRect rect = label.frame;
        rect.origin.y = y;
        label.frame = rect;
        y += CGRectGetHeight(rect) + _style.spacing;
    }
    for (LMRLabel *label in _bottomRightView.subviews) {
        CGRect rect = label.frame;
        __block NSInteger index;
        [indexes enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL *stop) {
            if ([obj isEqualToNumber:@(label.indexPath.row)]) {
                index = idx;
                *stop = YES;
            }
        }];
        rect.origin.y = [yOrigins[index] floatValue];
        label.frame = rect;
    }
}

@end