//
//  MWBLoopCollectionViewCell.m
//  LoopViewDemo
//
//  Created by 马文铂 on 15/12/8.
//  Copyright © 2015年 UK. All rights reserved.
//

#import "MWBLoopCollectionViewCell.h"

@implementation MWBLoopCollectionViewCell
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self makeSubViews];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeSubViews];
    }
    return self;
}
- (void)makeSubViews{
    self.LoopImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    self.LoopImageView.userInteractionEnabled = YES;
    [self addSubview:self.LoopImageView];
}
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self.LoopImageView setFrame:self.bounds];
}
@end
