unit BaiduMapAPI.Search.CommTypes;
//author:Xubzhlin
//Email:371889755@qq.com

//�ٶȵ�ͼAPI ���� ������Ԫ

//TSearchResult �������

interface

uses
{$IFDEF Android}
  Androidapi.JNI.baidu.mapapi.search,
{$ENDIF}
{$IFDEF iOS}
  iOSapi.BaiduMapAPI_Base,
{$ENDIF}
  FMX.Maps;

type
  TSearchResult_ErrorNo = (
    NO_ERROR=0,                  ///<���������������
    RESULT_NOT_FOUND,            ///<û���ҵ��������
    AMBIGUOUS_KEYWORD,           ///<�����������
    AMBIGUOUS_ROURE_ADDR,        ///<������ַ�����
    NOT_SUPPORT_BUS,             ///<�ó��в�֧�ֹ�������
    NOT_SUPPORT_BUS_2CITY,       ///<��֧�ֿ���й���
    ST_EN_TOO_NEAR,              ///<���յ�̫��
    KEY_ERROR,                   ///<key����
    PERMISSION_UNFINISHED,       ///��δ��ɼ�Ȩ�����ڼ�Ȩͨ��������
    NETWORK_TIME_OUT,            ///�������ӳ�ʱ
    NETWORK_ERROR,               ///�������Ӵ���
    POIINDOOR_BID_ERROR,         ///����ͼID����
    POIINDOOR_FLOOR_ERROR,       ///����ͼ����¥�����
    POIINDOOR_SERVER_ERROR,      ///����ͼ�����������ڲ�����
    INDOOR_ROUTE_NO_IN_BUILDING, ///���յ㲻��֧������·�ߵ�����ͼ��
    INDOOR_ROUTE_NO_IN_SAME_BUILDING,///����·�߹滮���յ㲻��ͬһ������
    MASS_TRANSIT_SERVER_ERROR,   ///��ǹ�����ͨ�������ڲ�����
    MASS_TRANSIT_OPTION_ERROR,   ///��ǹ�����ͨ�����룺������Ч
    MASS_TRANSIT_NO_POI_ERROR,   ///��ǹ�����ͨû��ƥ���POI
    SEARCH_SERVER_INTERNAL_ERROR,///�������ڲ�����
    SEARCH_OPTION_ERROR,          ///��������
    REQUEST_ERROR///�������
    );

  TPoiType = (POINT = 0,  BUS_STATION = 1,  BUS_LINE = 2,  SUBWAY_STATION = 3,  SUBWAY_LINE = 4);

  TPoiInfo = record
    name:string;
    uid:string;
    address:string;
    city:string;
    phoneNum:string;
    postCode:string;
    &type:TPoiType;
    location:TMapCoordinate;
    isPano:Boolean;
    hasCaterDetails:Boolean;
  end;

  TCityInfo = record
    city:string;
    num:Integer;
  end;

  TPoiAddrInfo = record
    address:string;
    location:TMapCoordinate;
    name:string;
  end;

  TSearchResult = class(TObject)
    error:TSearchResult_ErrorNo;
  end;

  TRouteLineType = (
    BIKINGSTEP, //����
    DRIVESTEP,  //�ݳ�
    TRANSITSTEP,//����
    WALKSTEP    //����
  );

  //��ͨ���� ö��
  TStepVehicleInfoType = (
    ESTEP_BUS,//����
    ESTEP_COACH,//���
    ESTEP_DRIVING,//�ݳ�
    ESTEP_PLANE,//�ɻ�
    ESTEP_TRAIN,//��
    ESTEP_WALK//����
  );

  //
  TPriceInfo = record
    TicketPrice:Double;//��ȡƱ�۸�Ԫ��
    TicketType:Integer;//��ȡƱ����
  end;

  //·������ö��
  TTransitRouteStepType = (
    BUSLINE,//����·��
    SUBWAY,//����·��
    WAKLING//·��·��
  );

  //·�߻��˷�����Ľ�ͨ������Ϣ
  //��ͨ���߰����� ����������
  TVehicleInfo = record
    PassStationNum:Integer;//�ý�ͨ·�ߵ�����վ��
    Title:String;//�ý�ͨ·�ߵ�����
    TotalPrice:string;//�ý�ͨ·�ߵ�ȫ�̼۸�
    Uid:string;//�ý�ͨ·�ߵı�ʶ
    ZonePrice:Double;//�ý�ͨ·�ߵ��������������۸�
  end;

  TTransitResultNode = record
    CityId:Integer;//���б��
    CityName:String;//������
    Location:TMapCoordinate;//����
    SearchWord:string;//����ʱ�ؼ��֣��ڼ�����ģ�������ؽ����б�ʱ���С�
  end;

// ��������ת��
{$IFDEF Android}
function CreateErrorNo(error:JSearchResult_ERRORNO):TSearchResult_ERRORNO;
function CreatePoiType(AType:JPoiInfo_POITYPE):TPoiType;
{$ENDIF}
{$IFDEF iOS}
function CreateErrorNo(error:BMKSearchErrorCode):TSearchResult_ERRORNO;
function CreatePoiType(AType:integer):TPoiType;
{$ENDIF}


implementation

{$IFDEF Android}
function CreateErrorNo(error:JSearchResult_ERRORNO):TSearchResult_ERRORNO;
begin
  Result:=TSearchResult_ERRORNO.NO_ERROR;
  if error.equals(TJSearchResult_ERRORNO.JavaClass.NO_ERROR) then
    Result:=TSearchResult_ERRORNO.NO_ERROR
  else if error.equals(TJSearchResult_ERRORNO.JavaClass.RESULT_NOT_FOUND) then
    Result:=TSearchResult_ERRORNO.RESULT_NOT_FOUND
  else if error.equals(TJSearchResult_ERRORNO.JavaClass.AMBIGUOUS_KEYWORD) then
    Result:=TSearchResult_ERRORNO.AMBIGUOUS_KEYWORD
  else if error.equals(TJSearchResult_ERRORNO.JavaClass.AMBIGUOUS_ROURE_ADDR) then
    Result:=TSearchResult_ERRORNO.AMBIGUOUS_ROURE_ADDR
  else if error.equals(TJSearchResult_ERRORNO.JavaClass.NOT_SUPPORT_BUS) then
    Result:=TSearchResult_ERRORNO.NOT_SUPPORT_BUS
  else if error.equals(TJSearchResult_ERRORNO.JavaClass.NOT_SUPPORT_BUS_2CITY) then
    Result:=TSearchResult_ERRORNO.NOT_SUPPORT_BUS_2CITY
  else if error.equals(TJSearchResult_ERRORNO.JavaClass.ST_EN_TOO_NEAR) then
    Result:=TSearchResult_ERRORNO.ST_EN_TOO_NEAR
  else if error.equals(TJSearchResult_ERRORNO.JavaClass.KEY_ERROR) then
    Result:=TSearchResult_ERRORNO.KEY_ERROR
  else if error.equals(TJSearchResult_ERRORNO.JavaClass.PERMISSION_UNFINISHED) then
    Result:=TSearchResult_ERRORNO.PERMISSION_UNFINISHED
  else if error.equals(TJSearchResult_ERRORNO.JavaClass.NETWORK_TIME_OUT) then
    Result:=TSearchResult_ERRORNO.NETWORK_TIME_OUT
  else if error.equals(TJSearchResult_ERRORNO.JavaClass.NETWORK_ERROR) then
    Result:=TSearchResult_ERRORNO.NETWORK_ERROR
  else if error.equals(TJSearchResult_ERRORNO.JavaClass.POIINDOOR_BID_ERROR) then
    Result:=TSearchResult_ERRORNO.POIINDOOR_BID_ERROR
  else if error.equals(TJSearchResult_ERRORNO.JavaClass.POIINDOOR_FLOOR_ERROR) then
    Result:=TSearchResult_ERRORNO.POIINDOOR_FLOOR_ERROR
  else if error.equals(TJSearchResult_ERRORNO.JavaClass.POIINDOOR_SERVER_ERROR) then
    Result:=TSearchResult_ERRORNO.POIINDOOR_SERVER_ERROR
  else if error.equals(TJSearchResult_ERRORNO.JavaClass.INDOOR_ROUTE_NO_IN_BUILDING) then
    Result:=TSearchResult_ERRORNO.INDOOR_ROUTE_NO_IN_BUILDING
  else if error.equals(TJSearchResult_ERRORNO.JavaClass.INDOOR_ROUTE_NO_IN_SAME_BUILDING) then
    Result:=TSearchResult_ERRORNO.INDOOR_ROUTE_NO_IN_SAME_BUILDING
  else if error.equals(TJSearchResult_ERRORNO.JavaClass.MASS_TRANSIT_SERVER_ERROR) then
    Result:=TSearchResult_ERRORNO.MASS_TRANSIT_SERVER_ERROR
  else if error.equals(TJSearchResult_ERRORNO.JavaClass.MASS_TRANSIT_OPTION_ERROR) then
    Result:=TSearchResult_ERRORNO.MASS_TRANSIT_OPTION_ERROR
  else if error.equals(TJSearchResult_ERRORNO.JavaClass.MASS_TRANSIT_NO_POI_ERROR) then
    Result:=TSearchResult_ERRORNO.MASS_TRANSIT_NO_POI_ERROR
  else if error.equals(TJSearchResult_ERRORNO.JavaClass.SEARCH_SERVER_INTERNAL_ERROR) then
    Result:=TSearchResult_ERRORNO.SEARCH_SERVER_INTERNAL_ERROR
  else if error.equals(TJSearchResult_ERRORNO.JavaClass.SEARCH_OPTION_ERROR) then
    Result:=TSearchResult_ERRORNO.SEARCH_OPTION_ERROR;
end;

function CreatePoiType(AType:JPoiInfo_POITYPE):TPoiType;
begin
  if AType = TJPoiInfo_POITYPE.JavaClass.POINT then
    Result:=TPoiType.POINT
  else if AType = TJPoiInfo_POITYPE.JavaClass.BUS_STATION then
    Result:=TPoiType.BUS_STATION
  else if AType = TJPoiInfo_POITYPE.JavaClass.BUS_LINE then
    Result:=TPoiType.BUS_LINE
  else if AType = TJPoiInfo_POITYPE.JavaClass.SUBWAY_STATION then
    Result:=TPoiType.SUBWAY_STATION
  else if AType = TJPoiInfo_POITYPE.JavaClass.SUBWAY_LINE then
    Result:=TPoiType.SUBWAY_LINE
end;
{$ENDIF}

{$IFDEF iOS}
function CreateErrorNo(error:BMKSearchErrorCode):TSearchResult_ERRORNO;
begin
  case error of
    BMK_SEARCH_NO_ERROR:
      Result:=TSearchResult_ERRORNO.NO_ERROR;
    BMK_SEARCH_AMBIGUOUS_KEYWORD:
      Result:=TSearchResult_ERRORNO.AMBIGUOUS_KEYWORD;
    BMK_SEARCH_AMBIGUOUS_ROURE_ADDR:
      Result:=TSearchResult_ERRORNO.AMBIGUOUS_ROURE_ADDR;
    BMK_SEARCH_NOT_SUPPORT_BUS:
      Result:=TSearchResult_ERRORNO.NOT_SUPPORT_BUS;
    BMK_SEARCH_NOT_SUPPORT_BUS_2CITY:
      Result:=TSearchResult_ERRORNO.NOT_SUPPORT_BUS_2CITY;
    BMK_SEARCH_RESULT_NOT_FOUND:
      Result:=TSearchResult_ERRORNO.RESULT_NOT_FOUND;
    BMK_SEARCH_ST_EN_TOO_NEAR:
      Result:=TSearchResult_ERRORNO.ST_EN_TOO_NEAR;
    BMK_SEARCH_KEY_ERROR:
      Result:=TSearchResult_ERRORNO.KEY_ERROR;
    BMK_SEARCH_NETWOKR_ERROR:
      Result:=TSearchResult_ERRORNO.NETWORK_ERROR;
    BMK_SEARCH_NETWOKR_TIMEOUT:
      Result:=TSearchResult_ERRORNO.NETWORK_TIME_OUT;
    BMK_SEARCH_PERMISSION_UNFINISHED:
      Result:=TSearchResult_ERRORNO.PERMISSION_UNFINISHED;
    BMK_SEARCH_INDOOR_ID_ERROR:
      Result:=TSearchResult_ERRORNO.POIINDOOR_BID_ERROR;
    BMK_SEARCH_FLOOR_ERROR:
      Result:=TSearchResult_ERRORNO.POIINDOOR_FLOOR_ERROR;
    BMK_SEARCH_INDOOR_ROUTE_NO_IN_BUILDING:
      Result:=TSearchResult_ERRORNO.INDOOR_ROUTE_NO_IN_BUILDING;
    BMK_SEARCH_INDOOR_ROUTE_NO_IN_SAME_BUILDING:
      Result:=TSearchResult_ERRORNO.INDOOR_ROUTE_NO_IN_SAME_BUILDING;
    BMK_SEARCH_PARAMETER_ERROR:
      Result:=TSearchResult_ERRORNO.REQUEST_ERROR;
  end;
end;

function CreatePoiType(AType:integer):TPoiType;
begin
  //0:��ͨ�� 1:����վ 2:������· 3:����վ 4:������·
  case AType of
    0:Result:=TPoiType.POINT;
    1:Result:=TPoiType.BUS_STATION;
    2:Result:=TPoiType.BUS_LINE;
    3:Result:=TPoiType.SUBWAY_STATION;
    4:Result:=TPoiType.SUBWAY_LINE;
  end;
end;

{$ENDIF}

end.
