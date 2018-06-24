//
//  MyInvoicesViewController.h
//  appmall
//
//  Created by majun on 2018/5/24.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "BaseViewController.h"
#import "MyInvoicesModel.h"
typedef void(^SelectMyInvoicesBlock)(MyInvoicesModel *model);


@interface MyInvoicesViewController : BaseViewController
/**  是否是开票信息按钮进入*/
@property (nonatomic, assign) BOOL isOpenPXXBtn;
@property (nonatomic,copy) SelectMyInvoicesBlock selectMyInvoicesBlock;
@end
