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

@end

@implementation ViewController

- (IBAction)handleButtonClicked:(id)sender {
  MPMediaPickerController *mediaPickerController = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
  
  mediaPickerController.delegate = self;

  [self presentViewController:mediaPickerController animated:YES completion:nil];
}

#pragma mark - MPMediaPickerControllerDelegate

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
  // Handle
  NSLog(@"%@", mediaItemCollection);
  
  for (MPMediaItem *mediaItem in mediaItemCollection.items) {
    NSLog(@"%@", mediaItem.assetURL);
  }
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
  // Handle
  NSLog(@"cancelled");
  
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
