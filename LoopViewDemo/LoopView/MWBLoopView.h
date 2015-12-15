//
//  MWBLoopView.h
//  LoopViewDemo
//
//  Created by 马文铂 on 15/12/8.
//  Copyright © 2015年 UK. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    LocalImage = 1, //加载本地图片
    WebImage = 0 //加载网络图片
}MWBImageType;

@class MWBLoopView;

@protocol MWBLoopViewDelegate <NSObject>
@optional
/**
 *  滚动到那一页
 *
 *  @param loopView loopView
 *  @param index    page
 */
- (void)loopView:(MWBLoopView *)loopView didScrollToPage:(NSInteger)index;
/**
 *  点击了那一页
 *
 *  @param loopView loopview
 *  @param index    page
 */
- (void)loopView:(MWBLoopView *)loopView didSelected:(NSInteger)index;
@end

@interface MWBLoopView : UICollectionView<MWBLoopViewDelegate>

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UILabel *pageLabel;

/******* @brief 网络获取图片数组****/
@property (nonatomic, strong) NSArray *imageURLs;
/******* @brief 本地图片数组****/
@property (nonatomic, strong) NSArray *localImages;
/******* @brief 没有图片轮播的占位图****/
@property (nonatomic, strong) UIImage *placeholder;
/******* @brief 是否自动播放 默认YES****/
@property (nonatomic, assign) BOOL autoMoving;
/******* @brief 时间间隔 默认 3秒****/
@property (nonatomic) NSTimeInterval movingTimeInterval;
/******* @brief 代理****/
@property (nonatomic, weak) id<MWBLoopViewDelegate> loopViewDelegate;
/******* @brief 进入滚动到多少页 默认0 如果大于array count ，显示第一张****/
@property (nonatomic, assign) NSInteger currentPageIndex;
/******* @brief 加载图片类型 默认 网络图片****/
@property (nonatomic, assign) MWBImageType imageType;
/******* @brief 没有数据的时候是否显示 默认图 默认 NO****/
@property (nonatomic, assign) BOOL showDefaultImage;
/******* @brief 是否显示pagecontrol 默认YES****/
@property (nonatomic, assign) BOOL showPageControl;
/******* @brief 是否显示 滑动到哪儿的label 默认YES****/
@property (nonatomic, assign) BOOL showpageLabel;
/******* @brief 是否隐藏pageControl 在只有一条或者没有数据的时候 默认隐藏YES****/
@property (nonatomic, assign) BOOL hidePageControlWhenNoData;
/******* @brief 是否隐藏pageLabel 在只有一条或者没有数据的时候 默认隐藏 YES****/
@property (nonatomic, assign) BOOL hidePageLabelWhenNoData;
/******* @brief 是否自动滚动 在只有一条或者没有数据的时候 默认不滚动 YES****/
@property (nonatomic, assign) BOOL notAutoMovingWhenNoData;
/******* @brief 是否可以滚动 再只有一条数据时 默认不可以 YES****/
@property (nonatomic, assign) BOOL notScrollWhenNoData;
@end
