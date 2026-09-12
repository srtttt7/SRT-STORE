#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface SRTWebViewController : UIViewController
@end

@implementation SRTWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.07 green:0.09 blue:0.15 alpha:1.0];

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:scrollView];

    UIView *contentView = [[UIView alloc] initWithFrame:scrollView.bounds];
    [scrollView addSubview:contentView];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 110) / 2, 40, 110, 110)];
    NSURL *imageUrl = [NSURL URLWithString:@"https://cdn.phototourl.com/free/2026-09-10-771919a2-7ccc-4d7d-b574-c770b5a21c2f.jpg"];
    NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
    if (imageData) {
        imageView.image = [UIImage imageWithData:imageData];
    }
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.cornerRadius = 55;
    imageView.layer.borderWidth = 2.0;
    imageView.layer.borderColor = [UIColor colorWithRed:0.6 green:0.2 blue:0.5 alpha:1.0].CGColor;
    imageView.clipsToBounds = YES;
    [contentView addSubview:imageView];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 165, self.view.bounds.size.width - 40, 35)];
    titleLabel.text = @"SRT STORE";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:24];
    [contentView addSubview:titleLabel];

    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 205, self.view.bounds.size.width - 40, 60)];
    descLabel.text = @"جميع الحقوق محفوظة © 2026\nتطوير: SRT STORE\nالنشر وإعادة الرفع ممنوعة";
    descLabel.textColor = [UIColor lightGrayColor];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.font = [UIFont systemFontOfSize:13];
    descLabel.numberOfLines = 3;
    [contentView addSubview:descLabel];

    CGFloat startY = 285;
    CGFloat buttonWidth = self.view.bounds.size.width - 60;
    CGFloat buttonHeight = 50;
    CGFloat spacing = 15;

    NSArray *buttonsData = @[
        @{@"title": @"قناة التليجرام | Telegram Channel", @"url": @"https://t.me/srt_ipa7"},
        @{@"title": @"مجموعة النقاشات | Discussion Group", @"url": @"https://t.me/srt_ipa7"},
        @{@"title": @"حساب المطور | Developer Account", @"url": @"https://t.me/evv2g"},
        @{@"title": @"إغلاق | Close", @"action": @"close"}
    ];

    for (int i = 0; i < buttonsData.count; i++) {
        NSDictionary *data = buttonsData[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(30, startY + (i * (buttonHeight + spacing)), buttonWidth, buttonHeight);
        [btn setTitle:data[@"title"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        btn.backgroundColor = [UIColor colorWithRed:0.35 green:0.12 blue:0.35 alpha:1.0];
        btn.layer.cornerRadius = 12;
        btn.layer.borderWidth = 1.0;
        btn.layer.borderColor = [UIColor colorWithRed:0.55 green:0.2 blue:0.55 alpha:1.0].CGColor;
        
        if (data[@"url"]) {
            [btn addTarget:self action:@selector(openLink:) forControlEvents:UIControlEventTouchUpInside];
            objc_setAssociatedObject(btn, "targetURL", data[@"url"], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        } else {
            [btn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [contentView addSubview:btn];
    }

    UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, startY + (buttonsData.count * (buttonHeight + spacing)) + 10, self.view.bounds.size.width - 40, 40)];
    footerLabel.text = @"تم فتح مميزات بواسطة المطور\nSRT STORE";
    footerLabel.textColor = [UIColor lightGrayColor];
    footerLabel.textAlignment = NSTextAlignmentCenter;
    footerLabel.font = [UIFont systemFontOfSize:12];
    footerLabel.numberOfLines = 2;
    [contentView addSubview:footerLabel];

    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, startY + (buttonsData.count * (buttonHeight + spacing)) + 70);
}

- (void)openLink:(UIButton *)sender {
    NSString *urlString = objc_getAssociatedObject(sender, "targetURL");
    if (urlString) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
    }
}

- (void)closeView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

%hook UIWindow

- (void)makeKeyAndVisible {
    %orig;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
            UIViewController *rootVC = window.rootViewController;
            while (rootVC.presentedViewController) {
                rootVC = rootVC.presentedViewController;
            }
            
            SRTWebViewController *webVC = [[SRTWebViewController alloc] init];
            webVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [rootVC presentViewController:webVC animated:YES completion:nil];
        });
    });
}

%end
