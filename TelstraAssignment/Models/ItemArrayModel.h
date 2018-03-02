//
//  ItemArray.h
//  TelstraAssignment
//
//  Created by Ashikraj R on 01/03/18.
//  Copyright © 2018 Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "ItemModel.h"

@interface ItemArrayModel : JSONModel

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSArray<ItemModel> *itemsList;

+ (JSONKeyMapper *)keyMapper;
+ (void) fetchItemswithCompletionHandler:(void (^)(ItemArrayModel *itemArrayModel, NSError * error))completionBlock;

@end
