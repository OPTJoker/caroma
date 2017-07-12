//
//  DetailViewController.h
//  KEMA
//
//  Created by 张雷 on 2017/6/30.
//  Copyright © 2017年 Allen. All rights reserved.
//

#import "XLUIViewController.h"
#import "ItemModel.h"

@interface DetailViewController : XLUIViewController

@property(nonatomic, copy) NSString *catID;
@property(nonatomic, copy) NSArray<ItemModel *> *items;

@end
