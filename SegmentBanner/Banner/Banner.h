//
//  Banner.h
//  SegmentBanner
//
//  Created by 万想想 on 2019/2/25.
//  Copyright © 2019年 wanxiangxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^TapActionBlock)(NSInteger index);
@interface Banner : UIView
/*
 *     images   图片数组
 *     tapBlock  点击事件
 */
-(instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images  tapBlock:(nonnull TapActionBlock)tapBlock;

@end

NS_ASSUME_NONNULL_END
