//
//  ScanCodeViewController.h
//  RPQRcode
//
//  Created by mac on 2018/3/26.
//  Copyright © 2018年 WRP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface ScanCodeViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession * session;
    AVCaptureMetadataOutput * output;
    NSInteger lineNum;
    BOOL upOrDown;
    NSTimer *lineTimer;
}

@property (nonatomic, strong) UIImageView *lineImageView;
@property (nonatomic, strong) UIImageView *backImageView;
@end
