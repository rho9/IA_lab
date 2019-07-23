# Script python per la generazione del labirinto data

## Usage

Prima di tutto installa *pillow*: libreria usata per processare le immagini.
`pip3 install pillow`

### `generator.py`

Per eseguire lo script: 
``` bash
./generator.py filename dimension_x [dimension_y]
```
- Il parametro *dimension_x* è un intero che indica le dimensioni (x) del labirinto che verrà generato, è un parametro obbligatorio.
- Il parametro *dimension_y* è come sopra, ma per le y. L'unica differenza è che è opzionale. Se omesso il labirinto è quadrato.

Il labirinto generato è completamente casuale e potrebbe avere soluzione troppo semplice o non averne proprio.

### `translator.py`

Per eseguire lo script: 
``` bash
./translator.py <imagename>.png
```
Lo script prende in input un immagine `.png` e crea un file `.pl` con lo stesso nome dell'immagine nella stessa folder dell'immagine. Il file generato contiene la rappresentazione testuale dell'immagine con la sintassi di prolog.

### Tip
Chiamare l'immagine `esempio_qualcosa.png` così verrà ignorata dal gitignore.