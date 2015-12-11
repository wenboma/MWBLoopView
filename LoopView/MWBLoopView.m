//
//  MWBLoopView.m
//  LoopViewDemo
//
//  Created by 马文铂 on 15/12/8.
//  Copyright © 2015年 UK. All rights reserved.
//

#import "MWBLoopView.h"
#import "UIImageView+WebCache.h"
#import "MWBLoopCollectionViewCell.h"

#define MIN_MOVING_TIMEINTERVAL       0.1 //最小滚动时间间隔
#define DEFAULT_MOVING_TIMEINTERVAL   3.0 //默认滚动时间间隔

@interface MWBLoopView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL needRefresh;

@end



@implementation MWBLoopView
@synthesize imageURLs = _imageURLs;
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self makeSubViews];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self makeSubViews];
    }
    return self;
}
- (void)makeSubViews{
    self.delegate = self;
    self.dataSource = self;
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.backgroundColor = [UIColor whiteColor];
    if ([self.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]])
    {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        [self setCollectionViewLayout:layout];
    }
    [self registerClass:[MWBLoopCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([MWBLoopCollectionViewCell class])];
    [self registerNofitication];
    
    
    self.imageType = WebImage;
    self.autoMoving = YES;
    self.currentPageIndex = 0;
    self.showDefaultImage = YES;
    self.showPageControl = self.showpageLabel = YES;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.needRefresh)
    {
        //最左边一张图其实是最后一张图，因此移动到第二张图，也就是imageURL的第一个URL的图。
        [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(self.currentPageIndex+1)>(self.imageURLs.count-1)?1:self.currentPageIndex+1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        self.needRefresh = NO;
    }
    [self loadPageControl];
    [self loadPageLabel];
}
- (void)loadPageControl{
    if(!self.pageControl && self.showPageControl){
        self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.frame.size.height-37, self.frame.size.width, 37)];
        self.pageControl.numberOfPages = 0;
    }
    if(self.pageControl && self.showPageControl){
        if(self.superview && ![self.superview.subviews containsObject:self.pageControl]){
            [self.superview addSubview:self.pageControl];
            [self.superview bringSubviewToFront:self.pageControl];
        }
    }
}
- (void)loadPageLabel{
    if(!self.pageLabel && self.showpageLabel){
        self.pageLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width-90, self.frame.size.height-37,60, 37)];
        self.pageLabel.font = [UIFont systemFontOfSize:15];
        self.pageLabel.textColor = [UIColor whiteColor];
        self.pageLabel.textAlignment = 1;
    }
    if(self.pageControl && self.showPageControl){
        if(self.superview && ![self.superview.subviews containsObject:self.pageLabel]){
            [self.superview addSubview:self.pageLabel];
            [self.superview bringSubviewToFront:self.pageLabel];
        }
    }
}
- (void)registerNofitication
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}
#pragma mark - Notification
//程序被暂停的时候，应该停止计时器
- (void)applicationWillResignActive
{
    [self stopMoving];
}

//程序从暂停状态回归的时候，重新启动计时器
- (void)applicationDidBecomeActive
{
    if (self.autoMoving)
    {
        [self startMoving];
    }else{
        [self stopMoving];
    }
}
#pragma mark - Public Method

- (void)startMoving
{
    [self addTimer];
}

- (void)stopMoving
{
    [self removeTimer];
}

#pragma mark - Private Method


- (void)addTimer
{
    [self removeTimer];
    NSTimeInterval speed = self.movingTimeInterval < MIN_MOVING_TIMEINTERVAL ? DEFAULT_MOVING_TIMEINTERVAL : self.movingTimeInterval;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:speed target:self selector:@selector(moveToNextPage) userInfo:nil repeats:YES];

}

- (void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)moveToNextPage
{
    CGPoint newContentOffset = (CGPoint){self.contentOffset.x + self.frame.size.width,0};
    [self setContentOffset:newContentOffset animated:YES];
}

- (void)adjustCurrentPage:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x / self.frame.size.width - 1;
    
    if (scrollView.contentOffset.x < self.frame.size.width)
    {
        page = [self.imageURLs count] - 3;
    }
    else if (scrollView.contentOffset.x >= self.frame.size.width * ([self.imageURLs count] - 1))
    {
        page = 0;
    }
    
    if (self.loopViewDelegate &&[self.loopViewDelegate respondsToSelector:@selector(loopView:didScrollToPage:)])
    {
        [self.loopViewDelegate loopView:self didScrollToPage:page];
    }
}
- (NSInteger)getCurrentScrolltoIndex:(UIScrollView *)scrollView{
    NSInteger page = scrollView.contentOffset.x / self.frame.size.width - 1;
    
    if (scrollView.contentOffset.x < self.frame.size.width)
    {
        page = [self.imageURLs count] - 3;
    }
    else if (scrollView.contentOffset.x >= self.frame.size.width * ([self.imageURLs count] - 1))
    {
        page = 0;
    }
    return page;
}
- (void)setPageControlIndexWithPage:(NSInteger)page{
    if(self.showPageControl && self.pageControl){
        if(page<self.pageControl.numberOfPages){
            self.pageControl.currentPage = page;
        }
    }
    if(self.showpageLabel && self.pageLabel){
        self.pageLabel.text = [NSString stringWithFormat:@"%lu/%lu",page+1,self.imageURLs.count-2];
    }
}
#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return MAX([self.imageURLs count],self.showDefaultImage);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MWBLoopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MWBLoopCollectionViewCell class]) forIndexPath:indexPath];
    
    if (![self.imageURLs count])
    {
        [cell.LoopImageView setImage:self.placeholder];
        return cell;
    }
    if(self.imageType == WebImage){
        [cell.LoopImageView sd_setImageWithURL:[NSURL URLWithString:self.imageURLs[indexPath.row]] placeholderImage:self.placeholder];
    }else{
        [cell.LoopImageView setImage:[UIImage imageNamed:self.imageURLs[indexPath.row]]];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.frame.size.width, self.frame.size.height);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger page = 0;
    NSUInteger lastIndex = [self.imageURLs count] - 3;
    
    if (indexPath.row == 0)
    {
        page = lastIndex;
    }
    else if (indexPath.row == self.imageURLs.count-1)
    {
        page = 0;
    }
    else
    {
        page = indexPath.row - 1;
    }
    if ([self.loopViewDelegate respondsToSelector:@selector(loopView:didSelected:)])
    {
        [self.loopViewDelegate loopView:self didSelected:page];
    }
}

#pragma mark - UIScrollerViewDelegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //轮播滚动的时候 移动到了哪一页
    [self adjustCurrentPage:scrollView];
}

//用户手动拖拽，暂停一下自动轮播
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}

//用户拖拽完成，恢复自动轮播（如果需要的话）并依据滑动方向来进行相对应的界面变化
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.autoMoving)
    {
        [self addTimer];
    }
    //用户手动拖拽的时候 移动到了哪一页
    [self adjustCurrentPage:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    //向左滑动时切换imageView
    if (scrollView.contentOffset.x < self.frame.size.width )
    {
        [self setContentOffset:CGPointMake(self.frame.size.width*(self.imageURLs.count-1)-(self.frame.size.width-scrollView.contentOffset.x), 0)];
        [self setPageControlIndexWithPage:[self getCurrentScrolltoIndex:scrollView]];
        return;
    }
    //向右滑动时切换imageView
    if (scrollView.contentOffset.x > ([self.imageURLs count] - 1) * self.frame.size.width )
    {
        [self setContentOffset:CGPointMake(self.frame.size.width+(scrollView.contentOffset.x-([self.imageURLs count] - 1) * self.frame.size.width), 0)];
        [self setPageControlIndexWithPage:[self getCurrentScrolltoIndex:scrollView]];
        return;
    }
    [self setPageControlIndexWithPage:[self getCurrentScrolltoIndex:scrollView]];
}
#pragma mark - Getter and Setter

- (NSArray *)imageURLs
{
    if (!_imageURLs)
    {
        _imageURLs = [NSArray array];
    }
    return _imageURLs;
}

- (void)setImageURLs:(NSArray *)imageURLs
{
    _imageURLs = imageURLs;
    if ([imageURLs count])
    {
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:[imageURLs lastObject]];
        [arr addObjectsFromArray:imageURLs];
        [arr addObject:[imageURLs firstObject]];
        _imageURLs = [NSArray arrayWithArray:arr];
    }
    [self reloadData];
    [self loadPageControl];
    [self loadPageLabel];
    if(self.pageControl && self.showPageControl){
        self.pageControl.numberOfPages = _imageURLs.count-2;
    }
    _needRefresh = YES;
}
@end
