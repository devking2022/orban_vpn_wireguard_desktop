// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../helpers/constants.dart';
// import '../helpers/pref.dart';
// import '../widgets/button_widget.dart';
// import 'home_screen.dart';

// class IntroducationScreen extends StatefulWidget {
//   @override
//   _IntroducationScreenState createState() => _IntroducationScreenState();
// }

// class _IntroducationScreenState extends State<IntroducationScreen> {
//   final int totalpages = 2;
//   final PageController pagecontroller = PageController(initialPage: 0);
//   int currentpage = 0;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView(
//         controller: pagecontroller,
//         onPageChanged: (int page) {
//           currentpage = page;
//           setState(() {});
//         },
//         children: [
//           buildPageContent(
//             textColor: Colors.white,
//             path: "assets/images/1.png",
//             title: "Safe and Secured",
//             body:
//                 'We always been committed to protecting your privacy and your data.',
//           ),
//           buildPageContent(
//             textColor: Colors.white,
//             path: "assets/images/2.png",
//             title: 'Best Server',
//             body:
//                 'We have best server around the world with super high speed connection.',
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildPageContent({
//     Color? textColor,
//     String? title,
//     String? body,
//     String? path,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Image.asset(path.toString()),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(
//                 title!,
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.w600,
//                   color: textColor,
//                 ),
//               ),
//               SizedBox(height: Get.height * 0.02),
//               Text(
//                 body!,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   height: 2,
//                   letterSpacing: 0.25,
//                   fontWeight: FontWeight.w400,
//                   color: textSecondry,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: Get.height * 0.05),
//           Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//             for (int i = 0; i < totalpages; i++)
//               i == currentpage
//                   ? buildPageIndicator(true)
//                   : buildPageIndicator(false)
//           ]),
//           SizedBox(height: Get.height * 0.10),
//           if (currentpage == 0)
//             button(
//                 lable: "Allow VPN",
//                 onTap: () async {
//                   pagecontroller.nextPage(
//                       duration: const Duration(milliseconds: 100),
//                       curve: Curves.bounceIn);
//                 }),
//           if (currentpage == 1)
//             button(
//                 lable: "Continue",
//                 onTap: () {
//                   Pref.isIntro = true;
//                   Get.offAll(() => const HomeScreen());
//                 }),
//           SizedBox(height: Get.height * 0.02),
//         ],
//       ),
//     );
//   }

//   Widget buildPageIndicator(bool isCurrentPage) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 350),
//       margin: const EdgeInsets.symmetric(horizontal: 5),
//       height: 10,
//       width: isCurrentPage ? 40 : 20,
//       decoration: BoxDecoration(
//           color: isCurrentPage ? orange : Colors.white24,
//           borderRadius: const BorderRadius.all(Radius.circular(12))),
//     );
//   }
// }
