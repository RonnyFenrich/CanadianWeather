//
//  TodayViewController.m
//  CanadianWeatherTodayExtension
//
//  Created by Ronny Fenrich on 2014-09-19.
//  Copyright (c) 2014 Ronny Fenrich. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "CanadianWeatherCommon.h"


@interface TodayViewController () <NCWidgetProviding>

@property (strong, nonatomic) IBOutlet UILabel *station;
@property (strong, nonatomic) IBOutlet UILabel *currentUpdateTime;

@property (strong, nonatomic) IBOutlet UIImageView *currentConditionImage;
@property (strong, nonatomic) IBOutlet UILabel *currentTemp;

@property (strong, nonatomic) IBOutlet UILabel *currentCondition;
@property (strong, nonatomic) IBOutlet UILabel *currentPressure;
@property (strong, nonatomic) IBOutlet UILabel *currentVisibility;
@property (strong, nonatomic) IBOutlet UILabel *currentWind;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    [self refreshWidgetUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {

    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    WeatherDataController *weatherDataController = [WeatherDataController sharedInstance];
    [weatherDataController refreshLocalDataWithForce:YES callback:^{

        [self refreshWidgetUI];
        completionHandler(NCUpdateResultNewData);
    }];

}

- (void)refreshWidgetUI {

    WeatherDataController *weatherDataController = [WeatherDataController sharedInstance];
    if (weatherDataController.hasData) {
        dispatch_async(dispatch_get_main_queue(), ^{

            WeatherData *cwd = weatherDataController.currentWeatherData;
            self.station.text = cwd.current.stationName;
            self.currentUpdateTime.text = cwd.current.observationTime;

            self.currentTemp.text = cwd.current.temperature.description;

            self.currentCondition.text = cwd.current.condition;
            self.currentPressure.text = cwd.current.pressure.description;
            self.currentVisibility.text = cwd.current.visibility.description;
            self.currentWind.text = cwd.current.windSpeed.description;
        });

    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.station.text = @"";
            self.currentUpdateTime.text = @"";

            self.currentTemp.text = @"";

            self.currentCondition.text = @"";
            self.currentPressure.text = @"";
            self.currentVisibility.text = @"";
            self.currentWind.text = @"";
        });

    }

}


- (IBAction)startHostApp:(id)sender {
    [self.extensionContext openURL:[NSURL URLWithString:@"CanadianWeather://"] completionHandler:nil];
}


@end