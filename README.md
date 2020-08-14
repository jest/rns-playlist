Zrzut skryptów do publikowania playlisty Radia Nowy Świat (RNŚ).

Całość składa się z czterech części.

1. Pobieranie strumienia; w skrypcie `_get_stream.sh` użyte jest standardowe
   narzędzie `curl` do otwarcia strumienia IceCast. Całość danych zapisywana jest
   na standardowe wyjście.

2. Obserwowanie strumienia z kroku 1; skrypt `_extract_icy_meta.pl` analizuje
   dane ze strumienia, w którym w plik MP3 co 16000 bajtów mogą być „wplecione”
   metadane, w przypadku  RNŚ `StreamTitle` informujący o aktualnie odtwarzanym
   utworze.

   **UWAGA: Wartość 16000 jest zaszyta na stałe w kodzie, chociaż powinna być
   pobierana z nagłówka odpowiedzi HTTP; to ograniczające założenie, które może
   się kompletnie nie sprawdzić na innej stacji zostanie wkrótce usunięte.**

   Metadane są wypisywane na standardowe wyjście, wraz ze znacznikiem czasu.

3. Tworzenie ze strumienia metadanych playlisty; skrypt `make_playlist_icy.pl`
   przetwarza metadane tworzone w kroku 2. i publikuje ładne (choć to zależy od
   gustu...) informacje o odtwarzanych utworach.

   **UWAGA: Aktualnie tworzona jest jedna długachna playlista, z najnowszymi
   utworami na dole. W ramach usprawnień tworzone playlisty wkrótce będą w formie
   „jedna na dzień”, a najnowsza, aktualna będzie miała odwróconą kolejność
   (tzn. najnowsze utwory na górze pliku).**

4. Publikowanie playlisty po wykryciu nowego utworu; skrypt `publish_icy_playlist.sh`
   czeka na nowe metadane z kroku 2., a po ich pojawieniu się generuje playlistę
   skryptem z kroku 3.; na zakończenie „pcha” wyniki na serwer surge.sh.

## Instalacje

Do działania skrypty wymagają:

* Bash 4
* współczesnego Perla (założyłem 5.20, ale może wcześniejsze też działają)
* `npx` (dostarczany w ramach współczesnych NodeJS)
* pakietu surge z NPM: aby zainstalować, należy wejść do katalogu `surge`
  i wykonać `yarn install`, ew. `npm install`

## Przykładowe działanie

W ramach działania na serwerze autora uruchomione jest:

* w jednym wątku sekwencja kroków 1. i 2.:

      bash _get_stream.sh | tee -a icy/stream.txt

* w drugim wątku nasłuchiwanie zmian w `icy/*` i publikacja, jak w krokach 3. i 4.:

      bash publish_icy_playlist.sh


## Licencja

Całość kodu i dokumentacji udostępniona na licencji Apache 2.0 (szczegóły w
`LICENSE.txt`).

Copyright 2020 Przemek Wesołek

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
