#import <UIKit/UIKit.h>

%hook UIWindow

- (void)makeKeyAndVisible {
    %orig;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n\n\nWelcome to SRT STORE"
                                                                           message:@"Thank you for using our app! Select an option below to connect with us."
                                                                    preferredStyle:UIAlertControllerStyleAlert];

            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(105, 12, 80, 80)];
            
            NSURL *imageUrl = [NSURL URLWithString:@"https://cdn.phototourl.com/free/2026-09-10-771919a2-7ccc-4d7d-b574-c770b5a21c2f.jpg"];
            NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
            if (imageData) {
                imageView.image = [UIImage imageWithData:imageData];
            }
            
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.layer.cornerRadius = 40;
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

            UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
            [window.rootViewController presentViewController:alert animated:YES completion:nil];
        });
    });
}

%end
