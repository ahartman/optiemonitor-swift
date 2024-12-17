//
//  OptieMonitorApp.swift
//  OptieMonitor
//
//  Created by André Hartman on 27/10/2020.
//

import SwiftUI

@main
struct OptieMonitorApp: App {
    @State private var viewModel = ViewModel()
    @Environment(\.scenePhase) var scenePhase

    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @State var notificationCenter = NotificationCenter()
    @State var localNotification = LocalNotification()

    init() {
        //let defaults = UserDefaults()
        //defaults.removeObject(forKey: "OptieMonitor")
        if let data = UserDefaults.standard.data(forKey: "OptieMonitor") {
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let savedData = try decoder.decode(
                    IncomingData.self, from: data)
                viewModel.unpackJSON(result: savedData)
            } catch {
                print("JSON error from UserDefaults:", error)
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            if viewModel.intraday.list.isEmpty {
                ContentUnavailableView(
                    "Nog geen gegevens beschikbaar",
                    systemImage: "icloud.and.arrow.down"
                )
            } else {
                if Ipad {
                    IPadView(viewModel: viewModel)
                        .environment(viewModel)
                } else {
                    TabView {
                        IntradayView(viewModel: viewModel)
                            .tabItem {
                                Image(systemName: "calendar.circle")
                                Text("Intraday")
                            }
                        InterdayView()
                            .tabItem {
                                Image(systemName: "calendar.circle.fill")
                                Text("Interday")
                            }
                        SettingsView(viewModel: viewModel)
                            .tabItem {
                                Image(systemName: "gear")
                                Text("Notificaties")
                            }
                    }
                    .environment(viewModel)
                }
            }
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active {
                Task { await viewModel.getJsonData(action: "currentOrder") }
            }
        }
    }
}

extension UIApplication {
    static var appVersion: String? {
        return Bundle.main.object(
            forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}

// implement AppDelegate
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication
            .LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        application.registerForRemoteNotifications()
        return true
    }

    // No callback in simulator -- must use device to get valid push token
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let deviceTokenString = deviceToken.reduce("") {
            $0 + String(format: "%02X", $1)
        }
        //print("Registering deviceTokenString: \(deviceTokenString)")
        let jsonObject: [String: String] = ["deviceToken": deviceTokenString]
        Task {
            await ViewModel().postJSONData(jsonObject, action: "apns")
        }
    }

    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print(
            "Failed to register for notifications: \(error.localizedDescription)"
        )
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print("Enter foreground")
    }
}

class NotificationCenter: NSObject, ObservableObject {
    var dumbData: UNNotificationResponse?

    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
}

extension NotificationCenter: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (
            UNNotificationPresentationOptions
        ) -> Void
    ) {}

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        dumbData = response
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        openSettingsFor notification: UNNotification?
    ) {}
}

class LocalNotification: ObservableObject {
    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [
            .alert, .sound,
        ]) { allowed, _ in
            // This callback does not trigger on main loop be careful
            print(
                allowed ? "Notifications allowed" : "Notifications not allowed")
        }
    }

    func setLocalNotification(
        title: String, subtitle: String, body: String, when: Double
    ) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: when, repeats: false)
        let request = UNNotificationRequest(
            identifier: "localNotification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(
            request, withCompletionHandler: nil)
    }
}
