//
//  ScanCodeViewController.m
//  RPQRcode
//
//  Created by mac on 2018/3/26.
//  Copyright © 2018年 WRP. All rights reserved.
//

#import "ScanCodeViewController.h"
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)

@implementation ScanCodeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted)
        {
            if (iOS8Later) {

                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"本应用无访问相机的权限，如需访问，可在设置中修改" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                }]];
                [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                } ]];
                
                [self presentViewController:alertController animated:YES completion:nil];
                
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"本应用无访问相机的权限，如需访问，可在设置中修改" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [alertView show];
            }
            
//            [[[UIAlertView alloc] initWithTitle:nil message:@"本应用无访问相机的权限，如需访问，可在设置中修改" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
            
            
            return;
            
        } else {
            
            
            //打开相机
            AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            
            //创建输入流
            AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
            //创建输出流
            output = [[AVCaptureMetadataOutput alloc]init];
            //设置代理 在主线程里刷新
            [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
            
            //设置扫描区域，这个需要仔细调整
            [output setRectOfInterest:CGRectMake(64/RPHeight, (RPWidth - 320)/2/RPWidth, 320/RPHeight, 320/RPWidth)];
            
            
            //初始化链接对象
            session = [[AVCaptureSession alloc]init];
            //高质量采集率
            [session setSessionPreset:AVCaptureSessionPresetHigh];
            
            [session addInput:input];
            [session addOutput:output];
            
            //设置扫码支持的编码格式
            output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
            
            
            AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
            layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
            layer.frame=self.view.layer.bounds;
            [self.view.layer addSublayer:layer];
            
        }
    }
    
    
    [self _initView];
    
}


//里面所有的控件可以自己定制，这里只是简单的例子
- (void)_initView {
    
    //扫码框
    _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, RPWidth, RPHeight - 64)];
    _backImageView.image = [UIImage imageNamed:@"camera_bg"];
    [self.view addSubview:_backImageView];
    
    
    _lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 15, RPWidth - 32, 1)];
    _lineImageView.backgroundColor = [UIColor orangeColor];
    [_backImageView addSubview:_lineImageView];
    
    //各种参数设置
    lineNum = 0;
    upOrDown = NO;
    
    lineTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(lineAnimation) userInfo:nil repeats:YES];
    
}


-(void)lineAnimation {
    if (upOrDown == NO) {
        lineNum ++;
        _lineImageView.frame = CGRectMake(CGRectGetMinX(_lineImageView.frame), 15 + lineNum, RPWidth - 32, 1);
        CGFloat tempHeight = CGRectGetHeight(_backImageView.frame) * 321/542;
        NSInteger height = (NSInteger)tempHeight + 20;
        if (lineNum == height) {
            upOrDown = YES;
        }
    }
    else {
        lineNum --;
        _lineImageView.frame = CGRectMake(CGRectGetMinX(_lineImageView.frame), 15 + lineNum, RPWidth - 32, 1);
        if (lineNum == 0) {
            upOrDown = NO;
        }
    }
}


#pragma mark AVCaptureMetadataOutputObjectsDelegate


- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    
    
    if ([metadataObjects count] > 0) {
        
        [session stopRunning]; //停止扫码
        
        
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects firstObject];
        
        ResultViewController *resultVC = [[ResultViewController alloc] init];
        resultVC.contentString = metadataObject.stringValue;
        [self.navigationController pushViewController:resultVC animated:NO];
        
        
    }
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [session startRunning];
    [lineTimer setFireDate:[NSDate distantPast]];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [session stopRunning];
    [lineTimer setFireDate:[NSDate distantFuture]];
    
    if (![self.navigationController.viewControllers  containsObject:self]) {//释放timer
        
        [lineTimer invalidate];
        lineTimer = nil;
    }
    
}

- (void)dealloc {
    
    NSLog(@"已释放");
}
@end



