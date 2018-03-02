//
//  ItemModel.h
//  TelstraAssignment
//
//  Created by Ashikraj R on 27/02/18.
//  Copyright © 2018 Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol ItemModel;

@interface ItemModel :JSONModel

@property (strong, nonatomic) NSString <Optional> *itemTitle;
@property (strong, nonatomic) NSString <Optional> *itemDescription;
@property (strong, nonatomic) NSString <Optional> *imageURL;

+ (JSONKeyMapper *)keyMapper;

@end
