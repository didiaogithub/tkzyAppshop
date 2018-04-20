//
//  ChangeMyAddressViewController.h
//  CKYSPlatform
//
//  Created by 二壮 on 16/11/17.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "BaseViewController.h"
#import "AddressModel.h"

typedef void (^TransBlockaddress)(AddressModel *addressModel);

typedef void (^AddressBackBlock)(NSString *deleteDefaultAddressId);

@interface ChangeMyAddressViewController : BaseViewController

@property(nonatomic,copy)TransBlockaddress addressBlock;

-(void)setAddressBlock:(TransBlockaddress)addressBlock;


@property (nonatomic, strong) AddressModel *addressModel;
@property (nonatomic, copy)   NSString *pushString;
@property (nonatomic, copy)   NSString *orderid;
@property (nonatomic, copy) NSString *isOversea;

#pragma mark-解决删除地址后 传过去的bug
@property(nonatomic,copy)AddressBackBlock backBlock;

-(void)setDeleteAddressIdWithBlock:(AddressBackBlock)deleteBlock;

@end
