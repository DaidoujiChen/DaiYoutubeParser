# DaiYoutubeParser
Parse the youtube video url path, do any custom things you want.

![image](https://s3-ap-northeast-1.amazonaws.com/daidoujiminecraft/Daidouji/DaiYoutubeParser.gif)

DaidoujiChen

daidoujichen@gmail.com

## Installation
Copy all the files in `DaiYoutubeParser\DaiYoutubeParser` to your project.

And

`````objc
#import "DaiYoutubeParser.h"
`````

## Usage
It is very easy to use, there is a only method

`````objc
+ (void)parse:(NSString *)youtubeID screenSize:(CGSize)screenSize videoQuality:(DaiYoutubeParserQuality)videoQuality completion:(DaiYoutubeParserComplection)completion;
`````

 - youtubeID, your target youtube video ID
 - screenSize, the screen size you want to show
 - videoQuality, choose the video quality. If the screenSize is not large enough, the video qulity can not get the better one
 - completion, callback success or fail, and the video url path

simple to use

`````objc
[DaiYoutubeParser parse:@"2cEi8IpUpBo" screenSize:CGSizeZero videoQuality:DaiYoutubeParserQualityHighres completion:^(DaiYoutubeParserStatus status, NSString *url) {
	if (status) {
		NSLog(@"%@", url);
	}
	else {
		NSLog(@"load fail");
	}
}];
`````
