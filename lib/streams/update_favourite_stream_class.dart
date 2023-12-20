import 'dart:async';

class UpdateFavouriteStreamControllerClass{
  final List<String> favouritesList;

  UpdateFavouriteStreamControllerClass(this.favouritesList);
}

class UpdateFavouriteStreamClass {
  static final UpdateFavouriteStreamClass _instance = UpdateFavouriteStreamClass._internal();
  late StreamController<UpdateFavouriteStreamControllerClass> _updateFavouriteStreamController;

  factory UpdateFavouriteStreamClass(){
    return _instance;
  }

  UpdateFavouriteStreamClass._internal() {
    _updateFavouriteStreamController = StreamController<UpdateFavouriteStreamControllerClass>.broadcast();
  }

  Stream<UpdateFavouriteStreamControllerClass> get updateFavouriteStream => _updateFavouriteStreamController.stream;


  void removeListener(){
    _updateFavouriteStreamController.stream.drain();
  }

  void emitData(UpdateFavouriteStreamControllerClass data){
    if(!_updateFavouriteStreamController.isClosed){
      _updateFavouriteStreamController.add(data);
    }
  }

  void dispose(){
    _updateFavouriteStreamController.close();
  }
}