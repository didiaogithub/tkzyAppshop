//
//  SCCommentModel.h
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/8/22.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//
//  评论列表的model

#import <Foundation/Foundation.h>



@interface   SCCommentImgModel: BaseModel

/** 昵称 */
@property (nonatomic, copy) NSString *smallname;
/** 评分 */
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *commentid;
/** 评论内容 */
@property (nonatomic, copy) NSString *content;
/** 时间 */
@property (nonatomic, copy) NSString *time;
/** 图像 */
@property (nonatomic, copy) NSString *head;
@property (nonatomic, copy) NSString *path1;
@property (nonatomic, copy) NSString *path2;
@property (nonatomic, copy) NSString *path3;
@property (nonatomic, copy) NSMutableArray  *imgPathArray;



@end

@interface  SCCommentModel: BaseModel

@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSArray <SCCommentImgModel *> *list;

@end
