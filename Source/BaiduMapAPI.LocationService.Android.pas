unit BaiduMapAPI.LocationService.Android;
//author:Xubzhlin
//Email:371889755@qq.com

//�ٶȵ�ͼAPI ��λ���� ��Ԫ
//�ٷ�����:http://lbsyun.baidu.com/
//TAndroidBaiduMapLocationService �ٶȵ�ͼ ��׿��λ����
interface

uses
  System.Classes, System.Types, FMX.Maps, Androidapi.JNI.JavaTypes, Androidapi.JNI.Embarcadero, Androidapi.JNI.GraphicsContentViewText, Androidapi.JNIBridge,
  Androidapi.JNI.baidu.location, BaiduMapAPI.LocationService;

type
  TAndroidBaiduMapLocationService = class;

  TBDLocationListenner = class(TJavaLocal, JBDLocationListener)
  private
    [weak]FLocationService: TAndroidBaiduMapLocationService;
  public
    procedure onReceiveLocation(P1: JBDLocation); cdecl;
    procedure onConnectHotSpotMessage(P1: JString; P2: Integer); cdecl;

    constructor Create(LocationService: TAndroidBaiduMapLocationService);
  end;

  TAndroidBaiduMapLocationService = class(TBaiduMapLocationService)
  private
    FScanSpan:Integer;
    FLocationClient:JLocationClient;
    FLocationListener:TBDLocationListenner;
    LocOption:JLocationClientOption;
  protected
    procedure DoInitLocation; override;
    procedure DoStarLocation; override;
    procedure DoStopLocation; override;
    function DoIsLocationEnabled:Boolean; override;
  public
    constructor Create; override;
    destructor Destroy; override;
  end;

implementation

uses Androidapi.Helpers, FMX.Helpers.Android, Androidapi.JNI.Location;

{ TAndroidBaiduMapLocationService }

constructor TAndroidBaiduMapLocationService.Create;
begin
  inherited;
//  CallInUIThreadAndWaitFinishing(
//   procedure
//   begin
     FLocationClient:=TJLocationClient.JavaClass.init(SharedActivityContext);
     FLocationListener:=TBDLocationListenner.Create(Self);
     FLocationClient.registerLocationListener(FLocationListener);
//   end);
end;

destructor TAndroidBaiduMapLocationService.Destroy;
begin
  FLocationListener.Free;
  FLocationClient:=nil;
  inherited;
end;

procedure TAndroidBaiduMapLocationService.DoInitLocation;
begin
//  CallInUIThreadAndWaitFinishing(
//  procedure
//  begin
    LocOption:=TJLocationClientOption.JavaClass.init;
    LocOption.setLocationMode(TJLocationClientOption_LocationMode.JavaClass.Hight_Accuracy);
    LocOption.setCoorType(StringToJString('bd09ll'));
    FScanSpan:=1000;
    LocOption.setScanSpan(FScanSpan);
    LocOption.setOpenGps(True);
    FLocationClient.setLocOption(LocOption);
//  end);
end;

function TAndroidBaiduMapLocationService.DoIsLocationEnabled: Boolean;
var
  LocationManager: JLocationManager;
  UnknownService: JObject;
begin
  Result := False;
  UnknownService := TAndroidHelper.Activity.getSystemService(TJContext.JavaClass.LOCATION_SERVICE);
  if UnknownService <> nil then
  begin
    LocationManager := TJLocationManager.Wrap((UnknownService as ILocalObject).GetObjectID);
    Result := LocationManager.isProviderEnabled(TJLocationManager.JavaClass.GPS_PROVIDER) or
              LocationManager.isProviderEnabled(TJLocationManager.JavaClass.NETWORK_PROVIDER);
    LocationManager := nil;
  end;
end;

procedure TAndroidBaiduMapLocationService.DoStarLocation;
begin
  FLocationClient.start;
end;

procedure TAndroidBaiduMapLocationService.DoStopLocation;
begin
  FLocationClient.stop;
end;

{ TBDLocationListenner }

constructor TBDLocationListenner.Create(
  LocationService: TAndroidBaiduMapLocationService);
begin
  inherited Create;
  FLocationService:=LocationService;
end;

procedure TBDLocationListenner.onConnectHotSpotMessage(P1: JString;
  P2: Integer);
begin

end;

procedure TBDLocationListenner.onReceiveLocation(P1: JBDLocation);
var
  Coordinate:TMapCoordinate;
begin
  //λ�ø���
  if FLocationService<>nil then
  begin
    Coordinate:= TMapCoordinate.Create(P1.getLatitude, P1.getLongitude);
    FLocationService.UserLocationWillChanged(Coordinate);
  end;

end;

end.
