//
//  DaiYoutubeParser.m
//  DaiYoutubeParser
//
//  Created by DaidoujiChen on 2015/10/2.
//  Copyright © 2015年 DaidoujiChen. All rights reserved.
//

#import "DaiYoutubeParser.h"
#import <objc/runtime.h>
#import "DaiYoutubeParserOperation.h"

@implementation DaiYoutubeParser

#pragma mark - private class method

// parser task queue
+ (NSOperationQueue *)parserTaskQueue {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objc_setAssociatedObject(self, _cmd, [NSOperationQueue new], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    });
    return objc_getAssociatedObject(self, _cmd);
}

#pragma mark - class method

+ (void)parse:(NSString *)youtubeID screenSize:(CGSize)screenSize videoQuality:(DaiYoutubeParserQuality)videoQuality completion:(DaiYoutubeParserComplection)completion {
    DaiYoutubeParserOperation *newOperation = [[DaiYoutubeParserOperation alloc] initWithYoutubeID:youtubeID screenSize:screenSize videoQuality:videoQuality completion:completion];
    [[self parserTaskQueue] addOperation:newOperation];
}

@end
