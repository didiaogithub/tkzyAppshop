//
//  
//  Skyndex
//
//  Created by AMP on 1/25/13.
//  Copyright (c) 2013 AMP. All rights reserved.
//

#define KscreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)
#define KscreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define RandomColor  RGBCOLOR(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))

#define KEYAPPVERSION @"appVersion"
#define KEYCURAPPVERSION @"CFBundleShortVersionString"
