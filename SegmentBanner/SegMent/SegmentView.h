//
//  SegmentView.h
//  InstrumentPro
//
//  Created by 万想想 on 2019/2/25.
//  Copyright © 2019年 wanxiangxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SegmentBlock)(NSInteger selectIndex);

@interface SegmentView : UIView

/*
 * itemArray  item title数组
 * pageViewArray  vc数组
 */
-(instancetype)initWithFrame:(CGRect)frame items:(nonnull NSArray *)itemArray pageView:(nonnull NSArray *)pageViewArray parentVC:(nonnull UIViewController *)parentVC;

//回调
@property (copy ,nonatomic) SegmentBlock segmentBlock;//

//首次选择的item
@property (assign, nonatomic) NSInteger firstSelectPage;

@end

NS_ASSUME_NONNULL_END
