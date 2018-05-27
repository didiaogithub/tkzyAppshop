//
//  MyInvoicesViewController.h
//  appmall
//
//  Created by majun on 2018/5/24.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "BaseViewController.h"
#import "MyInvoicesModel.h"
typedef void(^selectMyInvoicesBlock)(MyInvoicesModel *model);
@interface MyInvoicesViewController : BaseViewController
@property (nonatomic,copy) selectMyInvoicesBlock selectMyInvoicesBlock;
@end
