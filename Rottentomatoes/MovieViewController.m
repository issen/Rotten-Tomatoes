//
//  MovieViewController.m
//  Rottentomatoes
//
//  Created by Issen Su on 6/16/15.
//  Copyright (c) 2015 Issen Su. All rights reserved.
//

#import "MovieViewController.h"
#import "MovieCell.h"
#import <UIImageView+AFNetworking.h>
#import "ViewController.h"
#import "MRProgress.h"

@interface MovieViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (strong, nonatomic) NSArray *movies;

@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // already define in story board
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MyMovieCell"];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
  
    [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    [self loadMovieData];
    
//    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=ws32mxpd653h5c8zqfvksxw9&limit=20&country=us";
    
//    [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//        //NSLog(@"%@", object);
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//        self.movies = dict[@"movies"];
//        [self.tableView reloadData];
//        //NSDictionary *firstMovie = movies[0];
//        //NSLog(@"%@", firstMovie);
//        [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:YES];
//    }];
    
}

- (void)onRefresh {
    [self loadMovieData];
}

- (void) loadMovieData {
     NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=ws32mxpd653h5c8zqfvksxw9&limit=20&country=us";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        //NSLog(@"%@", object);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        self.movies = dict[@"movies"];
        [self.tableView reloadData];
        //NSDictionary *firstMovie = movies[0];
        //NSLog(@"%@", firstMovie);
        [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:YES];
        [self.refreshControl endRefreshing];
    }];   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    // reuseable cell
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyMovieCell" forIndexPath:indexPath];
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyMovieCell" forIndexPath:indexPath];
    NSDictionary *movie = self.movies[indexPath.row];
    NSString *title = movie[@"title"];
    cell.titleLabel.text = title;
    cell.synopsisLabel.text = movie[@"synopsis"];
    NSLog(@"%@", movie);
    
    NSString *posterURLString = [movie valueForKeyPath:@"posters.thumbnail"];
    NSLog(@"%@", posterURLString);
    [cell.posterView setImageWithURL:[NSURL URLWithString:posterURLString]];
    //cell.textLabel.text = [NSString stringWithFormat:@"Row %ld", (long)indexPath.row];
    //NSLog(@"Row %ld", (long)indexPath.row);
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    MovieCell *cell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *movie = self.movies[indexPath.row];
    ViewController *destinationVC = segue.destinationViewController;
    
    destinationVC.movie = movie;
    
}


@end
