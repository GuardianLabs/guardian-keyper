// import '/src/core/di_container.dart';
// import '/src/core/model/core_model.dart';
// import '/src/core/theme_data.dart';
// import '/src/core/widgets/common.dart';

// class SettingsConnectionPage extends StatelessWidget {
//   const SettingsConnectionPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final boxSettings = context.read<DIContainer>().boxSettings;
//     return Column(
//       children: [
//         // Header
//         const HeaderBar(
//           caption: 'Connection',
//           backButton: HeaderBarBackButton(),
//         ),
//         // Body
//         Expanded(
//           child: ListView(
//             padding: paddingAll20,
//             children: [
//               const Padding(
//                 padding: paddingV12,
//                 child: Text('Device Discovery', style: textStyleBold),
//               ),
//               //No discover methods message
//               Visibility(
//                   visible: !boxSettings.isBonjourDiscoverEnabled &&
//                       !boxSettings.isProxyDiscoverEnabled,
//                   child: Padding(
//                     padding: paddingBottom12,
//                     child: Text(
//                       'We advice you to enable at least one method'
//                       ' to avoid any issues with device discovery.',
//                       style:
//                           TextStyle(color: Theme.of(context).colorScheme.error),
//                     ),
//                   )),
//               // Use Bonjour Discover
//               Padding(
//                 padding: paddingBottom12,
//                 child: ValueListenableBuilder<Box<SettingsModel>>(
//                   valueListenable: boxSettings.listenable(),
//                   builder: (_, boxSettings, __) => SwitchListTile.adaptive(
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 20, vertical: 12),
//                       title: const Text('Bonjour Discover'),
//                       subtitle: const Text(
//                           'Directly discover devices in local network (e.g. Wi-Fi)'),
//                       value: boxSettings.isBonjourDiscoverEnabled,
//                       onChanged: (value) {
//                         boxSettings.isBonjourDiscoverEnabled = value;
//                         if (!boxSettings.isProxyDiscoverEnabled) {
//                           Navigator.of(context).pushReplacement(
//                               MaterialPageRoute(
//                                   builder: (_) => const ScaffoldWidget(
//                                       child: SettingsConnectionPage())));
//                         }
//                       }),
//                 ),
//               ),
//               //Use Proxy Discover
//               Padding(
//                 padding: paddingBottom32,
//                 child: ValueListenableBuilder<Box<SettingsModel>>(
//                   valueListenable: boxSettings.listenable(),
//                   builder: (_, boxSettings, __) => SwitchListTile.adaptive(
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 20, vertical: 12),
//                       title: const Text('Proxy Discover'),
//                       subtitle:
//                           const Text('Discover devices in Internet through'
//                               ' the Guardian Keyper proxy server'),
//                       value: boxSettings.isProxyDiscoverEnabled,
//                       onChanged: (value) {
//                         boxSettings.isProxyDiscoverEnabled = value;
//                         if (!boxSettings.isBonjourDiscoverEnabled) {
//                           Navigator.of(context).pushReplacement(
//                               MaterialPageRoute(
//                                   builder: (_) => const ScaffoldWidget(
//                                       child: SettingsConnectionPage())));
//                         }
//                       }),
//                 ),
//               ),
//               const Padding(
//                 padding: paddingBottom12,
//                 child: Text('Data Transfer', style: textStyleBold),
//               ),
//               //No data transfer methods message
//               Visibility(
//                   visible: !boxSettings.isDirectDataTransferEnabled &&
//                       !boxSettings.isProxyDataTransferEnabled,
//                   child: Padding(
//                     padding: paddingBottom12,
//                     child: Text(
//                       'We advice you to enable at least one method'
//                       ' to avoid any issues with data transfer.',
//                       style:
//                           TextStyle(color: Theme.of(context).colorScheme.error),
//                     ),
//                   )),
//               //Use Direct Data Transfer
//               Padding(
//                 padding: paddingBottom12,
//                 child: ValueListenableBuilder<Box<SettingsModel>>(
//                   valueListenable: boxSettings.listenable(),
//                   builder: (_, boxSettings, __) => SwitchListTile.adaptive(
//                       title: const Text('Direct Data Transfer'),
//                       subtitle:
//                           const Text('Transfer data using direct connection'),
//                       value: boxSettings.isDirectDataTransferEnabled,
//                       onChanged: (value) {
//                         boxSettings.isDirectDataTransferEnabled = value;
//                         if (!boxSettings.isProxyDataTransferEnabled) {
//                           Navigator.of(context).pushReplacement(
//                               MaterialPageRoute(
//                                   builder: (_) => const ScaffoldWidget(
//                                       child: SettingsConnectionPage())));
//                         }
//                       }),
//                 ),
//               ),
//               //Use Proxy Discover Data Transfer
//               ValueListenableBuilder<Box<SettingsModel>>(
//                 valueListenable: boxSettings.listenable(),
//                 builder: (_, settings, __) => SwitchListTile.adaptive(
//                     contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 20, vertical: 12),
//                     title: const Text('Proxy Discover'),
//                     subtitle: const Text(
//                         'Transfer data through the Guardian Keyper proxy server'),
//                     value: settings.isProxyDataTransferEnabled,
//                     onChanged: (value) {
//                       boxSettings.isProxyDataTransferEnabled = value;
//                       if (!boxSettings.isDirectDataTransferEnabled) {
//                         Navigator.of(context).pushReplacement(MaterialPageRoute(
//                             builder: (_) => const ScaffoldWidget(
//                                 child: SettingsConnectionPage())));
//                       }
//                     }),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
