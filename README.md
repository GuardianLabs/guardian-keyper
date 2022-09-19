<a name="readme-top"></a>
<!--
*** Readme template is based on https://github.com/othneildrew/Best-README-Template
-->


<!-- PROJECT SHIELDS -->


[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=flat&logo=Flutter&logoColor=white)
<br />
![Lines of code](https://img.shields.io/tokei/lines/github/GuardianLabs/guardian-keyper?style=flat)
<br />
<a href="https://play.google.com/store/apps/details?id=com.guardianlabs.keyper"><img alt="Get it on Google Play" src="https://img.shields.io/badge/Google_Play-414141?style=for-the-badge&logo=google-play&logoColor=white"/></a>
<a href="https://apps.apple.com/dz/app/guardian-keyper/id1637977332"><img alt="Download on AppStore" src="https://img.shields.io/static/v1?label=AppStore&message=Download&logoColor=white&logo=appstore&style=for-the-badge"/></a>





<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/GuardianLabs/guardian-keyper">
    <img src="assets/images/logo512.png" alt="Guardian Keyper" width="80" height="80">
  </a>

  <h3 align="center">Guardian Keyper</h3>

  <p align="center">
    Guardian Keyper is a P2P app for backing up secrets by splitting them between multiple devices.
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#usage">Usage</a></li>
        <li><a href="#key-features">Key features</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contacts">Contacts</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->
## About The Project

Guardian Keyper is a mobile app for securely backing up seed phrases and secrets. The user can choose several devices (e.g. his friends or family's phones) as her personal "Guardians". After that, the user can back up a seed phrase by splitting it into several Shards and sending those to the designated Guardians. Every shard by itself is useless: to reassemble the secret, one needs to collect a certain majority of the shards (e.g. 3 out of 5).

The general idea of Keyper is: to secure the most precious information we possess - our seed phrases - we should employ the power of our social connections.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- USAGE -->
### Usage

<p align="center">

  <img style='height: 600px; width: auto' src="https://github.com/GuardianLabs/guardian-keyper/blob/main/doc/keyper.gif">

</p>

1. Install the app to your device, and devices of your Guardians
2. Create a group to store the secret
3. Add Guardians (trusted devices) to the group by scanning their single-use QR codes, or getting single-use invite messages from them
4. Add your secret.
5. Send the secret shards to your Guardians. Note that due to the P2P nature of Keyper, the Guardian you're sending the shard to must be online simultaneously with you.


As soon as you enter the secret, it is immediately sharded, the shards are encrypted by your Guardians' public keys and the original secret is deleted from memory. The original secret is never stored in the non-volatile memory of your device. The shards are then sent to your Guardians. Each shard is useless on its own: depending on your choice, one will require either 2 out of 3, or 3 out of 5 secret shards to restore the secret - approved by the corresponding Guardianss. No Keyper data ever goes through the network unencrypted, and nothing is stored on a server: the app is completely peer-to-peer and is designed to work without Internet access (e.g. in an isolated WiFi network).

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- KEY FEATURES -->
### Key features
<details><summary>Decentralization</summary>The shards of the secret phrase are stored on several independent devices and are useless on their own. Even if someone gains unplanned access to one of them, the owner's digital assets will remain safe. The only kind of server we use is the bootstrap server for NAT puncturing. And even that is completely unnecessary - Keyper instances can communicate without Internet access in a WiFi LAN by utilising broadcast packets (mDNS protocol).</details>


<details><summary>Strong data protection</summary>Keyper uses industry-standard asymmetric public-key cryptography PGP-style – so it’s fully P2P and encrypted end-to-end. The complete secret is never stored on a device, while the shards are stored in the device's protected storage.</details>

<details><summary>Versatility</summary>Guardian Keyper is suitable for use with any password, seed phrase or other information that you want to keep secret.</details>

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->
## Getting Started
You can build Guardian Keyper from source code. Installation instructions are given for Linux; for Windows and macOS, follow the same steps in the context of your operating system.

### Installation

Сlone the project:
```sh
git clone git@github.com:GuardianLabs/guardian-keyper.git
```
Guardian Keyper requires Flutter to run. Use [__this guide__](https://docs.flutter.dev/get-started/install) to make sure the installation is correct. 
For checking all SDK dependencies, use:
```sh
flutter doctor
```
Go to your project folder and get project dependencies:
```sh
flutter pub get
```
If there are no issues, you can build the project with the following command:
```sh
flutter build apk --debug
```
Also, you can use android-simulator:
```sh
flutter emulator --launch <Your Emulator ID>
flutter run --debug
```


<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTRIBUTING -->
## Contributing

Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make Keyper better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request
6. If you have never committed to this repository before, accept our Contributor License Agreement (served by `cla-bot`)

Note that Guardian Labs requires every contributor to sign the Contributor License Agreement to facilitate publishing Guardian Keyper to GPL-incompatible app repositories, such as the AppStore. See `CLA.md` for details.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LICENSE -->
## License

Guardian Keyper is distributed under GPLv3 License with special permission to use MPL for AppStore publication. See `LICENSE` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTACTS -->
## Contacts
* If you want to report a bug, open an Issue
* If you have a general question or a suggestion, create a GitHub Discussion
* [Guardian Keyper support page](https://myguardian.network/support/)
* [![Twitter](https://img.shields.io/twitter/url/https/twitter.com/cloudposse.svg?style=social&label=Follow%20%40guardian_labs)](https://twitter.com/guardian_labs)
* [![](https://dcbadge.vercel.app/api/server/keyper?style=flat)](https://discord.gg/keyper)
* Email: Keyper.support@guardianlabs.org
* [![Telegram Group](https://img.shields.io/endpoint?color=neon&style=flat&url=https%3A%2F%2Ftg.sumanjay.workers.dev%2Fguardian_keyper_support)](https://telegram.dog/guardian_keyper_support)
