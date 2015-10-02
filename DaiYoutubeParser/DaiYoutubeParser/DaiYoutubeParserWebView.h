//
//  DaiYoutubeParserWebView.h
//  DaiYoutubeParser
//
//  Created by DaidoujiChen on 2015/10/2.
//  Copyright © 2015年 DaidoujiChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DaiYoutubeParserDefine.h"

@interface DaiYoutubeParserWebView : UIWebView <UIWebViewDelegate>

+ (DaiYoutubeParserWebView *)createWebView:(NSString *)youtubeID screenSize:(CGSize)screenSize videoQuality:(DaiYoutubeParserQuality)videoQuality completion:(DaiYoutubeParserComplection)completion;

@end
