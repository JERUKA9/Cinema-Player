=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

				    CinemaPlayer 1.6 beta8
				       dn. 17.01.2007

				  Autor: Zbigniew Chwedoruk
				e-mail: info@cinemaplayer.net
				  www: www.cinemaplayer.net

			    Program nale¿y do kategorii FREEWARE

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-




I. Informacje ogólne
====================


1. Co to za program i do czego s³u¿y:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

CinemaPlayer to program do odtwarzania filmów z napisami. Rozpoznaje wszystkie popularne
formaty napisów i list odtwarzania (playlisty). Potrafi równie¿ odtwarzaæ pliki dŸwiêkowe (wav,
mp3) oraz napisy do piosenek w formacie LRC. Odtwarzacz cechuje szybkoœæ dzia³ania, prostota
i intuicyjnoœæ obs³ugi oraz dziêki niezale¿noœci od Windows Media Player niskie wymagania
sprzêtowe.


2. Wymagania:
~~~~~~~~~~~~~

Do poprawnej pracy program potrzebuje DirectX w wersji przynajmniej 6. Zalecana jest najnowsza
wersja. Niektóre filmy wymagaj¹ dodatkowych kodeków.
Program jest przeznaczony dla systemów Windows 9x/ME oraz NT/2000/XP/Vista.


II. Historia zmian:
===================


wersja 1.6 beta8

I kolejna porcja zmian:
* (nowe) Dodano obs³ugê syntezatora ExpressIVO. Na razie nie da siê regulowaæ g³óœnoœci
  i prêdkoœci czytania.
* (nowe) Dodano opcjê kasowania zak³adek.
* (nowe) Dodano opcjê czyszczenia listy przy wyjœciu z programu.
* (nowe) Dodano opcjê wy³¹czaj¹c¹ przesuwanie obrazu mysz¹ na pe³nym ekranie.
* (nowe) Dodano opcjê pozwalaj¹c¹ ustawiæ czu³oœæ filtra wyszukuj¹cego plik z napisami.
  Dostêpne s¹ trzy poziomy:
  - tylko napisy o takiej samej nazwie jak plik z filmem
  - dopuszczaj napisy o podobnej nazwie jak plik z filmem
  - dopuszczaj równie¿ napisy o ma³o podobnej nazwie, ale tylko jeœli w katalogu nie ma
    innego filmu, który bardziej pasuje do tych napisów.
* (b³¹d 1.6) Przy wznawianiu ostatnio ogl¹danego filmu program ignorowa³ stan opcji,
  wy³¹czaj¹cej wczytywanie napisów.
* (b³¹d 1.6) Przy aktywnej opcji "Zatrzymaj odtwarzanie podczas zmiany ustawieñ", po
  aktywowaniu menu kontekstowego, a nastêpnie zamkniêciu tego menu przez klikniêcie lewym
  klawiszem myszy nastêpowa³o przesuniêcie obrazu.
* (b³¹d 1.6) Przy wstrzymanym odtwarzanieu (pauza) dwukrotne klikniêcie na film nie
  zmienia³o stanu: pe³ny ekran - okienko.
* (b³¹d 1.6) Jeœli program zosta³ automatycznie zamkniêty w powodu ogl¹dniêcia ca³ego filmu,
  to podczas próby ponownego uruchomienia ostatnio odtwarzanego filmu player wy³¹cza³ siê.
* kilka innych drobnych usprawnieñ i poprawek


wersja 1.6 beta7

19.12.2006

Tyle ile zd¹¿y³em zrobiæ do Œwi¹t:
* (nowe) Poprawiono wyszukiwanie napisów. Nowy algorytm powinnien zaspokoiæ oczekiwania
  znacznej wiêkszoœci u¿ytkowników. Dodatkowo, jeœli program znajdzie w katalogu kilka
  pasuj¹cych napisów, to wyœwietlana jest lista plików z mo¿liwoœci¹ wybrania w³aœciwego.
* (nowe) Po uruchomieniu playera aktywna jest opcja "Odtwarzanie". Jeœli zostanie ona wybrana
  przed wczytaniem filmu, to program bêdzie kontynuowa³ odtwarzanie ostatnio otwieranego pliku.
* (nowe) Pojawi³a siê nowa zak³adka w opcjach: "Playlista". Na razie zosta³a dodana jedna
  opcja, która pozwala wy³¹czyæ pytanie o kolejn¹ p³ytê CD podczas wyszukiwania nastêpnej
  (potencjalnie) czêœci filmu. 
* (b³¹d 1.6) Program koñczy³ siê b³êdem po wejœciu do opcji pod "Windows Vista".
* (b³¹d 1.6) Po przejœciu do pe³nego ekranu ze zmian¹ rozdzielczoœci znika³ obraz.
* kilka innych drobnych usprawnieñ i poprawek


wersja 1.6 beta6

16.11.2006

Znowu poprawki i parê nowych drobiazgów:

* (nowe) Dodano opis skrótów klawiszowych do menu pomocy. Spis dostêpny jest pod klawiszem F1.
* (nowe) Dodano t³umaczenie na jêzyk wêgierski. Podziêkowania dla Daniela Keszei.
* (nowe) Dodano obs³ugê klawiszy specjanych na klawiaturach multimedialnych. Program obs³uguje
  nastêpuj¹ce klawisze: Mute, Volume down, Volume up, Next track, Prev track, Stop, Play/Pause.
* (nowe) Po operacji Drag&Drop na playliœcie pliki zawsze dodaj¹ siê do istniej¹cej listy.
* (nowe) Dodano MP4 do listy obs³ugiwanych plików.
* (zmiana) Przy aktywnej opcji zamykania systemu po skoñczeniu odtwarzania, program nie zamyka
  systemu, jeœli w momencie skoñczenia filmu u¿ytkownik przegl¹da jakieœ okienko:
  (opcje, wczytywanie pliku, zmiana czcionki, itp.)
* (zmiana) Po w³¹czeniu œledzenia napisów automatycznie nastêpuje skok do najbli¿szego napisu,
  bez oczekiwania na pojawienie siê tego napisu.
* (zmiana) Aktualny napis w edytorze jest podkreœlony tylko wtedy, gdy opcja œledzenia
  jest aktywna.
* (b³¹d 1.6beta5) Program nie wczytywa³ napisów, jeœli by³ tylko jeden plik w katalogu z inna
  nazw¹ ni¿ film.
* (b³¹d 1.5) Poprawiono algorytm automatycznie wyszukuj¹cy nastêpny film w katalogu.
  Czasami Ÿle by³y rozpoznawane pliki, które w nazwie mia³y kolejny numer.
* (b³¹d 1.6beta5) Poprawiono dzia³anie opcji, która pozwala zatrzymaæ odtwarzanie po jednym
  klikniêciu myszk¹ na filmie.
* (b³¹d 1.6beta5) Poprawiono wyszukiwanie w katalogu pliku napisów o podobnej nazwie do filmu.
  Obecnie plik uznawany jest za podobny, jeœli ma przynajmiej w po³owie tak¹ sam¹ nazwê,
  lub jeœli nazwa filmu zawiera siê w nazwie napisu (albo odwrotnie).
* (b³¹d 1.6) Poprawiono dzia³anie opcji "Ukryj napisy". Zdarza³o siê, ¿e po w³¹czeniu tej
  opcji i wy³¹czeniu napisy ju¿ sie nie pojawia³y.
* (b³¹d 1.6) Poprawiono obs³ugê klawiatury w drzewku w okienku "Opcje".
* (b³¹d 1.x) Poprawiono wygl¹d okienka edytora przy du¿ym rozmiarze czcionek (120 dpi).
* kilkanaœcie innych drobnych zmian i poprawek.


wersja 1.6 beta5

02.10.2006

Kolejna porcja poprawek:

* (nowe) Dodano opcjê (Odtwarzanie->Nawigacja), która pozwala zatrzymaæ odtwarzanie
  po jednym klikniêciu myszk¹ na filmie.
* (nowe) Dodano mo¿liwoœæ regulowania czasu wyœwietlania napisów za pomoc¹ kó³ka myszy.
* (nowe) Dodano nowe podzycje w menu "Pomoc". Teraz mo¿na od razu przejœæ na stronê
  g³ówn¹ programu lub na forum.
* (b³¹d 1.6 beta4) W poprzedniej becie zepsuto blokowanie wygaszania monitora.
* (b³¹d 1.x) Znika³ obraz, jeœli w poprzedniej sesji "rêczne" zmieniono proporcje filmu.
* kilka innych drobnych poprawek


wersja 1.6 beta4

03.09.2006

Teraz te¿ g³ównie usuniêto b³êdy:

* (nowe) W okienku "O programie" znajdujê siê lista osób, które wp³aci³y jakiœ datek
  na CinemaPlayer. To dziêki nim player ma now¹ domenê!
* (nowe) Mo¿na wczytywaæ napisy, po przeci¹gniêciu pliku napisów na okno playera.
* (nowe) Program próbuje wczytaæ jako film, pliki o nieznanym rozszerzeniu przeci¹gniête
  na okno playera.
* (nowe) Jeœli film posiada kilka œcie¿ek audio i jest to mo¿liwe, to player próbuje wybraæ
  œcie¿kê w jêzyku pasuj¹cym do wersji jêzykowej, jaka jest ustawiona w programie.
* (nowe) Program próbuje odnaleŸæ plik z napisami jeœli ma on inn¹ nazwê ni¿ film.
  W trakcie Waszych testów oka¿e siê, czy przyjêty dopuszczalny poziom podobieñstwa jest
  odpowiedni.
* (nowe) Do opcji zamykania systemu po skoñczonym filmie dodano Hibernacjê.
* (b³¹d 1.6) Na s³abszych komuterach zdarza³o siê, ¿e lektor wyprzedza³ film.
  W zwi¹zku z tym zmniejszono lekko priorytet w¹tku lektora.
* (b³¹d 1.6) Usuniêto komunikat "Nieznany format pliku z napisami" jaki pojawia³ siê
  podczas automatycznego wczytywania napisów, gdy w katalogu z filmem istnia³ jeden plik
  tekstowy, ale nie bêd¹cy w rzeczywistoœci napisami do filmu. Teraz ten komunikat pokazuje
  siê tylko przy "rêcznym" wczytaniu pliku przez u¿ytkownika.
* (b³¹d 1.6) Pliki rmvb zawsze mia³y fps ustawione na 30.
* (b³¹d 1.6) Gdy opcja "Wczytaj napisy automatycznie" by³a nieaktywna, film nie uruchamia³
  siê automatycznie.
* (b³¹d 1.6) Usuniêto "Runtime Error 217" przy zmianach strumienia audio.
* (b³¹d 1.6) Lektor czyta³ kody opisuj¹ce styl napisów. Dodatkowo lektor pomija te¿ pierwsz¹
  linijkê napisów jeœli jest tam tylko informacja o formacie filmu i/lub pochodzeniu napisów.
* (b³¹d 1.2) Jeœli podczas automatycznego zamykania/usypiania systemu by³o otwarte menu
  kontekstowe, to program przestawa³ odpowiadaæ lub zawiesza³ ca³y system (win9x).
  Na pewno poprawnie dzia³a teraz pod win2k/xp. Nie mam mo¿liwoœci sprawdziæ jak jest
  pod win9x. Nadal istnieje dziwne zachowanie menu kontekstowego w czasie tej operacji.
  Nie powoduje to ¿adnych skutków ubocznych, a jest trudne do poprawienia wiêc pozostawi³em
  to tak jak jest.
* Kilka innych drobnych poprawek.


wersja 1.6 beta3

03.05.2006

Tym razem przede wszystkim usuniêto b³êdy:

* (nowe) Player wczytuje plik napisów, jeœli ma inna nazwê ni¿ film, ale jest jedynym
  plikiem tekstowym w katalogu.
* (nowe) Po wyjœciu z programu zapamiêtywany jest stan opcji "Czas pozosta³y do koñca filmu".
* (nowe) Dodano opcjê pozwalaj¹c¹ nie wczytywaæ automatycznie napisy.
* (zmiana) Poprawiono dzia³anie przycisku "Zastosuj" w ustawieniach. Przycisk jest odblokowany
  tylko jeœli nast¹pi³a jakaœ zmiana w ustawieniach.
* (b³¹d 1.6) Poprawiono b³¹d powoduj¹cy znikanie napisów po przejœciu do pe³nego ekranu.
* (b³¹d 1.6) Poprawiono b³¹d "Floating point division by zero".
* (b³¹d 1.6) Poprawiono b³¹d "Index out of bounds" pojawiaj¹cy siê po odinstalowaniu lektora.
* (b³¹d 1.6) Program nie zapamiêtywa³ ustawieñ domyœlnego katalogu dla filmów.
* (b³¹d 1.4) Poprawiono automatyczne wyszukiwanie kolejnych czêœci filmu. Przy wiêkszej iloœci 
  plików player wczytywa³ je w nastêpuj¹cej kolejnoœci: 01,02,03,04,05,15,16 i dalej 06,16.
* (b³¹d 1.x) Poprawiono obs³ugê klawiatury w "Edytorze szybkoœci wyœwietlania napisów" oraz
  "Edytorze napisów". Teraz klawisz skrótu (odpowiednio F8 i F11) otwiera i zamyka edytor.
  W "Edytorze szybkoœci wyœwietlania napisów" oraz "Korektorze czasu" dzia³a równie¿
  klawisz ESCAPE.
* (b³¹d 1.x) Poprawiono dzia³anie przesuwania pozycji na playliœcie. Po naciœniêciu klawisza
  ALT+DOWN lub ALT+UP przesuniêty element nadal jest zaznaczony.
* Kilka innych drobnych poprawek.


wersja 1.6 beta2

11.12.2005

Trochê spóŸniony Miko³aj:

* (nowe) Player poprawnie rozpoznaje œcie¿ki dŸwiêkowe w plikach OGM i MKV.
  Pliki OGM trzeba jeszcze przetestowaæ.
* (nowe) Dodano mo¿liwoœæ wyboru urz¹dzenia audio, na które zostanie skierowany dŸwiêk.
  Opcja dostêpna jest w "Opcje->Odtwarzanie->Pozosta³e opcje". Powinno to pozwoliæ
  na wybór karty dŸwiêkowej, jeœli s¹ dwie w systemie. Pozwala te¿ na lepszy dobór
  urz¹dzenia audio w przypadku dzwiêku w formatach AC3.
* (nowe) Player rozpoznaje jêzyk w ustawieniach u¿ytkownika i jeœli posiada odpowiedni¹
  wersjê jêzykow¹, to autmatycznie j¹ wybiera. W kolejnej wersji zostanie dodana te¿
  preselekcja œcie¿ki dŸwiêkowej.
* (nowe) Pojawi³o siê t³umaczenie playera na jêzyk hiszpañski.
  Podziêkowania dla Grecco Calderon!
* (nowe) Dodano mo¿liwoœæ w³¹czania/wy³¹czania lektora za pomoc¹ pilota.
* (nowe) Dodano opcjê pozwalaj¹c¹ na przerywanie przed koñcem czytania napisu przez
  lektora, jeœli pojawi³ siê nastêpny napis do przeczytania.
* (nowe) Dodano opcjê do ukrywania napisów, jeœli aktywny jest lektor.
* (nowe) Dodano now¹ pozycjê do listy predefiniowanych proporcji obrazu: 2.35:1
* (nowe) Dodano okienko z numerem konta bankowego autora (dostêpne w menu "Pomoc").
  Jeœli ktoœ uwa¿a, ¿e warto wesprzeæ projekt, to proszê bardzo :-)
* (b³¹d 1.6beta1) Player 1.6 ³¹czy dwa napisy w jeden, jeœli maj¹ ten sam czas i wystêpuj¹
  w pliku kolejno po sobie. Niestety b³êdnie by³ robiony podzia³ linii w takim napisie.
* (b³¹d 1.5) Po zatwierdzeniu ustawieñ (F12) napisy zawsze by³y w³¹czone, niezale¿nie 
  od stanu odpowiedniej opcji.
* (b³¹d 1.5) Przy widoku minimalnym, po przejœciu do pe³nego ekranu i póŸniejszego powrotu
  do okienka, pojawia³o siê menu, jak przy widoku standardowym.
* (b³¹d 1.x) Poprawiony stary b³¹d, który objawia³ siê dziwnym zachowaniem okien na pulpicie,
  po wyjœciu z pe³nego ekranu, kiedy aktywna by³a opcja "Ukryj pasek zadañ w trybie
  pe³noekranowym".
* (b³¹d 1.x) Teraz player poprawnie czyta nominaln¹ wartoœæ FPS w plikach OGM i MKV.
* Kilka innych drobnych poprawek.


wersja 1.6 beta1

18.10.2005

Na pocz¹tek skromna lista, ale bêdzie sukcesywnie siê rozrastaæ:

* (nowe) Dodano obs³ugê lektora! CinemaPlayer korzysta bezpoœrednio z modu³ów SAPI4 i SAPI5.
  Nie trzeba instalowaæ dodatkowych programów!
* (nowe) Dodano obs³ugê napisów w formacie SSA/ASS. Niestety CinemaPlayer nie potrafi
  interpretowaæ kodów steruj¹cych tego formatu. Wyœwietlane s¹ tylko same napisy.
* (nowe) Dodano obs³ugê kodów steruj¹cych wystêpuj¹cych na koñcu napisu
* (nowe) Dodano rozszerzenia MKV, MKA i RMVB do domyœlnej listy obs³ugiwanych plików.
* (b³¹d 1.5) Czasami po zamkniêciu edytora napisów film by³ przewijany na pocz¹tek.
* (b³¹d 1.5) Player nie wyœwietla³ napisu jeœli wewn¹trz wystêpowa³a pusta linia.
* (b³¹d 1.5) Nie wczytywa³y sie niektóre linie w napisach SRT


wersja 1.5.3

18.02.2005

Poprawiny po poprawinach:

* (b³¹d 1.5) Zak³adka "Typy plików" ju¿ ostatecznie powinna dzia³aæ poprawnie.
* (b³¹d 1.5) Nie dzia³a³a opcja "OSD po prawej stronie".


wersja 1.5.2

13.02.2005

Poprawiny po urodzinach:

* (zmiana) Opcja (Napisy|Pozosta³e opcje|Maksymalna szerokoœæ napisów) przyjmuje teraz wartoœci
  w pikselach lub procentach
* (b³¹d 1.4x) Poprawiono uruchamianie programu z parametrem "/ff". Czasami program pokazywa³
  czarny ekran zamiast filmu.
* (b³¹d 1.5) Program Ÿle wyœwietla³ w OSD opis opcji posiadaj¹cych stan w³¹czone/wy³¹czone.
* (b³¹d 1.5) W niektórych przypadkach program zawiesza³ siê (pusty komunikat o b³êdzie) przy
  wejœciu do opcji.


wersja 1.5.1

03.02.2005

Z okazji czwartych urodzin:

* (nowe) W opcjach dodano zak³adkê "Foldery". Zebrane zosta³y tam wszystkie œcie¿ki
  do katalogów u¿ywanych przez program. Do tej pory by³y dostêpne dwie: domyœlny folder
  dla filmów i dla napisów. Teraz pojawi³ siê trzeci: dla zrzutów ekranu.
* (nowe) Zapis aktualnej klatki do pliku. Po d³ugim okresie zmagania siê z problemami, 
  w koñcu uda³o siê uruchomiæ screenshoty. Pliki (w formacie BMP) zapisywane s¹ do katalogu
  ustawionego w zak³adce "Foldery". (Domyœlnie "Moje dokumenty"). Tworzony jest tam podkatalog
  z nazw¹ filmu a plik ma nazwê w formacie: "h_mm_ss_mms.bmp". Jest to czas filmu, z którego
  pochodzi klatka. Opcja ta mo¿e sprawiaæ jeszcze trochê problemów (w³acznie z zawieszeniem
  programu!)
* (nowe) Dodano opcjê (Napisy|Pozosta³e opcje|Maksymalna szerokoœæ napisów) pozwalaj¹c¹ 
  na ograniczenie maksymalnego rozmiaru napisów w poziomie. Przydatne jest do podczas ogl¹dania
  filmu na telewizorze, kiedy film (a w raz z nim napisy) nie mieszcz¹ siê na ekranie.
* (nowe) Dodano opcjê (Odtwarzanie|Pe³ny ekran|Wymuszaj standardowy panel kontrolny w trybie 
  pe³noekranowym). Dziêki niej mo¿na sprawiæ, ¿e nie zale¿nie od tego jaki jest ustawiony tryb 
  widoku, na pe³nym ekranie zawsze bêdzie widoczny panel standardowy.
* (nowe) Dodano opcjê (Odtwarzanie|Pozosta³e opcje|Zatrzymaj odtwarzanie podczas minimalizacji).
  Opcja przydatna szczególnie podczas s³uchania muzyki. Mo¿na zminimalizowaæ program, a utwór
  jest nadal odtwarzany
* (nowe) Player potrafi znaleŸæ plik z napisami, jeœli przy wczytywaniu kolejnej czêœci filmu
  nazwa napisów ró¿ni siê od nazwy filmu, ale jest utworzona wed³ug tej samej regu³y co nazwa 
  pliku z napisami dla poprzedniej czêœci filmu.
* (zmiana) Przeniesiono opcjê "Zatrzymaj odtwarzanie podczas zmiany ustawieñ" a zak³adki 
  "Odtwarzanie|Pe³ny ekran" do "Odtwarzanie|Pozosta³e opcje".
* (b³¹d 1.5) Na pe³nym ekranie, napisy pojawia³y siê przed panelem narzêdziowym.
* (b³¹d 1.5) Po otwarciu filmu przez "Otwórz z...' lub dwuklik na pliku napisy by³y niewidoczne.
* (b³¹d 1.5) le dzia³a³a opcja zmiany proporcji obrazu. Program nie pamiêta³ ostatnich ustawieñ
  podczas kolejnego uruchomienia oraz niewidoczne by³o OSD
* (b³¹d 1.5) Czasami w okienku opcji nie da³o siê "rozwin¹æ" ComboBoxów.
* (b³¹d 1.5) Kiedy ustawienia by³y zapisane do pliku, obraz by³ niewidoczny.
* (b³¹d 1.5) Program zawiesza³ siê, jeœli w trybie pe³noekranowym wybrano opcjê 
  "Widok 200%" (Alt+3).
* (b³¹d 1.5) le dzia³a³a zmiana g³oœnoœci przy pomocy kó³ka myszy.
* (b³ad 1.5) Po w³¹czeniu widoku minimalnego pasek narzêdziowy w trybie pe³noekranowym by³ 
  uszkodzony.
* (b³¹d 1.5) Przy zapisie playlisty program nie dodawa³ rozszerzenia (asx)
* (b³ad 1.x) Jeœli na koñcu napisu znajdowa³ siê znak podzia³u linii ("|"), to napisy 
  wyœwietlane na ekranie zajmowa³y prawie ca³y film



wersja 1.5

28.11.2004

D³uuuuugo to trwa³o, niektórzy ju¿ zw¹tpili, ale jednak nasta³ ten dzieñ...

* (nowe) Ca³kowicie nowy "silnik" do wyœwietlania napisów. Teraz powinno dzia³aæ stabilniej 
  i szybciej.
   - Tryb przezroczystych napisy przy wykorzystaniu overlay
   - Opcja pozwalaj¹ca na "przyci¹ganie" napisów do filmu. Szczególnie przydatne na 
     pe³nym ekranie i panoramicznych filmach. Napisy wyœwietlaj¹ siê zaraz pod filmem, 
     niezale¿nie od tego jakich s¹ rozmiarów. Oczywiœcie, jeœli napis nie zmieœci siê 
     w ca³oœci pod filmem, to bêdzie wyœwietlany odpowiednio wy¿ej.
   - Trzecia, bardzo gruba obwódka dla napisów.
   - Jeœli w trybie napisów "Pod filmem", dany napis mia³ wiêcej linii ni¿ zak³ada³y
     ustawienia, to ostatnie linie nie by³y wyœwietlane. Teraz takie napisy s¹ przesuwane 
     do góry (nachodz¹ na film), tak aby ca³y tekst zosta³ wyœwietlony. 
   - Dodano obs³ugê tagów pozwalaj¹cych formatowaæ wyœwietlanie napisy.
     Dok³adny opis obs³ugiwanych tagów znajduje siê w pliku "kody_sterujace_do_napisow.txt".
   - W zwi¹zku z wprowadzeniem obs³ugi tagów usuniêto opcjê, nakazuj¹c¹ interpretacjê 
     znaku "/" na poczatku napisu jako pochylenie czcionki. Teraz ta opcja jest zbêdna.

* (nowe) Inteligentne napisy
   - Dodano graficzny edytor pozwalaj¹cy regulowaæ prêdkoœæ wyœwietlania napisów. 
     Edytor dostepny jest w menu 'Widok' oraz z menu kontekstowego. Skrót klawiszowy: (F8).
     Edytor sk³ada siê z wykresu graficznego i czterech suwaków do regulacji ustawieñ.
     Wykres przedstawia funkcjê:
             | y = ax^2 + bx + c
      f(x) = |
             | y <= d

     gdzie:
        a - Przyrost czasu na literê [sek]
        b - Sta³y czas na literê [sek]
        c - Minimalny czas trwania napisu [sek]
        d - Maksymalny czas trwania napisu [sek]

        x - D³ugoœæ napisu [iloœæ liter]
        y - Czas wyœwietlania napisu [sek]

     Wartoœci x i y s¹ od³o¿one na wykresie. Parametry a, b, c oraz d mo¿na modyfikowaæ 
     przy pomocy suwaków.
     Zmiana parametrów jest od razu odzwierciedlana w odtwarzanym filmie, tak¿e mo¿na ³atwo 
     "organoleptycznie" dobraæ w³aœciwe dla nas tempo.
     Wprowadzono te¿ zabezpieczenie przed nadmiernym opóŸnianiem siê napisów. Player pozwala 
     na max. 2 sekundy opóŸnienia w stosunku do oryginalnego czasu. Jeœli czas ten zostanie 
     przekroczony, to natychmiast wyœwietlany jest nastêpny napis. (Zobaczymy jak to dzia³a 
     w praktyce i ewentualnie bêd¹ jakieœ korekty).

* (nowe) Dodano obs³ugê nowych formatów napisów: MPL3 oraz HATAK

* (nowe) Dodano OSD
   - Wygl¹d czcionki mo¿na regulowaæ podobnie jak przy napisach. 
     Mo¿liwa jest te¿ zmiana po³o¿enia i wielkoœci OSD przy pomocy skrótów. S¹ one takie same
     jak dla zmiany po³o¿enia napisów, tylko dochodzi jeszcze SHIFT, czyli: 
     Ctrl+Shift+Kursor_w_góre/Kursor_w_dó³ oraz Ctrl+Shift+ -/=. Mo¿na te¿ chwyciæ OSD 
     i przesun¹æ mysz¹
   - Dodano opcjê (F9), która pokazuje aktualny czas w formacie:
     "aktualny_czas_filmu"/"ca³kowity_czas_filmu" ["aktualna godzina"]
     Jeœli w menu Widok w³¹czono pokazywanie czasu pozosta³ego do koñca filmu, to 
     "aktualny_czas_filmu" wyœwietla czas w tej postaci

* (nowe) Dodano obs³ugê pilota
   - Opis kodów steruj¹cych znajduje siê w pliku "RemoteControler.txt".
   - Stworzony zosta³ plik do Girdera zawieraj¹cy wszystkie kody steruj¹ce do CinemaPlayera

* (nowe) Przebudowane okno ustawieñ (F12).
   - Teraz powinno byæ bardziej przejrzyœcie.
   - Okno przystosowane jest do obs³ugi stylów Windows XP.
   - Dodano opcjê "Zastosuj". Mo¿na zatwierdziæ wprowadzone zmiany bez zamykania okna

* (nowe/zmiana) Udoskonalono wyszukiwanie kolejnych czêœci filmu. 
   - Nazwa filmu nie musi koñczyæ siê cyfr¹. Numer pliku mo¿e znajdowac siê w dowolnym miejscu
     nazwy. 
   - Poprawiono procedurê zmiany p³yty w napêdzie CD. Po skoñczonym odtwarzaniu czêsci filmu
     player sam wysuwa p³ytê z napêdu, po wymianie p³yty i klikniêciu OK program zamyka tackê
     i rozpoczyna odtwarzanie kolejnej czêœci filmu.
   - Przy wy³¹czonej opcji "Rozpocznij odtwarzanie filmu po za³adowaniu", kolejne czêœci tego 
     samego filmu s¹ uruchamiane automatycznie.
   - Dodano opcjê wy³¹czaj¹c¹ automatyczne wyszukiwanie kolejnych czêœci filmu. 
     (Odtwarzanie->Pozosta³e opcje)

* (nowe) Dodano wsparcie dla filmów z kilkoma œcie¿kami audio
   - Pod prawym klawiszem myszy na ikonie g³oœniczka (obok regulacji g³óœnoœci) jest dostêpne
     menu w którym mo¿na zmieniæ œcie¿kê.

* (nowe) Dodano skrót klawiszowy do minimalizacji aplikacji (Shift+Esc)
* (nowe) Dodano opcjê "Prze³aduj film" do menu "Plik" (Ctrl+Q)
* (nowe) Dodano mo¿liwoœæ przeniesienia playlisty na lew¹ stronê okna
* (zmiana) Usuniêto automatyczne pokazywanie playlisty po przesuniêciu myszy do krawêdzi 
  ekranu na pe³nym ekranie
* (zmiana) Przebudowano menu Proporcji obrazu. Przeniesiono je poziom wy¿ej ni¿ by³o 
  poprzednio. Teraz jest obok menu "Powiêkszenie". Dodatkowo wybrana opcja proporcji obrazu 
  jest pamiêtana podczas kolejnego uruchomienia programu. 
* (nowe) Dodano przycisk do paska menu zamykaj¹cy program. Przycisk pojawia sie w trybie 
  pe³noekranowym.
* (nowe) Jeœli rozszerzenia plików zostan¹ skojarzone z playerem ("Typy plików" w opcjach),
  to w Windows XP CinemaPlayer zostanie dodany równie¿ do menu, jakie pojawia siê po w³o¿eniu
  p³yty do napedu CD (podziêkowania dla Krzysztofa S³owika)
* (poprawione) Przesuwanie napisów "w czasie" (klawisze "[", "]") dzia³a teraz co 0.25 sek.
* (nowe) Dodano mo¿liwoœæ w³¹czenia/wy³¹czenia pe³nego ekranu przez podwójne klikniêcie 
  na filmie (Odtwarzanie->Pe³ny ekran). Akcja która poprzednio by³a pod tym skrótem 
  (wycentrowaniu kadru) dalej jest dostêpna, nale¿y trzymaæ wciœniêty klawisza SHIFT, podczas 
  klikania. 
  Jeœli ta opcja jest wy³¹czona, to przy podwójnym kliku jest wycentrowanie kadru, natomiast 
  z SHIFTem przejœcie z/do pe³nego ekranu.
* (nowe) Dodano opcjê pozwalaj¹c¹ na zapamiêtanie po zamkniêciu programu, czy opcja 
  "Wy³¹czaj¹cej komputer po obejrzeniu filmu" (CTRL+F4) jest aktywna. Przydatne dla osób, 
  które notorycznie zasypiaj¹ podczas ogl¹dania filmu :-)
* (nowe) Dodano specjalny program "Language Translator" u³atwiaj¹cy tworzenie i edycjê plików 
  z wersjami jêzykowymi. Zmieniono format plików jêzykowych (LNG). 
  Zapraszam wszystkch do tworzenia nowych t³umaczeñ.
* (b³¹d 1.x) Jeœli obraz by³ powiekszony, to player Ÿle ustawia³ po³o¿enie i rozmiar
  obrazu po wczytaniu kolejnej czêœci filmu
* (b³¹d 1.x) Przy w³¹czonej opcji "Zawsze na wierzchu", niektóre okina dialogowe 
  pokazywa³y siê pod oknem playera i nie da³o siê ich "wyci¹gn¹æ" na wierzch.
* (b³¹d 1.2) przewiniêcie filmu na koniec przy pomocy myszy na pasku postêpu rozpoczyna³o 
  procedurê zamykania systemu (jeœli by³a w³¹czona) przed puszczeniem klawisza myszy
* (b³¹d 1.2) program zawiesza³ siê zaraz po wczytaniu filmu odtwarzanego przy pomocy nowszych
  wersji kodeka ffdshow
* (b³¹d 1.4) Czasami Ÿle inicjowane by³y listy obs³ugiwanych rozszerzeñ na zak³adce 
  "Typy plików" w opcjach. Pojawia³y siê podwójne wpisy.
* (b³¹d 1.4) Poprawiono automatyczne ³adowanie kolejnych czêœci filmu, przy zmianie numeru 
  pliku z 9->10, 19->20 itd.
* (b³¹d 1.4a) Poprawiono wczytywanie napisów podczas odtwarznia. (Film zatrzymywa³ sie 
  na oko³o 1 sekundê)
* (b³¹d 1.4a) Przy przejœciu do pe³nego ekranu ze zmian¹ rozdzielczoœci player "gubi³" napisy.
  Trzeba by³o wczytaæ je ponownie
* UWAGA! stwierdzono b³¹d w filtrze ffaudio. Jeœli film ma scie¿kê(i) dŸwiekow¹ w formacie 
  AC3, to zdarza siê ¿e player zawiesza siê. Jest to b³¹d ffaudio. Polecam AC3Filter, który 
  jest stabilny.
* Masa innych drobnych poprawek. Przy tak du¿ej liczbie zmian program praktycznie nie powiekszy³
  swojego rozmiaru.


Wa¿niejsze zmiany w kolejnych wersjach:
 - poprawione wyszukiwanie napisów (Drag&Drop, mo¿liwoœæ wybrania jednego z kilku plików 
   w katalogu z filmem, itp.)
 - obs³uga lektora (poprzez SpeechAPI)
 - regulacja jasnoœci i kontrastu obrazu
 - rozbudowa OSD o graficzn¹ prezentacjê powy¿szych parametrów, a tak¿e g³oœnoœci i innych 
   opcji "zakresowych"
 - porz¹dny plik pomocy
 - mo¿liwoœæ konfiguracji skrótów klawiszowych
 - mo¿liwoœæ konfiguracji przycisków na pasku narzêdziowym
 - zrzuty obrazu do pliku (screenshot)
 - nowy edytor napisów. na razie jest jedno za³o¿enia: powinnien pozwalaæ na swobodne pisanie,
   a nie tak jak teraz na wstawianie linii do listy
 - "inteligentny" tryb PanScan
 - kilka(naœcie) drobnych udoskonaleñ, które zg³oszono na forum, a jeszcze nie zosta³y 
   uwzglêdnione


wersja 1.4b

26.02.2003

Ta wersja powinna rozwi¹zaæ wiêkszoœæ wykrytych niedoci¹gniêæ

* dodano wyswietlanie napisów w trybie Overlay (odci¹¿enie procesora); Opcja jest standardowo
  w³¹czona, dodatkowo program sam wykrywa czy w danej chwili moze skorzystaæ z trybu Oberlay
  i jeœli jest to niemo¿liwe, to wykorzystuje star¹ metodê renderowania napisu
* dodano opcjê "Prze³aduj film"
* dodano mo¿liwoœæ przeniesienie playlisty na lew¹ strone okna, jednoczeœnie usuniêto 
  autopokazywanie playlisty w trybie pe³noekranowym
* opcja "Ukryj napisy" wróci³a na pasek narzêdziowy
* skrót klawiaturowy do minimalizacji "Shift+Esc"
* usuniety bl¹d powodujacy znikanie obrazu
* usuniêty "b³¹d" przy opcji "u¿yj tylko jednej opcji programu" pokazywa³ sciezke filmu
* poprawiono dzia³anie opcji "Zatrzymaj odtwarzanie podczas zmiany ustawieñ" - czasami
  film zatrzymywa³ siê na sta³e
* usuniêto b³¹d zwi¹zany z niemo¿noœci¹ za³adowania filmu przez operacje Drag&Drop
* dziêki dalszym optymalizacjom program zmiejszy³ swoj¹ objêtoœæ (teraz tylko 246kB)
* poprawiono kilka innych drobnych b³êdów

wersja 1.4a

19.09.2002

Prawem serii, znowu wersja z literk¹ "a"

* usuniêto b³¹d powoduj¹cy znikanie obrazu, po wczytaniu kolejnego filmu z playlisty
* usuniêto b³¹d pojawiaj¹cy siê podczas uruchamiania player z p³yty CD
* usuniêto b³¹d, który powodowa³ "dziwny" wygl¹d napisów przy ustawieniu stylu "Prostok¹tne t³o"

wersja 1.4

15.09.2002

Niektórzy ju¿ w¹tpili, ¿e nowa wersja jeszcze siê pojawi...

* edytor napisów
   - dodawanie, edycja i usuwanie napisów (zmienion¹ liniê nale¿y zatwierdziæ przez SHIFT+Enter
     lub przyciskiem w lewym dolnym rogu edytora
   - zapis napisów w dowolnym, obs³ugiwanym przez player formacie
   - dwuklick na napisie w edytorze powoduje przejœcie do danego fragmentu filmu
   - napisy w edytorze mog¹ przesuwaæ siê w miarê odtwarzania filmu (opcja na pasku zadañ)
   - opcja pozwalaj¹ca jednym klikniêciem rozmieœciæ okno playera i edytora na ca³ym ekranie
   - wyszukiwanie b³êdów "czasowych" w napisach
   - uruchamianie edytora po wykryciu b³êdów przy ³adowaniu napisów (opcja dostêpna pod
     klawiszem F12
   - korektor czasu; ma³e narzêdzie pozwalaj¹ce dopasowaæ napisy, gdy nie pasuj¹ do filmu:
      - przesuniecie o zadan¹ iloœæ sekund do przodu lub do ty³u
      - skalowanie - wystarczy podaæ ¿e napisy o czasie od "X" do "Y" powinny pokazywaæ siê 
        miêdzy czasem "A" a czasem "B". program sam przeliczy czasy poszczególnych linii.
        czasy "X" i "Y" mo¿na wskazaæ za pomoc¹ opcji w menu kontekstowym dostêpnym dla listy
        napisów w edytorze
      - zmiana FPS
* inteligentne napisy, czyli dynamiczne obliczanie czasu potrzebnego na przeczytanie
  wyœwietlanych napisów. je¿li ktoœ woli oryginalny czas, to mo¿na to wy³aczyæ w opcjach
* dodano nowe tryby wyœwietlania napisów
* kilka poziomów antyaliasowania napisów
* pe³ny ekran na dowolnym monitorze (telewizorze). wybierany jest ten monitor, na którym
  znajduje siê okno player w momencie przejscia do pe³nego ekranu. opcja na razie dostepna 
  na kartach GeForce
* wsparcie dla AC3 (automatyczne przekierowanie dzwieku z DirectSound na WaveOut)
* zmniejszono obci¹¿enie procesora przy renderowaniu napisów (teraz napisy tworzone s¹ w
  osobnym w¹tku)
* automatyczne rozpoznawanie kolejnych czêœci filmu (nazwa filmu musi byæ zakoñczona cyfr¹):
   - je¿eli s¹ w tym samym katalogu na dysku
   - je¿eli jest to p³ytka w CD-ROMie to program prosi o w³o¿enie kolejnej. (je¿li istniej¹ 
     inne napêdy CD-ROM, to program w pierwszym rzêdzie sprawdza obecnoœæ kolejnej czêœci w 
     tych napêdach)
* znak '/' na pocz¹tku linii napisów mo¿e byæ traktowany jako kursywa (nie tylko w formacie
   MPL2)
* funkcja STOP przewija film na pocz¹tek
* przeci¹gniêcie mysz¹ filmu do playera powoduje wyczyszczenie starej playlisty i uruchomienie
  filmu, z klawiszem SHIFT film jest tylko dodawany do obecnej listy (poprzednio by³o
  odwrotnie)
* nowy parametr uruchomieniowy /min - widok minimalny
* stan opcji "Zawsze na wierzchu" jest pamiêtany w ustawieniach
* do pliku konfiguracyjnego zapisywania jest œcie¿ka do folderu z filmami
* zmiania proporcji lub po³o¿enia obrazu na ekranie jest zachowywana po przejœciu do pe³nego
  ekranu (i odwrotnie)
* zmiany interfejsu
   - nowe ikonki na przyciskach
   - w menu rozwijanym pod przyciskiem "Otwórz film" dodano listê ostatnio otwartych plików
   - dodano ikonê playlisty na pasku zadañ
   - dodano ikonê widoku minimalnego na pasku zadañ
   - usuniêto ikonê "Ukryj napisy"
   - zmania skrótu dla playlisty F11->F10
   - menu "fitltry w uzyciu" pokazuje wszystkie filtry jakie zosta³y u¿yte do odtwarzania
     filmu, te które nie maj¹ opcji konfiguracyjnych s¹ zblokowane (poprzednio wogóle ich
     nie by³o)
* poprawiono kojarzenie plików filmowych z playerem (poprzednio w³aœciwoœci pliku AVI nie
  by³y dotêpne)
* nie powinno ju¿ pojawiaæ sie okienko "ActiveMovie" podczas przejœcia z/do pe³nego ekranu
* poprawione blokowanie wygaszacza
* poprawione zamykanie systemu po skoñczonym filmie
* nie powinno ju¿ byæ problemów przy zmianie fullscreena (czasami okno znika³o, albo player
  siê zawiesza³)
* poprawiono kilka innych drobnych zmian i b³edów



wersja 1.3a

01.02.2002

Ma³e zmiany w odpowiedzi na pierwsze opinie na temat wersji 1.3

* usuniêty b³¹d powoduj¹cy niepokazywanie czasu odtwarzania
* powrót do starych skrótów klawiszowych  (si³a przyzwyczajeñ jest wielka!):
  - skok o minutê do przodu i do ty³u (PgUp i PgDown)
  - zmiana g³oœnoœci (kursor w górê i kursor w dó³). Jednak kiedy widoczna jest playlista
    nastêpuje przemapowanie skrótów (Home i End). Po schowaniu playlisty nastêpuje powrót
    do pierwotnych ustawieñ
* poprawiono rozmieszczenie kontrolek na panelu kontrolnym w widoku minimalnym; panel lepiej
  dostosowuje siê do aktualnych rozmiarów okna

wersja 1.3

30.01.2002

Trochê to trwa³o, ale w koñcu jest nowa wersja!

* dodano playlistê, dostêpna jest pod klawiszem F11, na pe³nym ekranie wystarczy przesun¹æ
  kursor myszy do prawej krawêdzi ekranu. Oto najwa¿niejsze cechy playlisty:
  + rozpoznawane s¹ nastêpujace formaty list:
    - ASX
    - BPP
    - LST
    - PLS
    - M3U
    - MBL
    - VPL
  + mo¿liwoœæ wczytywania (lub dodawania do istniej¹cej listy) jednego lub wielu plików
    oraz katalogów (z podkatalogami lub nie); wszystkie skróty klawiszowe
    w pliku "Keyboard.txt"
  + opcje pozwalaj¹ce na wszechstronn¹ edycjê listy dostêpne s¹ po kliknêciu prawym klawiszem
    myszy na playliœcie
  + autopowtarzanie i losowe wybieranie elementów z listy
  + mo¿liwoœæ dodawania elementów do listy poprzez operacje Drag&Drop (równie¿ katalogi);
    przytrzymanie klawisza SHIFT w czasie "upuszczania" plików powoduje usuniêcie starej listy
  + filmy mo¿na wczytaæ równie¿ podaj¹c je jako listê parametrów przy uruchomieniu programu
  + proste (na razie) wsparcie dla filmów wielop³ytowych; przy odtwarzaniu kolejnego pliku
    z CD program prosi o w³o¿enie nastêpnej p³yty
* program mo¿e komunikowaæ siê z u¿ytkownikiem w jêzyku portugalskim (wersja braylijska)
  autorem jest Alexandre Aleixo Wagner, któremu sk³adam podziêkowania!
  Zapraszam wszystkich do t³umaczenia pliku LNG na inne jêzyki
* dodano obs³ugê napisów formatu LRC (napisy do plików audio np. MP3)
* dodano przegl¹danie podkatalogów domyœlnego katalogu w czasie szukania napisów
* dodano "widok minimalny" (oprócz filmu w oknie widoczny jest tylko prosty panel kontrolny)
* dodano menu do zmiany proporcji kadru (Widok->Powiêkszenie->Proporcje obrazu) lub 
  za pomoc¹ klawisza "przecinka" na klawiaturze numerycznej; po zmianie przez krótk¹ chwilê
  na pasku statusu pokazane s¹ aktualnie wybrane proporcje
* dodano opcjê kasowania listy ostatnio otwartych plików
* dodano skrót do opcji zamykania systemu po skoñczonym odtwarzaniu Ctrl + F4
* dodano opcjê pozwalaj¹c¹ na wy³¹czenie zatrzymywania odtwarzania w czasie zmiany ustawieñ
* pod Windows XP program wykorzystuje nowy wygl¹d kontrolek
* trochê przebudowano uk³ad menu
* zmieniono skróty (kolidowa³y z playlist¹) do regulacji g³oœnoœci (Home, End) 
  oraz du¿ych skoków (Ctrl + kursor w lewo, Ctrl + kursor w prawo)
* poprawiono mechanizm kojarzenia plików z programem (czasami b³êdnie dzia³a³o)
* po wczytaniu tekstu w czasie ogl¹dania filmu obraz traci³ proporcje
* po wyjœciu z programu z pe³nego ekranu na pasku zadañ pozostawa³ "œlad" po aplikacji
* pojawia³ siê b³¹d podczas zapisu konfiguracji do katalogu g³ównego (np. C:\)
* po przejœciu z/do pe³nego ekranu przez chwilê na napisach by³y widoczne "krzaczki"
* Ÿle dzia³a³o rozpoznawanie formatu krótkich plików z napisami (ok. 10 linii)
* inne drobne zmiany i poprawki



wersja 1.21

11.07.2001

Tym razem kolejne zmiany po bardzo krótkiej przerwie.

* dodano obs³ugê nowego formatu napisowego (SRT - SubRipper)
* uzupe³nonono obs³ugê formatu napisowego MPL2 (znacznik kursywy)
* kó³ko w myszy mo¿e s³u¿yæ do przeszukiwania filmu lub zmiany g³oœnoœci; dodatkowo gdy
  aktywna jest jedna z opcji, ustawienie kursora myszy nad kontrolk¹ s³u¿¹c¹ do
  manipulowania drug¹ opcj¹, pozwala sterowaæ kó³kiem myszy t¹ drug¹ opcj¹
* dodano domyœlny katalog dla filmów. Katalog ten jest otwierany jako pocz¹tkowy przy
  wczytywaniu pierwszego filmu po uruchomieniu programu; kolejne wywo³ania opcji
  "Otwórz film" jako pocz¹tkowego katalogu u¿ywaj¹ tego, w którym znajduje siê ostatnio
  otwarty film; klawisz SHIFT pozwala na u¿ycie domyœlnego katalogu jako pocz¹tkowego
  w dowolnym momencie
* program kontroluje swoje po³o¿enie spowodowane zmian¹ rozmiarów okna po otwarciu nowego
  filmu, je¿eli spowoduje to czêœciowe wysusiêcie okna poza ramy pulpitu, to player
  skoryguje odpowiednio swoje po³o¿enie; zmiana rozmiarów okna po otwoarciu filmu
  odbywa siê równomiernie w ka¿dym kierunku, a nie np. tylko w prawo i w dó³ (je¿eli player
  znajdowa³ siê dok³adnie na œrodku ekranu, to jest tak równiez po otwarciu filmu
* na pasku statusu pokazywane jest o ile przesuniête s¹ napisy wzglêdem filmu
  (klawisze "[", "]" oraz "P")
* okienko "Opcje" mo¿na wywo³aæ równie¿ za pomoc¹ klawisza F12
* wprowadzono kilka kosmetycznych poprawek i usuniêto parê drobnych b³êdów zauwa¿onych
  w wersji 1.2 przez u¿ytkowników



wersja 1.2

02.07.2001

Po d³ugiej przerwie spora porcja nowoœci. Pomimo du¿ej iloœci zmian player zwiêkszy³ swoj¹
wielkoœæ tylko o 2KB!

* program nie korzysta ju¿ z MediaPlayera, dziêki czemu jest mniejszy, zajmuje kilka (3-5)
  MB RAMu mniej w porównaniu do innych playerów; zmala³o tak¿e obci¹¿enie procesora.
* zmiana wielkoœci, proporcji i po³o¿enia kadru:
  - wystarczy chwyciæ mysz¹ za krawêdŸ filmu (zmieni siê kursor myszy) i przeci¹gn¹æ
    w wybrane po³o¿enie, aby zmieniæ wielkoœæ kadru (z zachowaniem proporcji obrazu).
  - przytrzymuj¹c CTRL podczas powy¿szej operacji, mo¿na zmieniæ proporcje kadru
    (lub za pomoc¹ klawiatury: CTRL + 2,4,6,8 numeryczne).
  - chwycenie mysz¹ wewnêtrznego obszaru kadru, pozwala przesuwaæ kadr w pionie.
    z klawiszem CTRL mo¿na równie¿ zmieniæ po³o¿enie w poziomie.
  - podwójny klik rozci¹ga kadr do wielkoœci okna (Num0, wczeœniej by³o Ctrl + Num5)
  - podwójny klik z wcisniêtym klawiszem CTRL rozci¹ga kadr do wielkoœci okna i przywraca
    oryginalne proporcje kadru.
  - cykliczne naciskanie "kropki" na klawiaturze numerycznej powoduje rozci¹ganie kadru na
    ca³e okno playera i powrót do aktualnie ustawionych proporcji.
* poprawiony algorytm analizuj¹cy napisy z plików (odporniejszy na drobne b³êdy w plikach)
* obs³uga nowych formatów napisów:
 - MPL:
    0000,0000,0,Jakis tekst...
    0000,0000,Jakis tekst...
 - MPL2:
    [0000][0000]Jakis tekst...
    Ten format nie jest jeszcze w pe³ni obs³ugiwany (ignorowany jest atrybut pochy³oœci)
* usunuêty b³¹d "Cannot change Visible in OnShow or OnHide"
* natychmiastowe przejœcie do pe³nego ekranu (bez prze³adowania filmu)
* poprawnie dzia³a ukrywanie kursora na pe³nym ekranie
* zmiana po³o¿enia napisów za pomoc¹ myszy i klawiatury (Ctrl + "strza³ka w górê/dó³")
* dostêp do w³aœciwoœci kodeków
* mo¿liwoœæ wyboru czêstotliwoœci odœwierzania dla pe³nego ekranu w Windows NT/2000
* panel kontrolny na pe³nym ekranie mo¿na przenieœæ do góry (nie zas³ania napisów)
* dodana opcja zmiany kierunku dzia³ania kó³ka myszy
* historia (ostatnio otwierane pliki) zosta³a przeniesiona do podmenu. Takie samo podmenu
  pojawi³o siê w menu kontekstowym. Obecnie program pamiêta 10 filmów
* po najechaniu myszk¹ nad suwak pozwalaj¹cy na przewijanie filmu w "dymku" pokazywany jest
  czas, jakiemu odpowiada po³o¿enie kursora myszy.
* przyciski odpowiadaj¹ce za zmianê prêdkoœci odtwarzania filmu zosta³y usuniête. W zamian
  pojawi³ siê ma³y suwak nad regulacj¹ g³osnoœci.
* nowy parametr w linii poleceñ "/m" powoduje otwarcie playera w oknie,
  ale zmaksymalizowanym.
* zak³adki - mo¿na zapamiêtaæ pozycjê odtwarzanego filmu i póŸniej wczytaæ film z zak³adki
* mo¿liwoœæ zapisania wiêkszoœci ustawieñ odtwarzacza do pliku. Przydatne przy nagrywaniu
  p³yt CD. Pozwala na dopasowanie odtwarzacza do konkretnego filmu.
  Zapamiêtywane s¹ nastêpuj¹ce parametry:
    - autostart po za³adowaniu
    - zamknij po skoñczeniu
    - odleg³oœæ napisów od dolnej krawêdzi
    - czcionka, kolor i rozmiar obwódki
    - domyœlna wartoœæ FPS dla asf'ów
    - przewijanie filmu - ma³y i du¿y krok
    - czas pokazywania napisów
    - czas ukrycia kursora
    - g³oœnoœæ
    - otwieranie jednej kopii programu
    - ukrywanie paska zadañ na pe³nym ekranie
    - przejœcie do pe³nego ekranu po za³adowaniu
    - skalowanie napisów w okienku
* poprawnie dzia³a wy³¹czanie wygaszania monitora podczas odtwarzania filmu
* w czasie wykonywania zmian w opcjach film jest pauzowany
* mo¿liwoœæ zamkniêcia/uœpienia systemu po skoñczonym odtwarzaniu
* na pasku statusu pokazywana jest aktualna prêdkoœæ odtwarzania (fps)
* œrodkowy przycisk myszy dzia³a jak ENTER (przesuwa film o sekundê do przodu)
* oraz kilka drobnych b³êdów i niedoci¹gniêæ, których nie sposób wymieniæ


wersja 1.1

24.02.2001

Pierwsze koty za p³oty! Oto kolejne udoskonalenia cinemaplayera:

* polska wersja! wystarczy umieœciæ plik z przet³umaczonymi napisami w katalogu i program
  bêdzie obs³ugiwa³ dany jêzyk
* czasami program wyœwietla³ tylko kawa³ek ostatniej litery w linii napisu
* podczas minimalizacji film jest pauzowany
* podczas minimalizacji programu w trybie pe³noekranowym ze zmian¹ rozdzielczoœci nastêpuje
  powrót do normalnej rozdzielczoœci
* je¿eli w trybie pe³noekranowym ukrywany jest pasek zadañ, to podczas minimalizacji
  programu jest on pokazywany
* szybsze zamykanie programu je¿eli program jest w trybie pe³noekranowym
* poprawiona obs³uga parametrów uruchomieniowych (autorun)


wersja 1.0

01.02.2001

Pe³na wersja, pozbawiona b³êdów. Chyba... :). Pierwsza publiczna edycja.

* poprawiona obs³uga scrolla myszy
* w menu kontekstowym opcja minimalizacji playera w trybie pe³noekranowym
* klikaj¹c na aktualny czas filmu mo¿na prze³¹czaæ opcjê "Time remaining"
* mo¿liwoœæ wy³¹czenia skalowania napisów
* teraz podczas minimalizacji zawsze widoczny jest pasek zadañ
* kolejne drobne poprawki


wersja 0.9.9 beta

* opcja automatycznego przejœcia do trybu pe³noekranowego w momencie rozpoczêcia odtwarzania
  filmu
* parametry uruchomieniowe:
 - œcie¿ka dostepu do filmu
 - œcie¿ka dostepu do tekstu
 - /f - start w trybie pe³noekranowym
 - /ff - start w trybie pe³noekranowym ze zmian¹ rozdzielczoœci
 kolejnoœæ parametrów jest nieistotna
* jeszcze bardziej przyspieszony algorytm renderowania napisów
* przewijanie filmu za pomoc¹ scrolla myszy
* kilka drobnych poprawek


wersja 0.9.8 beta

* czasami program zawiesza³ siê przy wychodzeniu
* wybór rozdzielczoœci dla trybu pe³noekranowego  w opcjach na WinNT/2000 nie dzia³a³
  poprawnie
* okienko statystyki
* trochê drobnych poprawek


wersja 0.9.7 beta

* czasami program zawiesza³ siê po oko³o godzinie ogl¹dania
* poprawiony i znacznie przyspieszony algorytm renderowania napisów
* poprawione dzia³anie opcji "Open with CinemaPlayer"
* skalowanie napisów w zale¿noœci od wielkoœci filmu (rozmiar podany w opcjach dotyczy
  pe³nego ekranu)
* opcja wyœwietlania czasu jaki pozosta³ do koñca filmu


wersja 0.9.6 beta

* w koñcu usuniêty b³¹d powoduj¹cy znikanie napisów
* opcja uruchamiania tylko jednej kopii programu
* okienko wyboru pliku z filmem uwzglêdnia rozszerzenia podane na zak³adce 'File types'
  w opcjach.
* opcja wyboru rozdzielczoœci u¿ywanej przy pe³nym ekranie (w trybie ze zmian¹
  rozdzielczosci)
* domyœlna liczba klatek na sekundê dla pliów '.asf' i napisów w formacie z klatakami
  (microDVD)
* trochê drobnych poprawek


wersja 0.9.5 beta

* dodane kojarzenie plików z programem.
* dla plików nie skojarzonych mo¿na dodaæ opcjê "Open with CinemaPlayer" do menu
  kontekstowego.
* szybka zmiana wielkoœci czcionki dla napisów (Ctrl + -/=)
* trochê drobnych poprawek


wersja 0.9.2 beta

* opcja ukrywania menu start w czasie odtwarzania filmu na pe³nym ekranie
* domyœlny katalog z napisami. Program szuka pliku w katalogu z filmem, gdy nie znajdzie to
  szuka w katalogu z napisami. Je¿eli podczas otwierania okienka dialogowego do wybierania
  plików z napisami bêdzie przytrzymany klawisz SHIFT to dialog otworzy siê z domyœlnym
  katalogiem napisów (bez SHIFT otwiera siê katalog filmu lub ostatnio otwieranego pliku 
  z napisami).
* trochê drobnych poprawek



wersja 0.9.1 beta

* wy³¹czenie screensavera w czasie odtwarzania filmu
* pamiêtanie plików z napisami w historii (5 ostatnich filmów)
* opcja "Stay on top"
* panel kontrolny na pe³nym ekranie po przesuniêciu myszki na dó³ ekranu
* poprawione zamykanie programu po skoñczeniu odtworzenia filmu
* masa drobnych poprawek


wersja 0.9 beta

Pierwsza "doros³a" wersja programu. Na razie program posiada ma³o opcji i du¿o b³êdów :)
* podstawowa rzecz, czyli odtwarzanie filmu i napisów ju¿ dzia³a ;)
* czcionka ma sta³y rozmiar, szczerze mówi¹c(pisz¹c) prawie wszystko jest na "sztywno"
* mo¿na za³adowaæ film przez przeci¹gniêcie i upuszczenie go na oknie programu
* automatycznie wczytywane s¹ napisy o takiej samej nazwie jak film
* pamiêtanych jest 5 ostatnio otwieranych filmów
* automatycznie wykrywana jest iloœæ linii tekstu widocznych na ekranie w danym momencie
* i trochê innych, lepiej lub gorzej dzia³aj¹cych bajerów...



III. Obs³uga programu
=====================


1. Oto co potrafi CinemaPlayer:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* Wczytanie plików video lub audio				(Ctrl + O)
  Dodanie plików video lub audio do playlisty			(Alt + O)
  Wczytanie wszystkich plików video lub audio z katalogu	(Ctrl + D)
  Dodanie wszystkich plików video lub audio z katalogu		(Alt + D)
  Wczytanie playlisty						(Ctrl + L)
  Zapisanie playlisty						(Ctrl + S)
 - ka¿da kolejna operacja wczytania/dodania pliku rozpoczyna siê w tym katalogu, który by³
   ostatnio otwarty; przytrzymanie klawisza SHIFT powoduje otwarcie katalogu domyœlnego
   dla filmów
 - pliki mo¿na za³adowaæ równie¿ przez przeci¹gniêcie i upuszczenie ich na oknie programu,
   tak samo mo¿na post¹piæ z katalogiem
 - automatyczne wczytywane s¹ pliki z napisami, je¿eli maj¹ tak¹ sam¹ nazwê jak plik audio
   lub video oraz znajduj¹ siê w tym samym katalogu lub w domyœlnym katalogu dla napisów.
 - program pamiêta 10 ostatnio otwartych filmów (pamiêtane s¹ te¿ pliki z napisami do nich);
 - program pozwala na zapamiêtanie 10 zak³adek, które pozwalaj¹ na rozpoczêcie odtwarzania
   filmu od momentu w którym seans zosta³ przerwany.
 - pliki mo¿na równie¿ za³adowaæ podaj¹c je jako listê parametrów przy uruchomieniu z linii
   poleceñ


* Wczytanie napisów 						(Ctrl + T)
 - otwierany jest katalog z plikiem audio/video lub po wcisniêciu klawisza SHIFT domyœlny
   katalog dla napisów.
 - program zapewnia wsparcie dla nastêpuj¹cych formatów napisów:
   - {xxxx}{xxxx}Jakiœ tekst...			MDVD
   - {xxxx}{}Jakiœ tekst...			MDVD
   - hh:mm:ss:Jakiœ tekst...			TMPlayer
   - hh:mm:ss=Jakiœ tekst...			TMPlayer
   - hh:mm:ss,x:Jakiœ tekst...			TMPlayer
   - xxxx,xxxx,x,Jakis tekst...			???
   - xxxx,xxxx,Jakis tekst...			MPL
   - [xxxx][xxxx]Jakis tekst|/Jakiœ tekst...	MPL2
   - hh:mm:ss --> hh:mm:ss			SRT (SubRipper)
     Jakiœ tekst1...
     Jakiœ tekst2...
   - [mm:ss] Jakiœ tekst...			LRC (Lyrics np. do MP3)


* Odtwarzanie/Pauza 						(Spacja)
  Zatrzymanie 							(. /Kropka/)
  Odtwarzaj poprzedni element z listy				(Ctrl + P)
  Odtwarzaj nastêpny element z listy				(Ctrl + N)
 - w czasie odtwarzania filmu program blokuje wygaszacz ekranu
 - napisy s¹ wyœwietlane bezpoœrednio na filmie
 - automatycznie wykrywana jest iloœæ linii tekstu widocznych na ekranie


* Tryb pe³noekranowy
 - pe³ny ekran							(Alt + Enter)
 - pe³ny ekran ze zmian¹ rozdzielczoœci				(Ctrl + Enter)
 - powrót do okna						(Esc)
 - po przesuniêciu myszki na dó³ lub górê ekranu (w zaleznoœci od ustawieñ opcji) poka¿e siê
   panel kontrolny
 - po przesuniêciu myszy do prawej krawêdzi ekranu poka¿e siê playlista

* £atwe i szybkie przechodzenie do dowolnego fragmentu filmu.
 - za pomoc¹ paska postêpu znajduj¹cego siê na górze panelu kontrolnego; po najechaniu mysz¹
   na pasek pokazywany jest czas jaki odpowiada wskazywanemu fragmentowi.
 program umo¿liwia nawigacjê do przodu i do ty³u o:
 - 1 sekundê 							(Enter/Backspace)
 - 10 sekund 							(W prawo/W lewo)
 - 1 minutê  							(Ctrl + W prawo/Ctrl + W lewo)
   dwie ostatnie wielkoœci mo¿na zmieniæ w opcjach.
 - program obs³uguje myszy ze scrollem; wedle uznania kó³ko mo¿e s³u¿yæ do przewijania filmu
   lub zmiany g³oœnoœci - konfiguracja z poziomu opcji (F12)

* Zmiana wielkoœci i proporcji obrazu
  wiêkszoœæ opcji dostêpna poprzez klawiaturê numeryczn¹
 - przesuwanie kadru w dowolnym kierunku			(Num1 do Num9)
   lub za pomoc¹ myszy: 
   "chwycenie" mysz¹ kadru, pozwala przesuwaæ obraz w pionie, przytrzymuj¹c klawisz CTRL
   mo¿na równie¿ zmieniæ po³o¿enie w poziomie
 - powiêkszenie/pomniejszenie kadru 				(Num+/Num-)
   lub za pomoc¹ myszy:
   "chwycenie" za krawêdŸ filmu i przeci¹gniêcie w wybrane po³o¿enie
 - zmiana proporcji obrazu					(Num. /Kropka/)
   powoduje cykliczn¹ zmianê proporcji:
   oryginalne proporcje / rozciagniêcie na ca³e okno programu / 16:9 / 4:3
 - p³ynna zmiana proporcji obrazu				(CTRL + Num2,Num4,Num6,Num8)
   lub za pomoc¹ myszy:
   przytrzymanie CTRL, "chwycenie" za krawêdŸ filmu i przeci¹gniêcie w wybrane po³o¿enie
 - dopasowanie obrazu do wielkoœci okna programu 		(Num0)
   lub za pomoc¹ myszy poprzez podwójne klikniêcie na obrazie
 - podwójny klik z wcisniêtym klawiszem CTRL dopasowuje obraz do wielkoœci okna i przywraca
   oryginalne proporcje obrazu
 - 50% wielkoœci obrazu						(Alt + 1)
 - 100% wielkoœci obrazu					(Alt + 2)
 - 200% wielkoœci obrazu					(Alt + 3)

* Zmiana tempa odtwarzania filmu
 - zmniejszenie tempa odtwarzania filmu				(Ctrl + Z)
 - zwiêkszenie tempa odtwarzania filmu				(Ctrl + C)
 - przywrócenie normalnego tempa				(Ctrl + X)
 - tempo mo¿na te¿ regulowaæ za pomoc¹ ma³ego suwaka znajduj¹cego siê obok paska
   postêpu czasu odtwarznia pliku

* Zmiana poziomu g³oœnoœci
 - g³oœniej 							(Home)
 - ciszej							(End)
 - wycisz							(Ctrl + M)
 - program obs³uguje myszy ze scrollem; wedle uznania kó³ko mo¿e s³u¿yæ do przewijania filmu
   lub zmiany g³oœnoœci - konfiguracja z poziomu opcji (F12)
 - g³oœnoœæ mo¿na te¿ regulowaæ za pomoc¹ trójk¹tnego suwaka znajduj¹cego siê po prawej
   stronie panelu sterowania.

* Manipulacja napisami
 - przesuniêcie napisów wzglêdem filmu o sekundê do ty³u	([)
 - przesuniêcie napisów wzglêdem filmu o sekundê do przodu	(])
 - anulowanie przesuniêæ					(P)
   na pasku statusu pokazywane jest o ile przesuniête s¹ napisy wzglêdem filmu
 - ukrycie/pokazanie napisów					(Alt + T)
 - pomniejszenie czcionki					(Ctrl + -)
 - powiêkszenie czcionki					(Ctrl + =)
 - zmiana po³o¿enia napisów w pionie				(Ctrl + w górê/Ctrl + w dó³)
   lub za pomoc¹ myszy:
   wystarczy "chwyciæ" napisy i przesun¹æ w wybrane po³o¿enie

* Parametry uruchomieniowe; kolejnoœæ parametrów jest nieistotna:
 - pliki video, audio lub playlisty ze œcie¿kami dostêpu (je¿eli wystêpuj¹ spacje,
   to œcie¿ki nale¿y umieœciæ w cudzys³owach)
 - /f - start w trybie pe³noekranowym
 - /ff - start w trybie pe³noekranowym ze zmienion¹ rozdzielczoœci¹
 - /m - start w zmaksymalizowanym oknie

* Program jest wielojêzyczny
  Wystarczy umieœciæ plik z przet³umaczonymi napisami w katalogu i program automatycznie
  bêdzie obs³ugiwa³ dany jêzyk. Pliki maj¹ rozszerzenie "lng", ale maj¹ strukturê plików
  "ini". Jêzyk polski jest wbudowany w program. Plik 'Polski.lng' do³¹czony zosta³ tylko
  w celu u³atwienia wykonywania t³umaczeñ osobom nieznaj¹cym jêzyka angielskiego.
  Je¿eli znasz jakiœ jêzyk obcy, to przet³umacz plik .lng i wyœlij go na adres:
  info@cineamaplayer.prv.pl; plik zostanie do³¹czony do programu, a wzmianka o Tobie bêdzie
  umieszczona w programie



2. Opcje dostêpne z poziomu okienka "Options":
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Zak³adka "Napisy":
------------------------------

* Wybór czcionki i kolorów dla napisów
* Zmiana gruboœci obwódki wokó³ liter
* Skalowanie wysokoœci czcionki w zale¿noœci od wielkoœci okienka. Je¿eli opcja jest
  w³¹czona to wybrana wysokoœæ czcionki dotyczy pe³nego ekranu
* Odleg³oœæ napisów od dolnej krawêdzi filmu (w procentach wysokoœci filmu)
* Czas przez jaki wyœwietlany jest napis (je¿eli plik z napisami tego nie okreœla)
* Domyœlny folder dla napisów. Tutaj program szuka pliku, je¿eli nie znajdzie go w folderze,
  w którym znajduje siê film

Zak³adka "Odtwarzanie":
------------------------------

* Nawigacja pozwala na przewijanie i szybki dostêp do dowolnego fragmentu filmu. Ma³e kroki
  s¹ te¿ u¿ywane do przewijania filmu za pomoc¹ scrolla w myszce
* Kó³ko myszy mo¿e sterowaæ przeszukiwaniem filmu lub regulacj¹ g³oœnoœci
* Mo¿na zmieniæ odwróciæ kierunek przwijania filmu scrollem myszy
* Mozna ustawiæ czas po jakim zostanie ukryty kursor myszy w trybie pe³noekranowym
* Mo¿na wybraæ rozdzielczoœæ jaka bêdzie u¿yta w trybie pe³noekranowym
* Ukrywanie paska zadañ w trybie pe³noekranowym - przydatne gdy pasek ma w³¹czon¹ opcjê
  'Autoukrywanie'
* Mo¿na automatycznie przejœæ do trybu pe³noekranowego w momencie rozpoczêcia odtwarzania
  (równie¿ ze amian¹ rozdzielczoœci)
* Na pe³nym ekranie mo¿na przenieœæ panel kontrolny na górê ekranu (nie bêdzie zas³ania³
  napisów)
* Liczba klatek na sekundê dla plików '.asf' i tekstów w formacie z klatkami
* Mo¿na automatyczne odtwarzaæ film po za³adowaniu
* Mo¿na nakazaæ zamkniêcie playera po skoñczeniu odtwarzania filmu
* Mo¿na nakazaæ uruchamianie tylko jedej kopii programu
* Mo¿na zamkn¹æ/uœpiæ system po skoñczonym odtwarzaniu filmu
* Domyœlny folder dla filmów


Zak³adka "FileTypes"/"Typy plików":
-----------------------------------

Program mo¿e s³u¿yæ jako domyœlny odtwarzacz filmów w systemie.
W oknie dialogowym wyboru pliku (wczytywanie filmu lub playlisty) wyœwietlane s¹ tylko te pliki,
  których rozszerzenia wymienione s¹ na tej zak³adce.
* Lista znajduj¹ca siê po lewej stronie zawiera playlisty (na górze) oraz pliki multimedialne
  (na dole), które nie s¹ skojarzone z odtwarzaczem, ale program mo¿e je otwieraæ.
  Pliki te mog¹ mieæ dodan¹ opcjê "Otwórz z CinemaPlayer" do systemowego menu kontekstowego.
* Lista po prawej stronie zawiera pliki, które maj¹ byæ automatycznie otwierane za pomoc¹
  CinemaPlayera.


=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-


To wszystko...
Mi³ego ogl¹dania!!!


(C) Zbigniew Chwedoruk
Bia³a Podlaska/Wroc³aw 2000-2007