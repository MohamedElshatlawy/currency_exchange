# X-Transfer - Currency Exchange App

A modern Flutter application for currency exchange with real-time rates, historical data visualization, and multi-language support.

## 📱 Screenshots

<div align="center">
  <img src="screenshots/Simulator Screenshot - iPhone 15 Pro Max - 2025-09-11 at 16.16.53.png" width="200" alt="Home Screen"/>
  <img src="screenshots/Simulator Screenshot - iPhone 15 Pro Max - 2025-09-11 at 16.17.48.png" width="200" alt="Currencies Screen"/>
  <img src="screenshots/Simulator Screenshot - iPhone 15 Pro Max - 2025-09-11 at 16.18.09.png" width="200" alt="Historical Data"/>
  <img src="screenshots/Simulator Screenshot - iPhone 15 Pro Max - 2025-09-11 at 16.18.21.png" width="200" alt="Transfer Screen"/>
</div>

## ✨ Features

- **Real-time Currency Exchange**: Get up-to-date exchange rates for multiple currencies
- **Historical Data Visualization**: View historical exchange rate trends with interactive charts
- **Currency Transfer**: Calculate and transfer amounts between different currencies
- **Multi-language Support**: Available in English and Arabic
- **Offline Support**: Cache data for offline usage
- **Clean Architecture**: Well-structured codebase following clean architecture principles
- **Responsive Design**: Optimized for different screen sizes
- **Modern UI**: Beautiful and intuitive user interface

## 🏗️ Architecture

This app follows **Clean Architecture** principles with the following layers:

- **Presentation Layer**: UI components, screens, and state management (BLoC/Cubit)
- **Domain Layer**: Business logic, entities, and use cases
- **Data Layer**: Data sources, repositories, and models

### Project Structure

```
lib/
├── core/                    # Core functionality and shared components
│   ├── base/               # Dependency injection and routing
│   ├── blocs/              # Generic BLoC components
│   ├── common/             # Shared constants, colors, fonts, themes
│   ├── components/         # Reusable UI components
│   └── util/               # Utilities, network, localization
├── scr/                    # Feature modules
│   ├── currencies/         # Currency listing and selection
│   ├── historical/         # Historical data and charts
│   ├── home/              # Home screen
│   ├── splash/            # Splash screen
│   └── transfer/          # Currency transfer functionality
└── main.dart              # App entry point
```

## 🛠️ Technologies & Dependencies

### Core Dependencies
- **Flutter SDK**: ^3.7.0
- **flutter_bloc**: ^9.1.1 - State management
- **get_it**: ^8.0.3 - Dependency injection
- **dio**: ^5.4.3+1 - HTTP client
- **flutter_screenutil**: ^5.9.3 - Responsive design

### UI & UX
- **auto_size_text**: ^3.0.0 - Responsive text
- **cached_network_image**: ^3.4.1 - Image caching
- **fl_chart**: ^0.68.0 - Charts and data visualization
- **pull_to_refresh**: ^2.0.0 - Pull to refresh functionality

### Data & Storage
- **sqflite**: ^2.3.0 - Local database
- **shared_preferences**: ^2.5.3 - Local preferences storage
- **fpdart**: ^1.1.1 - Functional programming utilities

### Localization & Internationalization
- **flutter_localizations**: SDK - Localization support
- **intl**: ^0.20.2 - Internationalization utilities

### Development & Testing
- **mockito**: ^5.4.4 - Mocking for tests
- **build_runner**: ^2.4.11 - Code generation
- **flutter_lints**: ^5.0.0 - Linting rules

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (^3.7.0)
- Dart SDK
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/MohamedElshatlawy/currency_exchange.git
   cd currency_exchange
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate necessary files**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 🌐 Supported Languages

- **English** (en_US)
- **Arabic** (ar_AE)

The app automatically detects the device language and switches accordingly. Users can also manually change the language from within the app.

## 📊 Features Overview

### Currency Exchange
- View exchange rates
- Support for multiple international currencies
- Quick currency conversion calculator

### Historical Data
- Interactive charts showing exchange rate trends
- Historical data visualization with fl_chart
- Date range selection for historical analysis

### Transfer Functionality
- Calculate transfer amounts between currencies
- Real-time rate updates
- Transfer history and tracking

### Offline Support
- Local caching with SQLite database
- Offline data access when network is unavailable
- Smart cache management and updates

## 🎨 Design System

The app uses a consistent design system with:

- **Custom Font**: Cairo font family with multiple weights
- **Responsive Design**: Adaptive layouts for different screen sizes
- **Theme Management**: Centralized theme configuration
- **Component Library**: Reusable UI components

## 🧪 Testing

Run tests using:

```bash
flutter test
```

The project includes:
- Unit tests for business logic
- Mock implementations for external dependencies


## 👨‍💻 Author

**Mohamed Elshatlawy**




