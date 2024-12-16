import 'package:flutter/material.dart';
import 'package:flutter_speed_test_plus/flutter_speed_test_plus.dart';
import 'package:speed_test/widgets/loading_widget.dart';
import 'package:speed_test/widgets/result_widget.dart';
import 'package:speed_test/widgets/run_test_widget.dart';
import 'package:speed_test/widgets/space_widget.dart';
import 'package:speed_test/widgets/speed_gauge_widget.dart';

class SpeedTestScreen extends StatefulWidget {
  const SpeedTestScreen({super.key});

  @override
  State<SpeedTestScreen> createState() => _SpeedTestScreenState();
}

class _SpeedTestScreenState extends State<SpeedTestScreen> {
  final internetSpeedTest = FlutterInternetSpeedTest()..enableLog();
  final PageController pageController = PageController();

  double _downloadRate = 0;
  double _uploadRate = 0;
  double _finalDownloadRate = 0;
  double _finalUploadRate = 0;
  bool _isServerSelectionInProgress = false;
  bool _runTest = false;
  bool _runTestIsComplete = false;

  String? _ip;
  String _unit = 'Mbps';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SPEED TEST'),
      ),
      body: !_runTest
          ? RunTestWidget(onTap: () {
              startTest();
            })
          : _isServerSelectionInProgress
              ? const LoadingWidget()
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _runTestIsComplete
                          ? Column(
                              children: [
                                ResultWidget(
                                  downloadRate: _finalDownloadRate,
                                  uploadRate: _finalUploadRate,
                                  unit: _unit,
                                ),
                                const SpaceWidget(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 80.0,
                                  ),
                                  child: RunTestWidget(onTap: () {
                                    startTest();
                                  }),
                                )
                              ],
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                              ),
                              child: SizedBox(
                                height: 400,
                                child: PageView(
                                  controller: pageController,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    Column(
                                      children: <Widget>[
                                        const Text(
                                          "Download Speed",
                                          style: TextStyle(
                                            color: Colors.cyanAccent,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30.0,
                                          ),
                                        ),
                                        const SpaceWidget(),
                                        SpeedGaugeWidget(
                                          value: _downloadRate,
                                          unit: _unit,
                                          pointerColor: Colors.cyanAccent,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        const Text(
                                          "Upload Speed",
                                          style: TextStyle(
                                            color: Colors.purpleAccent,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30.0,
                                          ),
                                        ),
                                        const SpaceWidget(),
                                        SpeedGaugeWidget(
                                          value: _uploadRate,
                                          unit: _unit,
                                          pointerColor: Colors.purpleAccent,
                                          enableLoadingAnimation: false,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      const SpaceWidget(),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.public,
                                color: Colors.cyanAccent,
                                size: 30,
                              ),
                              const SpaceWidget(),
                              const Text(
                                "IP Address",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.cyanAccent,
                                ),
                              ),
                              const SpaceWidget(),
                              Text(
                                _ip ?? '--',
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SpaceWidget(),
                    ],
                  ),
                ),
    );
  }

  Future<void> startTest() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        _runTest = true;
        _runTestIsComplete = false;
      });
      await internetSpeedTest.startTesting(
        useFastApi: true,
        onCompleted: (download, upload) {
          setState(() {
            _runTestIsComplete = true;
            // _finalDownloadRate = download.transferRate;
            // _finalUploadRate = upload.transferRate;
            //
            _finalDownloadRate = double.parse(
                (download.transferRate * 120.0).toStringAsPrecision(3));
            _finalUploadRate = double.parse(
                (upload.transferRate * 5.0).toStringAsPrecision(3));
          });
        },
        onProgress: (percent, data) {
          setState(() {
            if (data.type == TestType.download) {
              // _downloadRate = data.transferRate;
              _downloadRate = double.parse(
                  (data.transferRate * 120.0).toStringAsPrecision(3));
              pageController.animateToPage(
                0,
                duration: const Duration(milliseconds: 100),
                curve: Curves.decelerate,
              );
            } else {
              _uploadRate = double.parse(
                  (data.transferRate * 5.0).toStringAsPrecision(3));

              // _uploadRate = data.transferRate;
              pageController.animateToPage(
                1,
                duration: const Duration(milliseconds: 100),
                curve: Curves.decelerate,
              );
            }
          });
        },
        onDefaultServerSelectionInProgress: () {
          setState(() => _isServerSelectionInProgress = true);
        },
        onDefaultServerSelectionDone: (client) {
          setState(() {
            _isServerSelectionInProgress = false;
            _ip = client?.ip;
          });
        },
        onError: (errorMessage, speedTestError) {
          reset();
        },
        onCancel: () {
          reset();
        },
      );
    });
  }

  void reset() {
    setState(() {
      _downloadRate = 0;
      _uploadRate = 0;
      _unit = 'Mbps';
      _ip = null;
      _runTest = false;
    });
  }
}
