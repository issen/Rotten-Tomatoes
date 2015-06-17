//
//  ViewController.h
//  Rottentomatoes
//
//  Created by Issen Su on 6/16/15.
//  Copyright (c) 2015 Issen Su. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;

@property (strong, nonatomic) NSDictionary *movie;

@end

