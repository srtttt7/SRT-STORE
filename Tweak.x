#import <UIKit/UIKit.h>

%hook UIApplication
- (void)applicationDidFinishLaunching:(id)application {
    %orig;

    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n\n\nWelcome to SRT STORE"
                                                                       message:@"Thank you for using our app! Select an option below to connect with us."
                                                                preferredStyle:UIAlertControllerStyleAlert];

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(105, 15, 60, 60)];
        NSString *base64Image = @"iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA1JJREFUeNrs21Fok1UYACD/N3eubUvXmku2zC1m1IggKIoIGUUp4otBfRBEfRBEfRBE+hA+BPUhIn0QxBdBfRDEBy/6Iog+SIsgKCgy3Tbd3Oa2uf9u+3/vEnZmttza5lsH5zvfe/fO/53vO9933ve9f2s4HAbm4Xw/P9I4/wA8xQ/4o/I24A00/SRY/I0";
        
        imageView.image = [UIImage imageWithData:[[NSData alloc] initWithBase64EncodedString:base64Image options:0]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.layer.cornerRadius = 10;
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
}
%end
