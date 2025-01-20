abstract class Plug<T extends Plug<T>> {
  Future<Plug> init() async => this;
  Future<Plug> dispose() async => this;
}