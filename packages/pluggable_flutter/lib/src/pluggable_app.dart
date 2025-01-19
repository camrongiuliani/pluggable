import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pluggable_flutter/pluggable_flutter.dart';

typedef ThemeBuilder = ThemeData Function(BuildContext);
typedef CustomBuilder = Widget Function(BuildContext, Widget);
typedef InitCallback = FutureOr<void> Function();

Future<void> runPluggableApp({
  required PluggableNavigator navigationPlugin,
  List<PluggableModule> modules = const [],
  PluggableStorage? storagePlugin,
  PluggableAnalytics? analyticsPlugin,
  PluggableLogger? loggingPlugin,
  PluggableDI? diPlugin,
  ThemeData? theme,
}) async {
  await initPluggable(
    modules: modules,
    navigationPlugin: navigationPlugin,
    storagePlugin: storagePlugin,
    analyticsPlugin: analyticsPlugin,
    loggingPlugin: loggingPlugin,
    diPlugin: diPlugin,
  );

  runApp(
    AnimatedBuilder(
      animation: Pluggable,
      builder: (_, __) {
        return MaterialApp.router(
          theme: theme,
          routerConfig: Pluggable.navigator.config,
        );
      },
    ),
  );
}

// class PluggableApp extends StatefulWidget {
//   const PluggableApp({
//     required this.appTitle,
//     required this.initialRoute,
//     required this.modules,
//     required this.themeBuilder,
//     this.di,
//     this.onInit,
//     this.rootModule,
//     this.builder,
//     super.key,
//   });
//
//   final InitCallback? onInit;
//   final ThemeBuilder themeBuilder;
//   final String appTitle;
//   final List<PluggableModule> modules;
//   final PluggableModule? rootModule;
//   final CustomBuilder? builder;
//   final String initialRoute;
//
//   final PluggableDI? di;
//
//   @override
//   State<PluggableApp> createState() => _PluggableAppState();
// }
//
// class _PluggableAppState extends State<PluggableApp> {
//   bool initialized = false;
//
//   @override
//   initState() {
//     Future.wait([
//       Pluggable.init(
//         diPlugin: widget.di ?? PluggableGetIt(),
//         navigationPlugin: PluggableNavigatorImpl(
//           modules: widget.modules,
//           initialRoute: widget.initialRoute,
//         ),
//       ),
//       Future.sync(Pluggable.router.init),
//     ]).then((_) async {
//       await Future.delayed(Duration.zero);
//
//       if (widget.rootModule != null) {
//         widget.rootModule?.bind();
//       }
//
//       if (mounted) {
//         setState(() {
//           initialized = true;
//           widget.onInit?.call();
//         });
//       }
//     });
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (!initialized) {
//       return Container();
//     }
//
//     return Configurator(
//       config: widget.configuration,
//       builder: (ctx, config) {
//         final litho = widget.themeBuilder(ctx);
//
//         return LithoTheme(
//           data: litho,
//           child: I18n(
//             child: ActivityListener(
//               child: GestureDetector(
//                 onTap: () {
//                   FocusManager.instance.primaryFocus?.unfocus();
//                 },
//                 child: MaterialApp.router(
//                   title: widget.appTitle,
//                   // showSemanticsDebugger: true,
//                   theme: switch (ctx.materialTheme.brightness) {
//                     Brightness.dark => litho.darkTheme,
//                     Brightness.light => litho.theme,
//                   },
//                   builder: switch (widget.builder == null) {
//                     true => switch (Pluggable.debug) {
//                         false => null,
//                         true => (ctx, wgt) => wgt ?? const SizedBox.shrink(),
//                         // true => (ctx, wgt) => CXDesigner(
//                         //       child: wgt ?? const SizedBox.shrink(),
//                         //     ),
//                       },
//                     false => (ctx, wgt) {
//                         return widget.builder!(
//                           ctx,
//                           wgt ?? const SizedBox.shrink(),
//                         );
//                       },
//                   },
//                   debugShowCheckedModeBanner: false,
//                   localizationsDelegates: const [
//                     GlobalMaterialLocalizations.delegate,
//                     GlobalWidgetsLocalizations.delegate,
//                     GlobalCupertinoLocalizations.delegate,
//                   ],
//                   supportedLocales: const [
//                     Locale('en', "US"),
//                   ],
//                   routerConfig: Pluggable.router.routerConfig,
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
