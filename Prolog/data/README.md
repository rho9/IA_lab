# Script python per la generazione del labirinto data un immagine
`translator.py`

## Usage

Prima di tutto installa *pillow*: libreria usata per processare le immagini.
`pip install pillow`

Per eseguire lo script: 
``` bash
python translator.py <imagename>.png
```
Lo script prende in input un immagine `.png` e crea un file `.pl` con lo stesso nome dell'immagine nella stessa folder dell'immagine. Il file generato contiene la rappresentazione testuale dell'immagine con la sintassi di prolog.

## Tip
Chiamare l'immagine `esempio_qualcosa.png` così verrà ignorata dal gitignore.