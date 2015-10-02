//
//  DemoViewController.m
//  DaiYoutubeParser
//
//  Created by DaidoujiChen on 2015/10/5.
//  Copyright © 2015年 DaidoujiChen. All rights reserved.
//

#import "DemoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "DaiYoutubeParser.h"

@interface DemoViewController ()

@property (weak, nonatomic) IBOutlet UITableView *videoListTableView;
@property (weak, nonatomic) IBOutlet UIView *videoContainView;

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, weak) AVPlayerLayer *avPlayerLayer;

@end

@implementation DemoViewController

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak DemoViewController *weakSelf = self;
    [DaiYoutubeParser parse:self.dataSource[indexPath.row] screenSize:self.videoContainView.bounds.size videoQuality:DaiYoutubeParserQualityHighres completion:^(DaiYoutubeParserStatus status, NSString *url) {
        
        if (status) {
            if (weakSelf.avPlayerLayer) {
                [weakSelf.avPlayerLayer.player pause];
                [weakSelf.avPlayerLayer removeFromSuperlayer];
            }
            
            AVAsset *avAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:url] options:nil];
            AVPlayerItem *avPlayerItem = [AVPlayerItem playerItemWithAsset:avAsset];
            AVPlayer *avPlayer = [AVPlayer playerWithPlayerItem:avPlayerItem];
            weakSelf.avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:avPlayer];
            weakSelf.avPlayerLayer.frame = weakSelf.videoContainView.bounds;
            [weakSelf.videoContainView.layer addSublayer:weakSelf.avPlayerLayer];
            [avPlayer play];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Load Video Fail" message:@"Handle on Fail" delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil];
            [alert show];
        }

    }];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.videoListTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.dataSource = @[@"12345", @"2cEi8IpUpBo", @"P5KCCfURTCA", @"ADkvjHwGQDY", @"mIIb3Jf06AA", @"ViJ-geMKm0Q", @"W43FJw3yKGM", @"3iB8TCqagFQ"];
}

@end
