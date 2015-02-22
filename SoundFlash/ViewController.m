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
@property ( nonatomic, retain) AVAudioPlayer *audioPlayer;


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
    NSURL *songURL= [selectedSong valueForProperty:MPMediaItemPropertyAssetURL];
    
    self.chosenSong = selectedSong;
  



    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self updateLabel:songTitle];
     [self playSong:songURL];
    
    NSThread* evtThread = [ [NSThread alloc] initWithTarget:self
                                                   selector:@selector(update)
                                                     object:nil ];
    
    [evtThread start];
    NSLog(@"Thread created");

}

- (void) update {
    //while the song is playing
    NSLog(@"Entering thread");
    int previousPower=0;
    int currentLevel=1;
    while (true){
      if(_audioPlayer.playing){
        [NSThread sleepForTimeInterval:1.25];
        _audioPlayer.meteringEnabled = YES;
        // Sets it so that the meters update
        [_audioPlayer updateMeters];
        
        // Calculates the power level
        float power = 0.0f;
       /* for (int i = 0; i < [_audioPlayer numberOfChannels]; i++) {
           
           NSLog(@"power at chanel %d for power %f", i, [_audioPlayer peakPowerForChannel:i]);
          power += [_audioPlayer peakPowerForChannel:i];
           
        }*/
          
          power= [_audioPlayer averagePowerForChannel:0];
          
          
       // power /= [_audioPlayer numberOfChannels];
        power = 120+power;
         
     
          float currentPower= roundf(power*100.0f)/ 100.0f;
          
          
          
          
          float diffPower= currentPower-previousPower;
          
          
          if(diffPower<= -3 &&diffPower > -4)
          {
              currentLevel = currentLevel-1;
          }
          else if(diffPower <=-4 && diffPower >-5)
          {
              currentLevel = currentLevel-2;
          }
          else if(diffPower <=-5 && diffPower >-6)
          {
              currentLevel = currentLevel-3;
          }
          else if(diffPower <=-6 && diffPower >-7)
          {
              currentLevel = currentLevel-4;
          }
          else if(diffPower <=-7 && diffPower >-8)
          {
              currentLevel = currentLevel-5;
          }
          else if(diffPower <= -8 && diffPower > -30)
          {
              currentLevel = currentLevel-6;
          }
          
          
          
          if(diffPower >=3 && diffPower <4)
          {
              currentLevel =currentLevel+1;
          }
          else if(diffPower>=4  && diffPower<5)
          {
              currentLevel =currentLevel+2;
          }
          else if(diffPower>=5 &&diffPower <6)
          {
              currentLevel =currentLevel+3;
          }
          else if(diffPower>=6 &&diffPower <7)
          {
              currentLevel =currentLevel+4;
          }
          else if(diffPower>=7 &&diffPower <8)
          {
              currentLevel =currentLevel+5;
          }
          
          //initial spike is about 100, so shouldn't change colors
          else if(diffPower>=8 &&diffPower <30)
          {
              currentLevel =currentLevel+6;
          }
          
          if(currentLevel <1)
          {
              currentLevel=1;
          }
          if(currentLevel >7)
          {
              currentLevel=7;
          }
          


          
          //puts it back on the main queue thread so you can update UIView
          dispatch_async(dispatch_get_main_queue(), ^ {  [self updateBackgoundColor:previousPower:currentPower:currentLevel]; });
          
          
          

          
          //currentPower for this iteration will be previousPower for the next Iteration
          previousPower= currentPower;
          
          //[self updatePowerArray:currentPower];
     
          
      }
    }
}

-(void)updateBackgoundColor:(float)previousPower :(float)currentPower :(int) currentLevel
{
    
     if(currentLevel==1)
     {
         [self.view setBackgroundColor:[UIColor blackColor]];
         NSLog(@"Enter level 1");
     }
     else if(currentLevel==2)
     {
     
         [self.view setBackgroundColor:[UIColor purpleColor]];
         NSLog(@"Enter level 2");
     
     }
     else if(currentLevel==3)
     {
         [self.view setBackgroundColor:[UIColor blueColor]];
         NSLog(@"Enter level 3");
     }
     else if(currentLevel==4)
     {
     
         [self.view setBackgroundColor:[UIColor greenColor]];
         NSLog(@"Enter level 4");
     }
     else if(currentLevel==5)
     {
         [self.view setBackgroundColor:[UIColor yellowColor]];
         NSLog(@"Enter level 5");
     }
     else if(currentLevel==6)
     {
         
         [self.view setBackgroundColor:[UIColor orangeColor]];
         NSLog(@"Enter level 6");
     
     }
     else
     {
         NSLog(@"Enter level 7");
         [self.view setBackgroundColor:[UIColor redColor]];
     }

    
 
    
    
    //  NSLog(@"Diff Power: %f", diffPower);
    
    
    /*if(roundedPower <100)
    {
        [self.view setBackgroundColor:[UIColor blackColor]];
        NSLog(@"Enter level 1");
    }
    else if(roundedPower >=100 && roundedPower<103)
    {

        [self.view setBackgroundColor:[UIColor purpleColor]];
               NSLog(@"Enter level 2");
 
    }
    else if(roundedPower >=103 && roundedPower <106)
    {
        [self.view setBackgroundColor:[UIColor blueColor]];
               NSLog(@"Enter level 3");
    }
    else if(roundedPower >=106 && roundedPower<109)
    {

        [self.view setBackgroundColor:[UIColor greenColor]];
               NSLog(@"Enter level 4");
    }
    else if(roundedPower>= 109 && roundedPower<112)
    {
        [self.view setBackgroundColor:[UIColor yellowColor]];
        NSLog(@"Enter level 5");
    }
    else if(roundedPower >=112 && roundedPower <115)
    {

        [self.view setBackgroundColor:[UIColor orangeColor]];
               NSLog(@"Enter level 6");

    }
    else
    {
         NSLog(@"Enter level 7");
        [self.view setBackgroundColor:[UIColor redColor]];
    }*/
}

/*
- (void)configureAudioPlayer {
    NSURL *audioURL = [self.chosenSong valueForProperty:MPMediaItemPropertyAssetURL];
    //Sets the url of the song to be played and initializes the audioplayer
  self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:nil];
  [_audioPlayer setNumberOfLoops:1];
}*/

-(void)updateLabel: (NSString *) songTitle
{
    
    [ self.currentSongLabel setText:songTitle];
}

-(void)updatePowerArray:(float)roundedPower
{
    
}

-(void) playSong:(NSURL *) songURL
{
  
  
    
    //can't declare AVPlayer here as a local variable because when you call player play
    //the method then ends and does not keep going.  So make it a property because
    //when the method ends, the player will still keep on going
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:songURL error:nil];
    [self.audioPlayer play];
    
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
  // Handle
  NSLog(@"cancelled");
  
  [self dismissViewControllerAnimated:YES completion:nil];
    
    
    
}

@end
