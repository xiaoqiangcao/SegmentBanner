//
//  SegmentView.m
//  InstrumentPro
//
//  Created by 万想想 on 2019/2/25.
//  Copyright © 2019年 wanxiangxiang. All rights reserved.
//

#import "SegmentView.h"
#import "SegmentBarItem.h"
#import <UIView+YRExtension.h>

#define ITEMHEIGHT  40

@interface SegmentView ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollview;
@property (strong, nonatomic) SegmentBarItem *itemView;
@property (assign, nonatomic) CGFloat startOffsetx;

@end

@implementation SegmentView

-(instancetype)initWithFrame:(CGRect)frame items:(nonnull NSArray *)itemArray pageView:(nonnull NSArray *)pageViewArray parentVC:(nonnull UIViewController *)parentVC{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubViewsWithItemArray:itemArray pageView:pageViewArray parentVC:parentVC];
    }
    return self;
}

-(void)setSubViewsWithItemArray:(nonnull NSArray *)itemArray pageView:(nonnull NSArray *)pageViewArray parentVC:(UIViewController *)parentVC{
    
    __weak typeof(self)weakSelf = self;
    self.itemView = [[SegmentBarItem alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), ITEMHEIGHT)];
    self.itemView.dataSource = itemArray;
    self.itemView.selectBlock = ^(NSInteger selectIndex) {
        weakSelf.scrollview.contentOffset = CGPointMake(CGRectGetWidth(self.frame)*selectIndex, 0);
        if (weakSelf.segmentBlock) {
            weakSelf.segmentBlock(selectIndex);
        }
    };
    [self addSubview:self.itemView];

    self.scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, ITEMHEIGHT, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-ITEMHEIGHT)];
    self.scrollview.delegate = self;
    self.scrollview.pagingEnabled = YES;
    self.scrollview.backgroundColor = [UIColor whiteColor];
    self.scrollview.contentSize = CGSizeMake(itemArray.count*CGRectGetWidth(self.frame), CGRectGetWidth(self.frame));
    for (NSInteger j=0; j<pageViewArray.count; j++) {
        UIViewController *subVC = pageViewArray[j];
        subVC.view.bounds = CGRectMake(0, 0, CGRectGetWidth(self.scrollview.frame), CGRectGetHeight(self.scrollview.frame));
        subVC.view.y = 0;
        subVC.view.x = CGRectGetWidth(self.scrollview.frame)*j;
        [self.scrollview addSubview:subVC.view];
        [parentVC addChildViewController:subVC];
    }
    self.scrollview.contentOffset = CGPointMake(0, 0);
    [self addSubview:self.scrollview];
}


-(void)setFirstSelectPage:(NSInteger)firstSelectPage{
    
    _firstSelectPage = firstSelectPage;
    self.itemView.selectPage = firstSelectPage;
    self.scrollview.contentOffset = CGPointMake(CGRectGetWidth(self.frame)*firstSelectPage, 0);
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    self.startOffsetx = scrollView.contentOffset.x;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (scrollView==self.scrollview) {
        NSInteger page = scrollView.contentOffset.x/CGRectGetWidth(self.frame);
        CGFloat currentOffsetx = scrollView.contentOffset.x;
        if (currentOffsetx>self.startOffsetx) {//往左
            self.itemView.selectPage = page;
        }else if (currentOffsetx<self.startOffsetx){//右
            CGFloat dragWidth = self.startOffsetx-currentOffsetx;
            if (dragWidth>CGRectGetWidth(self.frame)/2) {//是否划过页面一半位置
                self.itemView.selectPage = page;
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == self.scrollview) {
        NSInteger page = scrollView.contentOffset.x/CGRectGetWidth(self.frame);
        self.itemView.selectPage = page;
        if (self.segmentBlock) {
            self.segmentBlock(page);
        }
    }
}


@end
