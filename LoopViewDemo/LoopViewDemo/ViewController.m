//
//  ViewController.m
//  LoopViewDemo
//
//  Created by 马文铂 on 15/12/8.
//  Copyright © 2015年 UK. All rights reserved.
//

#import "ViewController.h"
#import "MWBLoopView.h"
@interface ViewController ()<MWBLoopViewDelegate>
@property (nonatomic, strong) MWBLoopView *loopView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loopView = [[MWBLoopView alloc]initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, 144) collectionViewLayout:[[UICollectionViewFlowLayout alloc]init]];
//    self.loopView.imageURLs = @[ @"http://pic.58pic.com/58pic/13/18/14/87m58PICVvM_1024.jpg", @"http://pic.58pic.com/58pic/13/56/99/88f58PICuBh_1024.jpg",@"http://img.hb.aicdn.com/e0c05397f8b9ee69f53d0e9e48e7257d5e45beb12185c-PS2UoU_fw658"];
    self.loopView.imageURLs = @[ @"http://pic.58pic.com/58pic/13/18/14/87m58PICVvM_1024.jpg"];
    self.loopView.loopViewDelegate = self;
    self.loopView.placeholder = [UIImage imageNamed:@"share_weibo_default"];
    [self.view addSubview:self.loopView];
}

/**
 *  滚动到那一页
 *
 *  @param loopView loopView
 *  @param index    page
 */
- (void)loopView:(MWBLoopView *)loopView didScrollToPage:(NSInteger)index{
    NSLog(@"index:%lu",index);
}
/**
 *  点击了那一页
 *
 *  @param loopView loopview
 *  @param index    page
 */
- (void)loopView:(MWBLoopView *)loopView didSelected:(NSInteger)index{
    NSLog(@"touch index:%lu",index);
}
@end
