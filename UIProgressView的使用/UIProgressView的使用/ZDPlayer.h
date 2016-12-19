//
//  ZDPlayer.h
//  UIProgressView的使用
//
//  Created by zhudong on 2016/12/11.
//  Copyright © 2016年 zhudong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface ZDPlayer : NSObject
@property (nonatomic, copy) void (^playerDelegate)(CGFloat value, CGFloat totalTime, NSString *timeStr, NSString *totalStr);

+ (instancetype)sharePlayer;
- (void)playWithName: (NSString *)name;
- (void)playWithValue: (CGFloat) value;
- (void)pause;
@end
