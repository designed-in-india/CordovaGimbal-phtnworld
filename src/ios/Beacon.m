//
//  Beacon.m
//  CustomPlugin
//
//  Created by Leo on 26/03/15.
//
//

#import "Beacon.h"
#import <Gimbal/Gimbal.h>

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
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Info" message:@"Initialize" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    
    [self writeErrorLog:@"\n 1"];
    [self registerNotifications];
    [self writeErrorLog:@"\n 2"];

    [Gimbal setAPIKey:@"d1c5ea32-a1ee-405b-9bd8-88255ea574cc" options:nil];
    [self writeErrorLog:@"\n 3"];

    self.beaconManager = [GMBLBeaconManager new];
    [self.beaconManager startListening];
    self.beaconManager.delegate = self;
    [self writeErrorLog:@"\n 4"];

    self.placeManager = [GMBLPlaceManager new];
    self.placeManager.delegate = self;
    [self writeErrorLog:@"\n 5"];

    self.communicationManager = [GMBLCommunicationManager new];
    self.communicationManager.delegate = self;
    [self writeErrorLog:@"\n 6"];

    [GMBLPlaceManager startMonitoring];
    [GMBLCommunicationManager startReceivingCommunications];
    [self writeErrorLog:@"\n 7"];

    //[self checkBluetoothStatus];
    //[self checkLocationServiceStatus];
}

# pragma mark - Custom Methods
- (void) registerNotifications{
    
    [self writeErrorLog:@"\n 1.1"];

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
    [self writeErrorLog:@"\n 1.2"];

    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound
                                                                                                              categories:nil]];
    }
    [self writeErrorLog:@"\n 1.3"];

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

- (void) copyFileFromBundle:(CDVInvokedUrlCommand *)command{
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Info" message:@"Initialize" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    
    NSError* error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths firstObject];
    
    NSString *gimbalPath = [documentsDirectoryPath stringByAppendingPathComponent:@"/Gimbal"];

    
    if (![[NSFileManager defaultManager] fileExistsAtPath:gimbalPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:gimbalPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    NSString* gimbalFilePath = [NSString stringWithFormat:@"%@/application-properties.plist",gimbalPath];

    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:gimbalFilePath];
    
    if (!fileExists) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"application-properties" ofType:@"plist"];        
        if([[NSFileManager defaultManager] copyItemAtPath:path toPath:gimbalFilePath error:&error]){
            NSLog(@"Default file successfully copied over.");
        } else {
            NSLog(@"Error");
        }
        
    }
    
}

@end

@implementation AppDelegate (Beacon)

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Information" message:notification.alertBody delegate:self cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil, nil];
    [alert show];
}



@end
