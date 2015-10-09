//
//  DaiYoutubeParserOperation.m
//  DaiYoutubeParser
//
//  Created by DaidoujiChen on 2015/10/2.
//  Copyright © 2015年 DaidoujiChen. All rights reserved.
//

#import "DaiYoutubeParserOperation.h"
#import "DaiYoutubeParserWebView.h"

@interface DaiYoutubeParserOperation ()

@property (nonatomic, strong) NSString *youtubeID;
@property (nonatomic, assign) CGSize screenSize;
@property (nonatomic, assign) DaiYoutubeParserQuality videoQuality;
@property (nonatomic, copy) DaiYoutubeParserComplection completion;
@property (nonatomic, strong) DaiYoutubeParserWebView *webView;
@property (nonatomic, assign) BOOL isExecuting;
@property (nonatomic, assign) BOOL isFinished;

@end

@implementation DaiYoutubeParserOperation

#pragma mark - Observing Customization

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
    return YES;
}

#pragma mark - life cycle

- (id)initWithYoutubeID:(NSString *)youtubeID screenSize:(CGSize)screenSize videoQuality:(DaiYoutubeParserQuality)videoQuality completion:(DaiYoutubeParserComplection)completion {
    self = [super init];
    if (self) {
        self.youtubeID = youtubeID;
        self.screenSize = screenSize;
        self.videoQuality = videoQuality;
        self.completion = completion;
    }
    return self;
}

#pragma mark - Methods to Override

- (BOOL)isConcurrent {
    return YES;
}

- (void)start {
    if ([self isCancelled]) {
        [self operationFinish];
        return;
    }
    [self operationStart];
    
    // webView 只可以在 main thread 上跑
    __weak DaiYoutubeParserOperation *weakSelf = self;
    dispatch_sync(dispatch_get_main_queue(), ^{
        weakSelf.webView = [DaiYoutubeParserWebView createWebView:weakSelf.youtubeID screenSize:weakSelf.screenSize videoQuality:weakSelf.videoQuality completion:^(DaiYoutubeParserStatus status, NSString *url, NSString *videoTitle, NSNumber *videoDuration) {
            weakSelf.completion(status, url, videoTitle, videoDuration);
            weakSelf.webView = nil;
            [weakSelf operationFinish];
        }];
    });
}

#pragma mark - operation status

- (void)operationStart {
    self.isFinished = NO;
    self.isExecuting = YES;
}

- (void)operationFinish {
    self.isFinished = YES;
    self.isExecuting = NO;
}

@end
