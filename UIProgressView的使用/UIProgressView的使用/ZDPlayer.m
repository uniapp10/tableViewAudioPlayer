//
//  ZDPlayer.m
//  UIProgressView的使用
//
//  Created by zhudong on 2016/12/11.
//  Copyright © 2016年 zhudong. All rights reserved.
//

#import "ZDPlayer.h"

@interface ZDPlayer ()
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) id timeObserve;
@property (nonatomic, copy) NSString *seletedName;
@end
@implementation ZDPlayer
- (instancetype)initPrivate{
    [self player];
    return [super init];
}

- (instancetype)init{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use + [ZDPlayer sharePlayer]" userInfo:nil];
    return nil;
}

+ (instancetype)sharePlayer{
    static ZDPlayer *player;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[self alloc] initPrivate];
    });
    return player;
}
- (void)pause{
    [self.player pause];
}
- (void)playWithValue: (CGFloat) value{
    [self.player pause];
    CMTime time = self.player.currentItem.duration;
    float totalTime = CMTimeGetSeconds(time);
    
    [self.player seekToTime:CMTimeMake(value * totalTime, 1) completionHandler:^(BOOL finished) {
        if (finished) {
            [self.player play];
        }
    }];
}

- (void)playWithName: (NSString *)name{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.seletedName = name;
        self.playerItem = [self playerItemWithName:name];
        self.player = [AVPlayer playerWithPlayerItem: self.playerItem];
        [self observePlayItem];
    });
    
    if (![self.seletedName isEqualToString:name]) {
        self.seletedName = name;
        [self.player pause];
        self.playerItem = [self playerItemWithName:name];
        [self.player replaceCurrentItemWithPlayerItem: self.playerItem];
        [self observePlayItem];
    }
    
    [self.player play];
}
- (AVPlayerItem *)playerItemWithName: (NSString *)name{
    //先移除观察者
    if (self.playerItem) {
        [self.playerItem removeObserver:self forKeyPath:@"status"];
        [self.playerItem removeObserver:self forKeyPath:@"loadTimeRanges"];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    }
    
    NSURL *url;
    if ([name hasPrefix:@"http"]) {
        url = [NSURL URLWithString:name];
    }else{
        url = [NSURL fileURLWithPath:name];
    }
    AVPlayerItem *pItem = [[AVPlayerItem alloc] initWithURL:url];
    //监听加载状态(播放完毕,移除观察者)
    [pItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [pItem addObserver:self forKeyPath:@"loadTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    //添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishPlay) name:AVPlayerItemDidPlayToEndTimeNotification object:pItem];
    
    return pItem;
}

- (void)observePlayItem{
    
    if (self.timeObserve) {
        [self.player removeTimeObserver:self.timeObserve];
    }
    __weak typeof (self) weakSelf = self;
    self.timeObserve = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time);
        float total = CMTimeGetSeconds(weakSelf.playerItem.duration);
        float value = current / total;
        NSString *timeStr = [weakSelf getTimeString:current];
        NSString *totalStr = [weakSelf getTimeString:total];
        if (weakSelf.playerDelegate) {
            weakSelf.playerDelegate(value, total, timeStr, totalStr);
        }
//        NSLog(@"timeStr = %@, value = %.2f", timeStr, value);
    }];
}

//监听播放器状态
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        switch (self.player.status) {
            case AVPlayerStatusUnknown:
                NSLog(@"KVO：未知状态，此时不能播放");
                break;
            case AVPlayerStatusReadyToPlay:
                NSLog(@"KVO：准备完毕，可以播放");
                break;
            case AVPlayerStatusFailed:
                NSLog(@"KVO：加载失败，网络或者服务器出现问题");
                break;
            default:
                break;
        }
    }
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray *array = self.playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
        NSTimeInterval totalBuffer = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration);
        NSLog(@"缓冲%.2f", totalBuffer);
    }
}

- (NSString *)getTimeString: (NSTimeInterval)timeInterval{
    NSInteger miniutC = timeInterval / 60;
    NSInteger secondC = ((NSInteger)timeInterval) % 60;
    return [NSString stringWithFormat:@"%02zd:%02zd",miniutC, secondC];
}

- (void)finishPlay{
    
//    [self.playerItem removeObserver:self forKeyPath:@"status"];
//    [self.playerItem removeObserver:self forKeyPath:@"loadTimeRanges"];
    self.seletedName = nil;
    [self.player pause];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
