unit cp_Register;

interface

procedure Register;

implementation

uses
  Classes, cp_CinemaEngine, cp_ListBoxes, cp_TrackBars;

procedure Register;
begin
  RegisterComponents('CinemaPlayer', [TCinema, TPositionTrackBar,
    TVolumeTrackBar, TPlaylistBox]);
end;

end.
