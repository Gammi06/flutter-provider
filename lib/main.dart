import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// provider -> 공급자
// provider는 창고에 데이터를 공급 (공급자는 창고를 들고있음)
// 나중에 레파지토리로 사용할 예정

// 읽기전용
// final numProvider = Provider((_) => 1);

// 변경가능
final numProvider = StateProvider((_) => 1);

// 상태를 관찰하고 있는 위젯이 아니면 리빌드를 하지 않는다.(알아서 처리해줌)
void main() {
  runApp(
    // provider의 상태가 저장된다
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: AComponent()),
          Expanded(child: BComponent()),
        ],
      ),
    );
  }
}

// 소비자 : 소비자는 공급자provider한테 데이터를 요청한다.
// 공급자는 창고에서 데이터를 꺼내 돌려준다.
class AComponent extends ConsumerWidget {
  const AComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // read : 그림과 상관없는 일을 할때 사용함, (세션값 같은 거)
    // 소비를 한번만 할 때 read를 사용함
    // 최초에 실행될때(빌드될때) 딱 한번 실행됨 > 변경될 일이 없을 때 사용함
    // int num = ref.read(numProvider);

    // watch : 리스너 (바뀔 때마다 리빌드함)
    // numProvider의 값이 변경될 때마다 리빌드됨
    int num = ref.watch(numProvider);

    return Container(
      color: Colors.yellow,
      child: Column(
        children: [
          Text("ACompoent"),
          Expanded(
            child: Align(
              child: Text(
                "${num}",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// 서플라이어 공급자
class BComponent extends ConsumerWidget {
  const BComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.blue,
      child: Column(
        children: [
          Text("BCompoent"),
          Expanded(
            child: Align(
              child: ElevatedButton(
                onPressed: () {
                  // StateProvider만 사용 가능함
                  final result = ref.read(numProvider.notifier);
                  result.state = result.state + 5;
                },
                child: Text(
                  "숫자증가",
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
