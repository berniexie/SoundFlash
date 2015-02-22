//
//  PlaySongViewController.m
//  SoundFlash
//
//  Created by Alex Koh on 2/22/15.
//  Copyright (c) 2015 Bernard Xie. All rights reserved.
//

#import "PlaySongViewController.h"

@interface PlaySongViewController()

@property (weak, nonatomic) IBOutlet UILabel *currentPlayingSongLabel;

@end

@implementation PlaySongViewController


-(void) viewDidLoad{
    [super viewDidLoad];
    NSString *songTitle= [self.selectedSong valueForProperty:MPMediaItemPropertyTitle];
    
    NSLog(@"songy %@" ,self.selectedSong);
   NSString *nowPlaying= @"Now Playing: ";
    NSMutableString *displayString= [[NSMutableString alloc]initWithString:nowPlaying];
    [displayString appendString:songTitle];

    [self.currentPlayingSongLabel setText:displayString];
    
}

-(void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)doneButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
};





@end

