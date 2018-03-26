//
//  RPQRcode.h
//  RPQRcode
//
//  Created by mac on 2018/3/26.
//  Copyright © 2018年 WRP. All rights reserved.
//

#ifndef RPQRcode_h
#define RPQRcode_h
#import "UIImageView+CreatCode.h"
#import "ScanCodeViewController.h"
#import "ResultViewController.h"
// Include any system framework and library headers here that should be included in all compilation units.
// You will also need to set the Prefix Header build setting of one or more of your targets to reference this file.

#define RPWidth   [UIScreen mainScreen].bounds.size.width
#define RPHeight  [UIScreen mainScreen].bounds.size.height
#define RPScreen  [UIScreen mainScreen].bounds

#define RealValue(value) (value * RPWidth / 320)

#endif /* RPQRcode_h */
