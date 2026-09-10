#import <UIKit/UIKit.h>

%hook UIApplication
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL orig = %orig;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = nil;
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                window = scene.windows.firstObject;
                break;
            }
        }
        
        if (!window) {
            window = [UIApplication sharedApplication].windows.firstObject;
        }

        UIViewController *rootVC = window.rootViewController;
        if (!rootVC) return;

        while (rootVC.presentedViewController) {
            rootVC = rootVC.presentedViewController;
        }

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n\n\n\nWelcome to SRT STORE"
                                                                       message:@"Thank you for using our app! Select an option below to connect with us."
                                                                preferredStyle:UIAlertControllerStyleAlert];

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(110, 15, 55, 55)];
        
        NSURL *imageUrl = [NSURL URLWithString:@"https://cdn.phototourl.com/free/2026-09-10-771919a2-7ccc-4d7d-b574-c770b5a21c2f.jpg"];
        NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
        if (imageData) {
            imageView.image = [UIImage imageWithData:imageData];
        }
        
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.cornerRadius = 27.5;
        imageView.clipsToBounds = YES;
        [alert.view addSubview:imageView];

        UIAlertAction *telegramAction = [UIAlertAction actionWithTitle:@"Telegram Channel" 
                                                                 style:UIAlertActionStyleDefault 
                                                               handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/srt_ipa7"] 
                                               options:@{} 
                                     completionHandler:nil];
        }];

        UIAlertAction *developerAction = [UIAlertAction actionWithTitle:@"Developer Account" 
                                                                  style:UIAlertActionStyleDefault 
                                                                handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/evv2g"] 
                                               options:@{} 
                                     completionHandler:nil];
        }];

        UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"Close" 
                                                              style:UIAlertActionStyleCancel 
                                                            handler:nil];

        [alert addAction:telegramAction];
        [alert addAction:developerAction];
        [alert addAction:closeAction];

        [rootVC presentViewController:alert animated:YES completion:nil];
    });

    return orig;
}
%end
