//
//  CKShareManager.h
//  CKYSPlatform
//
//  Created by 二壮 on 2017/7/12.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CKShareManager : NSObject

+(instancetype)manager;

+(void)shareToFriendWithName:(NSString *)name andHeadImages:(id)headImages  andUrl:(NSURL *)url andTitle:(NSString*)title;

@end
