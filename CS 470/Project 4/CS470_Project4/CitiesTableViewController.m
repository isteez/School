//
//  CitiesTableViewController.m
//  CS470_Project4
//
//  Created by Stephen Kyles on 3/25/14.
//  Copyright (c) 2014 Stephen Kyles. All rights reserved.
//

#import "CitiesTableViewController.h"
#import "SchemaDataSource.h"
#import "City.h"
#import "CityDataSource.h"
#import "CitiesDetailTableViewController.h"

static BOOL _debug = NO;

@interface CitiesTableViewController ()
@property(nonatomic) SchemaDataSource *dataSource;
@property(nonatomic) CityDataSource *cityDataSource;
@property(nonatomic) UIActivityIndicatorView *activityIndicator;
@end

static NSString *CellIdentifier = @"Cell";

@implementation CitiesTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        UIImage *tabImage = [UIImage imageNamed:@"City.png"];
        self.tabBarItem.image = tabImage;
        self.title = @"Cities";
        [[SchemaDataSource sharedInstance] addObserver: self
                                            forKeyPath: @"dataSourceReady"
                                               options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                               context:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    self.dataSource = [SchemaDataSource sharedInstance];
    
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(refreshTableView:) forControlEvents:UIControlEventValueChanged];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.activityIndicator setCenter: self.view.center];
    [self.view addSubview: self.activityIndicator];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    self.cityDataSource = [[SchemaDataSource sharedInstance] cityDataSource];
    [self.tableView reloadData];
    [self.activityIndicator stopAnimating];
    if( _debug ) {
        NSString *oldValue = [change objectForKey: NSKeyValueChangeOldKey];
        NSString *newValue = [change objectForKey: NSKeyValueChangeNewKey];
        NSLog(@"Observer called with old value %@ and new value %@", oldValue, newValue);
    }
}

- (void) refreshTableView: (UIRefreshControl *) rControl
{
    if( [self.dataSource dataSourceReady] )
        [self.tableView reloadData];
    [rControl endRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.cityDataSource numberOfCities];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    City *city = [self.cityDataSource cityAtIndex: section];
    NSArray *theaters = [[self.dataSource theatersDataSource] getTheaterInCity:city.cityName];
    if( _debug ) {
        [city print];
        NSLog(@"%@ has %d theaters", city.cityName, [theaters count]);
    }
    return [theaters count];
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    City *city = [self.cityDataSource cityAtIndex: section];
    NSString *text = [NSString stringWithFormat:@"%@", city.cityName];
    return text;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    City *city = [self.cityDataSource cityAtIndex:[indexPath section]];
    NSArray *theatersInCity = [[self.dataSource theatersDataSource] getTheaterInCity:city.cityName];
    if( _debug )
        for( Theater *tic in theatersInCity )
            [tic print];
    cell.textLabel.text = [[theatersInCity objectAtIndex:[indexPath row]] theaterName];
    return cell;
}

- (NSIndexPath *) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // deselect a selected row when it is tapped for the second time.
    if( [self.tableView cellForRowAtIndexPath:indexPath].selected ) {
        [self.tableView deselectRowAtIndexPath: indexPath animated:YES];
        return nil;
    }
    return indexPath;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Did select row %d", [indexPath row] );
    City *city = [self.cityDataSource cityAtIndex:[indexPath section]];
    NSArray *theatersInCity = [[self.dataSource theatersDataSource] getTheaterInCity:city.cityName];
    Theater *theater = [[self.dataSource theatersDataSource] theaterWithName:[NSString stringWithFormat:@"%@", [[theatersInCity objectAtIndex:[indexPath row]] theaterName]]];
    CitiesDetailTableViewController *dc = [[CitiesDetailTableViewController alloc] initWithTheater:theater];
    [self.navigationController pushViewController:dc animated:YES];
}

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
