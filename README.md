# Speed Test

A Flutter application that allows users to measure their internet download and upload speeds and generate a PDF report of the results.

## Features

- **Minimalistic**: Simple and easy to use.
- **Real-time Speed Test**: Measure download and upload speeds using the `flutter_speed_test_plus` package.
- **Progress Tracking**: Visual feedback with a progress bar and percentage during the test.
- **PDF Export**: Generate and save/print a professional speed test report using `pdf` and `printing` packages.
- **Cancel Support**: Option to cancel the test while it is in progress.
- **Responsive UI**: Intuitive interface built with Flutter.

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK

### Installation

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/whybhav360/speed_test.git
    cd speed_test
    ```

2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Run the app**:
    ```bash
    flutter run
    ```

## Dependencies

This project uses the following packages:

- [flutter_speed_test_plus](https://pub.dev/packages/flutter_speed_test_plus): For internet speed testing.
- [pdf](https://pub.dev/packages/pdf): For creating PDF documents.
- [printing](https://pub.dev/packages/printing): For printing and layout of PDF files.
- [path_provider](https://pub.dev/packages/path_provider): For finding commonly used locations on the host file system.

## Usage

1.  Open the app.
2.  Tap the **"Start Speed Test"** button.
3.  Wait for the download and upload tests to complete.
4.  Once finished, you can see your results on the screen.
5.  Tap the **Floating Action Button (PDF icon)** at the bottom right to generate and save your report.

Made by Vaibhav Madaan 
[Github](https://github.com/whybhav360)
[LinkedIn](https://www.linkedin.com/in/vaibhav360/)

## Screenshot(s)

  <img width="234" src="https://github.com/user-attachments/assets/489d7d6a-0c00-4596-b51f-649b3b14fcb8" alt="Before" />
  <img width="234" src="https://github.com/user-attachments/assets/5ee68d90-5e5e-40ab-b61e-98094222b6e4" alt="After" />
  <img width="234" src="https://github.com/user-attachments/assets/c73f0941-e71d-4f4c-b2a4-e457b6750a3b" alt="SaveAsPDF" />


