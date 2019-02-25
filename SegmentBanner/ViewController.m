//
//  ViewController.m
//  SegmentBanner
//
//  Created by 万想想 on 2019/2/25.
//  Copyright © 2019年 wanxiangxiang. All rights reserved.
//

#import "ViewController.h"
#import "SubViewController.h"
#import "Banner.h"
#import "SegmentView.h"
#import <ReactiveObjC.h>
#import "BaseTableView.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UIImage *shadowImg;
@property (strong) UILabel *titleLabel;
@property (nonatomic, strong) BaseTableView *tableView;
@property (nonatomic, strong) UITableViewCell *cell;
@property (nonatomic, strong) SegmentView *segView;
@property (strong) Banner *bannerView;
@property (nonatomic, strong) NSMutableArray *segArray;
@property (assign) BOOL canScroll;
@property (assign) CGFloat alpha;

@end

@implementation ViewController

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
#define BANNER_HEIGHT  300.0f
#define VIEW_COLOR [UIColor colorWithRed:255.0/255 green:78.0/255 blue:144.0/255 alpha:1]

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.shadowImg = self.navigationController.navigationBar.shadowImage;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:[VIEW_COLOR colorWithAlphaComponent:self.alpha]] forBarMetrics:UIBarMetricsDefault];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:[VIEW_COLOR colorWithAlphaComponent:self.alpha]] forBarMetrics:UIBarMetricsDefault];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.shadowImage = self.shadowImg;
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
}

-(NSMutableArray *)segArray{
    
    if (!_segArray) {
        _segArray = [NSMutableArray array];
    }
    return _segArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:VIEW_COLOR] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor cyanColor];
    //    self.edgesForExtendedLayout = UIRectEdgeNone;
    __weak typeof(self)weakSelf = self;
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"tabNoti" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        weakSelf.canScroll = YES;
        [weakSelf subTabViewCanScroll:NO];
    }];
    self.canScroll = YES;
    [self setSubViews];
}

-(void)setSubViews{
    
    self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    self.titleLabel.textColor=[UIColor whiteColor];
    self.titleLabel.text=@"首页";
    self.titleLabel.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=self.titleLabel;
    self.titleLabel.alpha=0;
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.tableView];
    
    //    banner图
    NSArray *images = @[@"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=834866073,4089509342&fm=111&gp=0.jpg",@"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1986179278,1118313821&fm=27&gp=0.jpg",@"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=834866073,4089509342&fm=111&gp=0.jpg",@"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1986179278,1118313821&fm=27&gp=0.jpg"];
//    __weak typeof(self)weakSelf = self;
    self.bannerView = [[Banner alloc]initWithFrame:CGRectMake(0, -BANNER_HEIGHT, SCREEN_SIZE.width, BANNER_HEIGHT) images:images tapBlock:^(NSInteger index) {
        
    }];
    [self.tableView addSubview:self.bannerView];
}

-(SegmentView *)segView{
    
    //    芬兰控制器
    NSArray *titles = @[@"全部",@"服饰穿搭",@"生活百货",@"美食吃货",@"美容护理",@"母婴儿童",@"数码家电"];
    for (NSString *typeTitle in titles) {
        SubViewController *subVC = [[SubViewController alloc]init];
        subVC.type = typeTitle;
        [self.segArray addObject:subVC];
    }
    CGRect frame = CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height);
    SegmentView *segView = [[SegmentView alloc]initWithFrame:frame items:titles pageView:self.segArray parentVC:self];
    segView.firstSelectPage = 3;
    segView.segmentBlock = ^(NSInteger selectIndex) {
        NSLog(@"%@",titles[selectIndex]);
    };
    return segView;
}

-(BaseTableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedRowHeight = 0;
        _tableView.contentInset = UIEdgeInsetsMake(BANNER_HEIGHT, 0, 0, 0);
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.001f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return SCREEN_SIZE.height;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return self.cell;
}

-(UITableViewCell *)cell{
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cid"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cid"];
    }
    [cell addSubview:self.segView];
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //    监听父子视图滚动
    CGFloat naviH = [UIApplication sharedApplication].statusBarFrame.size.height+44;
    if (scrollView.contentOffset.y>-naviH) {
        scrollView.contentOffset = CGPointMake(0, -naviH);
        if (self.canScroll) {
            self.canScroll = NO;
            [self subTabViewCanScroll:YES];
        }
    }else{
        if (!self.canScroll) {
            scrollView.contentOffset = CGPointMake(0, -naviH);
        }
    }
    //    头视图设置
    CGFloat offsetY = scrollView.contentOffset.y;
    //    CGFloat xOffset = (offsetY+BANNER_HEIGHT)/2;
    if (offsetY<-BANNER_HEIGHT) {
        CGRect rect = self.bannerView.frame;
        rect.origin.y = offsetY;
        rect.size.height = -offsetY;
        //        rect.origin.x = xOffset;
        //        rect.size.width = rect.size.width+2*fabs(xOffset);
        self.bannerView.frame = rect;
    }
    //    导航栏设置
    CGFloat alpha = (scrollView.contentOffset.y+BANNER_HEIGHT)/(BANNER_HEIGHT-naviH);
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:[VIEW_COLOR colorWithAlphaComponent:alpha]] forBarMetrics:UIBarMetricsDefault];
    self.titleLabel.alpha = alpha;
    self.alpha = alpha;
}

-(void)subTabViewCanScroll:(BOOL)canScroll{
    
    for (SubViewController *subVC in self.segArray) {
        subVC.canScroll = canScroll;
        if (!canScroll) {
            subVC.tableView.contentOffset = CGPointZero;
        }
    }
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    return theImage;
}

@end
