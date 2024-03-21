# GitHub CI/CD Házifeladat

## Feladata és célja

A repository feladata és célja, hogy egy konténerizált környezetben fel tudjon építeni, egy Nginx webszervert, amiben a felhasználó által létrehozott weboldalt tudja megjeleníteni. 

## Dockerfile

A Dockerfile egy Nginx webszervert fog futtatni. A mellé csatolt index.html file-t fogja bemásolni abba a mappába ahol az Nginx tárolja a megjelenítendő weboldalakat. Ezek után a konténer 80-as HTTP portját ki exposolja a gazdagép 80-as portjára. Végül a CMD részlegben elindítja az Nginx szolgáltatást.

## index.html

A feladat leírásnak megfelelően megjeleníti H1-es címsorként a kért szöveget. Ezen kívül a kódban figyeltem arra, hogy az oldal alapértelmezett nyelve legyen magyar és a kódolása UTF-8. Erre azért volt szükség, hogy a magyar ékezetes betűket helyesen jelenítse meg. Ezen kívül az oldal címének megadtam a feladat nevét.

## docker_epit_push.yml

Az egész file azzal kezdődik, hogy a workflow nevét definiálja a következő kódrészlettel.

```
name: Docker_image_epites_es_push
```

Ezután definiáljuk, hogy milyen művelet végrehajtása esetén kezdődjön el a workflow. A mi esetünkben az elvárásoknak megfelelően akkor indul el, amikor a main branch-re pusholunk.

```yaml
on:
  push:
    branches:
      - main
```

A következő kódrészletben, a feladatokat/jobs-okat határozzuk meg. A mi esetünkben csak egy job van, ami felépíti az adott kódot és pusholja a megfelelő helyre. A runnernél egy Ubuntu-22.04-es rendszert határoztam meg.

```yaml
jobs:
  build-and-push:
    runs-on: ubuntu-22.04
```
Ezek után a lépéseket definiáljuk. Az első lépés, hogy a repository tartalmát megvizsgáljuk, hogy helyes-e a szintaktikája. Arra is irányul a vizsgálat, hogy helyenen le tudna-e futni. Ezt egy beépített eszközzel teszem meg. Az actions/checkout repository segítségével. A negyedik azaz a legutóbbi verziót használom belőle, mert így a Node.js 20 verzióval fogja lefuttani. Ez azért fontos mert hamarosan megszüntetik a korábbi verziók támogatását. Ha korábbi verziót használunk, abban az esetben a lépés futtatása megtörténik, de ad egy figyelmeztetést, hogy hamarosan meg fog szünni az adott verzió támogatása. 

```yaml
    steps:
    - name: Repository_vizsgalat
      uses: actions/checkout@v4
```

A következő lépés, az hogy megcsinálja a DockerHub-ra való bejeletkezést. A imént használt módszerrel valósítom meg. Itt is egy beépített előre definiált eszközt használtam. Ebben az esetben is fontos a verzió száma az előbb említett problémák miatt. A bejelentkezésnek meg kell adni a felhasználó nevet és jelszót a DockerHub-hoz. Ezt a GitHub-ban megadott adatokkal használom. Nem adom meg a kért adatokat, hanem korábban megadtam, a GitHub repository beállításaiban az actions résznél mint repository sercrets. Itt ezeket a paramétereket adom csak meg, nem a valós adatokat. Ezzel elkerülöm, hogy bizalmas bejelentkezési adatok kerüljenek a nyilvános repository-ba. Illetve ezzel megoldom, hogy ne mindnképpen az én DockerHub-omra kerüljön fel az image.

```yaml
- name: Docker_Hub_bejelentkezes
      uses: docker/login-action@v3
      with:
        username: ${{ secrets.DOCKER_USERNAME }}
        password: ${{ secrets.DOCKER_PASSWORD }}
```

Az utolsó lépést szintén a fent említett módon oldottam meg és figyeltem a verzióra is. Ez a lépés felépíti azt amit a Dockerfile-ban definiáltam és itt történik meg a push-olás a DockerHub-ra is. A tags résznél szintén változóban definiáltam a felhasználtót. Itt a feladatnak megfelelően homework:latest cimkét fogja megkapni a fel push-olt image.

```yaml
    - name: Docker_image_epites_es_push
      uses: docker/build-push-action@v5
      with:
        context: .
        file: ./Dockerfile
        push: true
        tags: ${{ secrets.DOCKER_USERNAME }}/homework:latest
```
