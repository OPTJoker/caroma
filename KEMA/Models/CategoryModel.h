//
//  CategoryModel.h
//  KEMA
//
//  Created by 张雷 on 2017/7/6.
//  Copyright © 2017年 Allen. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ItemModel;

@interface CategoryModel : NSObject
@property(nonatomic, copy) NSString *CateName;
@property(nonatomic, copy) NSString *CatID;
@property(nonatomic, copy) NSArray<ItemModel *> *items;

@end
