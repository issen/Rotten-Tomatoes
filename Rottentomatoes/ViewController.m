//
//  ViewController.m
//  Rottentomatoes
//
//  Created by Issen Su on 6/16/15.
//  Copyright (c) 2015 Issen Su. All rights reserved.
//

#import "ViewController.h"
#import <UIImageView+AFNetworking.h>
#import "MRProgress.h"
#import <MRProgress/MRProgressOverlayView+AFNetworking.h>


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (weak, nonatomic) IBOutlet UIView *networkErrorView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.networkErrorView setHidden:YES];
    //MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    
    [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];

    self.titleLabel.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"synopsis"];
    self.navigationBar.title = self.movie[@"title"];
    
    NSString *posterURLString = [self.movie valueForKeyPath:@"posters.detailed"];
    posterURLString = [self convertPosterUrlStringToHighRes:posterURLString];
    //[self.posterView setImageWithURL:[NSURL URLWithString:posterURLString]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:posterURLString]];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    [self.posterView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        NSLog(@"SUCCESS");
        self.posterView.alpha = 0.0;
        [UIView beginAnimations:@"fade in" context:nil];
        [UIView setAnimationDuration:1.0];
        self.posterView.alpha = 1.0;
        [UIView commitAnimations];
        self.posterView.image = image;
        [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        [self.networkErrorView setHidden:NO];
        [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
        NSLog(@"FAILURE");
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSString *) convertPosterUrlStringToHighRes:(NSString *)urlString {
    NSRange range = [urlString rangeOfString:@".*cloudfront.net/" options:NSRegularExpressionSearch];
    NSString *returnValue = urlString;
    if (range.length > 0) {
        returnValue = [urlString stringByReplacingCharactersInRange:range withString: @"https://content6.flixster.com/"];
    }
    
    return returnValue;
}

@end
