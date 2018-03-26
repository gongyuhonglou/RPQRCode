//
//  UIImageView+CreatCode.h
//  RPQRcode
//
//  Created by mac on 2018/3/26.
//  Copyright © 2018年 WRP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (CreatCode)
/**
 这里传入二维码的信息,image是加载二维码上方的图片,如果不要图片直接codeImage为nil即可,后面是图片的圆角
 */
- (void)creatCode:(NSString *)codeContent Image:(UIImage *)codeImage andImageCorner:(CGFloat)imageCorner;

@end
