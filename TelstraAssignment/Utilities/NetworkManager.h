//
//  NetworkManager.h
//  TelstraAssignment
//
//  Created by Ashikraj R on 27/02/18.
//  Copyright © 2018 Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject

+ (void) getListFromServer:(NSString *)urlString withCompletionHandler:(void (^)(NSDictionary *image, NSError * error))completionBlock;
+ (void) downloadImage:(NSString *)urlString withCompletionHandler:(void (^)(NSData *imageData, NSError * error))completionBlock;

@end
