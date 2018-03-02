//
//  ItemModel.h
//  TelstraAssignment
//
//  Created by Ashikraj R on 27/02/18.
//  Copyright © 2018 Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemModel : NSObject

@property (strong, nonatomic) NSString *itemTitle;
@property (strong, nonatomic) NSString *itemDescription;
@property (strong, nonatomic) NSString *imageURL;

- (instancetype)initWithDict:(NSDictionary *)dictionary;

@end
