<h1 align="center">DisasterReliefAid</h1>

<div style="display:flex;align-items:center;justify-content:center;">

<!-- [![GitHub branches](https://badgen.net/github/branches/JohnRamberger/DisasterReliefAid-JIB-2320)](https://github.com/JohnRamberger/DisasterReliefAid-JIB-2320) -->

[![GitHub release](https://img.shields.io/github/release/JohnRamberger/DisasterReliefAid-JIB-2320)](https://GitHub.com/JohnRamberger/DisasterReliefAid-JIB-2320/releases)

<!-- [![Checks](https://badgen.net/github/checks/JohnRamberger/DisasterReliefAid-JIB-2320)](https://GitHub.com/JohnRamberger/DisasterReliefAid-JIB-2320)
[![Pull Requests](https://badgen.net/github/prs/JohnRamberger/DisasterReliefAid-JIB-2320)](https://GitHub.com/JohnRamberger/DisasterReliefAid-JIB-2320) -->

</div>

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Description](#description)
- [Team](#team)
- [Installation Instructions](#installation-instructions)
  - [Prerequisites](#prerequisites)
  - [Installation Guide](#installation-guide)
- [Release Notes](#release-notes)
  - [Features](#features)
  - [Bug Fixes](#bug-fixes)
  - [Known Issues](#known-issues)
  - [Future Implementations](#future-implementations)

## Description

Our project aims to decrease the chaos that occurs in the case of disasters by increasing the preparedness of users and making the recovery process more efficient. Currently, when a natural disaster occurs, those who need help flood local authority call lines resulting in a long queue to be helped. We plan to make an app that can help solve this problem.

Our app will have 3 user types: the base user (or victim), volunteers, and control admins. In the case of a natural disaster, our app will match volunteers with victims in order to more efficiently help out those in need. Control admins will monitor the overall situation. You can think of this app as uber eats/doordash but instead of picking up food, the volunteers are picking up those who need help.

We will be making our app using Flutter, and the backend for our app will be made using Firebase and Google Cloud Platform.

## Team

| Name              | Email                  | Phone          | Github                                                  |
| ----------------- | ---------------------- | -------------- | ------------------------------------------------------- |
| John Ramberger    | jramberger3@gatech.edu | (470) 297-9440 | [JohnRamberger](https://github.com/JohnRamberger)       |
| Hargopal Choudhry | hchoudhry6@gatech.edu  | (470) 350-9017 | [Hchoudhry15](https://github.com/Hchoudhry15)           |
| Kume Agidi        | kagidi6@gatech.edu     | (678) 650-2871 | [kumeagidi](https://github.com/kumeagidi)               |
| Jamal Faqeeri     | jfaqeeri3@gatech.edu   | (404) 709-6385 | [kozyjamal](https://github.com/kozyjamal)               |
| Max Ho            | mho61@gatech.edu       | (925) 309-9352 | [acoustic-git-tar](https://github.com/acoustic-git-tar) |
| Medhana Kadiyala  | mkadiyala7@gatech.edu  | (470) 509-2394 | [medhanak](https://github.com/medhanak)                 |

## Installation Instructions

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install)
- [Android Studio](https://developer.android.com/studio) or [Visual Studio Code](https://code.visualstudio.com/download)
- [Android SDK](https://developer.android.com/studio#downloads) (if using or building for Android)
- An Emulator or a Physical Device
  - [Android Emulator](https://developer.android.com/studio/run/emulator)
  - [iOS Emulator](https://developer.apple.com/documentation/xcode/running_your_app_in_the_simulator_or_on_a_device)
  - [Physical Device (Android)](https://developer.android.com/studio/run/device)
  - [Physical Device (iOS)](https://developer.apple.com/documentation/xcode/running_your_app_in_the_simulator_or_on_a_device)
  - [Google Chrome](https://www.google.com/chrome/) (for fast development)

### Installation Guide

Please view the [Installation Guide](./installation.md) for more information on how to do the following:

- Install Flutter
- Run the app in debug mode
- Build the app for release
- Deploy the app to devices
- Common issues


## Release Notes

### Features

- Custom Sign Up
  - Can sign up as a user or volunteer
  - Can select Language and any Vulnerabilities they may have
- Different User Types
  - User
    - Can create help requests
    - Receive updates in real time
    - View how far away the volunteer is
  - Volunteer
    - Respond to help requests from users
    - Receive updates in real time
    - Can accept/decline help requests
  - Control Admin
    - Disable User/Volunteer accounts as needed
- Community
  - Message other users within the app
  - Create group chats
  - Receive updates in real time
- Help Requets
  - Users can create help requests
  - Volunteers can respond to help requests
  - Help requests are assigned to the closest active volunteer
  - Volunteers can also request help from other volunteers as needed
  - Help Requests update in real time
    - Location is shared between both the volunteer and user
    - Messaging chat is created between the volunteer and user
    - The help request can be cancelled/marked as complete by both sides

### Bug Fixes

- Fixed logout taking user to white screen. (v0.5.0)
- Fixed error messages not appearing on login screen. (v0.5.0)
- Fixed error with user type not being properly set when registering. (v0.5.0)
- Fixed error with chats occasionally show the error "Unexpected null value." (v0.4.0)
- Fixed issue where help requests were not able to be cancelled/marked as complete, and help request updates were not shown to the user (v0.3.0).
- Fixed issue with Firebase account not always staying logged in. (v0.2.0)
- Fixed issue where Terms and Conditions and birthdate field could be skipped when registering. (v0.2.0)

### Known Issues

- Github Release
  - Firebase is not working in the auto-generated releases, so while the app runs, it will not be able to connect to the database
- Security Concerns
  - Since the user's location is updated in real time, predators could use the app to take advantage of users in the time of a crisis.
  - Data privacy
    - Firebase Real-Time database access rules are not set up properly.
- Scale issues
  - This app (as it is now) cannot scale
  - 


### Future Implementations

- More control admin features
  - While a lot of the stuff that we originally saw control admins doing can be done directly through the firebase console, it would be nice to have it in the app/on a portal.
- Some sort of map visualization
- Security solutions