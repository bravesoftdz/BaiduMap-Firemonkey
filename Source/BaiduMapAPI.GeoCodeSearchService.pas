unit BaiduMapAPI.GeoCodeSearchService;
//author:Xubzhlin
//Email:371889755@qq.com

//�ٶȵ�ͼAPI ��ַ���롢������ ��Ԫ
//TGeoCodeOption ��������
//TAddressComponent ��ַ����Ĳ�λ���Ϣ
//TGeoCodeResult ��ַ������
//TReverseGeoCodeResult ����ַ������

interface

uses
  System.Generics.Collections, FMX.Maps, BaiduMapAPI.Search.CommTypes;

type
  TGeoCodeOption = record
    Address:string;
    City:string;
  end;

  TAddressComponent = record
    StreetNumber:string;  //�ֵ�����
    StreetName:string;    //�ֵ�����
    District:string;      //��������
    City:string;          //��������
    Province:string;      //ʡ������
    Country:string;       //����
    CountryCode:String;   //���Ҵ���
    AdCode:string;        //�����������
  end;

  TGeoCodeResult = class(TSearchResult)
    Location:TMapCoordinate;
    Address:string;
  end;

  TReverseGeoCodeResult = class(TSearchResult)
    AddressDetail:TAddressComponent;
    Address:string;
    BusinessCircle:string;
    SematicDescription:string;
    CityCode:string;
    Location:TMapCoordinate;
    PoiList:TList<TPoiInfo>;

    constructor Create;
    destructor Destroy; override;
  end;

  TOnGetGeoCodeResult = procedure(Sender:TObject; GeoCodeResult:TGeoCodeResult) of object;
  TOnGetReverseGeoCodeResult = procedure(Sender:TObject; ReverseResult:TReverseGeoCodeResult) of object;

  IBaiduMapGeoCodeSearchService = interface
    ['{141DD987-D594-4DA5-952B-6FD6546E1CCF}']
    function GeoCode(GeoCodeOption:TGeoCodeOption):Boolean;
    //���ݵ�ַ���Ʒ��ص�����Ϣ
    function ReverseGeoCode(Coordinate:TMapCoordinate):Boolean;
    //���ݵ������귵�ص�����Ϣ
  end;

  TBaiduMapGeoCodeSearchService = class(TInterfacedObject, IBaiduMapGeoCodeSearchService)
  private
    FOnGetGeoCodeResult:TOnGetGeoCodeResult;
    FOnGetReverseGeoCodeResult:TOnGetReverseGeoCodeResult;
  protected
    function DoGeoCode(GeoCodeOption:TGeoCodeOption):Boolean;  virtual;  abstract;
    function DoReverseGeoCode(Coordinate:TMapCoordinate):Boolean; virtual;  abstract;

    procedure GetGeoCodeResult(GeoCodeResult:TGeoCodeResult);
    procedure GetReverseGeoCodeResult(ReverseResult:TReverseGeoCodeResult);
  public
    function GeoCode(GeoCodeOption:TGeoCodeOption):Boolean;
    function ReverseGeoCode(Coordinate:TMapCoordinate):Boolean;
    property OnGetGeoCodeResult:TOnGetGeoCodeResult read FOnGetGeoCodeResult write FOnGetGeoCodeResult;
    property OnGetReverseGeoCodeResult:TOnGetReverseGeoCodeResult read FOnGetReverseGeoCodeResult write FOnGetReverseGeoCodeResult;
  end;

  TBaiduMapGeoCodeSearch = class(TObject)
  private
    FGeoCodeSearchService:TBaiduMapGeoCodeSearchService;
  public
    constructor Create;
    destructor Destroy; override;

    property GeoCodeSearchService:TBaiduMapGeoCodeSearchService read FGeoCodeSearchService;
  end;

implementation

{$IFDEF IOS}
uses
  BaiduMapAPI.GeoCodeSearchService.iOS;
{$ENDIF}
{$IFDEF ANDROID}
uses
  BaiduMapAPI.GeoCodeSearchService.Android;
{$ENDIF ANDROID}

{ TGeoCodeSearchService }

function TBaiduMapGeoCodeSearchService.GeoCode(GeoCodeOption: TGeoCodeOption): Boolean;
begin
  Result:=DoGeoCode(GeoCodeOption);
end;

procedure TBaiduMapGeoCodeSearchService.GetGeoCodeResult(
  GeoCodeResult: TGeoCodeResult);
begin
  if Assigned(FOnGetGeoCodeResult) then
    FOnGetGeoCodeResult(Self, GeoCodeResult);
end;

procedure TBaiduMapGeoCodeSearchService.GetReverseGeoCodeResult(
  ReverseResult: TReverseGeoCodeResult);
begin
  if Assigned(FOnGetReverseGeoCodeResult) then
    FOnGetReverseGeoCodeResult(Self, ReverseResult);
end;

function TBaiduMapGeoCodeSearchService.ReverseGeoCode(
  Coordinate: TMapCoordinate): Boolean;
begin
  Result:=DoReverseGeoCode(Coordinate);
end;

{ TBaiduMapGeoCodeSearch }

constructor TBaiduMapGeoCodeSearch.Create;
begin
  inherited Create;
  {$IFDEF IOS}
    FGeoCodeSearchService:=TiOSBaiduMapGeoCodeSearchService.Create;
  {$ENDIF}
  {$IFDEF ANDROID}
    FGeoCodeSearchService:=TAndroidBaiduMapGeoGodeearchService.Create;
  {$ENDIF ANDROID}
end;

destructor TBaiduMapGeoCodeSearch.Destroy;
begin
  if FGeoCodeSearchService<>nil then
    FGeoCodeSearchService.Free;
  inherited;
end;

{ TReverseGeoCodeResult }

constructor TReverseGeoCodeResult.Create;
begin
  inherited Create;
  PoiList:=TList<TPoiInfo>.Create;
end;

destructor TReverseGeoCodeResult.Destroy;
begin
  PoiList.Free;
  inherited;
end;

end.
