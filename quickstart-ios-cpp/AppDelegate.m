#import "AppDelegate.h"
#import "BanubaSdkManager.h"
#import "BanubaClientToken.h"
#import <OpenGLES/EAGL.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    let mainBundle = [NSBundle mainBundle].bundlePath;
    let bnbRes = [NSString stringWithFormat:@"%@/%@",
                                            mainBundle,
                                            @"bnb-resources"];
    let bnbEffects = [NSString stringWithFormat:@"%@/%@",
                                             mainBundle,
                                            @"/effects"];

    BanubaSdkManager_initialize(
        (const char*[]){
            bnbRes.UTF8String /* this is sdk resources */,
            bnbEffects.UTF8String /*this is for effects*/,
            NULL},
        BNB_CLIENT_TOKEN);

    return YES;
}

- (void)applicationWillTerminate:(UIApplication*)application
{
    // It also possible to free SDK resources somewhere in app:
    // BanubaSdkManager_deinitialize();
}

@end
