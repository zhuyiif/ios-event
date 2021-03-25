//
//  ViewController.m
//  fb_event
//
//  Created by zack on 3/23/21.
//

#import "EventViewController.h"
#import "NSString+Helpers.h"
#import "EventModel.h"

@interface EventViewController ()
@property (strong, nonatomic) EventModel * evModel;
@end

@implementation EventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.evModel = [[EventModel alloc] init];
    [self.evModel loadJson];
    
    
    //sort by startdate
    
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell.
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.text = [self.evModel eventAtIndex:indexPath.row section:indexPath.section] ;

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.evModel numberOfDateInSection: section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.evModel numberOfSections];
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    return [self.evModel sectionHeader:section];
}

@end
