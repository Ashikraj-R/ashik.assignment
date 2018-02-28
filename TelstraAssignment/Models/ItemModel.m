//
//  ItemModel.m
//  TelstraAssignment
//
//  Created by Ashikraj R on 27/02/18.
//  Copyright © 2018 Infosys. All rights reserved.
//

#import "ItemModel.h"

@implementation ItemModel

- (instancetype)initWithDict:(NSDictionary *)dictionary{
    
    self = [super init];
    
    if(self)
    {
        @try {
            if([dictionary objectForKey:@"title"]) {
                
                //Check if null received in JSON
                if([dictionary objectForKey:@"title"] == [NSNull null]) {
                    self.itemTitle = @"";
                }
                else {
                    self.itemTitle = [dictionary objectForKey:@"title"];
                }
            }
            
            if([dictionary objectForKey:@"description"]) {
                
                //Check if null received in JSON
                if([dictionary objectForKey:@"description"] == [NSNull null]) {
                    self.itemDescription = @"";
                }
                else {
                    self.itemDescription = [dictionary objectForKey:@"description"];
                }
            }
            
            if([dictionary objectForKey:@"imageHref"]) {
                
                //Check if null received in JSON
                if([dictionary objectForKey:@"imageHref"] == [NSNull null]) {
                    self.imageURL = @"";
                }
                else {
                    self.imageURL = [dictionary objectForKey:@"imageHref"];
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Error occured : %@", exception);
            return nil;
        }
    }
    
    //Returning nil if the all the 3 paramters are null so that it won't be displayed in the table
    if([self.itemTitle isEqualToString:@""]&&[self.itemDescription isEqualToString:@""]&&[self.imageURL isEqualToString:@""]) {
        return nil;
    }
    
    return self;
}

@end
