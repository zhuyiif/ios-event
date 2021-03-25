//
//  ViewController.m
//  fb_event
//
//  Created by zack on 3/23/21.
//

#import "ViewController.h"
#import "NSString+Helpers.h"
#import "EventModel.h"

@interface ViewController ()
@property (strong, nonatomic) EventModel * evModel;
@end

@implementation ViewController

- (NSArray *)JSONFromFile {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"mock" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.evModel = [[EventModel alloc] init];
    [self.evModel loadJson];
    
    //load json
    NSArray *array = [self JSONFromFile];
    
    NSDictionary *event =[array objectAtIndex:0];
    
    NSString *firstDate = [event objectForKey:@"start"];
    NSDate *fDate = [firstDate eventDate];
    
    NSLog(@"count = %d" , array.count);
    
    NSLog(@"first str = %@" , firstDate);

    NSLog(@"first = %@" , fDate);
    
    //sort by startdate
    
}


@end
