---
layout: post
title: "Utiliser une EEPROM"
date: 2026-02-06 8:00
comments: true
tags: [ retro, 8bits ]
---

Le moment est venu de connecter une ROM au processeur 6502 dans l'espoir de lui
faire faire quelque chose.

<!-- more -->


## ROM ? PROM ? EPROM ? EEPROM ?

Je n'avais jamais cherché à comprendre ces différents termes. Je me suis dit que
c'était le bon moment pour faire un peu de recherche.

### Read Only Memory

Une ROM est écrite une fois pour toute lors de sa fabrication.

### Programmable Read Only Memory

Une PROM peut-être écrite une seule fois, car elle est à base de fusibles.

### Erasable Programmable Read Only Memory

Une EPROM peut-être effacée et ré-écrite plusieurs fois. L'effacement est réalisé avec des rayons UV,
pas super pratique à la maison ;)

### Electrically Erasable Programmable Read Only Memory

Une EEPROM peut-être effacée et ré-écrite plusieurs fois, avec des appareils électriques
assez communs et bon-marché.
J'en ai même déjà fabriqué avec un simple arduino pour programmer certains petits micro-contrôleurs.

On utilisera ici une EEPROM modèle AT28C256.
Elle fait 256Kb (bits), soit 32Ko (octets).


## Connexions

On va relier le processeur directement à la ROM mais déjà une interrogation se
pose : le bus de données du processeur fait 16 bits (soit 64Ko) alors que celui de la
ROM fait seulement 15 bits (soit 32Ko).
Si on branche la ROM en $0000-$7fff (première moitié de l'espace d'adressage du
processeur) que va-t-il se passer lorsque le processeur tentera de lire une
adresse entre $8000 et $ffff ?
Et bien comme le bit de poid fort (le 16ème bit) du bus d'adresse n'est
pas relié à la ROM, ce serait comme si la ROM était "en miroir".  Elle
apparaîtrait deux fois. Une fois en $0000-$7fff et une seconde fois en
$8000-8ffff.

On voudrait plutôt que les 32Ko de ROM soit vu une seule fois, pour pouvoir
utiliser plus tard l'autre moitié en tant que RAM. Il y a un _pin_ "enable" sur
la ROM. Elle ne produit de sortie que lorsque ce _pin_ est à 0.  Donc, en reliant
le bit d'adresse de poid fort (le 16ème) du processeur sur le _pin_ "enable" de la ROM nous
laissons la plage $8000-$ffff libre pour la future RAM. Pourquoi ? Parce que
quand le processeur émet une adresse à partir de $8000 et au-dessus, le bit de
poid fort est à 1. Le nombre hexadécimal $8000 correspond au binaire `1000000000000000`.
Comme ce bit est relié au _pin_ "enable" de la ROM, celle-ci devient indisponible.

Le problème est que (comme vu dans l'article précédent) la séquence de boot/reset va
lire l'adresse de début du programme en $fffc et $fffd. Nous avons donc besoin
de l'inverse. On veut que la future RAM utilise la plage $0000-7fff et que la ROM soit
accessible en $8000-$ffff.  L'astuce consiste simplement à mettre une porte logique NOT
entre le bit d'adresse de poid fort du processeur et le _pin_ "enable" de la ROM.

Voici le cablage dont je prends plus soin que d'habitude à réaliser, car il va falloir désinstaller
et réinstaller l'EEPROM plusieurs fois pour la programmer.

{% img center /images/ordi8bits-003.jpg %}

## Programmation de la ROM

Pour écrire dans la ROM, j'utilise un programmeur T48 avec le logiciel
[minipro](https://gitlab.com/DavidGriffith/minipro).

{% img center /images/ordi8bits-004.jpg %}

La première ROM est remplie d'instructions NOP. J'utilise Ruby pour la créer.

{% highlight ruby %}
rom = Array.new(32_768, 0xea)

File.open("rom.bin", "wb") do |file|
  file.write(rom.pack("C*"))
end
{% endhighlight %}

On peut vérifier le contenu du fichier `rom.bin` avec la commande `hexdump`.
On voit qu'il est bien rempli d'instructions NOP (opcode $ea) :

    $ hexdump -C rom.bin
    00000000  ea ea ea ea ea ea ea ea  ea ea ea ea ea ea ea ea  |................|
    *
    00008000

Une fois la ROM programmée et remise en place, je recable l'arduino Mega sur le processeur pour lire
les valeurs du bus d'adresse et du bus de données.  Il y a tellement de cables
qu'on ne voit même plus le processeur :D

{% img center /images/ordi8bits-005.jpg %}

En monitorant à l'aide de l'arduino, on voit que la communication processeur/ROM se
fait correctement :

|---|---------|-----|------|
|   | Address | R/W | Data |
|---|---------|-----|------|
|   |  ea15   |  R  |  ea
|   |  ea15   |  R  |  ea
| @ |  ffff   |  R  |  ea
| @ |  ea15   |  R  |  ea
| @ |  01ff   |  R  |  ea
| @ |  01fe   |  R  |  ea
| @ |  01fd   |  R  |  ea
| @ |  fffc   |  R  |  ea
| @ |  fffd   |  R  |  ea
| ! |  eaea   |  R  |  ea
|   |  eaeb   |  R  |  ea
|   |  eaeb   |  R  |  ea
|   |  eaec   |  R  |  ea
|   |  eaec   |  R  |  ea
|   |  eaed   |  R  |  ea
|   |  eaed   |  R  |  ea

La colonne _Address_ correspond à ce qui circule sur le bus d'adresse du 6502.
La colonne _R/W_ indique si le processeur est en mode lecture (R) ou écriture (W).
La colonne _Data_ correspond à ce qui circule sur le bus de données.

On voit que le processeur est constamment en mode lecture.
Les 7 lignes identifiées par un "@" sont les 7 cycles de la séquence de
reset. Cette séquence se termine par la lecture de l'adresse du début de programme aux adresses $fffc et $fffd.
Comme la ROM est remplie de $ea, le processeur saute donc à l'adresse $eaea
(identifié par la ligne qui commence avec "!").
Le processeur va y lire la valeur $ea, qui correspond à l'instruction NOP (NO Operation).
Il va donc avancer à l'adresse suivante qui contiendra aussi un NOP, et ainsi de suite.

Il est normal de voir deux fois les adresses pour l'instruction NOP car elle
demande 2 cycles pour être exécutée.

J'ai deux questions qui restent en suspens : que fait exactement la séquence de
reset (et accessoirement est-ce important) ? Et pourquoi le premier NOP (ligne "!") ne consomme qu'un seul cycle ?
On verra si j'obtiens les réponses bientôt ;)

## Notes

J'essaye d'utiliser dans la mesure du possible les unités de mesure comme suit :

- **ko** pour kilo octet décimal – 1000 octets
- **Ko** pour kilo octet binaire – 1024 octets
- **kb** pour kilo bit décimal – 1000 bits
- **Kb** pour kilo bit binaire – 1024 bits
{% include serie_ordi_8bits.md %}
