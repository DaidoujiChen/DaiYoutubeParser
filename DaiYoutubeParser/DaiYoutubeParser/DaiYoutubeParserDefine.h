//
//  DaiYoutubeParserDefine.h
//  DaiYoutubeParser
//
//  Created by DaidoujiChen on 2015/10/5.
//  Copyright © 2015年 DaidoujiChen. All rights reserved.
//

#ifndef DaiYoutubeParserDefine_h
#define DaiYoutubeParserDefine_h
#import <UIKit/UIKit.h>

typedef enum {
    DaiYoutubeParserQualitySmall,
    DaiYoutubeParserQualityMedium,
    DaiYoutubeParserQualityLarge,
    DaiYoutubeParserQualityHD720,
    DaiYoutubeParserQualityHD1080,
    DaiYoutubeParserQualityHighres
} DaiYoutubeParserQuality;

typedef enum {
    DaiYoutubeParserStatusFail,
    DaiYoutubeParserStatusSuccess
} DaiYoutubeParserStatus;

typedef void (^DaiYoutubeParserComplection)(DaiYoutubeParserStatus status, NSString *url, NSString *videoTitle, NSNumber *videoDuration);

#endif
