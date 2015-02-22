//
//  ViewController.m
//  SoundFlash
//
//  Created by Bernard Xie on 2/21/15.
//  Copyright (c) 2015 Bernard Xie. All rights reserved.
//

#import "ViewController.h"
#import "PlaySongViewController.h"

//@import MediaPlayer;

@interface ViewController ()<MPMediaPickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *currentSongLabel;
@property MPMediaItem *chosenSong;



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
    
    

}


-(void)updateLabel: (NSString *) songTitle
{
    
    [ self.currentSongLabel setText:songTitle];
}




- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
  // Handle
  NSLog(@"cancelled");
  
  [self dismissViewControllerAnimated:YES completion:nil];

}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"nextViewSegue"] &&self.chosenSong !=nil)
    {
        // this passes the self.chosenSong to the next view controller.  Its destination is a list of view controllers, and since
        //the view controller with the id "nextViewSegue" is next, it will be the viewController objectAtIndex:0
        [[[[segue destinationViewController] viewControllers] objectAtIndex:0] setSelectedSong:self.chosenSong];
    }
}





@end
