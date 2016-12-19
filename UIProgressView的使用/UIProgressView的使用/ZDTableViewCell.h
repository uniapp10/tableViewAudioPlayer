//
//  ZDTableViewCell.h
//  UIProgressView的使用
//
//  Created by zhudong on 2016/12/8.
//  Copyright © 2016年 zhudong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ZDTableViewCell : UITableViewCell
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic,strong) UISlider *slider;
@property (nonatomic,strong) UILabel *currentTimeLabel;
@property (nonatomic,strong) UILabel *totalTimeLabel;

@end
