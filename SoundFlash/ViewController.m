//
//  ViewController.m
//  SoundFlash
//
//  Created by Bernard Xie on 2/21/15.
//  Copyright (c) 2015 Bernard Xie. All rights reserved.
//

#import "ViewController.h"

@import MediaPlayer;

@interface ViewController ()<MPMediaPickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *currentSongLabel;
@property MPMediaItem *chosenSong;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;


@end

@implementation ViewController

-(void) viewDidLoad{
    [super viewDidLoad];
    songArray= [[NSMutableArray alloc]init];
}

-(void) didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (IBAction)handleButtonClicked:(id)sender {
  MPMediaPickerController *mediaPickerController = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
  
  mediaPickerController.delegate = self;

  [self presentViewController:mediaPickerController animated:YES completion:nil];
}

#pragma mark - MPMediaPickerControllerDelegate

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
  // Handle

    
    //adds the song the user selected to the songArray
      MPMediaItem *song= [mediaItemCollection.items objectAtIndex:0];
    
     [songArray addObject:song];

    
    //get the last song(most recently added song in the array)
    MPMediaItem *selectedSong = [songArray objectAtIndex:songArray.count-1];
    
    NSString *songTitle= [selectedSong valueForProperty:MPMediaItemPropertyTitle];
    
    self.chosenSong = selectedSong;
  
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self updateLabel:songTitle];
    [self configureAudioPlayer];

    NSLog(@"should be playing music %@", songTitle);
    NSLog(@"%d", [self.audioPlayer play]);
}

- (void)configureAudioPlayer {
  NSURL *audioURL = self.chosenSong.assetURL;
  //Sets the url of the song to be played and initializes the audioplayer
  self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:nil];
  [_audioPlayer setNumberOfLoops:-1];
}

-(void)updateLabel: (NSString *) songTitle
{
    
    [ self.currentSongLabel setText:songTitle];
}

-(void) playSong:(NSString *)songTitle
{
   
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
  // Handle
  NSLog(@"cancelled");
  
  [self dismissViewControllerAnimated:YES completion:nil];
    
    
    
}

@end
