//
//  ItemArray.m
//  TelstraAssignment
//
//  Created by Ashikraj R on 01/03/18.
//  Copyright © 2018 Infosys. All rights reserved.
//

#import "ItemArrayModel.h"
#import "ItemModel.h"
#import "NetworkManager.h"
#import "Reachability.h"
#import "Constants.h"

@implementation ItemArrayModel

- (instancetype)initWithDict:(NSDictionary *)dictionary{
    
    self = [super init];
    
    if(self)
    {
        @try {
            
            if([dictionary objectForKey:@"title"]) {
                
                //Check if null received in JSON
                if([dictionary objectForKey:@"title"] == [NSNull null]) {
                    self.title = @"";
                }
                else {
                    self.title = [dictionary objectForKey:@"title"];
                }
            }
            
            if([dictionary objectForKey:@"rows"]) {
                
                if([[dictionary objectForKey:@"rows"] isKindOfClass:[NSArray class]]) {
                    
                    NSMutableArray *itemArray = [[NSMutableArray alloc] init];
                    
                    for(NSDictionary *itemDict in [dictionary objectForKey:@"rows"]) {
                        
                        ItemModel *item = [[ItemModel alloc] initWithDict:itemDict];
                        
                        if(item) {
                            [itemArray addObject:item];
                        }
                        
                    }
                    
                    self.itemsList = itemArray;
                    
                }
            }
        }
        @catch (NSException *exception) {
            
            NSLog(@"Error occured : %@", exception);
            return nil;
            
        }
    }
    
    return self;
    
}

+ (void) fetchItemswithCompletionHandler:(void (^)(ItemArrayModel *itemArrayModel, NSError * error))completionBlock {
    
    //Check for internet connection and show error if not available
    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        
        //Creating custom error object
        NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
        [info setValue:@"Internet Connection not available" forKey:@"Message"];
        NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:-1009 userInfo:info];
        
        completionBlock(nil,error);
        
        return;
    }
    
    //Perform service call to fetch list from server
    [NetworkManager getListFromServer:URL_FOR_LIST withCompletionHandler:^(NSDictionary *dictionary, NSError *error) {
        
        //Check if no error is present
        if(error == nil && dictionary != nil) {
            
            ItemArrayModel *itemArrayModel = [[ItemArrayModel alloc] initWithDict:dictionary];
            completionBlock(itemArrayModel, nil);
            
        }
        else {
            
            if(error) {
                completionBlock(nil,error);
            }
            else {
                //Creating custom error object
                NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
                [info setValue:@"Some error occured" forKey:@"Message"];
                NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:-1009 userInfo:info];
                
                completionBlock(nil,error);
            }
            
        }
    }];
    
}

@end
