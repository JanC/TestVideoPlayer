//
// Created by Jan on 13/08/14.
// Copyright (c) 2014 Fyber. All rights reserved.
//

#import "SPVideoPlayerController.h"

#define STRINGIFY(x) @#x


NSString *const SPVideoURLString = @"http://clips.vorwaerts-gmbh.de/VfE_html5.mp4";
@import MediaPlayer;


@interface SPVideoPlayerController ()
@property(nonatomic, strong) MPMoviePlayerController *player;
@end

@implementation SPVideoPlayerController {

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.player.scalingMode = MPMovieScalingModeAspectFill;

    [self.view addSubview:self.player.view];



    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerPlaybackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerPlaybackStateDidChange:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieLoadStateDidChange:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:nil];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.player.view.frame = self.view.bounds;
}


#pragma mark - Actions

- (IBAction)playAction:(id)sender
{
    self.player.contentURL = [NSURL URLWithString:SPVideoURLString];
    [self.player prepareToPlay];
    [self.player play];
}

- (IBAction)stopAction:(id)sender
{
    [self.player stop];
}

#pragma mark - Notifications


- (void)movieLoadStateDidChange:(id)movieLoadStateDidChange
{
    NSLog(@"Video Load changed to state %u", self.player.loadState);

}

- (void)moviePlayerPlaybackStateDidChange:(id)moviePlayerPlaybackStateDidChange
{
    NSLog(@"Movie playback changed to state %@", @(self.player.playbackState));

}

- (void)moviePlayerPlaybackDidFinish:(id)moviePlayerPlaybackDidFinish
{
    NSLog(@"self.player.playbackState %d", self.player.playbackState);
    MPMoviePlaybackState state = self.player.playbackState;
    NSLog(@"self.player.playbackState URL %@", self.player.contentURL);

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Finished" message:[self stateToString:state] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];;

}

#pragma mark - Helper

-(NSString *) stateToString:(MPMoviePlaybackState) state {
    NSString *stateString = @"";
    switch (state) {

        case MPMoviePlaybackStateStopped:
            stateString = STRINGIFY(MPMoviePlaybackStateStopped);
            break;
        case MPMoviePlaybackStatePlaying:
            stateString = STRINGIFY(MPMoviePlaybackStatePlaying);
            break;
        case MPMoviePlaybackStatePaused:
            stateString = STRINGIFY(MPMoviePlaybackStatePaused);
            break;
        case MPMoviePlaybackStateInterrupted:
            stateString = STRINGIFY(MPMoviePlaybackStateInterrupted);
            break;
        case MPMoviePlaybackStateSeekingForward:
            stateString = STRINGIFY(MPMoviePlaybackStateSeekingForward);
            break;
        case MPMoviePlaybackStateSeekingBackward:
            stateString = STRINGIFY(MPMoviePlaybackStateSeekingBackward);
            break;
    }
    return stateString;
}

@end