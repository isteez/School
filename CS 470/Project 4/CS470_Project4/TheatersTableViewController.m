//
//  TheatersTableViewController.m
//  TableViewDemoPart1
//
//  Created by AAK on 3/9/14.
//  Copyright (c) 2014 Ali Kooshesh. All rights reserved.
//

#import "TheatersTableViewController.h"
#import "Theater.h"
#import "TheatersDataSource.h"
#import "MoviesAtTheatersDataSource.h"
#import "SchemaDataSource.h"
#import "MovieAtTheater.h"
#import "DetailedMovieViewController.h"
#import "Showtime.h"

@interface TheatersTableViewController ()

@property(nonatomic) SchemaDataSource *dataSource;
@property(nonatomic) TheatersDataSource *theatersDataSource;
@property(nonatomic) UIActivityIndicatorView *activityIndicator;

@end

static BOOL _debug = NO;
static NSString *CellIdentifier = @"Cell";

@implementation TheatersTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        UIImage *tabImage = [UIImage imageNamed:@"Theaters"];
        self.tabBarItem.image = tabImage;
        self.title = @"Theaters";
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
    self.dataSource = [SchemaDataSource sharedInstance];
    
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(refreshTableView:) forControlEvents:UIControlEventValueChanged];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.activityIndicator setCenter: self.view.center];
    [self.view addSubview: self.activityIndicator];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    self.theatersDataSource = [[SchemaDataSource sharedInstance] theatersDataSource];
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
    return [self.theatersDataSource numberOfTheaters];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Theater *theater = [self.theatersDataSource theaterAtIndex: section];
    NSArray *movies = [[self.dataSource moviesAtTheatersDataSource] moviesForTheater:theater.theaterName inCity:theater.cityName];
    if( _debug ) {
        [theater print];
        NSLog(@"%@ has %d movies", theater.theaterName, [movies count]);
    }
    return [movies count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if( section == 0 )
        return 85;
    return 45;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    Theater *theater = [self.theatersDataSource theaterAtIndex: section];
    NSString *text = [NSString stringWithFormat:@"%@\n%@\n%@", theater.theaterName, theater.line1address, theater.cityName];
    return text;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                                   reuseIdentifier:CellIdentifier];
    
    Theater *theater = [self.theatersDataSource theaterAtIndex: [indexPath section]];
    NSArray *moviesAtTheaterAndCity = [[self.dataSource moviesAtTheatersDataSource] moviesForTheater:theater.theaterName inCity:theater.cityName];
    Movie *movie = [[self.dataSource moviesDataSource] movieWithTitle:[[moviesAtTheaterAndCity objectAtIndex:indexPath.row] movieName]];
    
    if( _debug )
        for( MovieAtTheater *mat in moviesAtTheaterAndCity )
            [mat print];
    
    cell.textLabel.text = [[moviesAtTheaterAndCity objectAtIndex:[indexPath row]] movieName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Rated: %@", movie.rating];
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
    Theater *theater = [self.theatersDataSource theaterAtIndex: [indexPath section]];
    NSArray *moviesAtTheaterAndCity = [[self.dataSource moviesAtTheatersDataSource] moviesForTheater:theater.theaterName inCity:theater.cityName];
    Movie *movie = [[self.dataSource moviesDataSource] movieWithTitle:[NSString stringWithFormat:@"%@", [[moviesAtTheaterAndCity objectAtIndex:[indexPath row]] movieName]]];
    DetailedMovieViewController *dc = [[DetailedMovieViewController alloc] initWithMovie: movie andTheater:theater];
    [self.navigationController pushViewController:dc animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
