
import UIKit
import UserNotifications
import YandexMapsMobile

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]

        window = UIWindow(frame: UIScreen.main.bounds)

        UNUserNotificationCenter.current().requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }

        YMKMapKit.setApiKey("1c92f6ba-56f7-491a-a16a-935ddf7fcc79")
        YMKMapKit.sharedInstance().onStart()
   
        configureUserNotifications()

        if Session.shared.isFirstLaunch() {
            let navigationController = UINavigationController()
            window?.rootViewController = navigationController

            let router = OnboardingRouter(navigationController: navigationController)
            router.start()
        } else {
            let router = TabBarRouter(window: window)
            router.start()
        }

        window?.makeKeyAndVisible()
        return true
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void
  ) {
      if #available(iOS 14.0, *) {
          completionHandler(.banner)
      } else {
          // Fallback on earlier versions
      }
  }

    private func configureUserNotifications() {
      UNUserNotificationCenter.current().delegate = self
    }
}

