//
//  ZDTableViewController.m
//  UIProgressView的使用
//
//  Created by zhudong on 2016/12/8.
//  Copyright © 2016年 zhudong. All rights reserved.
//

#import "ZDTableViewController.h"
#import "ZDTableViewCell.h"
#import "ZDPlayer.h"

@interface ZDTableViewController ()
@property (nonatomic, strong) NSArray *songNames;
@property (nonatomic,strong) ZDPlayer *audioPlayer;
@property (nonatomic,strong) UISlider *slider;
@property (nonatomic,strong) UIButton *audioPlayBtn;
@property (nonatomic,assign) BOOL isAudioBreak;
@property (nonatomic,assign) NSInteger playingIndex;
@property (nonatomic,strong) UILabel *currentTimeLabel;
@property (nonatomic,strong) UILabel *totalTimeLabel;
@end

@implementation ZDTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.playingIndex = -1;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
//
    self.audioPlayer = [ZDPlayer sharePlayer];
    __weak typeof(self) weakSelf = self;
    self.audioPlayer.playerDelegate = ^ void (CGFloat value, CGFloat totalTime, NSString *timeStr, NSString *totalStr){
        weakSelf.slider.value = value;
        weakSelf.currentTimeLabel.text = timeStr;
        weakSelf.totalTimeLabel.text = totalStr;
        if (value >= 0.99) {
            [weakSelf.audioPlayBtn setImage:[UIImage imageNamed:@"home_audio_play"] forState:UIControlStateNormal];
            weakSelf.slider.value = 0;
            weakSelf.slider.userInteractionEnabled = false;
            weakSelf.audioPlayBtn = nil;
            weakSelf.slider = nil;
            weakSelf.isAudioBreak = false;
            weakSelf.playingIndex = -1;
        }
    };
    [self loadData];
}

- (void)loadData{
    NSArray *nameArray = @[@"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3", @"1", @"2", @"3"];
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:nameArray.count];
    [nameArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@.mp3", obj] ofType:nil];
        [arrM addObject:path];
    }];
    self.songNames = [arrM copy];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.songNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZDTableViewCell *cell = [[ZDTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZDTableViewCell"];
    cell.playBtn.tag = indexPath.row;
    [cell.playBtn addTarget:self action:@selector(audioBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    if (indexPath.row == self.playingIndex) {
        [cell.playBtn setImage:[UIImage imageNamed:@"home_audio_stop"] forState:UIControlStateNormal];
        self.isAudioBreak = false;
        self.slider = cell.slider;
        self.audioPlayBtn = cell.playBtn;
        self.currentTimeLabel = cell.currentTimeLabel;
        self.totalTimeLabel = cell.totalTimeLabel;
    }
    return cell;
}

- (void)sliderChanged:(UISlider *)slider{
    [self.audioPlayer playWithValue:slider.value];
}

- (void)audioBtnClick: (UIButton *)btn{
    
    ZDTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag inSection:0]];
    NSString *songName = self.songNames[btn.tag];
    self.currentTimeLabel = cell.currentTimeLabel;
    self.totalTimeLabel = cell.totalTimeLabel;
    if ((self.audioPlayBtn != btn)) {
        self.playingIndex = btn.tag;
        //修改UI
        [self.audioPlayBtn setImage:[UIImage imageNamed:@"home_audio_play"] forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:@"home_audio_stop"] forState:UIControlStateNormal];
        //播放
        cell.slider.userInteractionEnabled = true;
        self.slider.userInteractionEnabled = false;
        self.slider = cell.slider;
        [self.audioPlayer playWithName: songName];
        
        self.audioPlayBtn = btn;
        self.isAudioBreak = false;
    }else {
        self.isAudioBreak = !self.isAudioBreak;
        if (self.isAudioBreak) {
            self.playingIndex = -1;
            [self.audioPlayBtn setImage:[UIImage imageNamed:@"home_audio_play"] forState:UIControlStateNormal];
            [self.audioPlayer pause];
            self.slider.userInteractionEnabled = false;
        }else{
            self.playingIndex = btn.tag;
            [self.audioPlayBtn setImage:[UIImage imageNamed:@"home_audio_stop"] forState:UIControlStateNormal];
            [self.audioPlayer playWithName:songName];
            self.slider.userInteractionEnabled = true;
        }
    }
}

@end
