
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
@property ( nonatomic, retain) AVAudioPlayer *audioPlayer;
@property(nonatomic, retain) NSThread* evtThread;


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
    
    
      NSURL *songURL= [self.selectedSong valueForProperty:MPMediaItemPropertyAssetURL];
    
    
    
    
    
    [self playSong:songURL];
    
    self.evtThread = [ [NSThread alloc] initWithTarget:self
                                                   selector:@selector(update)
                                                     object:nil ];
    
    [self.evtThread start];
    NSLog(@"Thread created");
    
}

- (void) update {
    //while the song is playing
    NSLog(@"Entering thread");
    int previousPower=0;
    int currentLevel=1;
    
    while (true){
        if(_audioPlayer.playing)
        {
            [NSThread sleepForTimeInterval:1.25];
            
            _audioPlayer.meteringEnabled = YES;
            // Sets it so that the meters update
            [_audioPlayer updateMeters];
            
            // Calculates the power level
            float power = 0.0f;
            
            power= [_audioPlayer averagePowerForChannel:0];
            
            
            // power /= [_audioPlayer numberOfChannels];
            power = 120+power;
            
            
            float currentPower= roundf(power*100.0f)/ 100.0f;
            
            
            
            
            float diffPower= currentPower-previousPower;
            
            
            if(diffPower<= -2 &&diffPower > -3)
            {
                currentLevel = currentLevel-1;
            }
            else if(diffPower <=-3 && diffPower >-4)
            {
                currentLevel = currentLevel-2;
            }
            else if(diffPower <=-4 && diffPower >-5)
            {
                currentLevel = currentLevel-3;
            }
            else if(diffPower <=-5 && diffPower >-6)
            {
                currentLevel = currentLevel-4;
            }
            else if(diffPower <=-6 && diffPower >-7)
            {
                currentLevel = currentLevel-5;
            }
            else if(diffPower <= -7 && diffPower > -30)
            {
                currentLevel = currentLevel-6;
            }
            
            
            
            if(diffPower >=2 && diffPower <3)
            {
                currentLevel =currentLevel+1;
            }
            else if(diffPower>=3  && diffPower<4)
            {
                currentLevel =currentLevel+2;
            }
            else if(diffPower>=4 &&diffPower <5)
            {
                currentLevel =currentLevel+3;
            }
            else if(diffPower>=5 &&diffPower <6)
            {
                currentLevel =currentLevel+4;
            }
            else if(diffPower>=6 &&diffPower <7)
            {
                currentLevel =currentLevel+5;
            }
            
            //initial spike is about 100, so shouldn't change colors
            else if(diffPower>=7 &&diffPower <30)
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
        else
        {
            break;
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

}

-(void) playSong:(NSURL *) songURL
{
    
    
    
    //can't declare AVPlayer here as a local variable because when you call player play
    //the method then ends and does not keep going.  So make it a property because
    //when the method ends, the player will still keep on going
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:songURL error:nil];
    [self.audioPlayer play];
    
}



- (IBAction)doneButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.evtThread cancel];
    //uncomment if you want song to stop playing when they go back to the Selct Music Menu.  with this commented, will play songs on
    //top of each other if you press back and select a new song
    [self.audioPlayer stop];
}



-(void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}









@end

