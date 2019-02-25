//
//  Banner.m
//  SegmentBanner
//
//  Created by 万想想 on 2019/2/25.
//  Copyright © 2019年 wanxiangxiang. All rights reserved.
//

#import "Banner.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>
@interface Banner ()<UIScrollViewDelegate>

@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (copy, nonatomic) TapActionBlock tapBlock;

@end

@implementation Banner

-(instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images  tapBlock:(nonnull TapActionBlock)tapBlock{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.images = images;
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
        [self setConstraints];
        [self setBannerView];
        [self setTimer];
        self.tapBlock = tapBlock;
    }
    return self;
}

-(void)setConstraints{
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
        make.height.mas_equalTo(50);
        make.right.mas_equalTo(self.mas_right).offset(0);
    }];
}

-(void)setTimer{
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(pageScroll) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
}

-(void)pageScroll{
    
    CGFloat x = self.scrollView.contentOffset.x;
    if (x>=self.scrollView.contentSize.width) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.frame), 0) animated:YES];
        self.pageControl.currentPage = 0;
    }else{
        [self.scrollView setContentOffset:CGPointMake(x+CGRectGetWidth(self.frame), 0) animated:YES];
        self.pageControl.currentPage = x/CGRectGetWidth(self.frame);
    }
}

-(void)setBannerView{
    
    //    第一张
    UIImageView *firstImg = [[UIImageView alloc]init];
    //最后一张图片
    if ([self isValidUrl:self.images.lastObject]) {
        [firstImg sd_setImageWithURL:[NSURL URLWithString:self.images.lastObject]];
    }else{
        firstImg.image = [UIImage imageNamed:self.images.lastObject];
    }
    firstImg.contentMode = UIViewContentModeScaleToFill;
    [self.scrollView addSubview:firstImg];
    [firstImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollView.mas_left).offset(0);
        make.top.mas_equalTo(self.scrollView.mas_top).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
        make.width.mas_equalTo(CGRectGetWidth(self.frame));
    }];
    //    中间
    for (NSInteger i=0; i<self.images.count; i++) {
        UIImageView *imgView = [[UIImageView alloc]init];
        //x中间图片
        if ([self isValidUrl:self.images[i]]) {
            [imgView sd_setImageWithURL:[NSURL URLWithString:self.images[i]]];
        }else{
            imgView.image = [UIImage imageNamed:self.images[i]];
        }
        imgView.contentMode = UIViewContentModeScaleToFill;
        imgView.userInteractionEnabled = YES;
        imgView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [imgView addGestureRecognizer:tap];
        [self.scrollView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.scrollView.mas_left).offset((CGRectGetWidth(self.frame)*(i+1)));
            make.top.mas_equalTo(self.scrollView.mas_top).offset(0);
            make.bottom.mas_equalTo(self.mas_bottom).offset(0);
            make.width.mas_equalTo(CGRectGetWidth(self.frame));
        }];
    }
    //    最后一张
    UIImageView *lastImg = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame)+1, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    //最后一张图片
    if ([self isValidUrl:self.images.firstObject]) {
        [lastImg sd_setImageWithURL:[NSURL URLWithString:self.images.firstObject]];
    }else{
        lastImg.image = [UIImage imageNamed:self.images.firstObject];
    }
    lastImg.contentMode = UIViewContentModeScaleToFill;
    [self.scrollView addSubview:lastImg];
    [lastImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollView.mas_left).offset(CGRectGetWidth(self.frame)+1);
        make.top.mas_equalTo(self.scrollView.mas_top).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
        make.width.mas_equalTo(CGRectGetWidth(self.frame));
    }];
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame)*self.images.count, CGRectGetHeight(self.frame));
    self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.frame), 0);
    /// 图片总数
    self.pageControl.numberOfPages = self.images.count;
    self.pageControl.currentPage = 0;
}

-(void)tapAction:(UITapGestureRecognizer*)gester{
    
    self.tapBlock(gester.view.tag);
}

-(UIScrollView *)scrollView{
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.scrollEnabled = YES;
        _scrollView.pagingEnabled = YES;
        _scrollView.clipsToBounds = YES;
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame)*(2+self.images.count), CGRectGetHeight(self.frame));
    }
    return _scrollView;
}

-(UIPageControl *)pageControl{
    
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor yellowColor];
    }
    return _pageControl;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX>=(self.images.count+1)*(CGRectGetWidth(self.frame))) {
        scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.frame), 0);
        self.pageControl.currentPage = 0;
    }else{
        self.pageControl.currentPage = offsetX/CGRectGetWidth(self.frame)-1;
    }
}

- (BOOL)isValidUrl:(NSString *)url
{
    NSString *regex =@"[a-zA-z]+://[^\\s]*";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:url];
}

@end
