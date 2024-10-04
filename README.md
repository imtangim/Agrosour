# 🌱 Agrisour

<img src="assets/screenshot/empty_phone_screen_00017 copy.jpg" alt="Agrisour App" style="border-radius: 15px;">

## 📥 Download Agrisour App

<a href="https://raw.githubusercontent.com/imtangim/Agrisour/assets/app/app.apk" download style="display: inline-block; padding: 10px 20px; font-size: 16px; color: #fff; background-color: #007bff; text-align: center; text-decoration: none; border-radius: 5px; box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);">Download App</a>

**Agrisour** is an innovative mobile solution designed to assist farmers with precision agriculture by utilizing sensors, AI, and real-time data to optimize crop yield, soil health, and overall farming efficiency.

## 🚀 Features

- **User Profile**: Personalized profiles for farmers to track and manage their agricultural activities.
- **Google Authentication**: Secure sign-in using Google accounts.
- **Real-time Data Collection**: Collects real-time data from connected sensors, giving farmers up-to-the-minute insights on their land.
- **NPK Sensor Integration**: Real-time monitoring of nitrogen, phosphorus, and potassium levels.
- **Soil Moisture & Temperature Monitoring**: Access hourly data to optimize irrigation and soil conditions.
- **Flood Sensing**: Receive alerts when flood conditions are detected in your area.
- **AI-based Recommendations**: Get AI-driven suggestions to enhance crop health and yield.
- **Leaf Disease Detection**: Capture photos of leaves and get instant feedback on possible diseases.
- **Community**: Post, delete, and interact with other farmers in a community to share insights and best practices.
- **Post Creation, Deletion, and Interactivity**: Farmers can create posts, delete their content, and engage with the posts of others to foster a collaborative environment.
- **Weather Forecast**: Local weather forecasting for better decision-making.

## 🎥 Demo

[Agrisour App Demo <img src="assets/screenshot/empty_phone_screen_00017 copy.jpg" alt="Agrisour App" style="border-radius: 15px;">](https://www.youtube.com/watch?v=hz2hnEkhN9M)

Click the image above to watch a quick demo of the app in action.

## 📱 Screenshots

<img src="assets/screenshot/1.png" alt="Login" width="200" style="border-radius: 15px;"> <img src="assets/screenshot/2.png" style="border-radius: 15px;" alt="Dashboard" width="200"> <img src="assets/screenshot/3.png" alt="Sensor Data" width="200" style="border-radius: 15px;"> <img src="assets/screenshot/4.png" alt="Flood Monitoring" width="200" style="border-radius: 15px;"> <img src="assets/screenshot/5.png" alt="Community" width="200" style="border-radius: 15px;"> <img src="assets/screenshot/6.png" alt="Community" width="200" style="border-radius: 15px;"> <img src="assets/screenshot/7.png" alt="Profile" width="200" style="border-radius: 15px;"> <img src="assets/screenshot/8.png" alt="Community" width="200" style="border-radius: 15px;"> <img src="assets/screenshot/9.png" alt="Community" width="200" style="border-radius: 15px;"> <img src="assets/screenshot/10.png" alt="Result" width="200" style="border-radius: 15px;">

## 🛠️ Setup Instructions

To get started with the Agrisour App, follow these steps for the initial build:

### Prerequisites

Make sure you have the following installed:

- **Flutter SDK** (version 3.0 or higher)
- **Android Studio** or **VSCode** with Flutter/Dart extensions
- **Firebase account** with a configured project

### 1. Clone the Repository

```bash
git clone https://github.com/imtangim/Agrisour.git
cd Agrisour
```

### 2. Install Dependencies

Navigate to the project folder and install the required packages:

```bash
flutter pub get
```

### 3. Set Api key

Navigate to the project `lib/core/theme/keys.dart`:

```bash
class KeysForApi {
    static const String geminiKey =  "Your gemini key";
    static const String openWeatherKey = "You open weather api key";
}
```

### 4. Set Up Firebase

1. Visit [Firebase Console](https://console.firebase.google.com/), create a new project, and register your Android and iOS apps.
2. Create Project and add flutter app.

### 5. Set Up Google Authentication

1. In the [Firebase Console](https://console.firebase.google.com/), go to **Authentication** > **Sign-in method**.
2. Enable **Google** as a sign-in provider.
3. For Android:

   - Ensure that you have added the correct SHA-1 and SHA-256 keys in your Firebase project settings.
   - You can get the SHA keys using the following command (replace `path_to_keystore` and `alias_name` with your values):

   ```bash
   keytool -list -v -keystore path_to_keystore -alias alias_name -storepass your_password
   ```

4. For iOS:
   - Ensure that **reversed client ID** from the downloaded `GoogleService-Info.plist` is correctly set in your Xcode project under the URL schemes.

5. Download the `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS) and place them in the appropriate directories:
   - **For Android**: Place `google-services.json` in `android/app/`.
   - **For iOS**: Place `GoogleService-Info.plist` in `ios/Runner/`.

### 6. Run the App

For Android:

```bash
flutter run
```

For iOS:

```bash
flutter run --dart-define=FLUTTER_BUILD_MODE=debug
```

### 7. Configure NPK Sensor

- Ensure that your NPK sensor is properly connected and configured with the app. Refer to the documentation for sensor calibration.
  Here’s a nicely formatted schema for the real-time database that you can add to your Markdown file:

### 8. AI-Based Leaf Disease Detection

- Make sure to enable camera access to take pictures for disease detection.

### 9. Real-time Data Collection

- Set up and calibrate the sensors for collecting soil moisture, temperature, and flood conditions.

## 📊 Realtime Database Schema For Firebase Realtime Database

### Database URL

```
https://you-project.firebaseio.com/
```

### Schema Structure

```json

  "sensor_data": {
    "humidity": 0.6,
    "moisture": 0.8,
    "nitrogen": 110,
    "phosphorus": 130,
    "potassium": 110,
    "temperature": 30
  }

```

### Explanation of Fields

- **humidity**: The current humidity level measured in percentage (0.0 - 1.0).
- **moisture**: The soil moisture level measured in percentage (0.0 - 1.0).
- **nitrogen**: The nitrogen content in the soil (in mg/kg).
- **phosphorus**: The phosphorus content in the soil (in mg/kg).
- **potassium**: The potassium content in the soil (in mg/kg).
- **temperature**: The current temperature measured in degrees Celsius.

This schema captures the essential sensor data required for monitoring agricultural conditions, aiding farmers in making informed decisions.

## 🤝 Contributing

Contributions are welcome! If you’d like to collaborate, please fork the repository and create a pull request. Make sure to follow the contribution guidelines.

## 📧 Contact

For any inquiries, feel free to reach out:

- **Email**: tanjim437@gmail.com
- **GitHub**: [imtangim](https://github.com/imtangim)
