//
//  ViewController.m
//  CanadianWeather
//
//  Created by Ronny Fenrich on 2014-06-30.
//  Copyright (c) 2014 Ronny Fenrich. All rights reserved.
//

#import "ViewController.h"
#import "WeatherDataController.h"


@interface ViewController ()
            
@property (strong, nonatomic) IBOutlet UIButton *getWeatherButton;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}



- (IBAction)getWeatherBtnTapped:(id)sender {

    self.getWeatherButton.hidden = YES;
    // get latest weather data, cache and forward to display view controller
    WeatherDataController *weatherDataController = [WeatherDataController sharedInstance];
    [weatherDataController refreshLocalDataWithForce:YES callback:^{

        dispatch_async(dispatch_get_main_queue(), ^{

            self.getWeatherButton.hidden = NO;
            if (weatherDataController.hasData) {
                [self performSegueWithIdentifier:@"segueShowWeatherData" sender:nil];
            }
        });



    }];

}

@end
