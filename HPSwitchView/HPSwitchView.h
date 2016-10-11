//
//  HPSwitchView.h
//  HPSwitchViewDemo
//
//  Created by 韩学鹏 on 16/10/10.
//  Copyright © 2016年 韩学鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HPSwitchView;

@protocol HPSwitchViewDelegate <NSObject>

@required


/**
 顶部tab个数

 @param view 当前控件

 @return tab个数
 */
- (NSInteger)numberOfTab:(HPSwitchView *)view;


/**
 每个tab所属的控制器

 @param view   本控件
 @param index tab索引

 @return 所属控制器
 */
- (UIViewController *)onSwitchView:(HPSwitchView *)view viewOfTab:(NSInteger)index;

@optional


/**
 滑动左边界时传递手势参数

 @param view 当前控件
 @param pan  手势
 */
- (void)onSiwtchView:(HPSwitchView *)view panLeftEdge:(UIPanGestureRecognizer *)pan;


/**
 滑动右边界时传递手势参数

 @param view 当前控件
 @param pan  手势
 */
- (void)onSwitchView:(HPSwitchView *)view panRightEdge:(UIPanGestureRecognizer *)pan;


/**
 选择tab

 @param view  当前控件
 @param index 选中的tab索引
 */
- (void)onSwitchView:(HPSwitchView *)view didSelectedTab:(NSInteger)index;

@end

@interface HPSwitchView : UIView<UIScrollViewDelegate>

@property (nonatomic, weak) id<HPSwitchViewDelegate> delegate;


/**
 主视图
 */
@property (nonatomic, strong) UIScrollView *mainScrollView;


/**
 顶部页签视图
 */
@property (nonatomic, strong) UIScrollView *topScrollView;


/**
 x轴方向内容偏移量
 */
@property (nonatomic, assign) CGFloat contentOffsetX;


/**
 是否左滑动
 */
@property (nonatomic, assign) BOOL isLeftScroll;


/**
 是否主视图滑动
 */
@property (nonatomic, assign) BOOL isMainScroll;


/**
 是否创建了UI
 */
@property (nonatomic, assign) BOOL isBuildUI;


@property (nonatomic, assign) NSInteger selectedTabID;

@property (nonatomic, strong) UIImageView *shadowImageView;

@property (nonatomic, strong) UIImage *shadowImage;

@property (nonatomic, strong) UIColor *tabItemNormalColor;

@property (nonatomic, strong) UIColor *tabItemSelectedColor;

@property (nonatomic, strong) UIImage *tabItemNormalBackgroundImage;

@property (nonatomic, strong) UIImage *tabItemSelectedBackgroundImage;


/**
 主视图的子视图数组
 */
@property (nonatomic, strong) NSMutableArray *viewArray;


/**
 设置需要显示

 @param selectedViewIndex 需要显示的视图索引
 @param animated          是否动画显示
 */
- (void)setSelectedViewIndex:(NSInteger)selectedViewIndex animated:(BOOL)animated;


/**
 创建子视图UI
 */
- (void)buildUI;


/**
 通过16进制颜色值获取UIColor

 @param hexRGB 16进制颜色值

 @return UIColor
 */
- (UIColor *)colorFromHexRGB:(NSString *)hexRGB;

@end
