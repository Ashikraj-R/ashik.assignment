//
//  UIImageView+ImageDownloader.m
//  TelstraAssignment
//
//  Created by Ashikraj R on 28/02/18.
//  Copyright © 2018 Infosys. All rights reserved.
//

#import "UIImageView+ImageDownloader.h"
#import "NetworkManager.h"
#import "Constants.h"

@implementation UIImageView (ImageDownloader)


//Extension method to download image from server/online.
- (void)downloadImageFromUrl:(NSString *)urlString withCompletionHandler:(void (^)(NSData *imageData, NSString *imageURL))completionBlock {
    
    NSLog(MESSAGE_ENTERING,__FUNCTION__);
    
    @try {
    
        [NetworkManager downloadImage:urlString withCompletionHandler:^(NSData *imageData, NSError *error) {
            if(imageData != nil && error == nil) {
            
                //Since UI related change, dispatching in main thread
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.image = [UIImage imageWithData:imageData];
                });
                completionBlock(imageData,urlString);
            }
        }];
        
    }
    
    @catch (NSException *exception) {
        NSLog(ERROR_STANDARD,__FUNCTION__, exception);
    }
    
    @finally {
        NSLog(MESSAGE_EXITING,__FUNCTION__);
    }
}

@end
