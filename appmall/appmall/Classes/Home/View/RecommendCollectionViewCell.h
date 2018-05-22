//
//  RecommendCollectionViewCell.h
//  appmall
//
//  Created by 壮壮 on 15/04/2018.
//  Copyright © 2018 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKHomeDataModel.h"
@interface RecommendCollectionViewCell : UICollectionViewCell

-(void)loadDataModel:(TKHomeDataModel *)model andIndex:(NSIndexPath  *)index andSuperSection:(NSInteger )section;

@end
