# Chess AI Overlay

Chess AI Overlay is a Flutter-based mobile application that helps you make better chess moves in real time. The app captures your game screen as you play, detects when you’ve made a move, analyzes the updated board state using AI (Stockfish), and overlays the next best move on your screen almost instantly.

> **Disclaimer:** This project is intended for educational and personal use. Be mindful of potential policy violations when using overlays with third-party chess apps.

## Table of Contents

- [Features](#features)
- [Architecture & Tech Stack](#architecture--tech-stack)
- [Installation and Setup](#installation-and-setup)
- [Usage](#usage)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [License](#license)

## Features

- **Real-Time Screen Capture:**  
  Captures your game screen continuously using a custom native plugin based on Android’s MediaProjection API.
  
- **Move Detection & Board Analysis:**  
  Detects when a move is made by analyzing live frames, processes the image to identify the chessboard and piece positions, and converts the board state to FEN (Forsyth-Edwards Notation).

- **AI-Powered Move Calculation:**  
  Feeds the current board state into the Stockfish engine (running locally or via a cloud API) to calculate the best move almost instantly.

- **Overlay UI:**  
  Displays the recommended move as an overlay on your active game screen with visual cues (arrows, highlighted squares).

- **Low Latency:**  
  Designed to detect moves and provide move suggestions with minimal delay for a seamless playing experience.

## Architecture & Tech Stack

### Tech Stack

- **Flutter:** Cross-platform mobile app development.
- **Custom Native Plugin (Android):**  
  Leverages Android’s MediaProjection API to capture live screen frames.
- **Image Processing:**  
  Uses libraries such as OpenCV (or similar) to recognize the chessboard and convert the state to FEN.
- **Chess Engine:**  
  Stockfish for analyzing board states and determining the optimal move.
- **Overlay UI:**  
  Built in Flutter with transparent overlays to display move suggestions.

### System Architecture

1. **Screen Capture Module:**  
   A custom native plugin (to be developed) that uses the MediaProjection API to capture your screen in real time.

2. **Frame Processing Module:**  
   Continuously extracts frames from the live stream and analyzes them to detect when a move is made.

3. **Board Recognition & FEN Conversion:**  
   Processes the extracted frames to identify the chessboard and determine the piece positions, converting the data into FEN notation.

4. **AI Move Calculation:**  
   Sends the FEN string to the Stockfish engine (either running locally on the device or via an API) to calculate the best move.

5. **Overlay Module:**  
   Displays the recommended move as an overlay on top of your game screen, ensuring minimal latency between move detection and suggestion.

## Installation and Setup

### Prerequisites

- **Flutter SDK:** Version 2.10 or later.
- **Android Device:** Running Android 5.0+ (MediaProjection API is required).
- **Development Environment:** Android Studio or VS Code with Flutter support.
- **Custom Plugin Development:** You may need to build a custom native plugin if an appropriate package isn’t available on pub.dev.

### Getting Started

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/dukeazeta/chess_ai_overlay.git
   cd chess_ai_overlay
