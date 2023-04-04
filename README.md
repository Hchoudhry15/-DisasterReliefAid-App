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
- [Release Notes](#release-notes)
  - [v0.4.0](#v040)
    - [Features](#features)
    - [Bug Fixes](#bug-fixes)
    - [Known Issues](#known-issues)
  - [v0.3.0](#v030)
    - [Features](#features-1)
    - [Bug Fixes](#bug-fixes-1)
    - [Known Issues](#known-issues-1)
  - [v0.2.0](#v020)
    - [Features](#features-2)
    - [Bug Fixes](#bug-fixes-2)
    - [Known Issues](#known-issues-2)
  - [v0.1.0](#v010)
    - [Features](#features-3)
    - [Bug Fixes](#bug-fixes-3)
    - [Known Issues](#known-issues-3)

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

## Release Notes

### v0.4.0

[![GitHub release](https://badgen.net/badge/Release/v0.4.0/blue?icon=github)](https://github.com/JohnRamberger/DisasterReliefAid-JIB-2320/releases/tag/v0.4.0)

<!-- [![Screenshots](https://badgen.net/badge/%20/App%20Screenshots/blue?icon=awesome)](./repo-images/v0.1.0/screenshots-v0.1.0.md) -->

<!-- [View App Screenshots](./repo-images/v0.1.0/screenshots-v0.1.0.md) -->

#### Features

- Help Request Updates
  - Live updates are now sent back and forth between the user and volunteer
    - Includes Location Updates and Status Updates
  - Help requests can now be cancelled and marked as complete
    - can be done from the user's side or the volunteer's side
    - updates are shown to both parties
  - Volunteer and User can now start a chat with each other
    - Chat is shown in the Community Tab
- Group Chats
  - User's can now communicate as a group
  - Similar to before, but now user's can enter a list of emails to create a group chat
- All chats are now shown in the Community Tab
- Added profanity filter to chat messages
- Control Admin Login
  - Users can now login as a control admin using a pre-defined password
  - Control Admins can moderate users

#### Bug Fixes

- Fixed various bugs with the chat system
- Fixed various bugs with help requests not being properly updated/created

#### Known Issues

- N/A

---

### v0.3.0

[![GitHub release](https://badgen.net/badge/Release/v0.3.0/blue?icon=github)](https://github.com/JohnRamberger/DisasterReliefAid-JIB-2320/releases/tag/v0.3.0)

<!-- [![Screenshots](https://badgen.net/badge/%20/App%20Screenshots/blue?icon=awesome)](./repo-images/v0.1.0/screenshots-v0.1.0.md) -->

<!-- [View App Screenshots](./repo-images/v0.1.0/screenshots-v0.1.0.md) -->

#### Features

- Chat System
  - Created backend chat system using Firebase
  - Chats are saved between users
  - Users can look up other user’s emails and start a chat with them
  - Created search bar widget that finds users to chat with
      - When a user is not in the database, the correct error message pops up
  - Created chat bubble widget for front end in chats
  - Chats are ordered based on time
  - Created text controller widget that sends the chat messages
  - Chats update realtime
- Help Requests
  - Users can now successfully request help
  - Created Firebase Function to process help requests and send them to the correct volunteers
  - Added support for Volunteers receiving help requests
  - Added toggle to allow volunteers to be active or inactive (active = able to receive help requests)
  - Volunteers can accept and decline help requests
  - Volunteers are able to see the currently active help request and navigate to the User's location
  - Volunteer's location is updated in real time

#### Bug Fixes

- Fixed issue with having to login every time the app is opened/refreshed
- Fixed issue with users being able to bypass Birthdate and Acknowledgement on Register

#### Known Issues

- Help requests are not able to be cancelled/marked as complete
- Help request updates are not shown to the user

---

### v0.2.0

[![GitHub release](https://badgen.net/badge/Release/v0.2.0/blue?icon=github)](https://github.com/JohnRamberger/DisasterReliefAid-JIB-2320/releases/tag/v0.2.0)

<!-- [![Screenshots](https://badgen.net/badge/%20/App%20Screenshots/blue?icon=awesome)](./repo-images/v0.1.0/screenshots-v0.1.0.md) -->

<!-- [View App Screenshots](./repo-images/v0.1.0/screenshots-v0.1.0.md) -->

#### Features

- Geolocation integration
  - used when requesting help
  - permissions updated for location request
  - privacy ensured by allowing temporary location
- Request help page
  - updated UI to have request details
  - shows user that their location is being captured
  - sends location to database for processing
- Improved navigation
  - changed page layout and button mappings
- UI improvements
  - increased contrast on text
  - more consistent layout

#### Bug Fixes

- Added error catching
  - On login page and registration page
- Email field (on register) now checks to make sure email is valid
- Login now correctly validates username/password

#### Known Issues

- Firebase account does not always stay logged in
- Terms and Conditions can be skipped when registering
- Some inconsistencies in UI on registration/login views
- skills/vulnerabilities are linked, and count stays the same when swapping pages

---

### v0.1.0

[![GitHub release](https://badgen.net/badge/Release/v0.1.0/blue?icon=github)](https://github.com/JohnRamberger/DisasterReliefAid-JIB-2320/releases/tag/v0.1.0)
[![Screenshots](https://badgen.net/badge/%20/App%20Screenshots/blue?icon=awesome)](./repo-images/v0.1.0/screenshots-v0.1.0.md)

<!-- [View App Screenshots](./repo-images/v0.1.0/screenshots-v0.1.0.md) -->

#### Features

- Database setup and connected to app
- Splash screen while loading
- User account creation
  - Firebase authentication to prevent duplicate emails
  - password strength checking
  - Privacy statement placeholder
- Allow users to setup their profile
  - allow users to select their language, birthdate, and any vulnerabilities
- Volunteer account creation
  - Skillset section to include strengths
- Ability for users to log in
- Home screen
  - template cards created

#### Bug Fixes

- N/A

#### Known Issues

- N/A

---
