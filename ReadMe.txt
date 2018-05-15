=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

				    CinemaPlayer 1.6 beta8
				       dn. 17.01.2007

				  Autor: Zbigniew Chwedoruk
				e-mail: info@cinemaplayer.net
				  www: www.cinemaplayer.net

			    Program nale�y do kategorii FREEWARE

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-




I. Informacje og�lne
====================


1. Co to za program i do czego s�u�y:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

CinemaPlayer to program do odtwarzania film�w z napisami. Rozpoznaje wszystkie popularne
formaty napis�w i list odtwarzania (playlisty). Potrafi r�wnie� odtwarza� pliki d�wi�kowe (wav,
mp3) oraz napisy do piosenek w formacie LRC. Odtwarzacz cechuje szybko�� dzia�ania, prostota
i intuicyjno�� obs�ugi oraz dzi�ki niezale�no�ci od Windows Media Player niskie wymagania
sprz�towe.


2. Wymagania:
~~~~~~~~~~~~~

Do poprawnej pracy program potrzebuje DirectX w wersji przynajmniej 6. Zalecana jest najnowsza
wersja. Niekt�re filmy wymagaj� dodatkowych kodek�w.
Program jest przeznaczony dla system�w Windows 9x/ME oraz NT/2000/XP/Vista.


II. Historia zmian:
===================


wersja 1.6 beta8

I kolejna porcja zmian:
* (nowe) Dodano obs�ug� syntezatora ExpressIVO. Na razie nie da si� regulowa� g��no�ci
  i pr�dko�ci czytania.
* (nowe) Dodano opcj� kasowania zak�adek.
* (nowe) Dodano opcj� czyszczenia listy przy wyj�ciu z programu.
* (nowe) Dodano opcj� wy��czaj�c� przesuwanie obrazu mysz� na pe�nym ekranie.
* (nowe) Dodano opcj� pozwalaj�c� ustawi� czu�o�� filtra wyszukuj�cego plik z napisami.
  Dost�pne s� trzy poziomy:
  - tylko napisy o takiej samej nazwie jak plik z filmem
  - dopuszczaj napisy o podobnej nazwie jak plik z filmem
  - dopuszczaj r�wnie� napisy o ma�o podobnej nazwie, ale tylko je�li w katalogu nie ma
    innego filmu, kt�ry bardziej pasuje do tych napis�w.
* (b��d 1.6) Przy wznawianiu ostatnio ogl�danego filmu program ignorowa� stan opcji,
  wy��czaj�cej wczytywanie napis�w.
* (b��d 1.6) Przy aktywnej opcji "Zatrzymaj odtwarzanie podczas zmiany ustawie�", po
  aktywowaniu menu kontekstowego, a nast�pnie zamkni�ciu tego menu przez klikni�cie lewym
  klawiszem myszy nast�powa�o przesuni�cie obrazu.
* (b��d 1.6) Przy wstrzymanym odtwarzanieu (pauza) dwukrotne klikni�cie na film nie
  zmienia�o stanu: pe�ny ekran - okienko.
* (b��d 1.6) Je�li program zosta� automatycznie zamkni�ty w powodu ogl�dni�cia ca�ego filmu,
  to podczas pr�by ponownego uruchomienia ostatnio odtwarzanego filmu player wy��cza� si�.
* kilka innych drobnych usprawnie� i poprawek


wersja 1.6 beta7

19.12.2006

Tyle ile zd��y�em zrobi� do �wi�t:
* (nowe) Poprawiono wyszukiwanie napis�w. Nowy algorytm powinnien zaspokoi� oczekiwania
  znacznej wi�kszo�ci u�ytkownik�w. Dodatkowo, je�li program znajdzie w katalogu kilka
  pasuj�cych napis�w, to wy�wietlana jest lista plik�w z mo�liwo�ci� wybrania w�a�ciwego.
* (nowe) Po uruchomieniu playera aktywna jest opcja "Odtwarzanie". Je�li zostanie ona wybrana
  przed wczytaniem filmu, to program b�dzie kontynuowa� odtwarzanie ostatnio otwieranego pliku.
* (nowe) Pojawi�a si� nowa zak�adka w opcjach: "Playlista". Na razie zosta�a dodana jedna
  opcja, kt�ra pozwala wy��czy� pytanie o kolejn� p�yt� CD podczas wyszukiwania nast�pnej
  (potencjalnie) cz�ci filmu. 
* (b��d 1.6) Program ko�czy� si� b��dem po wej�ciu do opcji pod "Windows Vista".
* (b��d 1.6) Po przej�ciu do pe�nego ekranu ze zmian� rozdzielczo�ci znika� obraz.
* kilka innych drobnych usprawnie� i poprawek


wersja 1.6 beta6

16.11.2006

Znowu poprawki i par� nowych drobiazg�w:

* (nowe) Dodano opis skr�t�w klawiszowych do menu pomocy. Spis dost�pny jest pod klawiszem F1.
* (nowe) Dodano t�umaczenie na j�zyk w�gierski. Podzi�kowania dla Daniela Keszei.
* (nowe) Dodano obs�ug� klawiszy specjanych na klawiaturach multimedialnych. Program obs�uguje
  nast�puj�ce klawisze: Mute, Volume down, Volume up, Next track, Prev track, Stop, Play/Pause.
* (nowe) Po operacji Drag&Drop na playli�cie pliki zawsze dodaj� si� do istniej�cej listy.
* (nowe) Dodano MP4 do listy obs�ugiwanych plik�w.
* (zmiana) Przy aktywnej opcji zamykania systemu po sko�czeniu odtwarzania, program nie zamyka
  systemu, je�li w momencie sko�czenia filmu u�ytkownik przegl�da jakie� okienko:
  (opcje, wczytywanie pliku, zmiana czcionki, itp.)
* (zmiana) Po w��czeniu �ledzenia napis�w automatycznie nast�puje skok do najbli�szego napisu,
  bez oczekiwania na pojawienie si� tego napisu.
* (zmiana) Aktualny napis w edytorze jest podkre�lony tylko wtedy, gdy opcja �ledzenia
  jest aktywna.
* (b��d 1.6beta5) Program nie wczytywa� napis�w, je�li by� tylko jeden plik w katalogu z inna
  nazw� ni� film.
* (b��d 1.5) Poprawiono algorytm automatycznie wyszukuj�cy nast�pny film w katalogu.
  Czasami �le by�y rozpoznawane pliki, kt�re w nazwie mia�y kolejny numer.
* (b��d 1.6beta5) Poprawiono dzia�anie opcji, kt�ra pozwala zatrzyma� odtwarzanie po jednym
  klikni�ciu myszk� na filmie.
* (b��d 1.6beta5) Poprawiono wyszukiwanie w katalogu pliku napis�w o podobnej nazwie do filmu.
  Obecnie plik uznawany jest za podobny, je�li ma przynajmiej w po�owie tak� sam� nazw�,
  lub je�li nazwa filmu zawiera si� w nazwie napisu (albo odwrotnie).
* (b��d 1.6) Poprawiono dzia�anie opcji "Ukryj napisy". Zdarza�o si�, �e po w��czeniu tej
  opcji i wy��czeniu napisy ju� sie nie pojawia�y.
* (b��d 1.6) Poprawiono obs�ug� klawiatury w drzewku w okienku "Opcje".
* (b��d 1.x) Poprawiono wygl�d okienka edytora przy du�ym rozmiarze czcionek (120 dpi).
* kilkana�cie innych drobnych zmian i poprawek.


wersja 1.6 beta5

02.10.2006

Kolejna porcja poprawek:

* (nowe) Dodano opcj� (Odtwarzanie->Nawigacja), kt�ra pozwala zatrzyma� odtwarzanie
  po jednym klikni�ciu myszk� na filmie.
* (nowe) Dodano mo�liwo�� regulowania czasu wy�wietlania napis�w za pomoc� k�ka myszy.
* (nowe) Dodano nowe podzycje w menu "Pomoc". Teraz mo�na od razu przej�� na stron�
  g��wn� programu lub na forum.
* (b��d 1.6 beta4) W poprzedniej becie zepsuto blokowanie wygaszania monitora.
* (b��d 1.x) Znika� obraz, je�li w poprzedniej sesji "r�czne" zmieniono proporcje filmu.
* kilka innych drobnych poprawek


wersja 1.6 beta4

03.09.2006

Teraz te� g��wnie usuni�to b��dy:

* (nowe) W okienku "O programie" znajduj� si� lista os�b, kt�re wp�aci�y jaki� datek
  na CinemaPlayer. To dzi�ki nim player ma now� domen�!
* (nowe) Mo�na wczytywa� napisy, po przeci�gni�ciu pliku napis�w na okno playera.
* (nowe) Program pr�buje wczyta� jako film, pliki o nieznanym rozszerzeniu przeci�gni�te
  na okno playera.
* (nowe) Je�li film posiada kilka �cie�ek audio i jest to mo�liwe, to player pr�buje wybra�
  �cie�k� w j�zyku pasuj�cym do wersji j�zykowej, jaka jest ustawiona w programie.
* (nowe) Program pr�buje odnale�� plik z napisami je�li ma on inn� nazw� ni� film.
  W trakcie Waszych test�w oka�e si�, czy przyj�ty dopuszczalny poziom podobie�stwa jest
  odpowiedni.
* (nowe) Do opcji zamykania systemu po sko�czonym filmie dodano Hibernacj�.
* (b��d 1.6) Na s�abszych komuterach zdarza�o si�, �e lektor wyprzedza� film.
  W zwi�zku z tym zmniejszono lekko priorytet w�tku lektora.
* (b��d 1.6) Usuni�to komunikat "Nieznany format pliku z napisami" jaki pojawia� si�
  podczas automatycznego wczytywania napis�w, gdy w katalogu z filmem istnia� jeden plik
  tekstowy, ale nie b�d�cy w rzeczywisto�ci napisami do filmu. Teraz ten komunikat pokazuje
  si� tylko przy "r�cznym" wczytaniu pliku przez u�ytkownika.
* (b��d 1.6) Pliki rmvb zawsze mia�y fps ustawione na 30.
* (b��d 1.6) Gdy opcja "Wczytaj napisy automatycznie" by�a nieaktywna, film nie uruchamia�
  si� automatycznie.
* (b��d 1.6) Usuni�to "Runtime Error 217" przy zmianach strumienia audio.
* (b��d 1.6) Lektor czyta� kody opisuj�ce styl napis�w. Dodatkowo lektor pomija te� pierwsz�
  linijk� napis�w je�li jest tam tylko informacja o formacie filmu i/lub pochodzeniu napis�w.
* (b��d 1.2) Je�li podczas automatycznego zamykania/usypiania systemu by�o otwarte menu
  kontekstowe, to program przestawa� odpowiada� lub zawiesza� ca�y system (win9x).
  Na pewno poprawnie dzia�a teraz pod win2k/xp. Nie mam mo�liwo�ci sprawdzi� jak jest
  pod win9x. Nadal istnieje dziwne zachowanie menu kontekstowego w czasie tej operacji.
  Nie powoduje to �adnych skutk�w ubocznych, a jest trudne do poprawienia wi�c pozostawi�em
  to tak jak jest.
* Kilka innych drobnych poprawek.


wersja 1.6 beta3

03.05.2006

Tym razem przede wszystkim usuni�to b��dy:

* (nowe) Player wczytuje plik napis�w, je�li ma inna nazw� ni� film, ale jest jedynym
  plikiem tekstowym w katalogu.
* (nowe) Po wyj�ciu z programu zapami�tywany jest stan opcji "Czas pozosta�y do ko�ca filmu".
* (nowe) Dodano opcj� pozwalaj�c� nie wczytywa� automatycznie napisy.
* (zmiana) Poprawiono dzia�anie przycisku "Zastosuj" w ustawieniach. Przycisk jest odblokowany
  tylko je�li nast�pi�a jaka� zmiana w ustawieniach.
* (b��d 1.6) Poprawiono b��d powoduj�cy znikanie napis�w po przej�ciu do pe�nego ekranu.
* (b��d 1.6) Poprawiono b��d "Floating point division by zero".
* (b��d 1.6) Poprawiono b��d "Index out of bounds" pojawiaj�cy si� po odinstalowaniu lektora.
* (b��d 1.6) Program nie zapami�tywa� ustawie� domy�lnego katalogu dla film�w.
* (b��d 1.4) Poprawiono automatyczne wyszukiwanie kolejnych cz�ci filmu. Przy wi�kszej ilo�ci 
  plik�w player wczytywa� je w nast�puj�cej kolejno�ci: 01,02,03,04,05,15,16 i dalej 06,16.
* (b��d 1.x) Poprawiono obs�ug� klawiatury w "Edytorze szybko�ci wy�wietlania napis�w" oraz
  "Edytorze napis�w". Teraz klawisz skr�tu (odpowiednio F8 i F11) otwiera i zamyka edytor.
  W "Edytorze szybko�ci wy�wietlania napis�w" oraz "Korektorze czasu" dzia�a r�wnie�
  klawisz ESCAPE.
* (b��d 1.x) Poprawiono dzia�anie przesuwania pozycji na playli�cie. Po naci�ni�ciu klawisza
  ALT+DOWN lub ALT+UP przesuni�ty element nadal jest zaznaczony.
* Kilka innych drobnych poprawek.


wersja 1.6 beta2

11.12.2005

Troch� sp�niony Miko�aj:

* (nowe) Player poprawnie rozpoznaje �cie�ki d�wi�kowe w plikach OGM i MKV.
  Pliki OGM trzeba jeszcze przetestowa�.
* (nowe) Dodano mo�liwo�� wyboru urz�dzenia audio, na kt�re zostanie skierowany d�wi�k.
  Opcja dost�pna jest w "Opcje->Odtwarzanie->Pozosta�e opcje". Powinno to pozwoli�
  na wyb�r karty d�wi�kowej, je�li s� dwie w systemie. Pozwala te� na lepszy dob�r
  urz�dzenia audio w przypadku dzwi�ku w formatach AC3.
* (nowe) Player rozpoznaje j�zyk w ustawieniach u�ytkownika i je�li posiada odpowiedni�
  wersj� j�zykow�, to autmatycznie j� wybiera. W kolejnej wersji zostanie dodana te�
  preselekcja �cie�ki d�wi�kowej.
* (nowe) Pojawi�o si� t�umaczenie playera na j�zyk hiszpa�ski.
  Podzi�kowania dla Grecco Calderon!
* (nowe) Dodano mo�liwo�� w��czania/wy��czania lektora za pomoc� pilota.
* (nowe) Dodano opcj� pozwalaj�c� na przerywanie przed ko�cem czytania napisu przez
  lektora, je�li pojawi� si� nast�pny napis do przeczytania.
* (nowe) Dodano opcj� do ukrywania napis�w, je�li aktywny jest lektor.
* (nowe) Dodano now� pozycj� do listy predefiniowanych proporcji obrazu: 2.35:1
* (nowe) Dodano okienko z numerem konta bankowego autora (dost�pne w menu "Pomoc").
  Je�li kto� uwa�a, �e warto wesprze� projekt, to prosz� bardzo :-)
* (b��d 1.6beta1) Player 1.6 ��czy dwa napisy w jeden, je�li maj� ten sam czas i wyst�puj�
  w pliku kolejno po sobie. Niestety b��dnie by� robiony podzia� linii w takim napisie.
* (b��d 1.5) Po zatwierdzeniu ustawie� (F12) napisy zawsze by�y w��czone, niezale�nie 
  od stanu odpowiedniej opcji.
* (b��d 1.5) Przy widoku minimalnym, po przej�ciu do pe�nego ekranu i p�niejszego powrotu
  do okienka, pojawia�o si� menu, jak przy widoku standardowym.
* (b��d 1.x) Poprawiony stary b��d, kt�ry objawia� si� dziwnym zachowaniem okien na pulpicie,
  po wyj�ciu z pe�nego ekranu, kiedy aktywna by�a opcja "Ukryj pasek zada� w trybie
  pe�noekranowym".
* (b��d 1.x) Teraz player poprawnie czyta nominaln� warto�� FPS w plikach OGM i MKV.
* Kilka innych drobnych poprawek.


wersja 1.6 beta1

18.10.2005

Na pocz�tek skromna lista, ale b�dzie sukcesywnie si� rozrasta�:

* (nowe) Dodano obs�ug� lektora! CinemaPlayer korzysta bezpo�rednio z modu��w SAPI4 i SAPI5.
  Nie trzeba instalowa� dodatkowych program�w!
* (nowe) Dodano obs�ug� napis�w w formacie SSA/ASS. Niestety CinemaPlayer nie potrafi
  interpretowa� kod�w steruj�cych tego formatu. Wy�wietlane s� tylko same napisy.
* (nowe) Dodano obs�ug� kod�w steruj�cych wyst�puj�cych na ko�cu napisu
* (nowe) Dodano rozszerzenia MKV, MKA i RMVB do domy�lnej listy obs�ugiwanych plik�w.
* (b��d 1.5) Czasami po zamkni�ciu edytora napis�w film by� przewijany na pocz�tek.
* (b��d 1.5) Player nie wy�wietla� napisu je�li wewn�trz wyst�powa�a pusta linia.
* (b��d 1.5) Nie wczytywa�y sie niekt�re linie w napisach SRT


wersja 1.5.3

18.02.2005

Poprawiny po poprawinach:

* (b��d 1.5) Zak�adka "Typy plik�w" ju� ostatecznie powinna dzia�a� poprawnie.
* (b��d 1.5) Nie dzia�a�a opcja "OSD po prawej stronie".


wersja 1.5.2

13.02.2005

Poprawiny po urodzinach:

* (zmiana) Opcja (Napisy|Pozosta�e opcje|Maksymalna szeroko�� napis�w) przyjmuje teraz warto�ci
  w pikselach lub procentach
* (b��d 1.4x) Poprawiono uruchamianie programu z parametrem "/ff". Czasami program pokazywa�
  czarny ekran zamiast filmu.
* (b��d 1.5) Program �le wy�wietla� w OSD opis opcji posiadaj�cych stan w��czone/wy��czone.
* (b��d 1.5) W niekt�rych przypadkach program zawiesza� si� (pusty komunikat o b��dzie) przy
  wej�ciu do opcji.


wersja 1.5.1

03.02.2005

Z okazji czwartych urodzin:

* (nowe) W opcjach dodano zak�adk� "Foldery". Zebrane zosta�y tam wszystkie �cie�ki
  do katalog�w u�ywanych przez program. Do tej pory by�y dost�pne dwie: domy�lny folder
  dla film�w i dla napis�w. Teraz pojawi� si� trzeci: dla zrzut�w ekranu.
* (nowe) Zapis aktualnej klatki do pliku. Po d�ugim okresie zmagania si� z problemami, 
  w ko�cu uda�o si� uruchomi� screenshoty. Pliki (w formacie BMP) zapisywane s� do katalogu
  ustawionego w zak�adce "Foldery". (Domy�lnie "Moje dokumenty"). Tworzony jest tam podkatalog
  z nazw� filmu a plik ma nazw� w formacie: "h_mm_ss_mms.bmp". Jest to czas filmu, z kt�rego
  pochodzi klatka. Opcja ta mo�e sprawia� jeszcze troch� problem�w (w�acznie z zawieszeniem
  programu!)
* (nowe) Dodano opcj� (Napisy|Pozosta�e opcje|Maksymalna szeroko�� napis�w) pozwalaj�c� 
  na ograniczenie maksymalnego rozmiaru napis�w w poziomie. Przydatne jest do podczas ogl�dania
  filmu na telewizorze, kiedy film (a w raz z nim napisy) nie mieszcz� si� na ekranie.
* (nowe) Dodano opcj� (Odtwarzanie|Pe�ny ekran|Wymuszaj standardowy panel kontrolny w trybie 
  pe�noekranowym). Dzi�ki niej mo�na sprawi�, �e nie zale�nie od tego jaki jest ustawiony tryb 
  widoku, na pe�nym ekranie zawsze b�dzie widoczny panel standardowy.
* (nowe) Dodano opcj� (Odtwarzanie|Pozosta�e opcje|Zatrzymaj odtwarzanie podczas minimalizacji).
  Opcja przydatna szczeg�lnie podczas s�uchania muzyki. Mo�na zminimalizowa� program, a utw�r
  jest nadal odtwarzany
* (nowe) Player potrafi znale�� plik z napisami, je�li przy wczytywaniu kolejnej cz�ci filmu
  nazwa napis�w r�ni si� od nazwy filmu, ale jest utworzona wed�ug tej samej regu�y co nazwa 
  pliku z napisami dla poprzedniej cz�ci filmu.
* (zmiana) Przeniesiono opcj� "Zatrzymaj odtwarzanie podczas zmiany ustawie�" a zak�adki 
  "Odtwarzanie|Pe�ny ekran" do "Odtwarzanie|Pozosta�e opcje".
* (b��d 1.5) Na pe�nym ekranie, napisy pojawia�y si� przed panelem narz�dziowym.
* (b��d 1.5) Po otwarciu filmu przez "Otw�rz z...' lub dwuklik na pliku napisy by�y niewidoczne.
* (b��d 1.5) �le dzia�a�a opcja zmiany proporcji obrazu. Program nie pami�ta� ostatnich ustawie�
  podczas kolejnego uruchomienia oraz niewidoczne by�o OSD
* (b��d 1.5) Czasami w okienku opcji nie da�o si� "rozwin��" ComboBox�w.
* (b��d 1.5) Kiedy ustawienia by�y zapisane do pliku, obraz by� niewidoczny.
* (b��d 1.5) Program zawiesza� si�, je�li w trybie pe�noekranowym wybrano opcj� 
  "Widok 200%" (Alt+3).
* (b��d 1.5) �le dzia�a�a zmiana g�o�no�ci przy pomocy k�ka myszy.
* (b�ad 1.5) Po w��czeniu widoku minimalnego pasek narz�dziowy w trybie pe�noekranowym by� 
  uszkodzony.
* (b��d 1.5) Przy zapisie playlisty program nie dodawa� rozszerzenia (asx)
* (b�ad 1.x) Je�li na ko�cu napisu znajdowa� si� znak podzia�u linii ("|"), to napisy 
  wy�wietlane na ekranie zajmowa�y prawie ca�y film



wersja 1.5

28.11.2004

D�uuuuugo to trwa�o, niekt�rzy ju� zw�tpili, ale jednak nasta� ten dzie�...

* (nowe) Ca�kowicie nowy "silnik" do wy�wietlania napis�w. Teraz powinno dzia�a� stabilniej 
  i szybciej.
   - Tryb przezroczystych napisy przy wykorzystaniu overlay
   - Opcja pozwalaj�ca na "przyci�ganie" napis�w do filmu. Szczeg�lnie przydatne na 
     pe�nym ekranie i panoramicznych filmach. Napisy wy�wietlaj� si� zaraz pod filmem, 
     niezale�nie od tego jakich s� rozmiar�w. Oczywi�cie, je�li napis nie zmie�ci si� 
     w ca�o�ci pod filmem, to b�dzie wy�wietlany odpowiednio wy�ej.
   - Trzecia, bardzo gruba obw�dka dla napis�w.
   - Je�li w trybie napis�w "Pod filmem", dany napis mia� wi�cej linii ni� zak�ada�y
     ustawienia, to ostatnie linie nie by�y wy�wietlane. Teraz takie napisy s� przesuwane 
     do g�ry (nachodz� na film), tak aby ca�y tekst zosta� wy�wietlony. 
   - Dodano obs�ug� tag�w pozwalaj�cych formatowa� wy�wietlanie napisy.
     Dok�adny opis obs�ugiwanych tag�w znajduje si� w pliku "kody_sterujace_do_napisow.txt".
   - W zwi�zku z wprowadzeniem obs�ugi tag�w usuni�to opcj�, nakazuj�c� interpretacj� 
     znaku "/" na poczatku napisu jako pochylenie czcionki. Teraz ta opcja jest zb�dna.

* (nowe) Inteligentne napisy
   - Dodano graficzny edytor pozwalaj�cy regulowa� pr�dko�� wy�wietlania napis�w. 
     Edytor dostepny jest w menu 'Widok' oraz z menu kontekstowego. Skr�t klawiszowy: (F8).
     Edytor sk�ada si� z wykresu graficznego i czterech suwak�w do regulacji ustawie�.
     Wykres przedstawia funkcj�:
             | y = ax^2 + bx + c
      f(x) = |
             | y <= d

     gdzie:
        a - Przyrost czasu na liter� [sek]
        b - Sta�y czas na liter� [sek]
        c - Minimalny czas trwania napisu [sek]
        d - Maksymalny czas trwania napisu [sek]

        x - D�ugo�� napisu [ilo�� liter]
        y - Czas wy�wietlania napisu [sek]

     Warto�ci x i y s� od�o�one na wykresie. Parametry a, b, c oraz d mo�na modyfikowa� 
     przy pomocy suwak�w.
     Zmiana parametr�w jest od razu odzwierciedlana w odtwarzanym filmie, tak�e mo�na �atwo 
     "organoleptycznie" dobra� w�a�ciwe dla nas tempo.
     Wprowadzono te� zabezpieczenie przed nadmiernym op�nianiem si� napis�w. Player pozwala 
     na max. 2 sekundy op�nienia w stosunku do oryginalnego czasu. Je�li czas ten zostanie 
     przekroczony, to natychmiast wy�wietlany jest nast�pny napis. (Zobaczymy jak to dzia�a 
     w praktyce i ewentualnie b�d� jakie� korekty).

* (nowe) Dodano obs�ug� nowych format�w napis�w: MPL3 oraz HATAK

* (nowe) Dodano OSD
   - Wygl�d czcionki mo�na regulowa� podobnie jak przy napisach. 
     Mo�liwa jest te� zmiana po�o�enia i wielko�ci OSD przy pomocy skr�t�w. S� one takie same
     jak dla zmiany po�o�enia napis�w, tylko dochodzi jeszcze SHIFT, czyli: 
     Ctrl+Shift+Kursor_w_g�re/Kursor_w_d� oraz Ctrl+Shift+ -/=. Mo�na te� chwyci� OSD 
     i przesun�� mysz�
   - Dodano opcj� (F9), kt�ra pokazuje aktualny czas w formacie:
     "aktualny_czas_filmu"/"ca�kowity_czas_filmu" ["aktualna godzina"]
     Je�li w menu Widok w��czono pokazywanie czasu pozosta�ego do ko�ca filmu, to 
     "aktualny_czas_filmu" wy�wietla czas w tej postaci

* (nowe) Dodano obs�ug� pilota
   - Opis kod�w steruj�cych znajduje si� w pliku "RemoteControler.txt".
   - Stworzony zosta� plik do Girdera zawieraj�cy wszystkie kody steruj�ce do CinemaPlayera

* (nowe) Przebudowane okno ustawie� (F12).
   - Teraz powinno by� bardziej przejrzy�cie.
   - Okno przystosowane jest do obs�ugi styl�w Windows XP.
   - Dodano opcj� "Zastosuj". Mo�na zatwierdzi� wprowadzone zmiany bez zamykania okna

* (nowe/zmiana) Udoskonalono wyszukiwanie kolejnych cz�ci filmu. 
   - Nazwa filmu nie musi ko�czy� si� cyfr�. Numer pliku mo�e znajdowac si� w dowolnym miejscu
     nazwy. 
   - Poprawiono procedur� zmiany p�yty w nap�dzie CD. Po sko�czonym odtwarzaniu cz�sci filmu
     player sam wysuwa p�yt� z nap�du, po wymianie p�yty i klikni�ciu OK program zamyka tack�
     i rozpoczyna odtwarzanie kolejnej cz�ci filmu.
   - Przy wy��czonej opcji "Rozpocznij odtwarzanie filmu po za�adowaniu", kolejne cz�ci tego 
     samego filmu s� uruchamiane automatycznie.
   - Dodano opcj� wy��czaj�c� automatyczne wyszukiwanie kolejnych cz�ci filmu. 
     (Odtwarzanie->Pozosta�e opcje)

* (nowe) Dodano wsparcie dla film�w z kilkoma �cie�kami audio
   - Pod prawym klawiszem myszy na ikonie g�o�niczka (obok regulacji g��no�ci) jest dost�pne
     menu w kt�rym mo�na zmieni� �cie�k�.

* (nowe) Dodano skr�t klawiszowy do minimalizacji aplikacji (Shift+Esc)
* (nowe) Dodano opcj� "Prze�aduj film" do menu "Plik" (Ctrl+Q)
* (nowe) Dodano mo�liwo�� przeniesienia playlisty na lew� stron� okna
* (zmiana) Usuni�to automatyczne pokazywanie playlisty po przesuni�ciu myszy do kraw�dzi 
  ekranu na pe�nym ekranie
* (zmiana) Przebudowano menu Proporcji obrazu. Przeniesiono je poziom wy�ej ni� by�o 
  poprzednio. Teraz jest obok menu "Powi�kszenie". Dodatkowo wybrana opcja proporcji obrazu 
  jest pami�tana podczas kolejnego uruchomienia programu. 
* (nowe) Dodano przycisk do paska menu zamykaj�cy program. Przycisk pojawia sie w trybie 
  pe�noekranowym.
* (nowe) Je�li rozszerzenia plik�w zostan� skojarzone z playerem ("Typy plik�w" w opcjach),
  to w Windows XP CinemaPlayer zostanie dodany r�wnie� do menu, jakie pojawia si� po w�o�eniu
  p�yty do napedu CD (podzi�kowania dla Krzysztofa S�owika)
* (poprawione) Przesuwanie napis�w "w czasie" (klawisze "[", "]") dzia�a teraz co 0.25 sek.
* (nowe) Dodano mo�liwo�� w��czenia/wy��czenia pe�nego ekranu przez podw�jne klikni�cie 
  na filmie (Odtwarzanie->Pe�ny ekran). Akcja kt�ra poprzednio by�a pod tym skr�tem 
  (wycentrowaniu kadru) dalej jest dost�pna, nale�y trzyma� wci�ni�ty klawisza SHIFT, podczas 
  klikania. 
  Je�li ta opcja jest wy��czona, to przy podw�jnym kliku jest wycentrowanie kadru, natomiast 
  z SHIFTem przej�cie z/do pe�nego ekranu.
* (nowe) Dodano opcj� pozwalaj�c� na zapami�tanie po zamkni�ciu programu, czy opcja 
  "Wy��czaj�cej komputer po obejrzeniu filmu" (CTRL+F4) jest aktywna. Przydatne dla os�b, 
  kt�re notorycznie zasypiaj� podczas ogl�dania filmu :-)
* (nowe) Dodano specjalny program "Language Translator" u�atwiaj�cy tworzenie i edycj� plik�w 
  z wersjami j�zykowymi. Zmieniono format plik�w j�zykowych (LNG). 
  Zapraszam wszystkch do tworzenia nowych t�umacze�.
* (b��d 1.x) Je�li obraz by� powiekszony, to player �le ustawia� po�o�enie i rozmiar
  obrazu po wczytaniu kolejnej cz�ci filmu
* (b��d 1.x) Przy w��czonej opcji "Zawsze na wierzchu", niekt�re okina dialogowe 
  pokazywa�y si� pod oknem playera i nie da�o si� ich "wyci�gn��" na wierzch.
* (b��d 1.2) przewini�cie filmu na koniec przy pomocy myszy na pasku post�pu rozpoczyna�o 
  procedur� zamykania systemu (je�li by�a w��czona) przed puszczeniem klawisza myszy
* (b��d 1.2) program zawiesza� si� zaraz po wczytaniu filmu odtwarzanego przy pomocy nowszych
  wersji kodeka ffdshow
* (b��d 1.4) Czasami �le inicjowane by�y listy obs�ugiwanych rozszerze� na zak�adce 
  "Typy plik�w" w opcjach. Pojawia�y si� podw�jne wpisy.
* (b��d 1.4) Poprawiono automatyczne �adowanie kolejnych cz�ci filmu, przy zmianie numeru 
  pliku z 9->10, 19->20 itd.
* (b��d 1.4a) Poprawiono wczytywanie napis�w podczas odtwarznia. (Film zatrzymywa� sie 
  na oko�o 1 sekund�)
* (b��d 1.4a) Przy przej�ciu do pe�nego ekranu ze zmian� rozdzielczo�ci player "gubi�" napisy.
  Trzeba by�o wczyta� je ponownie
* UWAGA! stwierdzono b��d w filtrze ffaudio. Je�li film ma scie�k�(i) d�wiekow� w formacie 
  AC3, to zdarza si� �e player zawiesza si�. Jest to b��d ffaudio. Polecam AC3Filter, kt�ry 
  jest stabilny.
* Masa innych drobnych poprawek. Przy tak du�ej liczbie zmian program praktycznie nie powiekszy�
  swojego rozmiaru.


Wa�niejsze zmiany w kolejnych wersjach:
 - poprawione wyszukiwanie napis�w (Drag&Drop, mo�liwo�� wybrania jednego z kilku plik�w 
   w katalogu z filmem, itp.)
 - obs�uga lektora (poprzez SpeechAPI)
 - regulacja jasno�ci i kontrastu obrazu
 - rozbudowa OSD o graficzn� prezentacj� powy�szych parametr�w, a tak�e g�o�no�ci i innych 
   opcji "zakresowych"
 - porz�dny plik pomocy
 - mo�liwo�� konfiguracji skr�t�w klawiszowych
 - mo�liwo�� konfiguracji przycisk�w na pasku narz�dziowym
 - zrzuty obrazu do pliku (screenshot)
 - nowy edytor napis�w. na razie jest jedno za�o�enia: powinnien pozwala� na swobodne pisanie,
   a nie tak jak teraz na wstawianie linii do listy
 - "inteligentny" tryb PanScan
 - kilka(na�cie) drobnych udoskonale�, kt�re zg�oszono na forum, a jeszcze nie zosta�y 
   uwzgl�dnione


wersja 1.4b

26.02.2003

Ta wersja powinna rozwi�za� wi�kszo�� wykrytych niedoci�gni��

* dodano wyswietlanie napis�w w trybie Overlay (odci��enie procesora); Opcja jest standardowo
  w��czona, dodatkowo program sam wykrywa czy w danej chwili moze skorzysta� z trybu Oberlay
  i je�li jest to niemo�liwe, to wykorzystuje star� metod� renderowania napisu
* dodano opcj� "Prze�aduj film"
* dodano mo�liwo�� przeniesienie playlisty na lew� strone okna, jednocze�nie usuni�to 
  autopokazywanie playlisty w trybie pe�noekranowym
* opcja "Ukryj napisy" wr�ci�a na pasek narz�dziowy
* skr�t klawiaturowy do minimalizacji "Shift+Esc"
* usuniety bl�d powodujacy znikanie obrazu
* usuni�ty "b��d" przy opcji "u�yj tylko jednej opcji programu" pokazywa� sciezke filmu
* poprawiono dzia�anie opcji "Zatrzymaj odtwarzanie podczas zmiany ustawie�" - czasami
  film zatrzymywa� si� na sta�e
* usuni�to b��d zwi�zany z niemo�no�ci� za�adowania filmu przez operacje Drag&Drop
* dzi�ki dalszym optymalizacjom program zmiejszy� swoj� obj�to�� (teraz tylko 246kB)
* poprawiono kilka innych drobnych b��d�w

wersja 1.4a

19.09.2002

Prawem serii, znowu wersja z literk� "a"

* usuni�to b��d powoduj�cy znikanie obrazu, po wczytaniu kolejnego filmu z playlisty
* usuni�to b��d pojawiaj�cy si� podczas uruchamiania player z p�yty CD
* usuni�to b��d, kt�ry powodowa� "dziwny" wygl�d napis�w przy ustawieniu stylu "Prostok�tne t�o"

wersja 1.4

15.09.2002

Niekt�rzy ju� w�tpili, �e nowa wersja jeszcze si� pojawi...

* edytor napis�w
   - dodawanie, edycja i usuwanie napis�w (zmienion� lini� nale�y zatwierdzi� przez SHIFT+Enter
     lub przyciskiem w lewym dolnym rogu edytora
   - zapis napis�w w dowolnym, obs�ugiwanym przez player formacie
   - dwuklick na napisie w edytorze powoduje przej�cie do danego fragmentu filmu
   - napisy w edytorze mog� przesuwa� si� w miar� odtwarzania filmu (opcja na pasku zada�)
   - opcja pozwalaj�ca jednym klikni�ciem rozmie�ci� okno playera i edytora na ca�ym ekranie
   - wyszukiwanie b��d�w "czasowych" w napisach
   - uruchamianie edytora po wykryciu b��d�w przy �adowaniu napis�w (opcja dost�pna pod
     klawiszem F12
   - korektor czasu; ma�e narz�dzie pozwalaj�ce dopasowa� napisy, gdy nie pasuj� do filmu:
      - przesuniecie o zadan� ilo�� sekund do przodu lub do ty�u
      - skalowanie - wystarczy poda� �e napisy o czasie od "X" do "Y" powinny pokazywa� si� 
        mi�dzy czasem "A" a czasem "B". program sam przeliczy czasy poszczeg�lnych linii.
        czasy "X" i "Y" mo�na wskaza� za pomoc� opcji w menu kontekstowym dost�pnym dla listy
        napis�w w edytorze
      - zmiana FPS
* inteligentne napisy, czyli dynamiczne obliczanie czasu potrzebnego na przeczytanie
  wy�wietlanych napis�w. je�li kto� woli oryginalny czas, to mo�na to wy�aczy� w opcjach
* dodano nowe tryby wy�wietlania napis�w
* kilka poziom�w antyaliasowania napis�w
* pe�ny ekran na dowolnym monitorze (telewizorze). wybierany jest ten monitor, na kt�rym
  znajduje si� okno player w momencie przejscia do pe�nego ekranu. opcja na razie dostepna 
  na kartach GeForce
* wsparcie dla AC3 (automatyczne przekierowanie dzwieku z DirectSound na WaveOut)
* zmniejszono obci��enie procesora przy renderowaniu napis�w (teraz napisy tworzone s� w
  osobnym w�tku)
* automatyczne rozpoznawanie kolejnych cz�ci filmu (nazwa filmu musi by� zako�czona cyfr�):
   - je�eli s� w tym samym katalogu na dysku
   - je�eli jest to p�ytka w CD-ROMie to program prosi o w�o�enie kolejnej. (je�li istniej� 
     inne nap�dy CD-ROM, to program w pierwszym rz�dzie sprawdza obecno�� kolejnej cz�ci w 
     tych nap�dach)
* znak '/' na pocz�tku linii napis�w mo�e by� traktowany jako kursywa (nie tylko w formacie
   MPL2)
* funkcja STOP przewija film na pocz�tek
* przeci�gni�cie mysz� filmu do playera powoduje wyczyszczenie starej playlisty i uruchomienie
  filmu, z klawiszem SHIFT film jest tylko dodawany do obecnej listy (poprzednio by�o
  odwrotnie)
* nowy parametr uruchomieniowy /min - widok minimalny
* stan opcji "Zawsze na wierzchu" jest pami�tany w ustawieniach
* do pliku konfiguracyjnego zapisywania jest �cie�ka do folderu z filmami
* zmiania proporcji lub po�o�enia obrazu na ekranie jest zachowywana po przej�ciu do pe�nego
  ekranu (i odwrotnie)
* zmiany interfejsu
   - nowe ikonki na przyciskach
   - w menu rozwijanym pod przyciskiem "Otw�rz film" dodano list� ostatnio otwartych plik�w
   - dodano ikon� playlisty na pasku zada�
   - dodano ikon� widoku minimalnego na pasku zada�
   - usuni�to ikon� "Ukryj napisy"
   - zmania skr�tu dla playlisty F11->F10
   - menu "fitltry w uzyciu" pokazuje wszystkie filtry jakie zosta�y u�yte do odtwarzania
     filmu, te kt�re nie maj� opcji konfiguracyjnych s� zblokowane (poprzednio wog�le ich
     nie by�o)
* poprawiono kojarzenie plik�w filmowych z playerem (poprzednio w�a�ciwo�ci pliku AVI nie
  by�y dot�pne)
* nie powinno ju� pojawia� sie okienko "ActiveMovie" podczas przej�cia z/do pe�nego ekranu
* poprawione blokowanie wygaszacza
* poprawione zamykanie systemu po sko�czonym filmie
* nie powinno ju� by� problem�w przy zmianie fullscreena (czasami okno znika�o, albo player
  si� zawiesza�)
* poprawiono kilka innych drobnych zmian i b�ed�w



wersja 1.3a

01.02.2002

Ma�e zmiany w odpowiedzi na pierwsze opinie na temat wersji 1.3

* usuni�ty b��d powoduj�cy niepokazywanie czasu odtwarzania
* powr�t do starych skr�t�w klawiszowych  (si�a przyzwyczaje� jest wielka!):
  - skok o minut� do przodu i do ty�u (PgUp i PgDown)
  - zmiana g�o�no�ci (kursor w g�r� i kursor w d�). Jednak kiedy widoczna jest playlista
    nast�puje przemapowanie skr�t�w (Home i End). Po schowaniu playlisty nast�puje powr�t
    do pierwotnych ustawie�
* poprawiono rozmieszczenie kontrolek na panelu kontrolnym w widoku minimalnym; panel lepiej
  dostosowuje si� do aktualnych rozmiar�w okna

wersja 1.3

30.01.2002

Troch� to trwa�o, ale w ko�cu jest nowa wersja!

* dodano playlist�, dost�pna jest pod klawiszem F11, na pe�nym ekranie wystarczy przesun��
  kursor myszy do prawej kraw�dzi ekranu. Oto najwa�niejsze cechy playlisty:
  + rozpoznawane s� nast�pujace formaty list:
    - ASX
    - BPP
    - LST
    - PLS
    - M3U
    - MBL
    - VPL
  + mo�liwo�� wczytywania (lub dodawania do istniej�cej listy) jednego lub wielu plik�w
    oraz katalog�w (z podkatalogami lub nie); wszystkie skr�ty klawiszowe
    w pliku "Keyboard.txt"
  + opcje pozwalaj�ce na wszechstronn� edycj� listy dost�pne s� po klikn�ciu prawym klawiszem
    myszy na playli�cie
  + autopowtarzanie i losowe wybieranie element�w z listy
  + mo�liwo�� dodawania element�w do listy poprzez operacje Drag&Drop (r�wnie� katalogi);
    przytrzymanie klawisza SHIFT w czasie "upuszczania" plik�w powoduje usuni�cie starej listy
  + filmy mo�na wczyta� r�wnie� podaj�c je jako list� parametr�w przy uruchomieniu programu
  + proste (na razie) wsparcie dla film�w wielop�ytowych; przy odtwarzaniu kolejnego pliku
    z CD program prosi o w�o�enie nast�pnej p�yty
* program mo�e komunikowa� si� z u�ytkownikiem w j�zyku portugalskim (wersja braylijska)
  autorem jest Alexandre Aleixo Wagner, kt�remu sk�adam podzi�kowania!
  Zapraszam wszystkich do t�umaczenia pliku LNG na inne j�zyki
* dodano obs�ug� napis�w formatu LRC (napisy do plik�w audio np. MP3)
* dodano przegl�danie podkatalog�w domy�lnego katalogu w czasie szukania napis�w
* dodano "widok minimalny" (opr�cz filmu w oknie widoczny jest tylko prosty panel kontrolny)
* dodano menu do zmiany proporcji kadru (Widok->Powi�kszenie->Proporcje obrazu) lub 
  za pomoc� klawisza "przecinka" na klawiaturze numerycznej; po zmianie przez kr�tk� chwil�
  na pasku statusu pokazane s� aktualnie wybrane proporcje
* dodano opcj� kasowania listy ostatnio otwartych plik�w
* dodano skr�t do opcji zamykania systemu po sko�czonym odtwarzaniu Ctrl + F4
* dodano opcj� pozwalaj�c� na wy��czenie zatrzymywania odtwarzania w czasie zmiany ustawie�
* pod Windows XP program wykorzystuje nowy wygl�d kontrolek
* troch� przebudowano uk�ad menu
* zmieniono skr�ty (kolidowa�y z playlist�) do regulacji g�o�no�ci (Home, End) 
  oraz du�ych skok�w (Ctrl + kursor w lewo, Ctrl + kursor w prawo)
* poprawiono mechanizm kojarzenia plik�w z programem (czasami b��dnie dzia�a�o)
* po wczytaniu tekstu w czasie ogl�dania filmu obraz traci� proporcje
* po wyj�ciu z programu z pe�nego ekranu na pasku zada� pozostawa� "�lad" po aplikacji
* pojawia� si� b��d podczas zapisu konfiguracji do katalogu g��wnego (np. C:\)
* po przej�ciu z/do pe�nego ekranu przez chwil� na napisach by�y widoczne "krzaczki"
* �le dzia�a�o rozpoznawanie formatu kr�tkich plik�w z napisami (ok. 10 linii)
* inne drobne zmiany i poprawki



wersja 1.21

11.07.2001

Tym razem kolejne zmiany po bardzo kr�tkiej przerwie.

* dodano obs�ug� nowego formatu napisowego (SRT - SubRipper)
* uzupe�nonono obs�ug� formatu napisowego MPL2 (znacznik kursywy)
* k�ko w myszy mo�e s�u�y� do przeszukiwania filmu lub zmiany g�o�no�ci; dodatkowo gdy
  aktywna jest jedna z opcji, ustawienie kursora myszy nad kontrolk� s�u��c� do
  manipulowania drug� opcj�, pozwala sterowa� k�kiem myszy t� drug� opcj�
* dodano domy�lny katalog dla film�w. Katalog ten jest otwierany jako pocz�tkowy przy
  wczytywaniu pierwszego filmu po uruchomieniu programu; kolejne wywo�ania opcji
  "Otw�rz film" jako pocz�tkowego katalogu u�ywaj� tego, w kt�rym znajduje si� ostatnio
  otwarty film; klawisz SHIFT pozwala na u�ycie domy�lnego katalogu jako pocz�tkowego
  w dowolnym momencie
* program kontroluje swoje po�o�enie spowodowane zmian� rozmiar�w okna po otwarciu nowego
  filmu, je�eli spowoduje to cz�ciowe wysusi�cie okna poza ramy pulpitu, to player
  skoryguje odpowiednio swoje po�o�enie; zmiana rozmiar�w okna po otwoarciu filmu
  odbywa si� r�wnomiernie w ka�dym kierunku, a nie np. tylko w prawo i w d� (je�eli player
  znajdowa� si� dok�adnie na �rodku ekranu, to jest tak r�wniez po otwarciu filmu
* na pasku statusu pokazywane jest o ile przesuni�te s� napisy wzgl�dem filmu
  (klawisze "[", "]" oraz "P")
* okienko "Opcje" mo�na wywo�a� r�wnie� za pomoc� klawisza F12
* wprowadzono kilka kosmetycznych poprawek i usuni�to par� drobnych b��d�w zauwa�onych
  w wersji 1.2 przez u�ytkownik�w



wersja 1.2

02.07.2001

Po d�ugiej przerwie spora porcja nowo�ci. Pomimo du�ej ilo�ci zmian player zwi�kszy� swoj�
wielko�� tylko o 2KB!

* program nie korzysta ju� z MediaPlayera, dzi�ki czemu jest mniejszy, zajmuje kilka (3-5)
  MB RAMu mniej w por�wnaniu do innych player�w; zmala�o tak�e obci��enie procesora.
* zmiana wielko�ci, proporcji i po�o�enia kadru:
  - wystarczy chwyci� mysz� za kraw�d� filmu (zmieni si� kursor myszy) i przeci�gn��
    w wybrane po�o�enie, aby zmieni� wielko�� kadru (z zachowaniem proporcji obrazu).
  - przytrzymuj�c CTRL podczas powy�szej operacji, mo�na zmieni� proporcje kadru
    (lub za pomoc� klawiatury: CTRL + 2,4,6,8 numeryczne).
  - chwycenie mysz� wewn�trznego obszaru kadru, pozwala przesuwa� kadr w pionie.
    z klawiszem CTRL mo�na r�wnie� zmieni� po�o�enie w poziomie.
  - podw�jny klik rozci�ga kadr do wielko�ci okna (Num0, wcze�niej by�o Ctrl + Num5)
  - podw�jny klik z wcisni�tym klawiszem CTRL rozci�ga kadr do wielko�ci okna i przywraca
    oryginalne proporcje kadru.
  - cykliczne naciskanie "kropki" na klawiaturze numerycznej powoduje rozci�ganie kadru na
    ca�e okno playera i powr�t do aktualnie ustawionych proporcji.
* poprawiony algorytm analizuj�cy napisy z plik�w (odporniejszy na drobne b��dy w plikach)
* obs�uga nowych format�w napis�w:
 - MPL:
    0000,0000,0,Jakis tekst...
    0000,0000,Jakis tekst...
 - MPL2:
    [0000][0000]Jakis tekst...
    Ten format nie jest jeszcze w pe�ni obs�ugiwany (ignorowany jest atrybut pochy�o�ci)
* usunu�ty b��d "Cannot change Visible in OnShow or OnHide"
* natychmiastowe przej�cie do pe�nego ekranu (bez prze�adowania filmu)
* poprawnie dzia�a ukrywanie kursora na pe�nym ekranie
* zmiana po�o�enia napis�w za pomoc� myszy i klawiatury (Ctrl + "strza�ka w g�r�/d�")
* dost�p do w�a�ciwo�ci kodek�w
* mo�liwo�� wyboru cz�stotliwo�ci od�wierzania dla pe�nego ekranu w Windows NT/2000
* panel kontrolny na pe�nym ekranie mo�na przenie�� do g�ry (nie zas�ania napis�w)
* dodana opcja zmiany kierunku dzia�ania k�ka myszy
* historia (ostatnio otwierane pliki) zosta�a przeniesiona do podmenu. Takie samo podmenu
  pojawi�o si� w menu kontekstowym. Obecnie program pami�ta 10 film�w
* po najechaniu myszk� nad suwak pozwalaj�cy na przewijanie filmu w "dymku" pokazywany jest
  czas, jakiemu odpowiada po�o�enie kursora myszy.
* przyciski odpowiadaj�ce za zmian� pr�dko�ci odtwarzania filmu zosta�y usuni�te. W zamian
  pojawi� si� ma�y suwak nad regulacj� g�osno�ci.
* nowy parametr w linii polece� "/m" powoduje otwarcie playera w oknie,
  ale zmaksymalizowanym.
* zak�adki - mo�na zapami�ta� pozycj� odtwarzanego filmu i p�niej wczyta� film z zak�adki
* mo�liwo�� zapisania wi�kszo�ci ustawie� odtwarzacza do pliku. Przydatne przy nagrywaniu
  p�yt CD. Pozwala na dopasowanie odtwarzacza do konkretnego filmu.
  Zapami�tywane s� nast�puj�ce parametry:
    - autostart po za�adowaniu
    - zamknij po sko�czeniu
    - odleg�o�� napis�w od dolnej kraw�dzi
    - czcionka, kolor i rozmiar obw�dki
    - domy�lna warto�� FPS dla asf'�w
    - przewijanie filmu - ma�y i du�y krok
    - czas pokazywania napis�w
    - czas ukrycia kursora
    - g�o�no��
    - otwieranie jednej kopii programu
    - ukrywanie paska zada� na pe�nym ekranie
    - przej�cie do pe�nego ekranu po za�adowaniu
    - skalowanie napis�w w okienku
* poprawnie dzia�a wy��czanie wygaszania monitora podczas odtwarzania filmu
* w czasie wykonywania zmian w opcjach film jest pauzowany
* mo�liwo�� zamkni�cia/u�pienia systemu po sko�czonym odtwarzaniu
* na pasku statusu pokazywana jest aktualna pr�dko�� odtwarzania (fps)
* �rodkowy przycisk myszy dzia�a jak ENTER (przesuwa film o sekund� do przodu)
* oraz kilka drobnych b��d�w i niedoci�gni��, kt�rych nie spos�b wymieni�


wersja 1.1

24.02.2001

Pierwsze koty za p�oty! Oto kolejne udoskonalenia cinemaplayera:

* polska wersja! wystarczy umie�ci� plik z przet�umaczonymi napisami w katalogu i program
  b�dzie obs�ugiwa� dany j�zyk
* czasami program wy�wietla� tylko kawa�ek ostatniej litery w linii napisu
* podczas minimalizacji film jest pauzowany
* podczas minimalizacji programu w trybie pe�noekranowym ze zmian� rozdzielczo�ci nast�puje
  powr�t do normalnej rozdzielczo�ci
* je�eli w trybie pe�noekranowym ukrywany jest pasek zada�, to podczas minimalizacji
  programu jest on pokazywany
* szybsze zamykanie programu je�eli program jest w trybie pe�noekranowym
* poprawiona obs�uga parametr�w uruchomieniowych (autorun)


wersja 1.0

01.02.2001

Pe�na wersja, pozbawiona b��d�w. Chyba... :). Pierwsza publiczna edycja.

* poprawiona obs�uga scrolla myszy
* w menu kontekstowym opcja minimalizacji playera w trybie pe�noekranowym
* klikaj�c na aktualny czas filmu mo�na prze��cza� opcj� "Time remaining"
* mo�liwo�� wy��czenia skalowania napis�w
* teraz podczas minimalizacji zawsze widoczny jest pasek zada�
* kolejne drobne poprawki


wersja 0.9.9 beta

* opcja automatycznego przej�cia do trybu pe�noekranowego w momencie rozpocz�cia odtwarzania
  filmu
* parametry uruchomieniowe:
 - �cie�ka dostepu do filmu
 - �cie�ka dostepu do tekstu
 - /f - start w trybie pe�noekranowym
 - /ff - start w trybie pe�noekranowym ze zmian� rozdzielczo�ci
 kolejno�� parametr�w jest nieistotna
* jeszcze bardziej przyspieszony algorytm renderowania napis�w
* przewijanie filmu za pomoc� scrolla myszy
* kilka drobnych poprawek


wersja 0.9.8 beta

* czasami program zawiesza� si� przy wychodzeniu
* wyb�r rozdzielczo�ci dla trybu pe�noekranowego  w opcjach na WinNT/2000 nie dzia�a�
  poprawnie
* okienko statystyki
* troch� drobnych poprawek


wersja 0.9.7 beta

* czasami program zawiesza� si� po oko�o godzinie ogl�dania
* poprawiony i znacznie przyspieszony algorytm renderowania napis�w
* poprawione dzia�anie opcji "Open with CinemaPlayer"
* skalowanie napis�w w zale�no�ci od wielko�ci filmu (rozmiar podany w opcjach dotyczy
  pe�nego ekranu)
* opcja wy�wietlania czasu jaki pozosta� do ko�ca filmu


wersja 0.9.6 beta

* w ko�cu usuni�ty b��d powoduj�cy znikanie napis�w
* opcja uruchamiania tylko jednej kopii programu
* okienko wyboru pliku z filmem uwzgl�dnia rozszerzenia podane na zak�adce 'File types'
  w opcjach.
* opcja wyboru rozdzielczo�ci u�ywanej przy pe�nym ekranie (w trybie ze zmian�
  rozdzielczosci)
* domy�lna liczba klatek na sekund� dla pli�w '.asf' i napis�w w formacie z klatakami
  (microDVD)
* troch� drobnych poprawek


wersja 0.9.5 beta

* dodane kojarzenie plik�w z programem.
* dla plik�w nie skojarzonych mo�na doda� opcj� "Open with CinemaPlayer" do menu
  kontekstowego.
* szybka zmiana wielko�ci czcionki dla napis�w (Ctrl + -/=)
* troch� drobnych poprawek


wersja 0.9.2 beta

* opcja ukrywania menu start w czasie odtwarzania filmu na pe�nym ekranie
* domy�lny katalog z napisami. Program szuka pliku w katalogu z filmem, gdy nie znajdzie to
  szuka w katalogu z napisami. Je�eli podczas otwierania okienka dialogowego do wybierania
  plik�w z napisami b�dzie przytrzymany klawisz SHIFT to dialog otworzy si� z domy�lnym
  katalogiem napis�w (bez SHIFT otwiera si� katalog filmu lub ostatnio otwieranego pliku 
  z napisami).
* troch� drobnych poprawek



wersja 0.9.1 beta

* wy��czenie screensavera w czasie odtwarzania filmu
* pami�tanie plik�w z napisami w historii (5 ostatnich film�w)
* opcja "Stay on top"
* panel kontrolny na pe�nym ekranie po przesuni�ciu myszki na d� ekranu
* poprawione zamykanie programu po sko�czeniu odtworzenia filmu
* masa drobnych poprawek


wersja 0.9 beta

Pierwsza "doros�a" wersja programu. Na razie program posiada ma�o opcji i du�o b��d�w :)
* podstawowa rzecz, czyli odtwarzanie filmu i napis�w ju� dzia�a ;)
* czcionka ma sta�y rozmiar, szczerze m�wi�c(pisz�c) prawie wszystko jest na "sztywno"
* mo�na za�adowa� film przez przeci�gni�cie i upuszczenie go na oknie programu
* automatycznie wczytywane s� napisy o takiej samej nazwie jak film
* pami�tanych jest 5 ostatnio otwieranych film�w
* automatycznie wykrywana jest ilo�� linii tekstu widocznych na ekranie w danym momencie
* i troch� innych, lepiej lub gorzej dzia�aj�cych bajer�w...



III. Obs�uga programu
=====================


1. Oto co potrafi CinemaPlayer:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* Wczytanie plik�w video lub audio				(Ctrl + O)
  Dodanie plik�w video lub audio do playlisty			(Alt + O)
  Wczytanie wszystkich plik�w video lub audio z katalogu	(Ctrl + D)
  Dodanie wszystkich plik�w video lub audio z katalogu		(Alt + D)
  Wczytanie playlisty						(Ctrl + L)
  Zapisanie playlisty						(Ctrl + S)
 - ka�da kolejna operacja wczytania/dodania pliku rozpoczyna si� w tym katalogu, kt�ry by�
   ostatnio otwarty; przytrzymanie klawisza SHIFT powoduje otwarcie katalogu domy�lnego
   dla film�w
 - pliki mo�na za�adowa� r�wnie� przez przeci�gni�cie i upuszczenie ich na oknie programu,
   tak samo mo�na post�pi� z katalogiem
 - automatyczne wczytywane s� pliki z napisami, je�eli maj� tak� sam� nazw� jak plik audio
   lub video oraz znajduj� si� w tym samym katalogu lub w domy�lnym katalogu dla napis�w.
 - program pami�ta 10 ostatnio otwartych film�w (pami�tane s� te� pliki z napisami do nich);
 - program pozwala na zapami�tanie 10 zak�adek, kt�re pozwalaj� na rozpocz�cie odtwarzania
   filmu od momentu w kt�rym seans zosta� przerwany.
 - pliki mo�na r�wnie� za�adowa� podaj�c je jako list� parametr�w przy uruchomieniu z linii
   polece�


* Wczytanie napis�w 						(Ctrl + T)
 - otwierany jest katalog z plikiem audio/video lub po wcisni�ciu klawisza SHIFT domy�lny
   katalog dla napis�w.
 - program zapewnia wsparcie dla nast�puj�cych format�w napis�w:
   - {xxxx}{xxxx}Jaki� tekst...			MDVD
   - {xxxx}{}Jaki� tekst...			MDVD
   - hh:mm:ss:Jaki� tekst...			TMPlayer
   - hh:mm:ss=Jaki� tekst...			TMPlayer
   - hh:mm:ss,x:Jaki� tekst...			TMPlayer
   - xxxx,xxxx,x,Jakis tekst...			???
   - xxxx,xxxx,Jakis tekst...			MPL
   - [xxxx][xxxx]Jakis tekst|/Jaki� tekst...	MPL2
   - hh:mm:ss --> hh:mm:ss			SRT (SubRipper)
     Jaki� tekst1...
     Jaki� tekst2...
   - [mm:ss] Jaki� tekst...			LRC (Lyrics np. do MP3)


* Odtwarzanie/Pauza 						(Spacja)
  Zatrzymanie 							(. /Kropka/)
  Odtwarzaj poprzedni element z listy				(Ctrl + P)
  Odtwarzaj nast�pny element z listy				(Ctrl + N)
 - w czasie odtwarzania filmu program blokuje wygaszacz ekranu
 - napisy s� wy�wietlane bezpo�rednio na filmie
 - automatycznie wykrywana jest ilo�� linii tekstu widocznych na ekranie


* Tryb pe�noekranowy
 - pe�ny ekran							(Alt + Enter)
 - pe�ny ekran ze zmian� rozdzielczo�ci				(Ctrl + Enter)
 - powr�t do okna						(Esc)
 - po przesuni�ciu myszki na d� lub g�r� ekranu (w zalezno�ci od ustawie� opcji) poka�e si�
   panel kontrolny
 - po przesuni�ciu myszy do prawej kraw�dzi ekranu poka�e si� playlista

* �atwe i szybkie przechodzenie do dowolnego fragmentu filmu.
 - za pomoc� paska post�pu znajduj�cego si� na g�rze panelu kontrolnego; po najechaniu mysz�
   na pasek pokazywany jest czas jaki odpowiada wskazywanemu fragmentowi.
 program umo�liwia nawigacj� do przodu i do ty�u o:
 - 1 sekund� 							(Enter/Backspace)
 - 10 sekund 							(W prawo/W lewo)
 - 1 minut�  							(Ctrl + W prawo/Ctrl + W lewo)
   dwie ostatnie wielko�ci mo�na zmieni� w opcjach.
 - program obs�uguje myszy ze scrollem; wedle uznania k�ko mo�e s�u�y� do przewijania filmu
   lub zmiany g�o�no�ci - konfiguracja z poziomu opcji (F12)

* Zmiana wielko�ci i proporcji obrazu
  wi�kszo�� opcji dost�pna poprzez klawiatur� numeryczn�
 - przesuwanie kadru w dowolnym kierunku			(Num1 do Num9)
   lub za pomoc� myszy: 
   "chwycenie" mysz� kadru, pozwala przesuwa� obraz w pionie, przytrzymuj�c klawisz CTRL
   mo�na r�wnie� zmieni� po�o�enie w poziomie
 - powi�kszenie/pomniejszenie kadru 				(Num+/Num-)
   lub za pomoc� myszy:
   "chwycenie" za kraw�d� filmu i przeci�gni�cie w wybrane po�o�enie
 - zmiana proporcji obrazu					(Num. /Kropka/)
   powoduje cykliczn� zmian� proporcji:
   oryginalne proporcje / rozciagni�cie na ca�e okno programu / 16:9 / 4:3
 - p�ynna zmiana proporcji obrazu				(CTRL + Num2,Num4,Num6,Num8)
   lub za pomoc� myszy:
   przytrzymanie CTRL, "chwycenie" za kraw�d� filmu i przeci�gni�cie w wybrane po�o�enie
 - dopasowanie obrazu do wielko�ci okna programu 		(Num0)
   lub za pomoc� myszy poprzez podw�jne klikni�cie na obrazie
 - podw�jny klik z wcisni�tym klawiszem CTRL dopasowuje obraz do wielko�ci okna i przywraca
   oryginalne proporcje obrazu
 - 50% wielko�ci obrazu						(Alt + 1)
 - 100% wielko�ci obrazu					(Alt + 2)
 - 200% wielko�ci obrazu					(Alt + 3)

* Zmiana tempa odtwarzania filmu
 - zmniejszenie tempa odtwarzania filmu				(Ctrl + Z)
 - zwi�kszenie tempa odtwarzania filmu				(Ctrl + C)
 - przywr�cenie normalnego tempa				(Ctrl + X)
 - tempo mo�na te� regulowa� za pomoc� ma�ego suwaka znajduj�cego si� obok paska
   post�pu czasu odtwarznia pliku

* Zmiana poziomu g�o�no�ci
 - g�o�niej 							(Home)
 - ciszej							(End)
 - wycisz							(Ctrl + M)
 - program obs�uguje myszy ze scrollem; wedle uznania k�ko mo�e s�u�y� do przewijania filmu
   lub zmiany g�o�no�ci - konfiguracja z poziomu opcji (F12)
 - g�o�no�� mo�na te� regulowa� za pomoc� tr�jk�tnego suwaka znajduj�cego si� po prawej
   stronie panelu sterowania.

* Manipulacja napisami
 - przesuni�cie napis�w wzgl�dem filmu o sekund� do ty�u	([)
 - przesuni�cie napis�w wzgl�dem filmu o sekund� do przodu	(])
 - anulowanie przesuni��					(P)
   na pasku statusu pokazywane jest o ile przesuni�te s� napisy wzgl�dem filmu
 - ukrycie/pokazanie napis�w					(Alt + T)
 - pomniejszenie czcionki					(Ctrl + -)
 - powi�kszenie czcionki					(Ctrl + =)
 - zmiana po�o�enia napis�w w pionie				(Ctrl + w g�r�/Ctrl + w d�)
   lub za pomoc� myszy:
   wystarczy "chwyci�" napisy i przesun�� w wybrane po�o�enie

* Parametry uruchomieniowe; kolejno�� parametr�w jest nieistotna:
 - pliki video, audio lub playlisty ze �cie�kami dost�pu (je�eli wyst�puj� spacje,
   to �cie�ki nale�y umie�ci� w cudzys�owach)
 - /f - start w trybie pe�noekranowym
 - /ff - start w trybie pe�noekranowym ze zmienion� rozdzielczo�ci�
 - /m - start w zmaksymalizowanym oknie

* Program jest wieloj�zyczny
  Wystarczy umie�ci� plik z przet�umaczonymi napisami w katalogu i program automatycznie
  b�dzie obs�ugiwa� dany j�zyk. Pliki maj� rozszerzenie "lng", ale maj� struktur� plik�w
  "ini". J�zyk polski jest wbudowany w program. Plik 'Polski.lng' do��czony zosta� tylko
  w celu u�atwienia wykonywania t�umacze� osobom nieznaj�cym j�zyka angielskiego.
  Je�eli znasz jaki� j�zyk obcy, to przet�umacz plik .lng i wy�lij go na adres:
  info@cineamaplayer.prv.pl; plik zostanie do��czony do programu, a wzmianka o Tobie b�dzie
  umieszczona w programie



2. Opcje dost�pne z poziomu okienka "Options":
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Zak�adka "Napisy":
------------------------------

* Wyb�r czcionki i kolor�w dla napis�w
* Zmiana grubo�ci obw�dki wok� liter
* Skalowanie wysoko�ci czcionki w zale�no�ci od wielko�ci okienka. Je�eli opcja jest
  w��czona to wybrana wysoko�� czcionki dotyczy pe�nego ekranu
* Odleg�o�� napis�w od dolnej kraw�dzi filmu (w procentach wysoko�ci filmu)
* Czas przez jaki wy�wietlany jest napis (je�eli plik z napisami tego nie okre�la)
* Domy�lny folder dla napis�w. Tutaj program szuka pliku, je�eli nie znajdzie go w folderze,
  w kt�rym znajduje si� film

Zak�adka "Odtwarzanie":
------------------------------

* Nawigacja pozwala na przewijanie i szybki dost�p do dowolnego fragmentu filmu. Ma�e kroki
  s� te� u�ywane do przewijania filmu za pomoc� scrolla w myszce
* K�ko myszy mo�e sterowa� przeszukiwaniem filmu lub regulacj� g�o�no�ci
* Mo�na zmieni� odwr�ci� kierunek przwijania filmu scrollem myszy
* Mozna ustawi� czas po jakim zostanie ukryty kursor myszy w trybie pe�noekranowym
* Mo�na wybra� rozdzielczo�� jaka b�dzie u�yta w trybie pe�noekranowym
* Ukrywanie paska zada� w trybie pe�noekranowym - przydatne gdy pasek ma w��czon� opcj�
  'Autoukrywanie'
* Mo�na automatycznie przej�� do trybu pe�noekranowego w momencie rozpocz�cia odtwarzania
  (r�wnie� ze amian� rozdzielczo�ci)
* Na pe�nym ekranie mo�na przenie�� panel kontrolny na g�r� ekranu (nie b�dzie zas�ania�
  napis�w)
* Liczba klatek na sekund� dla plik�w '.asf' i tekst�w w formacie z klatkami
* Mo�na automatyczne odtwarza� film po za�adowaniu
* Mo�na nakaza� zamkni�cie playera po sko�czeniu odtwarzania filmu
* Mo�na nakaza� uruchamianie tylko jedej kopii programu
* Mo�na zamkn��/u�pi� system po sko�czonym odtwarzaniu filmu
* Domy�lny folder dla film�w


Zak�adka "FileTypes"/"Typy plik�w":
-----------------------------------

Program mo�e s�u�y� jako domy�lny odtwarzacz film�w w systemie.
W oknie dialogowym wyboru pliku (wczytywanie filmu lub playlisty) wy�wietlane s� tylko te pliki,
  kt�rych rozszerzenia wymienione s� na tej zak�adce.
* Lista znajduj�ca si� po lewej stronie zawiera playlisty (na g�rze) oraz pliki multimedialne
  (na dole), kt�re nie s� skojarzone z odtwarzaczem, ale program mo�e je otwiera�.
  Pliki te mog� mie� dodan� opcj� "Otw�rz z CinemaPlayer" do systemowego menu kontekstowego.
* Lista po prawej stronie zawiera pliki, kt�re maj� by� automatycznie otwierane za pomoc�
  CinemaPlayera.


=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-


To wszystko...
Mi�ego ogl�dania!!!


(C) Zbigniew Chwedoruk
Bia�a Podlaska/Wroc�aw 2000-2007