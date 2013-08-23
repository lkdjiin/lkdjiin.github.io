---
layout: post
title: "Modern IE pour Linux: foutage de gueule"
date: 2013-07-20 08:44
comments: true
categories: [opinion, test, linux]
---

**Question:** «Que doit faire régulièrement un développeur du web ?»

**Réponse:** «Tester le rendu de son site sur plusieurs navigateurs.»

Internet Explorer fait partie du lot. Qu'on le veuille ou non, il faut
tester nos sites dans IE, même quand on travaille sur Linux.
Au début de l'année, Microsoft a lancé
[Modern.IE](http://www.modern.ie/fr). L'ancien site tout moche où on
téléchargait les VMs qui ne fonctionnaient que sur Windows à fait place
à un site moderne, new look, qui te
promet (dixit le dit site):

{% blockquote %}
Facilitez vos tests pour Internet Explorer
{% endblockquote %}

<!-- more -->

On te dis qu'on va bien s'occuper de toi. J'ai eu envie d'y croire alors
j'ai essayé. Ce qui m'intéresse ce sont les outils de virtualisation, alors
rendez vous sur la page http://www.modern.ie/fr/virtualization-tools. Voici
ce qu'on peut y lire:

{% blockquote %}
Testez votre site. Dans tout navigateur sur un Mac ou un ordinateur Windows.
{% endblockquote %}

Ça aurait du me mettre la puce à l'oreille mais je continue quand même.
Deux clics plus tard, j'obtiens la liste des VMs pour Linux/VirtualBox.
Premier constat: la taille des VMs, toujours aussi gargantuesque, 
5 ou 6 gigas pour certaines.
Bon, c'est pas ça qui va m'arrêter, mais faut quand même savoir que leur
serveur ne supporte pas le resume…

Quelques heures plus tard, mission accomplie, IE 9 est téléchargé. Je
lance le script d'install qui tente de décompresser la bête.
Mais non. Comment ça, non ? Ben non, fichier corrompu (!?). J'ai un peu la nausée à l'idée de devoir
re-télécharger 5 Go. J'essaye de les décompresser avec
deux trois programmes classiques que j'ai sous la main. Rien à faire.
Corrompu…

Retour sur le site Modern.IE pour trouver ça: «Need more help downloading and installing the VMs?
[Try Rey Bango’s blog](http://blog.reybango.com/2013/02/04/making-internet-explorer-testing-easier-with-new-ie-vms/).»

Ok je fais ça. Qu'est-ce-que j'y apprends:


{% blockquote %}
A number of people have mentioned that they’ve had trouble unzipping the
images and that they may be corrupt. They’re not corrupt. There’s an issue in
both OSX & Linux where using the OS’s default zip tool is failing to open the
.zip file properly. We’re aware of this and are looking into it. The interim
solution is to use a 3rd party unzip tool like “The Unarchiver” in the Apple
app store or Peazip for Linux. These will correctly unzip the .zip files and
give you working images.
{% endblockquote %}

Traduction rapide (et sûrement un peu maladroite) pour les non-anglophones, accrochez vous, ça vaut son
pesant de cacahuètes:

{% blockquote %}
Plusieurs personnes ont rapporté avoir des problèmes à décompresser les images
et que celles-ci pouvaient être corrompues. Elles ne sont pas corrompues. Il y
a un problème dans OSX et Linux, qui empêche d'ouvrir proprement les fichiers
zip avec les outils par défaut de l'OS. On est au courant de ça et on regarde
ce qu'on peut faire. La solution provisoire est d'utiliser un outil de
décompression tiers, comme "The Unarchiver" dans l'app store ou bien Peazip
pour Linux. Ces outils décompresseront correctement les zip et produiront des
images qui fonctionnent.
{% endblockquote %}

Sans rire !? C'est tout ce que Microsoft a à dire la-dessus ? «C'est pas
nous, m'sieur, c'est encore la faute à OSX et Linux tout ça.»
Vous m'imaginez dire ça au boulot:

  **Client:** Il y a un problème avec le site, il fonctionne correctement dans
IE mais des utilisateurs nous ont rapporté qu'il s'affichait mal avec
Chrome et Firefox.

  **Moi:** Non, il ne s'affiche pas mal, il y a juste un problème avec Firefox et Chrome
qui empêche mon site de s'afficher correctement. En attendant que je corrige
ça, vos utilisateurs peuvent toujours regarder le site avec IE.

Le post date de février, c'est toujours pas corrigé. La suite de l'histoire
maintenant: Je n'ai jamais entendu
parler de ce *Peazip*, je cherche un peu et fini par l'installer. Après 10
minutes d'essais infructeux, pendant lesquelles j'ai du essuyer à peu près
40 bugs (sans rire), je le désinstalle et j'abandonne.
J'ai perdu
mon temps mais c'est de ma faute, qu'est ce qui m'a pris de croire
que Microsoft s'interessait aux utilisateurs de Linux ?

Pour ceux et celles qui se demande quelle est la solution, c'est la même que depuis
des années: [ievms](https://github.com/xdissent/ievms) le script qui fonctionne.

À demain.

*P.S. Ça fait des mois que je pense à écrire cet article. Ça fait du bien
quand ça sort.*

{% connexe %}
