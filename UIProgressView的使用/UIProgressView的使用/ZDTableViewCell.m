//
//  ZDTableViewCell.m
//  UIProgressView的使用
//
//  Created by zhudong on 2016/12/8.
//  Copyright © 2016年 zhudong. All rights reserved.
//

#import "ZDTableViewCell.h"
#import <Masonry/Masonry.h>

@interface ZDTableViewCell ()

@end
@implementation ZDTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        self.contentView.backgroundColor = [UIColor purpleColor];
    }
    return self;
}

- (void)setupUI{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 10, 50, 50);
//    btn.imageView.contentMode = UIViewContentModeCenter;
    [btn setImage:[UIImage imageNamed:@"home_audio_play"] forState:UIControlStateNormal];
    self.playBtn = btn;
    
    UISlider *slider = [[UISlider alloc] init];
    slider.tintColor = [UIColor greenColor];
    slider.backgroundColor = [UIColor redColor];
    self.slider = slider;
    
    UILabel *currentTL = [[UILabel alloc] init];
    currentTL.text = @"00:00";
    self.currentTimeLabel = currentTL;
    UILabel *totalTL = [[UILabel alloc] init];
    self.totalTimeLabel = totalTL;
    
    [self.contentView addSubview:btn];
    [self.contentView addSubview:slider];
    [self.contentView addSubview:currentTL];
    [self.contentView addSubview:totalTL];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(10));
        make.left.equalTo(@20);
        make.width.height.equalTo(@60);
        make.bottom.equalTo(@-10);
    }];
    
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn);
        make.left.equalTo(btn.mas_right).offset(20);
        make.right.equalTo(@-20);
        make.height.equalTo(@30);
    }];
    
    [currentTL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(slider);
        make.top.equalTo(slider.mas_bottom).offset(10);
    }];
    
    [totalTL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(slider);
        make.top.equalTo(currentTL);
    }];
}
@end
