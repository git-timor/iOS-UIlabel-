//
//  UIColor+Equalable.h
//  MZSelectableLabelDemo
//
//  Created by Michał Zaborowski on 05.08.2014.
//  Copyright (c) 2014 Michal Zaborowski. All rights reserved.
//
// http://stackoverflow.com/questions/970475/how-to-compare-uicolors

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <UIKit/UIKit.h>

@interface UIColor (Equalable)
- (BOOL)isEqualToColor:(UIColor *)otherColor;
@end
