//
//  Beacon.m
//  CustomPlugin
//
//  Created by Leo on 26/03/15.
//
//

#import "Beacon.h"

@interface Beacon()<GMBLPlaceManagerDelegate, GMBLCommunicationManagerDelegate,GMBLBeaconManagerDelegate,GMBLApplicationStatusDelegate>

@property (nonatomic) GMBLPlaceManager *placeManager;
@property (nonatomic) GMBLBeaconManager* beaconManager;
@property (nonatomic) GMBLCommunicationManager *communicationManager;

@end


@implementation Beacon

#pragma mark - Cordova Methods

- (void) open:(CDVInvokedUrlCommand*)command
{
    NSLog(@"");
}

- (void)initializeBeacon:(CDVInvokedUrlCommand*)command
{
    [self writeErrorLog:@"1"];
    [self registerNotifications];
    [self writeErrorLog:@"2"];

    [Gimbal setAPIKey:@"d1c5ea32-a1ee-405b-9bd8-88255ea574cc" options:nil];
    [self writeErrorLog:@"3"];

    self.beaconManager = [GMBLBeaconManager new];
    [self.beaconManager startListening];
    self.beaconManager.delegate = self;
    [self writeErrorLog:@"4"];

    self.placeManager = [GMBLPlaceManager new];
    self.placeManager.delegate = self;
    [self writeErrorLog:@"5"];

    self.communicationManager = [GMBLCommunicationManager new];
    self.communicationManager.delegate = self;
    [self writeErrorLog:@"6"];

    [GMBLPlaceManager startMonitoring];
    [GMBLCommunicationManager startReceivingCommunications];
    [self writeErrorLog:@"7"];

    //[self checkBluetoothStatus];
    //[self checkLocationServiceStatus];
}

# pragma mark - Custom Methods
- (void) registerNotifications{
    
    [self writeErrorLog:@"1.1"];

    if ([[UIApplication sharedApplication] respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    [self writeErrorLog:@"1.2"];

    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound
                                                                                                              categories:nil]];
    }
    [self writeErrorLog:@"1.3"];

}
- (void) checkBluetoothStatus{
    
    if ([GMBLApplicationStatus bluetoothStatus] == (GMBLBluetoothStatusAdminRestricted | GMBLBluetoothStatusPoweredOff)) {
        //Display alert
    }
}

- (void)checkLocationServiceStatus{
    if ([GMBLApplicationStatus locationStatus] == (GMBLLocationStatusAdminRestricted | GMBLLocationStatusNotAuthorizedAlways)) {
        //Display alert
    }
}

# pragma mark - Gimbal PlaceManager delegate methods

- (void)placeManager:(GMBLPlaceManager *)manager didBeginVisit:(GMBLVisit *)visit
{
    UILocalNotification * notification = [[UILocalNotification alloc] init];
    notification.alertBody = @"Welcome to the Photon World 2015 Conference";
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (void)placeManager:(GMBLPlaceManager *)manager didEndVisit:(GMBLVisit *)visit
{
    UILocalNotification * notification = [[UILocalNotification alloc] init];
    notification.alertBody = @"Thank you.";
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (void)beaconManager:(GMBLBeaconManager *)manager didReceiveBeaconSighting:(GMBLBeaconSighting *)sighting{
    
}

- (void)applicationStatus:(GMBLApplicationStatus *)applicationStatus didChangeLocationStatus:(GMBLLocationStatus)locationStatus{
    NSLog(@"");
}

- (void) writeErrorLog:(NSString *)error {
    
    NSString* documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileName = [documentsDirectory stringByAppendingPathComponent:@"ErrorLog.txt"];
    
    //Create new file if it doesn't exist
    if(![[NSFileManager defaultManager] fileExistsAtPath:fileName])
        [[NSFileManager defaultManager] createFileAtPath:fileName contents:nil attributes:nil];
    
    //Append error log to file
    NSFileHandle* file = [NSFileHandle fileHandleForUpdatingAtPath:fileName];
    [file seekToEndOfFile];
    [file writeData:[error dataUsingEncoding:NSUTF8StringEncoding]];
    [file closeFile];
}

@end

@implementation AppDelegate (Beacon)

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Information" message:notification.alertBody delegate:self cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil, nil];
    [alert show];
}



@end
