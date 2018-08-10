unit BaiduMapAPI.RoutePlanSearchService;
//author:Xubzhlin
//Email:371889755@qq.com

//�ٶȵ�ͼAPI ��·�滮���� ������Ԫ
//�ٷ�����:http://lbsyun.baidu.com/

interface

uses
  System.Generics.Collections, FMX.Maps, BaiduMapAPI.Search.CommTypes;

type
  TDrivingPolicy = (
    ECAR_AVOID_JAM,//�ݳ����ԣ� ���ӵ��
    ECAR_DIS_FIRST,//�ݳ˼������Գ�������̾���
    ECAR_FEE_FIRST,//�ݳ˼������Գ��������ٷ���
    ECAR_TIME_FIRST//�ݳ˼������Գ�����ʱ������
  );

  TDrivingTrafficPolicy = (
    ROUTE_PATH,//�ݳ�·�߲���·��
    ROUTE_PATH_AND_TRAFFIC//�ݳ�·�ߺ�·��
  );

  //���ڹ������˲���
  TTacticsIncity = (
    ETRANS_LEAST_TIME,//ʱ���
    ETRANS_LEAST_TRANSFER,//�ٻ���
    ETRANS_LEAST_WALK,//�ٲ���
    ETRANS_NO_SUBWAY,//��������
    ETRANS_SUBWAY_FIRST,//��������
    ETRANS_SUGGEST//�Ƽ�
  );

{$SCOPEDENUMS ON}
  //��ǹ������˲���
  TTacticsIntercity = (
    ETRANS_LEAST_PRICE,//�۸��
    ETRANS_LEAST_TIME,//ʱ���
    ETRANS_START_EARLY//������
  );
{$SCOPEDENUMS OFF}

  //��ǽ�ͨ��ʽ����
  TTransTypeIntercity = (
    ETRANS_COACH_FIRST,//�������
    ETRANS_PLANE_FIRST,//�ɻ�����
    ETRANS_TRAIN_FIRST//������
  );

  //���ɲ���
  TTransitPolicy = (
    EBUS_NO_SUBWAY,//�����������Գ�������������
    EBUS_TIME_FIRST,//�����������Գ�����ʱ������
    EBUS_TRANSFER_FIRST,//�����������Գ��������ٻ���
    EBUS_WALK_FIRST//�����������Գ��������ٲ��о���
  );

  //�������
  TPlanNodeType = (
    Location,   //����ȷ�����
    CityCode,   //���б���͵���ȷ�����
    City        //�������ƺ͵���ȷ�����
  );

  //���
  TPlanNode = record
    &type:TPlanNodeType;
    location:TMapCoordinate;
    cityCode:Integer;
    cityName:string;
    name:string;
  end;

  //���ڽ��
  TIndoorPlanNode = record
    footer:string;
    location:TMapCoordinate;
  end;

  //��·�滮���� ������
  TRoutePlanOption = class(TObject)
   from:TPlanNode;
   &to:TPlanNode;
  end;

  //���� �滮����
  TBikingRoutePlanOption = class(TRoutePlanOption)
  end;

  //�ݳ� �滮����
  TDrivingRoutePlanOption = class(TRoutePlanOption)
    CityName:string;
    Policy:TDrivingPolicy;
    trafficPolicy:TDrivingTrafficPolicy;
    wayPoints:TArray<TPlanNode>;
  end;

  //���� �滮����
  TIndoorRoutePlanOption = class(TObject)
   from:TIndoorPlanNode;
   &to:TIndoorPlanNode;
  end;

  //������ͨ���� �滮����
  TMassTransitRoutePlanOption = class(TRoutePlanOption)
    CoordType:string;
    PageIndex:integer;
    PageSize:Integer;
    TacticsIncity:TTacticsIncity;
    TacticsIntercity:TTacticsIntercity;
    TransTypeIntercity:TTransTypeIntercity;
  end;

  //ͬ�ǹ�����ͨ���� �滮����
  TTransitRoutePlanOption = class(TRoutePlanOption)
    CityName:string;
    Policy:TTransitPolicy;
  end;

  //���й滮����
  TWalkingRoutePlanOption = class(TRoutePlanOption)
  end;

  TRouteNode = record
    Location:TMapCoordinate;//��ȡ����
    Title:String;//����
    Uid:String;//���ڵ�ͬʱΪPOIʱ����
  end;

  //·���е�һ��·��
  TRouteStep = class(TObject)
    WayPoints:TList<TMapCoordinate>; //·���������ĵ������꼯��
    Distance:Integer; //·�γ��� ��λ:��
    Duration:Integer; //·�κ�ʱ ��λ:��
    constructor Create; virtual;
    destructor Destroy; override;
  end;

  //·�����ݽṹ�Ļ���,��ʾһ��·�ߣ�·�߿��ܰ�����·�߹滮�еĻ���/�ݳ�/����·��
  //����Ϊ·�����ݽṹ�Ļ��࣬һ���ע��������󼴿ɣ�����ֱ�����ɸ������
  TRouteLine<T:class> = class(TObject)
    &type:TRouteLineType;    //����
    Steps:TObjectList<T>; //������·
    Distance:Integer; //·�߳���
    Duration:Integer; //·�ߺ�ʱ
    Starting:TRouteNode;//�����Ϣ
    Terminal:TRouteNode;//�յ���Ϣ
    Title:string; //��·����

    constructor Create; virtual;
    destructor Destroy; override;
  end;

  TSuggestAddrInfo = record
    SuggestEndCity:TArray<TCityInfo>;//�յ�����б��������ص��ڵ�ǰ����û���ҵ����������������ң��򷵻�ӵ�иõص���Ϣ�ĳ����б�
    SuggestEndNode:TArray<TPoiInfo>; //�յ��ַѡ���б�,���յ���Ϣ������ʱ��䡣
    SuggestStartCity:TArray<TCityInfo>;//�������б��������ص��ڵ�ǰ����û���ҵ����������������ң��򷵻�ӵ�иõص���Ϣ�ĳ����б�
    SuggestStartNode:TArray<TPoiInfo>;//����ַѡ���б�,�������Ϣ����ʱ��䡣
  end;

  //������·�е�һ��·��
  TBikingStep = class(TRouteStep)
    Direction:Integer;  //��·����㷽��ֵ
    Entrance:TRouteNode;//·�������Ϣ
    EntranceInstructions:string; //·�������ʾ��Ϣ
    &Exit:TRouteNode;   //·���յ���Ϣ
    ExitInstructions:string; //·�γ���ָʾ��Ϣ
    Instructions:string; //·������ָʾ��Ϣ
  end;

  //һ�� ����·��
  TBikingRouteLine = class(TRouteLine<TBikingStep>)
  end;

  TRouteResult<T:class> = class(TSearchResult)
    RouteLines:TObjectList<T>; //ȡ���滮·��
    SuggestAddrInfo:TSuggestAddrInfo;//error Ϊ ERRORNO#AMBIGUOUS_ROURE_ADDR ʱ ��ͨ���˽ӿڻ�ȡ������Ϣ

    constructor Create;
    destructor Destroy; override;
  end;

  //���� �滮 �ص���
  TBikingRouteResult = class(TRouteResult<TBikingRouteLine>)
  end;

  TTaxiInfo = record
    Desc:string;//·�ߴ�������Ϣ
    Distance:Integer;//��·�� �� ��λ�� m
    Duration:Integer;//�ܺ�ʱ����λ�� ��
    PerKMPrice:Double;//ÿǧ�׵��ۣ���λ Ԫ , ע���˼۸�Ϊ����۸�
    StartPrice:Double;//�𲽼ۣ���λ�� Ԫ, ע���˼۸�Ϊ����۸�
    TotalPrice:Double;//�ܼ� , ��λ�� Ԫ, ע���˼۸�Ϊ����۸�
  end;

  TDrivingStep = class(TRouteStep)
    Direction:Integer;//���ظ�·����㷽��ֵ
    Entrance:TRouteNode;//·�������Ϣ
    EntranceInstructions:string;//·����ڵ�ָʾ��Ϣ
    &Exit:TRouteNode;//·�γ�����Ϣ
    ExitInstructions:string;//·�γ���ָʾ��Ϣ
    Instructions:string;//·������ָʾ��Ϣ
    NumTurns:Integer;//·����Ҫת����
    TrafficList:TArray<Integer>;//��ȡ·���������飬����ΪwayPoints����-1
    //0��û·����1����ͨ��2��������3��ӵ��
  end;

  //�ݳ�·��
  TDrivingRouteLine = class(TRouteLine<TDrivingStep>)
  end;

  //�ݳ� �滮 �ص���
  TDrivingRouteResult = class(TRouteResult<TDrivingRouteLine>)
  end;

  TIndoorStepNode = record
    Detail:string;//��ȡ��Ϣ������Ϣ
    Location:TMapCoordinate;//��ȡ����
    Name:string; //
    &Type:string;//��ȡ����;
  end;

  //����һ�����ڲ���·��
  TIndoorRouteStep = class(TRouteStep)
    BuildingId:String;//��ȡ������id
    Entrace:TRouteNode;//��ȡ���
    &Exit:TRouteNode;//��ȡ����
    FloorId:String;//��ȡ¥��id
    Instructions:String;//��ȡ·������ָʾ��Ϣ
    StepNodes:TList<TIndoorStepNode>;//��ȡstep�нڵ�
    constructor Create; override;
    destructor Destroy; override;
  end;

  //��ʾһ������·��
  TIndoorRouteLine = class(TRouteLine<TIndoorRouteStep>)
  end;

  //���� ���й滮 �ص���
  TIndoorRouteResult = class(TRouteResult<TIndoorRouteLine>)
  end;

  TTransitBaseInfo = class(TObject)
    ArriveStation:string;//��ȡ����վ�����ࣩ
    ArriveTime:string;//��ȡ����ʱ��
    DepartureStation:string;//��ȡ����վ(����)
    DepartureTime:string;//��ȡ����ʱ��
    Name:string;//��ȡ����
  end;

  //��������Ϣ
  TBusInfo = class(TTransitBaseInfo)
    StopNum:Integer;//���;��վ����
    &Type:Integer;//������ڹ����ľ�������
  end;

  //��ͳ���Ϣ
  TCoachInfo = class(TTransitBaseInfo)
    Price:Double;//��ȡ��Ʊ��
    ProviderName:string;//��ȡ����������
    ProviderUrl:string;//��ȡ������������ַ
  end;

  //������Ϣ
  TPlaneInfo = class(TTransitBaseInfo)
    Airlines:string;//��ȡ���չ�˾
    Booking:string;//��ȡ��Ʊ��ַ
    Discount:Double;//��ȡ�ۿ�
    Price:Double;//��ȡ��Ʊ��
  end;

  TTrainInfo = class(TTransitBaseInfo)
    Booking:string;//��ȡ��Ʊ�绰
    Price:Double;//��ȡ��Ʊ��
  end;

  TTrafficCondition = record
    TrafficGeoCnt:Integer;//��ȡ��·���ĵ���
    TrafficStatus:Integer;//��ȡ·��״̬��0��·����1��ͨ��2���У�3ӵ�£�4�ǳ�ӵ��
  end;

  //��ʾһ������·��
  TMassTransitStep = class(TRouteStep)
    BusInfo:TBusInfo;//��ȡ����������Ϣ
    CoachInfo:TCoachInfo;//��ȡ��;�����Ϣ
    EndLocation:TMapCoordinate;//��ȡ��·���յ�
    Instructions:String;//��ȡ��·�λ���˵��
    PlaneInfo:TPlaneInfo;//��ȡ�ɻ�������Ϣ
    StartLocation:TMapCoordinate;//��ȡ��·�����
    TrafficConditions:TArray<TTrafficCondition>;
    TrainInfo:TTrainInfo;//��ȡ�𳵾�����Ϣ
    VehileType:TStepVehicleInfoType;//��ȡ��·���н�ͨ��ʽ�����ͣ�1�𳵣�2�ɻ���3������4�ݳ���5���У�6���
  end;


  TTransitSteps = TObjectList<TMassTransitStep>;

  //��ʾһ����ǽ�ͨ����·�ߣ�����·�߽����ݼȶ����Ե�����ֽ�ͨ���ߡ�
  //����·�߿��ܰ��������й���·�Σ�����·�Σ�����·�Σ��ɻ������
  TMassTransitRouteLine = class(TRouteLine<TMassTransitStep>)
    ArriveTime:string;//��ȡ����·Ԥ�Ƶ���ʱ�䣬��ʽ��2016-04-05T17��06��10
    NewSteps:TObjectList<TTransitSteps>;//���ظ���·��step��Ϣ
    Price:Double;//��ȡ����·����Ʊ�ۣ�Ԫ��
    PriceInfo:TList<TPriceInfo>;//��ȡ��Ʊ��ϸ��Ϣ

    constructor Create; override;
    destructor Destroy; override;
  end;

  TMassTransitRouteResult = class(TRouteResult<TMassTransitRouteLine>)
    Destination:TTransitResultNode;//�յ�
    Origin:TTransitResultNode;//���
    TaxiInfo:TTaxiInfo;//����Ϣ
    Total:Integer;//����·������
  end;

  TTransitStep = class(TRouteStep)
    Entrance:TRouteNode;//·�������Ϣ
    &Exit:TRouteNode;//·�γ�����Ϣ
    Instructions:string;//��ȡ��·�λ���˵��
    StepType:TTransitRouteStepType;//��ȡ·������
    VehicleInfo:TVehicleInfo;//��·��Ϊ����·�λ����·��ʱ�����Ի�ȡ��ͨ������Ϣ
  end;

  //��ʾһ������·�ߣ�����·�߽����ݼȶ����Ե�����ֽ�ͨ���ߡ�
  //����·�߿��ܰ��������й���·�Σ�����·�Σ�����·��
  TTransitRouteLine = class(TRouteLine<TTransitStep>)
  end;

  //����·�߽��
  TTransitRouteResult = class(TRouteResult<TTransitRouteLine>)
    TaxiInfo:TTaxiInfo;//����Ϣ
  end;

  //����һ������·��
  TWalkingStep = class(TRouteStep)
    Direction:Integer; //��·����㷽��ֵ
    Entrance:TRouteNode; //��ȡ·�������Ϣ
    EntranceInstructions:string; //��ȡ·�������ʾ��Ϣ
    &Exit:TRouteNode; //��ȡ·���յ���Ϣ
    ExitInstructions:string; //��ȡ·�γ���ָʾ��Ϣ
    Instructions:string; //��ȡ·������ָʾ��Ϣ
  end;

  //��ʾһ������·��
  TWalkingRouteLine = class(TRouteLine<TWalkingStep>)
  end;

  //��ʾ����·�߽��
  TWalkingRouteResult = class(TRouteResult<TWalkingRouteLine>)
    TaxiInfo:TTaxiInfo;//����Ϣ
  end;

  //�ص�
  TOnGetWalkingRouteResult = procedure(Sender:TObject; RouteResult:TWalkingRouteResult) of object;
  TOnGetTransitRouteResult = procedure(Sender:TObject; RouteResult:TTransitRouteResult) of object;
  TOnGetMassTransitRouteResult = procedure(Sender:TObject; RouteResult:TMassTransitRouteResult) of object;
  TOnGetDrivingRouteResult = procedure(Sender:TObject; RouteResult:TDrivingRouteResult) of object;
  TOnGetIndoorRouteResult = procedure(Sender:TObject; RouteResult:TIndoorRouteResult) of object;
  TOnGetBikingRouteResult = procedure(Sender:TObject; RouteResult:TBikingRouteResult) of object;

  IBaiduMapRoutePlanSearchService = interface
  ['{B4FC312B-7205-4887-8589-82DCEB23942C}']
    //��������·�߹滮
    function bikingSearch(option:TBikingRoutePlanOption):Boolean;
    //����ݳ�·�߹滮
    function drivingSearch(option:TDrivingRoutePlanOption):Boolean;
    //�����ǹ���·�߼���
    function masstransitSearch(option:TMassTransitRoutePlanOption):Boolean;
    //���𻻳�·�߹滮
    function transitSearch(option:TTransitRoutePlanOption):Boolean;
    //��������·�߹滮
    function walkingIndoorSearch(option:TIndoorRoutePlanOption):Boolean;
    //������·�߹滮
    function walkingSearch(option:TWalkingRoutePlanOption):Boolean;
  end;

  TBaiduMapRoutePlanSearchService = class(TInterfacedObject, IBaiduMapRoutePlanSearchService)
  private
    FOnGetWalkingRouteResult:TOnGetWalkingRouteResult;
    FOnGetTransitRouteResult:TOnGetTransitRouteResult;
    FOnGetMassTransitRouteResult:TOnGetMassTransitRouteResult;
    FOnGetDrivingRouteResult:TOnGetDrivingRouteResult;
    FOnGetIndoorRouteResult:TOnGetIndoorRouteResult;
    FOnGetBikingRouteResult:TOnGetBikingRouteResult;
  protected
    function DobikingSearch(option:TBikingRoutePlanOption):Boolean; virtual;  abstract;
    function DodrivingSearch(option:TDrivingRoutePlanOption):Boolean; virtual;  abstract;
    function DomasstransitSearch(option:TMassTransitRoutePlanOption):Boolean; virtual;  abstract;
    function DotransitSearch(option:TTransitRoutePlanOption):Boolean; virtual;  abstract;
    function DowalkingIndoorSearch(option:TIndoorRoutePlanOption):Boolean; virtual;  abstract;
    function DowalkingSearch(option:TWalkingRoutePlanOption):Boolean; virtual;  abstract;

    procedure GetWalkingRouteResult (RouteResult:TWalkingRouteResult);
    procedure GetTransitRouteResult(RouteResult:TTransitRouteResult);
    procedure GetMassTransitRouteResult(RouteResult:TMassTransitRouteResult);
    procedure GetDrivingRouteResult(RouteResult:TDrivingRouteResult);
    procedure GetIndoorRouteResult(RouteResult:TIndoorRouteResult);
    procedure GetBikingRouteResult(RouteResult:TBikingRouteResult);

  public
    function bikingSearch(option:TBikingRoutePlanOption):Boolean;
    function drivingSearch(option:TDrivingRoutePlanOption):Boolean;
    function masstransitSearch(option:TMassTransitRoutePlanOption):Boolean;
    function transitSearch(option:TTransitRoutePlanOption):Boolean;
    function walkingIndoorSearch(option:TIndoorRoutePlanOption):Boolean;
    function walkingSearch(option:TWalkingRoutePlanOption):Boolean;

    property OnGetWalkingRouteResult:TOnGetWalkingRouteResult read FOnGetWalkingRouteResult write FOnGetWalkingRouteResult;
    property OnGetTransitRouteResult:TOnGetTransitRouteResult read FOnGetTransitRouteResult write FOnGetTransitRouteResult;
    property OnGetMassTransitRouteResult:TOnGetMassTransitRouteResult read FOnGetMassTransitRouteResult write FOnGetMassTransitRouteResult;
    property OnGetDrivingRouteResult:TOnGetDrivingRouteResult read FOnGetDrivingRouteResult write FOnGetDrivingRouteResult;
    property OnGetIndoorRouteResult:TOnGetIndoorRouteResult read FOnGetIndoorRouteResult write FOnGetIndoorRouteResult;
    property OnGetBikingRouteResult:TOnGetBikingRouteResult read FOnGetBikingRouteResult write FOnGetBikingRouteResult;
  end;

  TTBaiduMapRoutePlanSearch = class(TObject)
  private
    FRoutePlanSearchService:TBaiduMapRoutePlanSearchService;
  public
    constructor Create;
    destructor Destroy; override;

    property RoutePlanSearchService:TBaiduMapRoutePlanSearchService read FRoutePlanSearchService;
  end;

implementation

{$IFDEF IOS}
//uses
//  BaiduMapAPI.RoutePlanSearchService.iOS;
{$ENDIF}
{$IFDEF ANDROID}
uses
  BaiduMapAPI.RoutePlanSearchService.Android;
{$ENDIF ANDROID}

{ TBaiduMapRoutePlanSearchService }

function TBaiduMapRoutePlanSearchService.bikingSearch(
  option: TBikingRoutePlanOption): Boolean;
begin
  Result:=DobikingSearch(option);
end;

function TBaiduMapRoutePlanSearchService.drivingSearch(
  option: TDrivingRoutePlanOption): Boolean;
begin
  Result:=DodrivingSearch(option);
end;

procedure TBaiduMapRoutePlanSearchService.GetBikingRouteResult(
  RouteResult: TBikingRouteResult);
begin
  if Assigned(FOnGetBikingRouteResult) then
    FOnGetBikingRouteResult(Self, RouteResult);
end;

procedure TBaiduMapRoutePlanSearchService.GetDrivingRouteResult(
  RouteResult: TDrivingRouteResult);
begin
  if Assigned(FOnGetDrivingRouteResult) then
    FOnGetDrivingRouteResult(Self, RouteResult);
end;

procedure TBaiduMapRoutePlanSearchService.GetIndoorRouteResult(
  RouteResult: TIndoorRouteResult);
begin
  if Assigned(FOnGetIndoorRouteResult) then
    FOnGetIndoorRouteResult(Self, RouteResult);
end;

procedure TBaiduMapRoutePlanSearchService.GetMassTransitRouteResult(
  RouteResult: TMassTransitRouteResult);
begin
  if Assigned(FOnGetMassTransitRouteResult) then
    FOnGetMassTransitRouteResult(Self, RouteResult);
end;

procedure TBaiduMapRoutePlanSearchService.GetTransitRouteResult(
  RouteResult: TTransitRouteResult);
begin
  if Assigned(FOnGetTransitRouteResult) then
    FOnGetTransitRouteResult(Self, RouteResult);
end;

procedure TBaiduMapRoutePlanSearchService.GetWalkingRouteResult(
  RouteResult: TWalkingRouteResult);
begin
  if Assigned(FOnGetWalkingRouteResult) then
    FOnGetWalkingRouteResult(Self, RouteResult);
end;

function TBaiduMapRoutePlanSearchService.masstransitSearch(
  option: TMassTransitRoutePlanOption): Boolean;
begin
  Result:=DomasstransitSearch(option);
end;

function TBaiduMapRoutePlanSearchService.transitSearch(
  option: TTransitRoutePlanOption): Boolean;
begin
  Result:=DotransitSearch(option);
end;

function TBaiduMapRoutePlanSearchService.walkingIndoorSearch(
  option: TIndoorRoutePlanOption): Boolean;
begin
  Result:=DowalkingIndoorSearch(option);
end;

function TBaiduMapRoutePlanSearchService.walkingSearch(
  option: TWalkingRoutePlanOption): Boolean;
begin
  Result:=DowalkingSearch(option);
end;

{ TRouteStep }

constructor TRouteStep.Create;
begin
  inherited;
  WayPoints:=TList<TMapCoordinate>.Create;
end;

destructor TRouteStep.Destroy;
begin
  WayPoints.Free;
  inherited;
end;

{ TRouteLine<T> }

constructor TRouteLine<T>.Create;
begin
  inherited;
  Steps:=TObjectList<T>.Create;
end;

destructor TRouteLine<T>.Destroy;
begin
  Steps.Free;
  inherited;
end;

{ TRouteResult<T> }

constructor TRouteResult<T>.Create;
begin
  inherited;
  RouteLines:=TObjectList<T>.Create;
end;

destructor TRouteResult<T>.Destroy;
begin
  RouteLines.Free;
  inherited;
end;

{ TIndoorRouteStep }

constructor TIndoorRouteStep.Create;
begin
  inherited;
  StepNodes:=TList<TIndoorStepNode>.Create;
end;

destructor TIndoorRouteStep.Destroy;
begin
  StepNodes.Free;
  inherited;
end;

{ TMassTransitRouteLine }

constructor TMassTransitRouteLine.Create;
begin
  inherited;
  NewSteps:=TObjectList<TTransitSteps>.Create;
  PriceInfo:=TList<TPriceInfo>.Create;
end;

destructor TMassTransitRouteLine.Destroy;
begin
  NewSteps.Free;
  PriceInfo.Free;
  inherited;
end;

{ TTBaiduMapRoutePlanSearch }

constructor TTBaiduMapRoutePlanSearch.Create;
begin
  inherited Create;
{$IFDEF IOS}
  //FRoutePlanSearchService:=TiOSBaiduMapFoutePlanSearchService.Create;
{$ENDIF}
{$IFDEF ANDROID}
  FRoutePlanSearchService:=TAndroidBaiduMapRoutePlanSearchService.Create;
{$ENDIF ANDROID}
end;

destructor TTBaiduMapRoutePlanSearch.Destroy;
begin
  if FRoutePlanSearchService<>nil then
    FRoutePlanSearchService.Free;
  inherited;
end;

end.

