//
//  SectionModel.m
//  CKYSPlatform
//
//  Created by 二壮 on 2017/5/24.
//  Copyright © 2017年 二壮. All rights reserved.
//

#import "SectionModel.h"

@implementation SectionModel

-(instancetype)init {
    self = [super init];
    if(self) {
        self.reuseIdentifier = [[NSUUID UUID] UUIDString];
    }
    return self;
}

+(instancetype)sectionModelWithTitle:(NSString *)title cells:(NSArray<CellModel *> *)cells {
    SectionModel *section = [[SectionModel alloc] init];
    section.title = title;
    section.cells = cells;
    return section;
}

@end
