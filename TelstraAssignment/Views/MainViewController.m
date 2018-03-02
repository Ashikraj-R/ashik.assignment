//
//  MainViewController.m
//  TelstraAssignment
//
//  Created by Ashikraj R on 27/02/18.
//  Copyright © 2018 Infosys. All rights reserved.
//

#import "MainViewController.h"
#import "NetworkManager.h"
#import "ItemViewModel.h"
#import "CustomTableCell.h"
#import "UIImageView+ImageDownloader.h"
#import "Reachability.h"
#import "Constants.h"
#import "OSCache.h"

@interface MainViewController ()

@property (strong, nonatomic) NSMutableArray *dataList;
@property (strong, nonatomic) NSString *navigationTitle;
@property (strong, nonatomic) OSCache *cache;

@end

@implementation MainViewController

- (instancetype)initWithViewModel:(ItemArrayViewModel *) itemArrayViewModel {
    
    self = [super init];
    
    if(self) {
        self.itemArrayViewModel = itemArrayViewModel;
    }
    
    return self;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initialSetup];
    [self fetchAndRefresh];
    
}

- (void) initialSetup {
    
    NSLog(MESSAGE_ENTERING,__FUNCTION__);
    
    //Initialize the required objects
    self.dataList = [[NSMutableArray alloc] init];
    self.cache = [[OSCache alloc] init];
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    //Set target to refresh control and add to the table view
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl beginRefreshing];
    
    //Set the table cell height to dynamic so it increases or decreases depending on cell content
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50;
    
    NSLog(MESSAGE_EXITING,__FUNCTION__);
    
}

- (void) refreshTable {
    [self fetchAndRefresh];
}

- (void) fetchAndRefresh {
    
    NSLog(MESSAGE_ENTERING,__FUNCTION__);
    
    [self.itemArrayViewModel fetchItemswithCompletionHandler:^(NSError *error) {
        
        //Pushing to main thread since UI related changes
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
        });
        
        if(error == nil) {
            
            //Pushing to main thread since UI related changes
            dispatch_async(dispatch_get_main_queue(), ^{
                self.navigationController.navigationBar.topItem.title = self.itemArrayViewModel.listTitle;
                [self.tableView reloadData];
            });
            
        }
        else {
            [self showError:ERROR_FETCH_FAILED];
        }
    }];
    
    NSLog(MESSAGE_EXITING,__FUNCTION__);
    
}

- (void)showError:(NSString *)errorMessage
{
    
    NSLog(MESSAGE_ENTERING,__FUNCTION__);
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Error"
                                 message:errorMessage
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"Ok"
                               style:UIAlertActionStyleDefault
                               handler:nil];
    
    //Adding ok buttons to alert controller
    [alert addAction:okButton];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
    NSLog(MESSAGE_EXITING,__FUNCTION__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemArrayViewModel.itemsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = CELL_IDENTIFIER;
    
    CustomTableCell *customCell = (CustomTableCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (customCell == nil) {
        customCell = [[CustomTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    @try {
        
        ItemViewModel *item = [self.itemArrayViewModel itemAtIndex:indexPath.row];
        
        customCell.titleLabel.text = item.itemTitle;
        customCell.descriptionLabel.text = item.itemDescription;
        customCell.itemImage.image = nil;
        
    }
    @catch (NSException *exception) {
        NSLog(ERROR_STANDARD,__FUNCTION__, exception);
    }
    
    return customCell;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    @try {
        if ([cell isKindOfClass:[CustomTableCell class]]) {
            
            CustomTableCell *customCell = (CustomTableCell *)cell;
            ItemViewModel *item = [self.itemArrayViewModel itemAtIndex:indexPath.row];
            
            //Load image data from cache if available
            if([_cache objectForKey:item.imageURL]) {
                customCell.itemImage.image = [UIImage imageWithData:[_cache objectForKey:item.imageURL]];
            }
            else {
                [customCell.itemImage downloadImageFromUrl:item.imageURL withCompletionHandler:^(NSData *imageData, NSString *imageURL) {
                    
                    //Dispatching in main thread to avoid redownload if user quickly scrolls up and down (Quick change of visible cells)
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_cache setObject:imageData forKey:imageURL];
                    });
                    
                }];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(ERROR_STANDARD,__FUNCTION__, exception);
    }
}

@end
