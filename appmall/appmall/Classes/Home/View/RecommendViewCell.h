//
//  RecommendViewCell.h
//  appmall
//
//  Created by 壮壮 on 15/04/2018.
//  Copyright © 2018 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKHomeDataModel.h"

@protocol RecommendViewCellDelegate<NSObject>
-(void)recommendViewCellDelegateMore:(NSInteger)index;
-(void)recommendViewCellClick:(NSIndexPath*)indexpath andTabIndex:(NSInteger)index;
@end

@interface RecommendViewCell : UITableViewCell

@property(weak,nonatomic)id <RecommendViewCellDelegate>delegate;
-(void)setCollection:(NSInteger )index andData:(TKHomeDataModel *)model;
-(CGFloat)getCollectionHeight:(NSInteger)index ;

@end
