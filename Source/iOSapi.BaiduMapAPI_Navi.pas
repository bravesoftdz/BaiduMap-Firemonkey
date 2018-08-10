unit iOSapi.BaiduMapAPI_Navi;

{ *********************************************************** }
{ }
{ CodeGear Delphi Runtime Library }
{ }
{ Copyright(c) 2012-2014 Embarcadero Technologies, Inc. }
{ }
{ *********************************************************** }

//
// Delphi-Objective-C Bridge
// Interfaces for Cocoa framework BaiduNaviSDK
//

interface

uses
  Macapi.ObjectiveC,
  Macapi.ObjCRuntime,
  iOSapi.UIKit,
  iOSapi.CocoaTypes,
  iOSapi.CoreLocation,
  iOSapi.Foundation;

const
  BNAVI_ROUTEPLAN_ERROR_INVALIDSTARTENDNODE = 5000;   //���������������յ�
  BNAVI_ROUTEPLAN_ERROR_INPUTERROR = 5001;    //�ڵ���������
  BNAVI_ROUTEPLAN_ERROR_NODESTOONEAR = 5002;//�ڵ�֮�����̫��

  //    ��������5100��ʼ��
  BNAVI_ROUTEPLAN_ERROR_SEARCHFAILED =5100;   //����ʧ��

  //    ��λ����5200��ʼ��
  BNAVI_ROUTEPLAN_ERROR_LOCATIONFAILED = 5200;    //��ȡ����λ��ʧ��
  BNAVI_ROUTEPLAN_ERROR_LOCATIONSERVICECLOSED = 5201; //��λ����δ����

  //    ��·����������5030��ʼ��
  BNAVI_ROUTEPLAN_ERROR_NONETWORK = 5030; //���粻����
  BNAVI_ROUTEPLAN_ERROR_NETWORKABNORMAL = 5031;//�����쳣������������·�滮ʧ�ܡ��Զ��л���������·�滮���ͻ���Ԥ�����壩
  //    ��·���̴���5050��ʼ��
  BNAVI_ROUTEPLAN_ERROR_ROUTEPLANFAILED = 5050; //�޷�������·���ͻ���������·����id<0��
  BNAVI_ROUTEPLAN_ERROR_SETSTARTPOSFAILED = 5051;//���ʧ��
  BNAVI_ROUTEPLAN_ERROR_SETENDPOSFAILED = 5052;   //�����յ�ʧ��
  BNAVI_ROUTEPLAN_ERROR_WAITAMOMENT = 5054;   //�ϴ���·ȡ���ˣ���Ҫ��һ��
  BNAVI_ROUTEPLAN_ERROR_DATANOTREADY = 5055;  //������������û��
  BNAVI_ROUTEPLAN_ERROR_ENGINENOTINIT = 5056; //����δ��ʼ��
  BNAVI_ROUTEPLAN_ERROR_LIGHTSEARCHERROR = 5057;//light����δ�ɹ�����

  BNRoutePlanMode_Invalid 			= $00000000 ;  //**<  ��Чֵ */
  BNRoutePlanMode_Recommend			= $00000001 ;	//**<  �Ƽ� */
  BNRoutePlanMode_Highway             = $00000002 ;	//**<  �������� */
  BNRoutePlanMode_NoHighway           = $00000004 ;	//**<  ���߸��� */
  BNRoutePlanMode_NoToll              = $00000008 ;	//**<  ���շ� */
  BNRoutePlanMode_AvoidTrafficJam     = $00000010 ;	//**<  ���ӵ�£����߹滮���У� */


type
  BNAVI_ROUTEPLAN_ERROR = Cardinal;
  BNRoutePlanMode = Cardinal;
  //����ģʽ
  BN_Speak_Mode_Enum = (
    BN_Speak_Mode_High,                //**< ����ģʽ */
    BN_Speak_Mode_Mid,                 //**< ר��ģʽ */
    BN_Speak_Mode_Low                 //**< ����ģʽ */
  );

  //���죬��ҹģʽ����
  BNDayNight_CFG_Type = (
    BNDayNight_CFG_Type_Auto,   //�Զ�
    BNDayNight_CFG_Type_Day,    //����ģʽ
    BNDayNight_CFG_Type_Night  //��ҹģʽ
  );

  BNCoordinate_Type = (
    BNCoordinate_OriginalGPS = 0,//**< ԭʼ�ľ�γ������ */
    BNCoordinate_BaiduMapSDK = 1 //**< �Ӱٶȵ�ͼ�л�ȡ��sdk */
  );

  BNaviUIType =
  (
    BNaviUI_Unknown = 0,
    BNaviUI_NormalNavi,       //��������
    BNaviUI_Declaration       //����ҳ��
  );

  BNavi_ExitPage_Type =
  (
    EN_BNavi_ExitTopVC,
    EN_BNavi_ExitAllVC
  );

  TInitServicesBlock = procedure of object;
  TTrySetShowTrafficInNaviBlock = procedure of object;
  TGetCityIDByLocationSucessBlock = procedure(parame:Integer) of object;
  TGetCityIDByLocationFailBlock = procedure of object;

  BNLocation = interface;
  BNHeading = interface;
  BNCoreServices = interface;
  BNaviModel = interface;
  BNPosition = interface;
  BNRoutePlanNode =interface;
  BNRouteItem = interface;
  BNRouteDetailInfo = interface;
  BNaviCalcRouteTime = interface;
  BNUIManagerProtocol = interface;
  BNNaviUIManagerDelegate = interface;
  BNStrategyManagerProtocol = interface;
  BNRoutePlanManagerProtocol = interface;
  BNNaviRoutePlanDelegate = interface;
  BNLocationManagerProtocol = interface;

  BNLocationClass = interface(NSObjectClass)
    ['{B81FDBDA-9495-448D-900E-3B104625E70F}']
  end;
  BNLocation = interface(NSObject)
    ['{3F6C4E00-E241-4940-8464-1783EC8EC834}']
    //wgs84ll��ʽ�ľ�γ��
    procedure setCoordinate(coordinate:CLLocationCoordinate2D); cdecl;
    function getCoordinate:CLLocationCoordinate2D; cdecl;
    //���Σ���λΪ��
    procedure setAltitude(altitude:CLLocationDistance); cdecl;
    function getAltitude:CLLocationDistance; cdecl;
    //ˮƽ���ȣ���λΪ��
    procedure setHorizontalAccuracy(horizontalAccuracy:CLLocationAccuracy); cdecl;
    function getHorizontalAccuracy:CLLocationAccuracy; cdecl;
    //��ֱ���ȣ���λΪ��
    procedure setVerticalAccuracy(verticalAccuracy:CLLocationAccuracy); cdecl;
    function getVerticalAccuracy:CLLocationAccuracy; cdecl;
    //����Ƕȣ���λΪ�ȣ���Χλ0.0-359.9��0��ʾ����
    procedure setCourse(course:CLLocationDirection); cdecl;
    function getCourse:CLLocationDirection; cdecl;
    //�ٶȣ���λΪ��/��
    procedure setSpeed(speed:CLLocationSpeed); cdecl;
    function getSpeed:CLLocationSpeed; cdecl;

    procedure setTimestamp(timestamp:NSDate); cdecl;
    function getTimestamp:NSDate; cdecl;
  end;
  TBNLocation = class(TOCGenericImport<BNLocationClass, BNLocation>)end;

  BNHeadingClass = interface(NSObjectClass)
    ['{9A7ACBFE-4593-42C6-9CEE-1226431F12B7}']
  end;
  BNHeading = interface(NSObject)
    ['{29AC6F33-57DD-484A-8CEA-6545D39656FC}']
    procedure setMagneticHeading(magneticHeading:CLLocationDirection); cdecl;
    function getMagneticHeading:CLLocationDirection; cdecl;
    //��ת�Ǿ���
    procedure setHeadingAccuracy(headingAccuracy:CLLocationDirection); cdecl;
    function getHeadingAccuracy:CLLocationDirection; cdecl;
    //��ת�Ƕȴ�С����λλ�ȣ���Χλ0-359.9��0��ʾ����
    procedure setTrueHeading(trueHeading:CLLocationDirection); cdecl;
    function getTrueHeading:CLLocationDirection; cdecl;
  end;
  TBNHeading = class(TOCGenericImport<BNHeadingClass, BNHeading>)end;


  BNCoreServicesClass = interface(NSObjectClass)
    ['{3C4D4B4C-CE82-416A-A2A8-20B64757F7D1}']
    function GetInstance:BNCoreServices; cdecl;
    procedure ReleaseInstance; cdecl;
    function libVersion:NSString; cdecl;
    function UIService:Pointer; cdecl;
    function RoutePlanService:Pointer; cdecl;
    function StrategyService:Pointer; cdecl;
    function LocationService:Pointer; cdecl;
  end;
  BNCoreServices = interface(NSObject)
    ['{485F517E-B514-49D2-892E-D9F7C2944479}']
    procedure initServices(ak:NSString); cdecl;
    procedure setTTSAppId(appId:NSString); cdecl;
    procedure setAutoExitNavi(autoExit:Boolean); cdecl;
    function startServices:Boolean; cdecl;
    [MethodName('startServicesAsyn:fail:')]
    procedure startServicesAsyn(success:TInitServicesBlock; fail:TInitServicesBlock); cdecl;
    function isServicesInited:Boolean; cdecl;
    procedure stopServices; cdecl;
    function convertToBD09MCWithWGS84ll(coordinate:CLLocationCoordinate2D):CLLocationCoordinate2D; cdecl;
  end;
  TBNCoreServices = class(TOCGenericImport<BNCoreServicesClass, BNCoreServices>)end;

  BNaviModelClass = interface(NSObjectClass)
    ['{B9800974-3ACA-4805-8397-974D72766DCD}']
    function getInstance:BNaviModel;  cdecl;
  end;
  BNaviModel = interface(NSObject)
    ['{B7A4FF7F-8388-4C87-A9C2-3C2B5CF860E5}']
    function getNaviViewController:UIViewController; cdecl;
    procedure exitNavi; cdecl;
    procedure resetNaviEndPoint(endNode:BNRoutePlanNode); cdecl;
  end;
  TBNaviModel = class(TOCGenericImport<BNaviModelClass, BNaviModel>)end;

  BNPositionClass = interface(NSObjectClass)
    ['{91339D2E-BF8F-4BFB-8784-D9A92C2C7212}']
  end;
  BNPosition = interface(NSObject)
    ['{A79670A5-3B75-4D48-847F-A417A87B052E}']
    procedure setX(x:double); cdecl;
    function getX:double; cdecl;
    procedure setY(y:double);  cdecl;
    function getY:double;  cdecl;
    procedure setEType(eType:BNCoordinate_Type); cdecl;
    function getEType:BNCoordinate_Type; cdecl;
  end;
  TBNPosition = class(TOCGenericImport<BNPositionClass, BNPosition>)end;

  BNRoutePlanNodeClass = interface(NSObjectClass)
    ['{764394AA-1A75-4307-8184-F0374FF39405}']
  end;
  BNRoutePlanNode = interface(NSObject)
    ['{C0B65A7C-2E36-4C1D-AB0B-8091010B0559}']
    procedure setPos(pos:BNPosition); cdecl;
    function getPos:BNPosition; cdecl;
    procedure setCityID(cityID:NSString); cdecl;
    function getCityID:NSString; cdecl;
    procedure setTitle(title:NSString); cdecl;
    function getTitle:NSString; cdecl;
    procedure setAddress(address:NSString); cdecl;
    function getAddress:NSString; cdecl;
  end;
  TBNRoutePlanNode = class(TOCGenericImport<BNRoutePlanNodeClass, BNRoutePlanNode>)end;

  BNRouteItemClass = interface(NSObjectClass)
    ['{AC2ED442-3274-46AB-9BB6-BDB95412ABFF}']
  end;
  BNRouteItem = interface(NSObject)
    ['{F231D3AA-832D-479D-9CB9-2793816D8280}']
    procedure setNextRoadName(nextRoadName:NSString); cdecl;
    function getNextRoadName:integer; cdecl;
    procedure setNLength(nLength:integer); cdecl;
    function getNLength:NSString; cdecl;
    procedure setNTime(nTime:integer); cdecl;
    function getNTime:integer; cdecl;
    procedure setCrossPos(crossPos:BNPosition); cdecl;
    function getCrossPos:BNPosition; cdecl;
    procedure setNShapePointIdx(nShapePointIdx:integer); cdecl;
    function getNShapePointIdx:integer; cdecl;
    procedure setNnOutLinkAngle(unOutLinkAngle:integer); cdecl;
    function getNnOutLinkAngle:integer; cdecl;
  end;
  TBNRouteItem = class(TOCGenericImport<BNRouteItemClass, BNRouteItem>)end;

  BNRouteDetailInfoClass = interface(NSObjectClass)
    ['{9942B722-C804-4626-B108-A1C7F454427B}']
  end;
  BNRouteDetailInfo = interface(NSObject)
    ['{4792BDE8-60AB-46A9-B23C-A33109789B91}']
    procedure setUnLabel(unLabel:integer); cdecl;
    function getUnLabel:integer; cdecl;
    procedure setUnLength(unLength:integer); cdecl;
    function getUnLength:integer; cdecl;
    procedure setUnPasstime(unPasstime:integer); cdecl;
    function getUnPasstime:integer; cdecl;
    procedure setRouteItemList(routeItemList:NSArray); cdecl;
    function getRouteItemList:NSArray; cdecl;
    procedure setBTolled(bTolled:boolean); cdecl;
    function getBTolled:boolean; cdecl;
  end;
  TBNRouteDetailInfo = class(TOCGenericImport<BNRouteDetailInfoClass, BNRouteDetailInfo>)end;

  BNaviCalcRouteTimeClass = interface(NSObjectClass)
    ['{F9A780AE-AFCD-4E67-90FF-13AB9850613D}']
  end;
  BNaviCalcRouteTime = interface(NSObject)
    ['{D20F39A8-3638-4C9E-A829-F8F5C3722586}']
    procedure setUnHour(unHour:integer); cdecl;
    function getUnHour:integer; cdecl;
    procedure setUnMin(unMin:integer); cdecl;
    function getUnMin:integer; cdecl;
    procedure setBValid(bValid:boolean); cdecl;
    function getBValid:boolean; cdecl;
  end;
  TBNaviCalcRouteTime = class(TOCGenericImport<BNaviCalcRouteTimeClass, BNaviCalcRouteTime>)end;
  (*
  BNUIManagerProtocolClass = interface(NSObjectClass)
    ['{83EC2B9A-4CAA-44B8-89ED-54C3029CEA1B}']
  end;
  BNUIManagerProtocol = interface(NSObject)
    ['{1393677B-B2D9-47FD-B276-B12BC439899F}']
    function navigationController:Pointer;  cdecl;
    [MethodName('showPage:delegate:extParams:')]
    procedure showPage(pageType:BNaviUIType; delegate:Pointer; extParams:NSDictionary); cdecl;
    [MethodName('exitPage:animated:extraInfo:')]
    procedure exitPage(exitType:BNavi_ExitPage_Type; animated:Boolean; extraInfo:NSDictionary); cdecl;
    function isInNaviPage:Boolean; cdecl;
  end;
  TBNUIManagerProtocol = class(TOCGenericImport<BNUIManagerProtocolClass, BNUIManagerProtocol>)end;
  *)

  BNUIManagerProtocol = interface(IObjectiveC)
    ['{1393677B-B2D9-47FD-B276-B12BC439899F}']
    function navigationController:Pointer;  cdecl;
    [MethodName('showPage:delegate:extParams:')]
    procedure showPage(pageType:BNaviUIType; delegate:Pointer; extParams:NSDictionary); cdecl;
    [MethodName('exitPage:animated:extraInfo:')]
    procedure exitPage(exitType:BNavi_ExitPage_Type; animated:Boolean; extraInfo:NSDictionary); cdecl;
    function isInNaviPage:Boolean; cdecl;
  end;

  BNNaviUIManagerDelegate = interface(IObjectiveC)
    ['{24DED9C2-3501-478A-9896-5DCB36B19FD8}']
    function naviPresentedViewController:Pointer; cdecl;
    [MethodName('extraInfo:extraInfo:')]
    procedure onExitPage(pageType:BNaviUIType; extraInfo:NSDictionary); cdecl;
  end;
  (*
  BNStrategyManagerProtocolClass = interface(NSObjectClass)
    ['{E752353F-A360-4EF0-8705-B34C881CDBAF}']
  end;
  BNStrategyManagerProtocol = interface(NSObject)
    ['{31068385-1040-4CF3-BA29-623FC2E968EC}']
    procedure reset; cdecl;
    procedure setParkInfo(parkInfo:Boolean); cdecl;
    function getParkInfo:Boolean; cdecl;
    procedure setDayNightType(dayNightType:BNDayNight_CFG_Type); cdecl;
    function getDayNightType:BNDayNight_CFG_Type; cdecl;
    procedure setSpeakMode(speakMode:BN_Speak_Mode_Enum); cdecl;
    function getSpeakMode:BN_Speak_Mode_Enum; cdecl;
    [MethodName('trySetShowTrafficInNavi:success:fail:')]
    procedure trySetShowTrafficInNavi(showTraffic:Boolean; success:TTrySetShowTrafficInNaviBlock; fail:TTrySetShowTrafficInNaviBlock); cdecl;
  end;
  TBNStrategyManagerProtocol = class(TOCGenericImport<BNStrategyManagerProtocolClass, BNStrategyManagerProtocol>)end;
  *)
  BNStrategyManagerProtocol = interface(IObjectiveC)
    ['{31068385-1040-4CF3-BA29-623FC2E968EC}']
    procedure reset; cdecl;
    procedure setParkInfo(parkInfo:Boolean); cdecl;
    function getParkInfo:Boolean; cdecl;
    procedure setDayNightType(dayNightType:BNDayNight_CFG_Type); cdecl;
    function getDayNightType:BNDayNight_CFG_Type; cdecl;
    procedure setSpeakMode(speakMode:BN_Speak_Mode_Enum); cdecl;
    function getSpeakMode:BN_Speak_Mode_Enum; cdecl;
    [MethodName('trySetShowTrafficInNavi:success:fail:')]
    procedure trySetShowTrafficInNavi(showTraffic:Boolean; success:TTrySetShowTrafficInNaviBlock; fail:TTrySetShowTrafficInNaviBlock); cdecl;
  end;

  BNRoutePlanManagerProtocolClass = interface(NSObjectClass)
    ['{391E8C57-7FBE-40EA-9B25-909714F741B3}']
  end;
  BNRoutePlanManagerProtocol = interface(NSObject)
    ['{A58C4EB2-62D0-458F-A17F-0EACB57E7CCB}']
    [MethodName('startNaviRoutePlan:naviNodes:time:delegete:userInfo:')]
    procedure startNaviRoutePlan(eMode:BNRoutePlanMode; naviNodes:NSArray; naviTime:BNaviCalcRouteTime; delegate:Pointer; userInfo:NSDictionary); cdecl;
    function getCurNodeCount:NSInteger; cdecl;
    function getNaviNodeAtIndex(index:NSInteger):BNRoutePlanNode; cdecl;
    procedure setNaviNodes(naviNodes:NSArray); cdecl;
    function getCurRoutePlanMode:Integer; cdecl;
    function GetCurrentSelectRouteIdx:NSInteger; cdecl;
    function getCurrentRouteDetailInfo(stRouteIdx:Integer):BNRouteDetailInfo; cdecl;
    function getCurrentPreference:Integer; cdecl;
    procedure setDisableOpenUrl(disableOpenUrl:Boolean); cdecl;
    function getDisableOpenUrl:Boolean; cdecl;
  end;
  TBNRoutePlanManagerProtocol = class(TOCGenericImport<BNRoutePlanManagerProtocolClass, BNRoutePlanManagerProtocol>)end;

  (*
  BNRoutePlanManagerProtocol = interface(IObjectiveC)
    ['{A58C4EB2-62D0-458F-A17F-0EACB57E7CCB}']
    [MethodName('startNaviRoutePlan:naviNodes:time:delegete:userInfo:')]
    procedure startNaviRoutePlan(eMode:BNRoutePlanMode; naviNodes:NSArray; naviTime:BNaviCalcRouteTime; delegate:Pointer; userInfo:NSDictionary); cdecl;
    function getCurNodeCount:NSInteger; cdecl;
    function getNaviNodeAtIndex(index:NSInteger):BNRoutePlanNode; cdecl;
    procedure setNaviNodes(naviNodes:NSArray); cdecl;
    function getCurRoutePlanMode:Integer; cdecl;
    function GetCurrentSelectRouteIdx:NSInteger; cdecl;
    function getCurrentRouteDetailInfo(stRouteIdx:Integer):BNRouteDetailInfo; cdecl;
    function getCurrentPreference:Integer; cdecl;
    procedure setDisableOpenUrl(disableOpenUrl:Boolean); cdecl;
    function getDisableOpenUrl:Boolean; cdecl;
  end;
  *)

  BNNaviRoutePlanDelegate = interface(IObjectiveC)
    ['{EBD69F8D-AAE8-4715-809A-23ED3B936C51}']
    procedure routePlanDidFinished(userInfo:NSDictionary); cdecl;
    procedure searchDidFinished(userInfo:NSDictionary); cdecl;
    [MethodName('routePlanDidFailedWithError:andUserInfo:')]
    procedure routePlanDidFailedWithError(error:NSError; userInfo:NSDictionary); cdecl;
    procedure routePlanDidUserCanceled(userInfo:NSDictionary); cdecl;
    procedure updateRoadConditionDidFinished(pbData:NSData); cdecl;
    procedure updateRoadConditionFailed(pbData:NSData); cdecl;
  end;
  (*
  BNLocationManagerProtocolClass = interface(NSObjectClass)
    ['{0248EB89-AE97-4785-87A7-4A292CB5B0F3}']
  end;
  BNLocationManagerProtocol = interface(NSObject)
    ['{C8B4AD58-A7F5-4BA0-A6BB-03315A7DC003}']
    procedure startUpdate; cdecl;
    procedure stopUpdate; cdecl;
    function getLastLocation:CLLocation; cdecl;
    procedure getCityIDByLocation(location:CLLocationCoordinate2D; sucess:TGetCityIDByLocationSucessBlock; fail:TGetCityIDByLocationFailBlock); cdecl;
    procedure setGpsFromExternal(gpsFromExternal:Boolean); cdecl;
    function getGpsFromExternal:Boolean; cdecl;
    procedure setCurrentLocation(currentLocation:Boolean); cdecl;
    function getCurrentLocation:Boolean; cdecl;
  end;
  TBNLocationManagerProtocol = class(TOCGenericImport<BNLocationManagerProtocolClass, BNLocationManagerProtocol>)end;
  *)
  BNLocationManagerProtocol = interface(CLLocationManagerDelegate)
    ['{C8B4AD58-A7F5-4BA0-A6BB-03315A7DC003}']
    procedure startUpdate; cdecl;
    procedure stopUpdate; cdecl;
    function getLastLocation:CLLocation; cdecl;
    procedure getCityIDByLocation(location:CLLocationCoordinate2D; sucess:TGetCityIDByLocationSucessBlock; fail:TGetCityIDByLocationFailBlock); cdecl;
    procedure setGpsFromExternal(gpsFromExternal:Boolean); cdecl;
    function getGpsFromExternal:Boolean; cdecl;
    procedure setCurrentLocation(currentLocation:Boolean); cdecl;
    function getCurrentLocation:Boolean; cdecl;
  end;

implementation

{$O-}
//iOS ���� Ŀǰ���������⣬����� ��������
//function BNCoreServices_FakeLoader:BNCoreServices; cdecl; external 'GYunits\BaiduLBS_iOSSDK_lib\BaiduNaviSDK\libbaiduNaviSDK.a' name 'OBJC_CLASS_$_BNCoreServices';
//function BNRoutePlanNode_FakeLoader:BNCoreServices; cdecl; external 'GYunits\BaiduLBS_iOSSDK_lib\BaiduNaviSDK\libbaiduNaviSDK.a' name 'OBJC_CLASS_$_BNRoutePlanNode';
{$O+}

end.
