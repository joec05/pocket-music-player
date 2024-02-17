
void runDelay(Function func, int duration) async{
  Future.delayed(Duration(milliseconds: duration), (){}).then((value){
    func();
  });
}