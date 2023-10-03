import 'package:ampconsapp/providers/measurements_notifier.dart';
import 'package:provider/provider.dart';

class MeasurementsProvider {
  static ChangeNotifierProvider<MeasurementsNotifier> getProvider() =>
      _instance;

  static final ChangeNotifierProvider<MeasurementsNotifier> _instance =
      ChangeNotifierProvider(
    create: (_) => MeasurementsNotifier(),
  );
}
