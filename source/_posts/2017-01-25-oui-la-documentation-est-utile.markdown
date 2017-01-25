---
layout: post
title: "Oui la documentation est utile"
date: 2017-01-25 11:13
comments: true
categories: documentation
---

J'ai lu récemment un article de blog intitulé
[Les meilleurs commentaires ne s'écrivent pas](https://blog.nathanaelcherrier.com/2017/01/11/les-meilleurs-commentaires-ne-secrivent-pas/).
Le titre est bon. Le sujet est intéressant. Les
intentions de l'auteur sont louables.

Malgré cela, cet article m'a laissé perplexe. Je pense que l'auteur se méprend.
Et comme le sujet m'est important et qu'on ne peut pas laisser de commentaires
sur son blog, j'ai eu envie d'écrire un article pour lui répondre.

Je reprendrai les même titres de partie que l'article original pour vous
permettre de vous repérer plus facilement si besoin.

<!-- more -->

## Self Documenting Code

L'article commence par comparer deux bouts de code qui ont le même objectif. Le
premier est mauvais, avec un commentaire nécessaire pour expliquer l'objectif.
Le second est meilleur, et se passe donc d'un commentaire.

*code 1*

```js
// Get the extension off the image filename
let pieces = imageName.split('.')
let extension = pieces.pop()
```

*code 2*

```js
let extension = getFileExtension(imageName)
```

Je suis entièrement d'accord avec la conclusion de cette première partie de
l'article :

> Le nom d'une fonction est déjà censé répondre à la question de ce que fait
> une portion de code. Pourquoi ne pas utiliser cette possibilité ?

Oui le nommage des fonctions/variables/classes/toussa est très important. À tel
point que je pense que c'est une des premières compétences à acquérir pour un/e
débutant/e.

Bref, jusqu'ici je suis entièrement d'accord. C'est après que ça se gâte.

## Trop de commentaires étouffe le code

Dans cette partie de l'article l'auteur prend le code suivant comme exemple:

```js
/**
 * Get the extension of the file
 * 
 * @param {string} filename - The filename
 * @return {string} the extension of the file  
 */
function getFileExtension(filename) {  
  let pieces = filename.split('.')
  return pieces.pop()
}
```

Dès le début de cette seconde partie,
un truc me gène beaucoup : l'auteur continue d'appeler ça du
«commentaire» alors qu'il s'agit de «documentation». Certain(e)s diront que je
pinaille, mais pour moi il s'agit d'une différence très importante. Voyons ce
qu'en pense le Larousse par exemple:

**Commentaire**: *Exposé par lequel on explique, on interprète, on juge un
texte ; notes et éclaircissements destinés à faciliter l'intelligence d'un
texte.*

**Documentation**: *Ensemble de documents fournis avec un appareil, un jeu, un
programme informatique, etc., et donnant des renseignements sur leur structure,
leur fonctionnement, leur utilisation, etc.*

Un commentaire sert donc à faciliter la compréhension d'un texte (pour nous un
bout de code informatique), alors qu'une documentation explique comment ça
marche. Peu importe si on pense que ces définitions ne s'appliquent pas
parfaitement à notre métier, ce qui compte c'est de comprendre que leurs
objectifs sont différents.

J'ai gardé ce sentiment dérangeant jusqu'au bout de l'article, qui entretient un flou
artistique autour du duo commentaire/documentation.

L'auteur se plaint ensuite que, dans un projet en cours:

> […] la plupart des commentaires écrits sont des commentaires qui n'existent
> que pour passer les tests. Ils sont redondants & inutiles.

En voyant le code donné plus haut en exemple, on peut comprendre sa position.
_Je_ peux aisément comprendre. Mais la plainte ne me semble pas clairement formulée. Qui est
responsable, selon l'auteur ? L'outil ?
Des collègues qui ne jouent pas le jeu ?
Le management qui impose un process trop strict ?
Ça m'intéresserais beaucoup de connaître le sentiment de l'auteur à ce sujet,
car j'ai l'impression que l'article blâme la documentation alors que le
problème est ailleurs.

L'article continue ainsi:

> Dites moi qu'il y a une information dans ce commentaire que vous n'aviez pas
> en lisant le code !

Oui je le dis ;) J'en ai une. Et même deux ! Une première sur les types, ce qui
est toujours bon à prendre avec un langage dynamique. Je vois que ça
fonctionne avec une chaîne de caractère, et pas avec un objet File ou Path ou
autre chose encore qui aurait du sens dans mon langage, dans mon framework, etc.
Et j'ai une
seconde information sur l'importance relative de cette méthode : si elle mérite une telle
documentation c'est sûrement qu'elle est destinée à être utilisée par d'autres
objets appartenant à d'autres classes. Autrement dit elle est publique et son
usage n'est pas réservé à une utilisation interne.

Il faut bien avouer que l'exemple donné est assez déprimant. Comme l'auteur le
souligne il y a une certaine redondance, c'est le moins qu'on puisse dire.
Si je devais écrire ce genre de choses
toute la journée j'aurai vite besoin de vacances. Et je comprends que ça le rende
marteau, et qu'il ne puisse plus voir ce genre particulier de documentation en peinture.

Mais ce qui me dérange ici, c'est que ça à tout l'air d'un exemple factice.
Ce code n'est pas destiné à aller en production. Par exemple, il se passe quoi
si le nom du fichier est `.bashrc`, ou `foobar` ? Bin ça marche pas.
Tirer une conclusion générale d'un exemple factice, c'est pour le moins
hasardeux.

Surtout que même en l'état actuel de la fonction, cette documentation
pourrait être largement améliorée. J'ai pris la liberté de modifier le
style pour un que je trouve plus léger, mais l'important est dans la
reformulation, pas dans le style.  Je me suis inspiré des documentations de
méthodes similaires trouvées dans d'autres langages:

```js
// Get the extension (the portion of filename starting from the last period).
//
// filename - The filename (as a string) to retrieve the extension of.
//
// Returns the extension of the file as a string. Or the filename itself
// if it has no dots. Or the filename without the dot if it starts with 
// a dot and don't have another one.
function getFileExtension(filename) {  
  let pieces = filename.split('.')
  return pieces.pop()
}
```

Bon d'accord, je me suis un peu amusé à la fin. Mais
on voit qu'il y a de quoi dire. Il y a moins de redondance. Et on a bien
plus d'informations, sans avoir besoin d'aller les extraire du code.

L'auteur conclu cette partie en disant qu'on fini par ne plus voir les
commentaires (*je rappelle qu'on parle en fait de documentation*) dans les projets
où il y en a de trop. Mais je ne pense pas que ça soit un problème, bien au
contraire. Je dirais même qu'avec une bonne coloration syntaxique, la documentation est
encore moins *présente*, je peux l'oublier encore plus facilement. **Et c'est très bien ainsi.**
La documentation est très utile, mais seulement de temps en temps. Dans ces
moments là, elle permet de gagner un temps précieux. Le reste du temps, elle doit
savoir se faire oublier. Et si j'en ai envie, mon éditeur de texte, ou mon IDE,
doit même pouvoir la faire disparaitre et réapparaitre à ma guise.

## La couverture par la documentation

L'article évoque ensuite des outils qui calculent le taux de couverture de la documentation.
Et comme quoi la course aux 100% est problématique.

C'est un tout autre débat, qui mériterait au moins un second article en réponse ;)
Mais qu'on soit d'accord ou pas, là, on blâme clairement l'outil plutôt que l'utilisateur.

Plus loin l'auteur poursuit :

> pour la documentation un haut taux de couverture est contre-productif et étouffe le code

???

*Contre productif* ? Permettre aux utilisateurs de votre code, ou à vous même dans
1 an, dans 3 ans, de comprendre le code en un claquement de doigt serait
*contre productif* ? On écrit le code (et sa documentation) **une fois**, et on les
lit **des dizaines de fois**. Et ça serait *contre productif* de faciliter cette
lecture ?

*Étouffe le code* ? L'auteur nous a expliqué dans la partie précédente qu'il ne
les voyait plus, ces commentaires/documentation, qu'ils devenaient invisibles
pour lui. Je ne comprend pas comment ça peut-être à la fois invisible et étouffant.
 Mais dans tout les cas, même si je rate quelque chose et au risque de me répéter :
votre éditeur/IDE doit être capable de masquer la documentation si celle-ci vous
gène, sinon il faut changer d'éditeur.

> Là où le code est propre le commentaire ne sera qu'une redondance sans grand intérêt

J'ai démontré le contraire.

> Là où le code est sale le développeur pourra utiliser le commentaire comme une
> excuse pour laisser le code sale

Mais WHAT ?

D'après ce que j'ai saisi, l'auteur travaille au sein d'une équipe. Et l'équipe
fait des *code reviews*, non ? Si oui, c'est de la responsabilité de *l'équipe*
de ne pas laisser passer de code sale. Ça n'est en rien la faute de la documentation, ou d'un commentaire,
ou d'un outil quelconque.
Si non, et bien comment dire, c'est juste que j'arrive pas à imaginer un endroit où on ne fait
pas de *code review*. Je sais que ça existe, j'ai même du y bosser, mais je ne me
souviens plus comment c'est. Plus sérieusement, si il n'y a pas de *code review* c'est pas
d'écrire ou non de la doc qui va changer grand chose à la *propreté* du code.
Et dans ce cas la responsabilité irait à l'auteur du code, pas à la documentation.

{% connexe %}
