//
//  SubViewController.h
//  SegmentBanner
//
//  Created by 万想想 on 2019/2/25.
//  Copyright © 2019年 wanxiangxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SubViewController : UIViewController
@property (strong) UITableView *tableView;
@property (assign) BOOL canScroll;
@property (copy) NSString *type;
@end

NS_ASSUME_NONNULL_END
