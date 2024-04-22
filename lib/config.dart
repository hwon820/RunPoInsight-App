class Config {
  static late String serverUrl;

  static void init() {
    serverUrl = "http://192.168.0.13:5000/users";
    print("Config initialized with serverUrl: $serverUrl");
  }
}
