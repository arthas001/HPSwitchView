//
//  HPSwitchView.m
//  HPSwitchViewDemo
//
//  Created by 韩学鹏 on 16/10/10.
//  Copyright © 2016年 韩学鹏. All rights reserved.
//

#import "HPSwitchView.h"

const CGFloat kHeightOfTopScrollView = 44.0f;
const CGFloat kWidthOfButtonMargin = 10.0f;
const CGFloat kFontSizeOfTabButton = 17.0f;
const NSUInteger kTagOffset = 100;

@implementation HPSwitchView


/**
 初始化
 */
- (void)initValues
{
    //初始化顶部滚动视图
    self.topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, kHeightOfTopScrollView)];
    self.topScrollView.scrollsToTop = NO;
    self.topScrollView.delegate = self;
    self.topScrollView.backgroundColor = [UIColor clearColor];
    self.topScrollView.pagingEnabled = NO;
    self.topScrollView.showsHorizontalScrollIndicator = NO;
    self.topScrollView.showsVerticalScrollIndicator = NO;
    self.topScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    UIImageView *backImg = [[UIImageView alloc] initWithFrame:self.topScrollView.frame];
    backImg.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    backImg.image = [[UIImage imageNamed:@"navigation_bar"] stretchableImageWithLeftCapWidth:100 topCapHeight:10];
    [self addSubview:backImg];
    [self addSubview:self.topScrollView];
    
    //初始化主滚动视图
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kHeightOfTopScrollView, self.bounds.size.width, self.bounds.size.height - kHeightOfTopScrollView)];
    self.mainScrollView.scrollsToTop = NO;
    self.mainScrollView.delegate = self;
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.userInteractionEnabled = YES;
    self.mainScrollView.bounces = NO;
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    
    self.contentOffsetX = 0;
    
    [self.mainScrollView.panGestureRecognizer addTarget:self action:@selector(scrollHandlePan:)];
    [self addSubview:self.mainScrollView];
    
    self.viewArray = [NSMutableArray array];
    self.isBuildUI = NO;
    
    self.selectedTabID = kTagOffset;
    
    self.shadowImage = [[UIImage imageNamed:@"navigation_bar_on"]
                        stretchableImageWithLeftCapWidth:50.f topCapHeight:5.0f];
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initValues];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initValues];
    }
    
    return self;
}

- (void)setSelectedViewIndex:(NSInteger)selectedViewIndex animated:(BOOL)animated
{
    NSInteger btnTag = kTagOffset + selectedViewIndex;
    UIButton *btn = (UIButton *)[self.topScrollView viewWithTag:btnTag];
    if (btn) {
        if (animated) {
            [self selectNameButton:btn];
        }else {
            [self adjustScrollViewContentX:btn];
            
            //如果更换按钮
            if (btn.tag != self.selectedTabID) {
                //获取之前的按钮
                UIButton *lastButton = (UIButton *)[self.topScrollView viewWithTag:selectedViewIndex];
                lastButton.selected = NO;
                self.selectedTabID = btnTag;
            }
            
            //选中按钮，已经选中的忽略
            if (!btn.selected) {
                btn.selected = YES;
                self.shadowImageView.frame = CGRectMake(btn.frame.origin.x, 0, btn.frame.size.width, kHeightOfTopScrollView);
                
                //设置新页出现
                if (!self.isMainScroll) {
                    [self.mainScrollView setContentOffset:CGPointMake((btnTag-kTagOffset)*self.bounds.size.width, 0) animated:YES];
                }
                self.isMainScroll = NO;
                if (self.delegate && [self.delegate respondsToSelector:@selector(onSwitchView:didSelectedTab:)]) {
                    [self.delegate onSwitchView:self didSelectedTab:_selectedTabID-kTagOffset];
                }
            }
        }
    }
}

- (void)adjustScrollViewContentX:(UIButton *)sender
{
    //如果 当前显示的最后一个tab文字超出右边界
    if (sender.frame.origin.x - _topScrollView.contentOffset.x > self.bounds.size.width - (kWidthOfButtonMargin+sender.bounds.size.width)) {
        //向左滚动视图，显示完整tab文字
        [_topScrollView setContentOffset:CGPointMake(sender.frame.origin.x - (_topScrollView.bounds.size.width- (kWidthOfButtonMargin+sender.bounds.size.width)), 0)  animated:YES];
    }
    
    //如果 （tab的文字坐标 - 当前滚动视图左边界所在整个视图的x坐标） < 按钮的隔间 ，代表tab文字已超出边界
    if (sender.frame.origin.x - _topScrollView.contentOffset.x < kWidthOfButtonMargin) {
        //向右滚动视图（tab文字的x坐标 - 按钮间隔 = 新的滚动视图左边界在整个视图的x坐标），使文字显示完整
        [_topScrollView setContentOffset:CGPointMake(sender.frame.origin.x - kWidthOfButtonMargin, 0)  animated:YES];
    }
}


/**
 创建子视图UI
 */
- (void)buildUI
{
    NSUInteger tabNumber = [self.delegate numberOfTab:self];
    for (int i=0; i<tabNumber; i++) {
        UIViewController *vc = [self.delegate onSwitchView:self viewOfTab:i];
        [self.viewArray addObject:vc];
        [self.mainScrollView addSubview:vc.view];
    }
    
    [self createNameButtons];
    
    //选中第一个view
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSwitchView:didSelectedTab:)]) {
        [self.delegate onSwitchView:self didSelectedTab:_selectedTabID - kTagOffset];
    }
    
    _isBuildUI = YES;
    
    //创建完子视图UI才需要调整布局
    [self setNeedsLayout];
}

//当横竖屏切换时可通过此方法调整布局
- (void)layoutSubviews
{
    //创建完子视图UI才需要调整布局
    if (_isBuildUI) {
        //更新主视图的总宽度
        self.mainScrollView.contentSize = CGSizeMake(self.bounds.size.width * [_viewArray count], 0);
        
        //更新主视图各个子视图的宽度
        for (int i = 0; i < [_viewArray count]; i++) {
            UIViewController *listVC = _viewArray[i];
            listVC.view.frame = CGRectMake(0+self.mainScrollView.bounds.size.width*i, 0,
                                           self.mainScrollView.bounds.size.width, self.mainScrollView.bounds.size.height);
        }
        
        //滚动到选中的视图
        [self.mainScrollView setContentOffset:CGPointMake((self.selectedTabID - kTagOffset)*self.bounds.size.width, 0) animated:NO];
        
        //调整顶部滚动视图选中按钮位置
        UIButton *button = (UIButton *)[_topScrollView viewWithTag:self.selectedTabID];
        [self adjustScrollViewContentX:button];
    }
}

/**
 初始化顶部tab的各个按钮
 */
- (void)createNameButtons
{
    self.shadowImageView = [[UIImageView alloc] init];
    self.shadowImageView.image = self.shadowImage;
    [self.topScrollView addSubview:self.shadowImageView];
    
    //顶部tabbar的总长度
    CGFloat topScrollViewContentWidth = kWidthOfButtonMargin;
    //每个tab偏移量
    CGFloat xOffset = kWidthOfButtonMargin;
    for (int i=0; i<self.viewArray.count; i++) {
        UIViewController *vc = self.viewArray[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGSize textSize;
        textSize.width = 106.6f;
        topScrollViewContentWidth += kWidthOfButtonMargin + textSize.width;
        //设置按钮尺寸
        btn.frame = CGRectMake(xOffset, 0, textSize.width, kHeightOfTopScrollView);
        //计算下一个tab的x偏移量
        xOffset += textSize.width + kWidthOfButtonMargin;
        btn.tag = i+kTagOffset;
        
        //默认选中第一个tab
        if (i  == 0) {
            self.shadowImageView.frame = CGRectMake(kWidthOfButtonMargin, 0, textSize.width, kHeightOfTopScrollView);
            btn.selected = YES;
        }
        
        [btn setTitle:vc.title forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:kFontSizeOfTabButton];
        [btn setTitleColor:self.tabItemNormalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.tabItemSelectedColor forState:UIControlStateSelected];
        [btn setBackgroundImage:self.tabItemNormalBackgroundImage forState:UIControlStateNormal];
        [btn setBackgroundImage:self.tabItemSelectedBackgroundImage forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(selectNameButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.topScrollView addSubview:btn];
    }
}



/**
 选中按钮触发事件

 @param sender sender description
 */
- (void)selectNameButton:(UIButton *)sender
{
    //如果点击的tab文字显示不全，调整滚动视图x坐标使tab文字显示全
    [self adjustScrollViewContentX:sender];
    
    //更换按钮
    if (sender.tag != self.selectedTabID) {
        //获取之前的按钮
        UIButton *lastButton = (UIButton *)[self.topScrollView viewWithTag:self.selectedTabID];
        lastButton.selected = NO;
        self.selectedTabID = sender.tag;
    }
    
    //设置按钮选中状态
    if (!sender.selected) {
        sender.selected = YES;
        
        //动画切换视图
        [UIView animateWithDuration:0.25f animations:^{
            self.shadowImageView.frame = CGRectMake(sender.frame.origin.x, 0, sender.frame.size.width, kHeightOfTopScrollView);
        } completion:^(BOOL finished) {
            if (finished) {
                //设置新页出现
                if (!self.isMainScroll) {
                    [self.mainScrollView setContentOffset:CGPointMake((sender.tag - kTagOffset)*self.bounds.size.width, 0) animated:YES];
                }
                self.isMainScroll = NO;
            }
        }];
    }
}


/**
 传递滑动手势给下一层

 @param pan 滑动手势
 */
- (void)scrollHandlePan:(UIPanGestureRecognizer *)pan
{
    if (self.mainScrollView.contentOffset.x <= 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(onSiwtchView:panLeftEdge:)]) {
            [self.delegate onSiwtchView:self panLeftEdge:pan];
        }
    }else if(self.mainScrollView.contentOffset.x >= self.mainScrollView.contentSize.width - self.mainScrollView.bounds.size.width){
        if (self.delegate && [self.delegate respondsToSelector:@selector(onSwitchView:panRightEdge:)]) {
            [self.delegate onSwitchView:self panRightEdge:pan];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (UIColor *)colorFromHexRGB:(NSString *)hexRGB
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    if (hexRGB) {
        NSScanner *scanner = [NSScanner scannerWithString:hexRGB];
        [scanner scanHexInt:&colorCode];
        redByte = (unsigned char)(colorCode >> 16);
        greenByte = (unsigned char)(colorCode >> 8);
        blueByte = (unsigned char)(colorCode);
        result = [UIColor colorWithRed:(float)redByte/0xff green:(float)greenByte/0xff blue:(float)blueByte/0xff alpha:1.0f];
        return result;
    }
    
    return [UIColor blackColor];
}

#pragma mark - UIScrollViewDelegate


/**
 开始滚动

 @param scrollView scrollView description
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == self.mainScrollView) {
        self.contentOffsetX = scrollView.contentOffset.x;
    }
}


/**
 滚动视图结束

 @param scrollView scrollView description
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //判断是左滚还是右滚
    if (scrollView == self.mainScrollView) {
        self.isLeftScroll = self.contentOffsetX < scrollView.contentOffset.x;
    }
}

/**
 滚动视图释放滚动

 @param scrollView scrollView description
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.mainScrollView) {
        if (self.contentOffsetX<=0 && scrollView.contentOffset.x<=0) {
            self.isMainScroll = NO;
        }else {
            self.isMainScroll = YES;
        }
        //调整顶部滑条按钮状态
        int tag = (int)scrollView.contentOffset.x/self.bounds.size.width + kTagOffset;
        UIButton *button = (UIButton *)[self.topScrollView viewWithTag:tag];
        [self selectNameButton:button];
    }
}




@end
