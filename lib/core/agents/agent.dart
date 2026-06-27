abstract class KataPlayAgent<Input, Output> {
  String get name;
  String get version => '1.0.0';
  bool get enabled => true;

  Future<Output> process(Input input);
  Future<bool> validate(Output output) async => true;
}
