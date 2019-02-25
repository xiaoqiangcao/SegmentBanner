//
//  SegItem.h
//  InstrumentPro
//
//  Created by 万想想 on 2019/2/25.
//  Copyright © 2019年 wanxiangxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SegItem : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLineWidth;


@end

NS_ASSUME_NONNULL_END
