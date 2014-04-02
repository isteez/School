//
//  CitiesDetailTableViewController.m
//  CS470_Project4
//
//  Created by Stephen Kyles on 3/25/14.
//  Copyright (c) 2014 Stephen Kyles. All rights reserved.
//

#import "CitiesDetailTableViewController.h"
#import "MoviesAtTheatersDataSource.h"
#import "MovieAtTheater.h"
#import "SchemaDataSource.h"
#import "DetailedMovieViewController.h"

@interface CitiesDetailTableViewController ()
@property(nonatomic) Theater *theater;
@property(nonatomic) SchemaDataSource *dataSource;
@end

static BOOL _debug = NO;
static NSString *CellIdentifier = @"Cell";

@implementation CitiesDetailTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(instancetype) initWithTheater: (Theater *) theater
{
    if( (self = [super init]) == nil )
        return nil;
    
    self.theater = theater;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.theater.theaterName;
    self.dataSource = [SchemaDataSource sharedInstance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *movies = [[self.dataSource moviesAtTheatersDataSource] moviesForTheater:self.theater.theaterName inCity:self.theater.cityName];
    
    if( _debug ) {
        [self.theater print];
        NSLog(@"%@ has %d movies", self.theater.theaterName, [movies count]);
    }
    return [movies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    NSArray *movies = [[self.dataSource moviesAtTheatersDataSource] moviesForTheater:self.theater.theaterName inCity:self.theater.cityName];
    Movie *movie = [[self.dataSource moviesDataSource] movieWithTitle:[[movies objectAtIndex:indexPath.row] movieName]];
    cell.textLabel.text = [[movies objectAtIndex:[indexPath row]] movieName];
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
    NSArray *movies = [[self.dataSource moviesAtTheatersDataSource] moviesForTheater:self.theater.theaterName inCity:self.theater.cityName];
    Movie *movie = [[self.dataSource moviesDataSource] movieWithTitle:[[movies objectAtIndex:indexPath.row] movieName]];
    DetailedMovieViewController *dc = [[DetailedMovieViewController alloc] initWithMovie:movie andTheater:self.theater];
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
