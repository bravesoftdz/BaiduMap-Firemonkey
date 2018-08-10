unit BaiduMapAPI.NaviService.Android;
//author:Xubzhlin
//Email:371889755@qq.com

//�ٶȵ�ͼAPI ��׿�������� ��Ԫ
//�ٷ�����:http://lbsyun.baidu.com/
//TAndroidBaiduMapNaviService �ٶȵ�ͼ ��׿��������

interface

uses
  System.Classes, BaiduMapAPI.NaviService, Androidapi.JNI.baidu.navisdk, Androidapi.JNI.JavaTypes,
  Androidapi.JNIBridge, Androidapi.JNI.Os, BaiduMapAPI.NaviService.CommTypes,
  Androidapi.JNI.Embarcadero, Androidapi.JNI.GraphicsContentViewText;

type
  TAndroidBaiduMapNaviService = class;

  TNaviManager_BaseListerer = class(TJavaLocal)
  private
    [weak]FNaviService:TAndroidBaiduMapNaviService;
  public
    constructor Create(NaviService:TAndroidBaiduMapNaviService);
  end;

  TNaviManager_NaviInitListener = class(TNaviManager_BaseListerer, JBaiduNaviManager_NaviInitListener)
  public
    procedure onAuthResult(P1: Integer; P2: JString); cdecl;
    procedure initStart; cdecl;
    procedure initSuccess; cdecl;
    procedure initFailed; cdecl;
  end;

  TNaviManager_RoutePlanListener = class(TNaviManager_BaseListerer, JBaiduNaviManager_RoutePlanListener)
  public
    procedure onJumpToNavigator; cdecl;
    procedure onRoutePlanFailed; cdecl;
  end;

  TJBNRouteGuideManager_OnNavigationListener = class(TNaviManager_BaseListerer, JBNRouteGuideManager_OnNavigationListener)
  public
    procedure onNaviGuideEnd; cdecl;
    procedure notifyOtherAction(P1: Integer; P2: Integer; P3: Integer; P4: JObject); cdecl;
  end;

  TJBaiduNaviManager_TTSPlayStateListener = class(TNaviManager_BaseListerer, JBaiduNaviManager_TTSPlayStateListener)
  public
    procedure playStart; cdecl; // ()V
    procedure playEnd; cdecl; // ()V
  end;

  TAndroidBaiduMapNaviService = class(TBaiduMapNaviService)
  private
    FSDCardPath:JString;
    FNaviManager:JBaiduNaviManager;
    FJNativeLayout:JNativeLayout;
    FView:JView;
    FNaviInitListener:TNaviManager_NaviInitListener;
    FRoutePlanListener:TNaviManager_RoutePlanListener;
    FNavigationListener:TJBNRouteGuideManager_OnNavigationListener;
    FTTSPlayStateListener:TJBaiduNaviManager_TTSPlayStateListener;
    function DoinitDirs:Boolean;
    procedure DoJumpToNavigator;
    procedure RealignView;
    procedure DoInitTTS;
    procedure DoInitNaviManager;
  protected
    procedure DoinitService; override;
    procedure DostartNaviRoutePlan(RoutePlan:TBNRoutePlanNodes); override;
    procedure DoSetVisible(const Value: Boolean); override;
    procedure DoUpdateBaiduNaviFromControl; override;
    procedure DoDestroyNavi; override;
  end;

implementation

uses
  Androidapi.Helpers, FMX.Helpers.Android, Androidapi.IOUtils, Androidapi.JNI.Os.Environment,
  FMX.Platform.Android, FMX.Forms, System.Types, FMX.CallUIThread.Helper.Android;

{ TAndroidBaiduMapNaviService }

procedure TAndroidBaiduMapNaviService.DoDestroyNavi;
begin
  if FView = nil then exit;

  CallInUIThread(procedure
  begin
    TJBNRouteGuideManager.JavaClass.getInstance.onDestroy;
  end);
end;

function TAndroidBaiduMapNaviService.DoinitDirs:Boolean;
var
  F:JFile;
begin
  Result:=False;
  if TJEnvironment.JavaClass.getExternalStorageState.equalsIgnoreCase(TJEnvironment.JavaClass.MEDIA_MOUNTED) then
    FSDCardPath:=TJEnvironment.JavaClass.getExternalStorageDirectory.toString;
  if FSDCardPath<>nil then
  begin
    F:=TJFile.JavaClass.init(FSDCardPath, SharedActivityContext.getPackageName);
    if not F.exists then
    begin
      try
        F.mkdir;
        Result:=True;
      except
      end;
    end
    else
      Result:=True;
  end;
end;

procedure TAndroidBaiduMapNaviService.DoinitService;
var
  PM:JPackageManager;
  SDK_INT:Integer;
  permissions: TJavaObjectArray<JString>;
begin
  if DoinitDirs then
  begin
    SDK_INT:=TJBuild_VERSION.JavaClass.SDK_INT;
    if TJBuild_VERSION.JavaClass.SDK_INT>=23 then
    begin
      permissions:= TJavaObjectArray<JString>.Create(1);

      permissions.Items[0]:=StringToJString('Manifest.permission.WRITE_EXTERNAL_STORAGE');
      PM:=SharedActivity.getPackageManager;
      if PM.checkPermission(permissions.Items[0], SharedActivity.getPackageName)
        <> TJPackageManager.JavaClass.PERMISSION_GRANTED then
        SharedActivity.requestPermissions(permissions, 1);

      permissions.Items[0]:=StringToJString('Manifest.permission.ACCESS_FINE_LOCATION');
      PM:=SharedActivity.getPackageManager;
      if PM.checkPermission(permissions.Items[0], SharedActivity.getPackageName)
        <> TJPackageManager.JavaClass.PERMISSION_GRANTED then
        SharedActivity.requestPermissions(permissions, 1);
    end;
    //

    CallInUIThreadAndWaitFinishingFix(DoInitNaviManager)
  end;
end;

procedure TAndroidBaiduMapNaviService.DoInitTTS;
var
  bundle:JBundle;
begin
  bundle:=TJBundle.JavaClass.init;
  bundle.putString(TJBNCommonSettingParam.JavaClass.TTS_APP_ID, StringToJString(TTSKey));
  TJBNaviSettingManager.JavaClass.setNaviSdkParam(bundle);
end;

procedure TAndroidBaiduMapNaviService.DoInitNaviManager;
begin
  if FNaviManager = nil then
    FNaviManager:=TJBaiduNaviManager.JavaClass.getInstance;

  if FNaviInitListener = nil then
    FNaviInitListener := TNaviManager_NaviInitListener.Create(Self);
    IF FTTSPlayStateListener = nil then
      FTTSPlayStateListener:=TJBaiduNaviManager_TTSPlayStateListener.Create(Self);
  //ʹ��Ĭ��TTS ������ �Զ���TTS�ص�
  FNaviManager.init(SharedActivity, FSDCardPath, SharedActivityContext.getPackageName, FNaviInitListener, nil, nil, FTTSPlayStateListener);
end;

procedure TAndroidBaiduMapNaviService.DoJumpToNavigator;
begin
  //����;�����Լ�resetEndNode��ص��ýӿ�
  CallInUIThread(
  procedure
  begin
    if FNavigationListener = nil then
      FNavigationListener:=TJBNRouteGuideManager_OnNavigationListener.Create(Self);

    if FView = nil  then
      FView:=TJBNRouteGuideManager.JavaClass.getInstance.onCreate(SharedActivity, FNavigationListener);

    FJNativeLayout := TJNativeLayout.JavaClass.init(SharedActivity,
      MainActivity.getWindow.getDecorView.getWindowToken);
    FJNativeLayout.setPosition(0, 0);
    FJNativeLayout.setSize(Round(Screen.Height), Round(Screen.Width));

    FJNativeLayout.setControl(FView);

    RealignView;
      //View.bringToFront;
      //MainActivity.setContentView(View);
  end);

end;

procedure TAndroidBaiduMapNaviService.DoSetVisible(const Value: Boolean);
begin
  if FView = nil then exit;
  
  CallInUIThread(procedure
  begin
    if Value then
      TJBNRouteGuideManager.JavaClass.getInstance.onStart
    else
      TJBNRouteGuideManager.JavaClass.getInstance.onStop;

  end);

end;

procedure TAndroidBaiduMapNaviService.DostartNaviRoutePlan(RoutePlan:TBNRoutePlanNodes);
var
  List:JArrayList;
  Node:JBNRoutePlanNode;
  i: Integer;
  b:Boolean;
begin
  //List:=TJList.Wrap((TJArrayList.JavaClass.Init as ILocalObject).GetObjectID);
  List:=TJArrayList.JavaClass.Init;
  for i := 0 to Length(RoutePlan) - 1 do
  begin
    //Ĭ��ʹ�� TJBNRoutePlanNode_CoordinateType.JavaClass.BD09LL ����ϵ
    Node:= TJBNRoutePlanNode.JavaClass.init(RoutePlan[i].location.Longitude, RoutePlan[i].location.Latitude,
      StringToJString(RoutePlan[i].name), StringToJString(RoutePlan[i].description), TJBNRoutePlanNode_CoordinateType.JavaClass.BD09LL);
    List.add(Node);
  end;
  if FRoutePlanListener = nil then
    FRoutePlanListener:=TNaviManager_RoutePlanListener.Create(Self);
  b := TJBaiduNaviManager.JavaClass.isNaviInited;
  b := TJBaiduNaviManager.JavaClass.isNaviSoLoadSuccess;
  b:=FNaviManager.launchNavigator(SharedActivity, JList(List), 1, True, FRoutePlanListener);
end;

procedure TAndroidBaiduMapNaviService.DoUpdateBaiduNaviFromControl;
begin
  CallInUiThread(RealignView);
end;

procedure TAndroidBaiduMapNaviService.RealignView;
const
  MapExtraSpace = 100;
  // To be sure that destination rect will fit to fullscreen
var
  MapRect: TRectF;
  RoundedRect: TRect;
  LSizeF: TPointF;
  LRealBounds: TRectF;
  LRealPosition, LRealSize: TPointF;
begin
  if (FJNativeLayout <> nil) then
  begin
    //ȫ��
    LRealPosition := TPointF.Zero;
    LSizeF := TPointF.Create(screen.Size.cx, screen.Size.cy);
    LRealSize := LSizeF * Scale;
    LRealBounds := TRectF.Create(LRealPosition, LRealSize);
    MapRect := TRectF.Create(0, 0, Screen.Width * MapExtraSpace,
      Screen.Height * MapExtraSpace);
    RoundedRect := MapRect.FitInto(LRealBounds).Round;
    if FView=nil then
      RoundedRect.Left := Round(Screen.Size.cx * Scale);
    FJNativeLayout.setPosition(RoundedRect.TopLeft.X, RoundedRect.TopLeft.Y);
    FJNativeLayout.setSize(RoundedRect.Width, RoundedRect.Height);
  end;
end;

{ TNaviManager_NavEventLister }

procedure TNaviManager_NaviInitListener.initFailed;
begin
  //��ʼ��ʧ��
end;

procedure TNaviManager_NaviInitListener.initStart;
begin
  //��ʼ����ʼ
end;

procedure TNaviManager_NaviInitListener.initSuccess;
begin
  //��ʼ���ɹ�
  if FNaviService<>nil then
    FNaviService.DoInitTTS;
end;

procedure TNaviManager_NaviInitListener.onAuthResult(P1: Integer; P2: JString);
var
  state:integer;
  s:string;
begin
  // key У��  P1 = 0 У��ɹ�  ����У��ʧ��
  state:=P1;
  if P2 <>nil then
  begin
    s:=JStringToString(P2);
  end;
end;


{ TNaviManager_BaseListerer }

constructor TNaviManager_BaseListerer.Create(
  NaviService: TAndroidBaiduMapNaviService);
begin
  inherited Create;
  FNaviService:=NaviService;
end;

{ TNaviManager_RoutePlanListener }

procedure TNaviManager_RoutePlanListener.onJumpToNavigator;
begin
  if (FNaviService<>nil) then
    FNaviService.DoJumpToNavigator;
end;

procedure TNaviManager_RoutePlanListener.onRoutePlanFailed;
begin
  //��·ʧ��
end;

{ TJBNRouteGuideManager_OnNavigationListener }

procedure TJBNRouteGuideManager_OnNavigationListener.notifyOtherAction(P1, P2,
  P3: Integer; P4: JObject);
begin

end;

procedure TJBNRouteGuideManager_OnNavigationListener.onNaviGuideEnd;
begin
  TJBNRouteGuideManager.JavaClass.getInstance.onStop;
  TJBNRouteGuideManager.JavaClass.getInstance.onDestroy;
  FNaviService.FView:=nil;
  CallInUIThread(FNaviService.RealignView);
end;

{ TJBaiduNaviManager_TTSPlayStateListener }

procedure TJBaiduNaviManager_TTSPlayStateListener.playEnd;
begin

end;

procedure TJBaiduNaviManager_TTSPlayStateListener.playStart;
begin

end;

end.
