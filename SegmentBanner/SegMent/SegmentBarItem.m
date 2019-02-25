//
//  SegmentItem.m
//  InstrumentPro
//
//  Created by 万想想 on 2019/2/25.
//  Copyright © 2019年 wanxiangxiang. All rights reserved.
//

#import "SegmentBarItem.h"
#import "SegItem.h"

@interface SegmentBarItem ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tabView;

@end

@implementation SegmentBarItem

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.transform = CGAffineTransformMakeRotation(-M_PI_2);
        [self addSubview:self.tabView];
    }
    return self;
}

//刷新数据
-(void)setDataSource:(NSArray *)dataSource{
    
    _dataSource = dataSource;
    [self.tabView reloadData];
}

-(UITableView *)tabView{
    
    if (!_tabView) {
        _tabView = [[UITableView alloc]initWithFrame:self.bounds];
        _tabView.estimatedRowHeight = 0;
        _tabView.estimatedSectionFooterHeight = 0;
        _tabView.estimatedSectionHeaderHeight = 0;
        _tabView.delegate = self;
        _tabView.dataSource = self;
        _tabView.showsVerticalScrollIndicator = NO;
        _tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tabView.backgroundColor = [UIColor whiteColor];
        _tabView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        [_tabView registerNib:[UINib nibWithNibName:NSStringFromClass([SegItem class]) bundle:nil] forCellReuseIdentifier:@"cell"];
    }
    return _tabView;
}

//重置view的frame
-(void)setFrame:(CGRect)frame{
    
    frame.size.height = CGRectGetWidth(self.frame);
    frame.size.width = CGRectGetHeight(self.frame);
    frame.origin.x = -CGRectGetHeight(self.frame)/2+CGRectGetWidth(self.frame)/2;
    frame.origin.y = -CGRectGetWidth(self.frame)/2+CGRectGetHeight(self.frame)/2;
    [super setFrame:frame];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.001f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat totalLength = [self widthForlabelWithHeight:CGRectGetHeight(self.frame) fontSize:15 Content:[self.dataSource componentsJoinedByString:@""]];
    if ((totalLength+self.dataSource.count*24)<CGRectGetWidth(self.frame)) {
        return CGRectGetWidth(self.frame)/self.dataSource.count;
    }else{
        CGFloat itemWidth = [self widthForlabelWithHeight:CGRectGetWidth(self.frame) fontSize:15 Content:self.dataSource[indexPath.row]];
        return itemWidth+24;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SegItem *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.transform = CGAffineTransformMakeRotation(M_PI_2);
    cell.titleLabel.text = self.dataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row==self.selectPage) {
        cell.bottomLine.backgroundColor = [UIColor redColor];
        cell.titleLabel.textColor = [UIColor redColor];
        [UIView animateWithDuration:1.0f animations:^{
            cell.titleLabel.font = [UIFont systemFontOfSize:16];
        }];
    }else{
        cell.bottomLine.backgroundColor = [UIColor clearColor];
        cell.titleLabel.textColor = [UIColor blackColor];
        [UIView animateWithDuration:1.0f animations:^{
            cell.titleLabel.font = [UIFont systemFontOfSize:14];
        }];
    }
    CGFloat itemWidth = [self widthForlabelWithHeight:CGRectGetWidth(self.frame) fontSize:15 Content:self.dataSource[indexPath.row]];
    cell.bottomLineWidth.constant = itemWidth;
    return cell;
}

//item点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectPage = indexPath.row;
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    self.selectBlock(indexPath.row);
    [tableView reloadData];
}


-(void)setSelectPage:(NSInteger)selectPage{

    _selectPage = selectPage;
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:selectPage inSection:0];
    [self.tabView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [_tabView reloadData];
}

-(CGFloat)widthForlabelWithHeight:(CGFloat)height fontSize:(CGFloat)fontSize Content:(nonnull NSString *)content{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, height)];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.text = content;
    [label sizeToFit];
    return label.frame.size.width;
}

@end
