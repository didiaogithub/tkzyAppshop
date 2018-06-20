//
//  ZJPayWebViewController.h
//  appmall
//
//  Created by majun on 2018/6/20.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "BaseViewController.h"

@interface ZJPayWebViewController : BaseViewController

/**  requestUrl*/
@property (nonatomic, copy) NSString *requestUrl;
/** 是否是欠款管理页面*/
@property (nonatomic, assign) BOOL isqkglPage;

@end
