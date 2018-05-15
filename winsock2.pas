{$MINENUMSIZE 4} { Force 4 bytes enumeration size}
unit WinSock2;

interface

uses Windows;

type
  u_char = Char;
  u_short = Word;
  u_int = Integer;
  u_long = Longint;
  pu_long = ^u_long;
  pu_short = ^u_short;

  TSocket = u_int;

const
  IOCPARM_MASK = $7f;
  IOC_OUT      = $40000000;
  IOC_IN       = $80000000;

  FIONREAD     = IOC_OUT or { get # bytes to read }
    ((Longint(SizeOf(Longint)) and IOCPARM_MASK) shl 16) or
    (Longint(Byte('f')) shl 8) or 127;
  FIONBIO      = IOC_IN or { set/clear non-blocking i/o }
    ((Longint(SizeOf(Longint)) and IOCPARM_MASK) shl 16) or
    (Longint(Byte('f')) shl 8) or 126;

const

{ Protocols }

  IPPROTO_TCP    =   6;		{ TCP           			}

type
  SunB = packed record
    s_b1, s_b2, s_b3, s_b4: u_char;
  end;

  SunW = packed record
    s_w1, s_w2: u_short;
  end;

  PInAddr = ^TInAddr;
  TInAddr = packed record
    case integer of
      0: (S_un_b: SunB);
      1: (S_un_w: SunW);
      2: (S_addr: u_long);
  end;

  PSockAddrIn = ^TSockAddrIn;
  TSockAddrIn = packed record
    case Integer of
      0: (sin_family: u_short;
          sin_port: u_short;
          sin_addr: TInAddr;
          sin_zero: array[0..7] of Char);
      1: (sa_family: u_short;
          sa_data: array[0..13] of Char)
  end;

const
  WSADESCRIPTION_LEN     =   256;
  WSASYS_STATUS_LEN      =   128;

type
  PWSAData = ^TWSAData;
  TWSAData = packed record
    wVersion: Word;
    wHighVersion: Word;
    szDescription: array[0..WSADESCRIPTION_LEN] of Char;
    szSystemStatus: array[0..WSASYS_STATUS_LEN] of Char;
    iMaxSockets: Word;
    iMaxUdpDg: Word;
    lpVendorInfo: PChar;
  end;

const

{ This is used instead of -1, since the
  TSocket type is unsigned.}

  INVALID_SOCKET		= TSocket(NOT(0));
  SOCKET_ERROR		= -1;

{ Types }

  SOCK_STREAM     = 1;               { stream socket }

{ Address families. }

  AF_INET         = 2;               { internetwork: UDP, TCP, etc. }

type
  { Structure used by kernel to store most addresses. }

  PSockAddr = ^TSockAddr;
  TSockAddr = TSockAddrIn;

const

  PF_INET         = AF_INET;

type

  SOCKADDR     = TSockAddr;
{  PSOCKADDR    = PSockaddr;}
  LPSOCKADDR   = PSockaddr;


{ Socket function prototypes }

var
  closesocket: function(s: TSocket): Integer; stdcall;
  connect: function(s: TSocket; name: PSockAddr; namelen: Integer): Integer; stdcall;
  ioctlsocket: function(s: TSocket; cmd: Longint; var arg: u_long): Integer; stdcall;
  htons: function(hostshort: u_short): u_short; stdcall;
  inet_addr: function(cp: PChar): u_long; stdcall; {PInAddr;}  { TInAddr }
  recv: function(s: TSocket; var Buf; len, flags: Integer): Integer; stdcall;
  send: function(s: TSocket; var Buf; len, flags: Integer): Integer; stdcall;
  socket: function(af, struct, protocol: Integer): TSocket; stdcall;
  WSAStartup: function(wVersionRequired: word; var WSData: TWSAData): Integer; stdcall;
  WSACleanup: function: Integer; stdcall;
  WSAAsyncSelect: function(s: TSocket; HWindow: HWND; wMsg: u_int; lEvent: Longint): Integer; stdcall;

//  function WSAGetLastError: Integer; stdcall;

  function isWinSock2Supported: boolean;

implementation

const
  winsocket = 'ws2_32.dll';

{function closesocket;
         external    winsocket name 'closesocket';
function connect;
         external    winsocket name 'connect';
function htons;
         external    winsocket name 'htons';
function inet_addr;
         external    winsocket name 'inet_addr';
function ioctlsocket;
         external    winsocket name 'ioctlsocket';
function recv;
         external    winsocket name 'recv';
function send;
         external    winsocket name 'send';
function socket;
         external    winsocket name 'socket';
function WSAAsyncSelect;
         external    winsocket name 'WSAAsyncSelect';
function WSAStartup;
         external     winsocket name 'WSAStartup';
function WSACleanup;
         external     winsocket name 'WSACleanup';
}
//function WSAGetLastError;
//         external    winsocket name 'WSAGetLastError';

var
  hWinSock2Lib: longint = 0;

function isWinSock2Supported: boolean;
begin
  Result := hWinSock2Lib > 0;
end;

initialization

  hWinSock2Lib := LoadLibrary(winsocket);
  if hWinSock2Lib = 0 then
  begin
    closesocket := nil;
    connect := nil;
    ioctlsocket := nil;
    htons := nil;
    inet_addr := nil;
    recv := nil;
    send := nil;
    socket := nil;
    WSAStartup := nil;
    WSACleanup := nil;
    WSAAsyncSelect := nil;
  end
  else
  begin
    closesocket := Pointer(GetProcAddress(hWinSock2Lib, 'closesocket'));
    connect := Pointer(GetProcAddress(hWinSock2Lib, 'connect'));
    ioctlsocket := Pointer(GetProcAddress(hWinSock2Lib, 'ioctlsocket'));
    htons := Pointer(GetProcAddress(hWinSock2Lib, 'htons'));
    inet_addr := Pointer(GetProcAddress(hWinSock2Lib, 'inet_addr'));
    recv := Pointer(GetProcAddress(hWinSock2Lib, 'recv'));
    send := Pointer(GetProcAddress(hWinSock2Lib, 'send'));
    socket := Pointer(GetProcAddress(hWinSock2Lib, 'socket'));
    WSAStartup := Pointer(GetProcAddress(hWinSock2Lib, 'WSAStartup'));
    WSACleanup := Pointer(GetProcAddress(hWinSock2Lib, 'WSACleanup'));
    WSAAsyncSelect := Pointer(GetProcAddress(hWinSock2Lib, 'WSAAsyncSelect'));
  end;

finalization

  if hWinSock2Lib > 0 then
    FreeLibrary(hWinSock2Lib);

end.
