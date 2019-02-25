//
//  SegmentItem.h
//  InstrumentPro
//
//  Created by 万想想 on 2019/2/25.
//  Copyright © 2019年 wanxiangxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SelectItemBlock)(NSInteger selectIndex);

@interface SegmentBarItem : UIView

@property (copy, nonatomic) NSArray *dataSource;

@property (copy, nonatomic) UIColor *bgColor;

@property (assign, nonatomic) NSInteger selectPage;

@property (copy, nonatomic) SelectItemBlock selectBlock;

@end

NS_ASSUME_NONNULL_END
