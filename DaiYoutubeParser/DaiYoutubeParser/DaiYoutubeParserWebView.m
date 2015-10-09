//
//  DaiYoutubeParserWebView.m
//  DaiYoutubeParser
//
//  Created by DaidoujiChen on 2015/10/2.
//  Copyright © 2015年 DaidoujiChen. All rights reserved.
//

#import "DaiYoutubeParserWebView.h"
#import <objc/message.h>

@interface DaiYoutubeParserWebView ()

@property (nonatomic, copy) DaiYoutubeParserComplection completion;
@property (nonatomic, strong) NSTimer *checkTimer;

@end

@implementation DaiYoutubeParserWebView

#pragma mark - UIWebViewDelegate

+ (void)webView:(DaiYoutubeParserWebView *)webView didFailLoadWithError:(NSError *)error {
    // 網路錯誤
    [webView terminalWebView];
    webView.completion(DaiYoutubeParserStatusFail, nil, nil, nil);
}

#pragma mark - private class method

+ (NSString *)videoQualityString:(DaiYoutubeParserQuality)videoQuality {
    switch (videoQuality) {
        case DaiYoutubeParserQualitySmall:
            return @"small";
        case DaiYoutubeParserQualityMedium:
            return @"medium";
        case DaiYoutubeParserQualityLarge:
            return @"large";
        case DaiYoutubeParserQualityHD720:
            return @"hd720";
        case DaiYoutubeParserQualityHD1080:
            return @"hd1080";
        case DaiYoutubeParserQualityHighres:
            return @"highres";
    }
}

#pragma mark - class method

+ (DaiYoutubeParserWebView *)createWebView:(NSString *)youtubeID screenSize:(CGSize)screenSize videoQuality:(DaiYoutubeParserQuality)videoQuality completion:(DaiYoutubeParserComplection)completion {
    
    // 把品質列舉轉為字串
    NSString *videoQualityString = [self videoQualityString:videoQuality];
    
    // 讀取本地 html 播放框架
    NSString *htmlFilePath = [[NSBundle mainBundle] pathForResource:@"YoutubeParserBridge" ofType:@"html"];
    NSString *originalHtmlString = [NSString stringWithContentsOfFile:htmlFilePath encoding:NSUTF8StringEncoding error:nil];
    NSString *htmlWithParameterString = [NSString stringWithFormat:originalHtmlString, screenSize.width, screenSize.height, youtubeID, videoQualityString];

    // 建立 webView
    DaiYoutubeParserWebView *returnWebView = [[DaiYoutubeParserWebView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    returnWebView.delegate = (id <UIWebViewDelegate>)self;
    returnWebView.allowsInlineMediaPlayback = YES;
    returnWebView.mediaPlaybackRequiresUserAction = NO;
    
    // 設置回調
    __weak DaiYoutubeParserWebView *weakReturnWebView = returnWebView;
    returnWebView.completion = ^(DaiYoutubeParserStatus status, NSString *url, NSString *videoTitle, NSNumber *videoDuration) {
        [weakReturnWebView terminalWebView];
        completion(status, url, videoTitle, videoDuration);
    };
    
    // 開始讀取, 並且設置 timer 觀測是不是有 error 發生
    [returnWebView loadHTMLString:htmlWithParameterString baseURL:[NSURL URLWithString:@"http://www.example.com"]];
    returnWebView.checkTimer = [NSTimer scheduledTimerWithTimeInterval:1.5f target:returnWebView selector:@selector(stateCheck:) userInfo:nil repeats:YES];
    return returnWebView;
}

#pragma mark - private instance method

- (NSString *)getVideoTitle {
    NSString *videoTitle = [self stringByEvaluatingJavaScriptFromString:@"getVideoTitle()"];
    return videoTitle;
}

- (NSNumber *)getDuration {
    NSUInteger unsignedIntegerValue = [[self stringByEvaluatingJavaScriptFromString:@"getDuration()"] integerValue];
    NSNumber *duration = (unsignedIntegerValue == NSNotFound)? nil:@(unsignedIntegerValue);
    return duration;
}

- (void)terminalWebView {
    [self stopLoading];
    [self.checkTimer invalidate];
    self.checkTimer = nil;
}

- (void)stateCheck:(NSTimer *)timer {
    /*
     這邊要 javascript 裡面有接應的 function `error()`
     他會回報是不是遇到錯誤了, 官方的錯誤列表為
     
     2 – The request contains an invalid parameter value. For example, this error occurs if you specify a video ID that does not have 11 characters, or if the video ID contains invalid characters, such as exclamation points or asterisks.
     
     5 – The requested content cannot be played in an HTML5 player or another error related to the HTML5 player has occurred.
     
     100 – The video requested was not found. This error occurs when a video has been removed (for any reason) or has been marked as private.
     
     101 – The owner of the requested video does not allow it to be played in embedded players.
     
     150 – This error is the same as 101. It's just a 101 error in disguise!
     */
    NSString *errorString = [self stringByEvaluatingJavaScriptFromString:@"error();"];
    if (errorString.integerValue > 0) {
        [self terminalWebView];
        self.completion(DaiYoutubeParserStatusFail, nil, nil, nil);
    }
}

- (id)webView:(id)arg1 identifierForInitialRequest:(id)arg2 fromDataSource:(id)arg3 {
    struct objc_super superObject;
    superObject.receiver = self;
    superObject.super_class = class_isMetaClass(object_getClass(self)) ? object_getClass(self.superclass) : self.superclass;
    
    // 解析類別
    // - videoplayback?, 一般影片
    // - .m3u8, 直播影片
    BOOL isFoundTargetString = NO;
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@", [(NSMutableURLRequest *)arg2 URL]];
    if ([urlString containsString:@"videoplayback?"]) {
        isFoundTargetString = YES;
    }
    else if ([urlString containsString:@".m3u8"]) {
        isFoundTargetString = YES;
    }
    
    if (isFoundTargetString) {
        NSString *videoTitle = [self getVideoTitle];
        NSNumber *duration = [self getDuration];
        self.completion(DaiYoutubeParserStatusSuccess, urlString, videoTitle, duration);
        return nil;
    }
    else {
        return ((id (*)(id, SEL, id, id, id))objc_msgSendSuper)((__bridge id)(&superObject), _cmd, arg1, arg2, arg3);
    }
}

@end
