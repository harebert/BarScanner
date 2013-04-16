//
//  ViewController.h
//  BarScanner
//
//  Created by 朱 皓斌 on 13-3-31.
//  Copyright (c) 2013年 朱 皓斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import "JSON.h"
#import "SBJSON.h"
#import "NSObject+SBJSON.h"
#import "NSString+SBJSON.h"
#import <AudioToolbox/AudioToolbox.h>
@interface ViewController : UIViewController<ZBarReaderDelegate,SBJsonProtocol,NSURLConnectionDelegate,NSURLConnectionDataDelegate>{
    NSString *barDataString;
    UIImageView *resultImage;
    UITextView *resultText;
    ZBarReaderViewController *reader;
    IBOutlet UILabel *codeText;
    NSMutableData *JsonData;
    UIView *memberView;
    UILabel *newLabel;
    UILabel *ZBarView;
    UILabel *titleLabel;
    NSString *schoolLink;
    UIImageView *barImageView;
}

- (IBAction)startScan:(UIButton *)sender;
@end
