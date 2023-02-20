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
  - [v0.2.0](#v020)
    - [Features](#features)
    - [Bug Fixes](#bug-fixes)
    - [Known Issues](#known-issues)
  - [v0.1.0](#v010)
    - [Features](#features-1)
    - [Bug Fixes](#bug-fixes-1)
    - [Known Issues](#known-issues-1)

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
