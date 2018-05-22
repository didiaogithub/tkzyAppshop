//
//  DistrictViewController.h
//  TinyShoppingCenter
//
//  Created by 二壮 on 16/9/14.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "BaseViewController.h"

#import "SelecteAreaModel.h"
@protocol DistrictViewControllerDelegate<NSObject>
- (void)returnSreaCode:(NSString *)code;
@end
@interface DistrictViewController : BaseViewController

@property(nonatomic,strong)SelecteAreaModel *areaModel;
@property(nonatomic,copy)NSString *areaString;
@property(nonatomic,copy)NSString *areacodeS;
@property(nonatomic,copy)NSString *typestr;
/**  delegate*/
@property (nonatomic, weak) id<DistrictViewControllerDelegate> delegate;

@end
