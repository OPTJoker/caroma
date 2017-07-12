//
//  ItemModel.h
//  KEMA
//
//  Created by 张雷 on 2017/7/6.
//  Copyright © 2017年 Allen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemModel : NSObject

// shortDesc 短描述
@property(nonatomic, copy) NSString *itemBrief;
// desc 长描述
@property(nonatomic, copy) NSString *itemDes;
// itemID 322
@property(nonatomic, copy) NSString *itemID;
// 网页链接
@property(nonatomic, copy) NSString *itemLink;
// name 322
@property(nonatomic, copy) NSString *itemName;
// 包路径
@property(nonatomic, copy) NSString *itemPkg;


@end
