//
//  DaiYoutubeParserOperation.h
//  DaiYoutubeParser
//
//  Created by DaidoujiChen on 2015/10/2.
//  Copyright © 2015年 DaidoujiChen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DaiYoutubeParserDefine.h"

@interface DaiYoutubeParserOperation : NSOperation

- (id)initWithYoutubeID:(NSString *)youtubeID screenSize:(CGSize)screenSize videoQuality:(DaiYoutubeParserQuality)videoQuality completion:(DaiYoutubeParserComplection)completion;

@end
