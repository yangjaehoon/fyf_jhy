// import 'package:flutter/material.dart';
// import 'package:fast_app_base/login/signup.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:get/get.dart';
// import 'package:fast_app_base/controller/auth_provider.dart';
//
// class LoginPage extends StatelessWidget {
//   const LoginPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     var emailController = TextEditingController();
//     var passwordController = TextEditingController();
//
//     return Scaffold(
//       backgroundColor: Colors.grey[300],
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Icon(
//                   Icons.phone_android,
//                   size: 100,
//                 ),
//                 const SizedBox(
//                   height: 30,
//                 ),
//                 Text(
//                   'Hello',
//                   style: GoogleFonts.bebasNeue(fontSize: 36.0),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 const Text(
//                   'Welcome back',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 50,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 25.0),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       border: Border.all(color: Colors.white),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 20.0),
//                       child: TextField(
//                         controller: emailController,
//                         decoration: const InputDecoration(
//                             border: InputBorder.none, hintText: 'Email'),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 25.0),
//                   child: Container(
//                     decoration: BoxDecoration(
//                         color: Colors.grey[200],
//                         border: Border.all(color: Colors.white),
//                         borderRadius: BorderRadius.circular(12)),
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 20.0),
//                       child: TextField(
//                         controller: passwordController,
//                         obscureText: true,
//                         decoration: const InputDecoration(
//                             border: InputBorder.none, hintText: 'Password'),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     AuthController.instance.loginregister(
//                         emailController.text.trim(),
//                         passwordController.text.trim());
//                   },
//                   child: Container(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 25.0),
//                       child: Container(
//                         padding: const EdgeInsets.all(20),
//                         decoration: BoxDecoration(
//                             color: Colors.red,
//                             borderRadius: BorderRadius.circular(12)),
//                         child: const Center(
//                           child: Text(
//                             'Sign in',
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 25,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text('Not a member?'),
//                     GestureDetector(
//                       onTap: () => Get.to(() => SignupPage()),
//                       child: const Text(
//                         ' Register Now!',
//                         style: TextStyle(
//                             color: Colors.blue, fontWeight: FontWeight.bold),
//                       ),
//                     )
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:fast_app_base/config.dart';
import 'package:fast_app_base/login/signup.dart';
import 'package:fast_app_base/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;



//import 'package:firebase_auth/firebase_auth.dart' as firebase_auth_provider;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app.dart';
import '../controller/auth_provider.dart' as auth;

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.phone_android,
                  size: 100,
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  'Hello',
                  style: GoogleFonts.bebasNeue(fontSize: 36.0),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Welcome back',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: 'Email'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: 'Password'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () async {
                    try {
                      print(await KakaoSdk.origin);

                      await Provider.of<auth.AuthProvider>(context,
                              listen: false)
                          .login(emailController.text.trim(),
                              passwordController.text.trim());
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Login failed: $e')),
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12)),
                      child: const Center(
                        child: Text(
                          'Sign in',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                getKakaoLoginButton(context),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Not a member?'),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupPage()),
                      ),

                      child: const Text(
                        ' Register Now!',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getKakaoLoginButton(BuildContext context) {
    return InkWell(
      onTap: () {
        signInWithKakao(context);
      },
      child: Card(
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        elevation: 2,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.yellow,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/image/login/kakao_login_medium_narrow.png',
                  height: 30),
              const SizedBox(
                width: 10,
              ),
              // const Text("Sign In with Kakao",
              // style: TextStyle(color: Colors.white, fontSize:17))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signInWithKakao(BuildContext context) async {

    final authProvider = Provider.of<auth.AuthProvider>(context, listen: false);

    if (await isKakaoTalkInstalled()) {
      try {
        print("들어옴");
        var provider = OAuthProvider("oidc.kakao");
        print("oidc 통과");
        OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
        var credential = provider.credential(
          idToken: token.idToken,
          accessToken: token.accessToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
        await sendAccessTokenToServer(token.accessToken);


        await authProvider.sendData(); //데베에 보내주기

        Navigator.pop(context);

        print('카카오톡으로 로그인 성공');

        Fluttertoast.showToast(msg: '카톡 로그인 성공 1');
      } catch (error) {
        Fluttertoast.showToast(msg: 'Error Type: ${error.runtimeType}, $error');

        print('카카오톡으로 로그인 실패 $error');
        // 예외 처리 코드 추가 가능
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }
        try {
          var provider = OAuthProvider("oidc.kakao");
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          var credential = provider.credential(
            idToken: token.idToken,
            accessToken: token.accessToken,
          );
          await FirebaseAuth.instance.signInWithCredential(credential);
          await sendAccessTokenToServer(token.accessToken);

          Navigator.pop(context);

          print('카카오계정으로 로그인 성공');
          Fluttertoast.showToast(msg: '카톡 로그인 성공2');
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
          Fluttertoast.showToast(
              msg: 'Error Type: ${error.runtimeType}, $error');
          // 예외 처리 코드 추가 가능
        }
      }
    }
    //핸드폰으로 테스트 할때는 카카오톡 깔려있으니 잠시 주석
    else {
      try {
        print("테스트1");
        var provider = OAuthProvider("oidc.kakao");
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        print("테스트2");
        var credential = provider.credential(
          idToken: token.idToken,
          accessToken: token.accessToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
        await sendAccessTokenToServer(token.accessToken);

        print("테스트3");
        Navigator.pop(context);

        print('카카오계정으로 로그인 성공');
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
        // 예외 처리 코드 추가 가능
      }
    }
  }

  Future<void> sendAccessTokenToServer(String accessToken) async{
    final response = await http.post(
      Uri.parse('http://$baseUrl/auth/kakao'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if(response.statusCode == 200){
      print('Spring 서버 로그인 성공: ${response.body}');
    }else{
      print('Spring 서버 로그인 실패: ${response.body}');
    }
  }
}
