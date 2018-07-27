---
layout: post
title: "Gopher : Récupérer le menu principal"
date: 2018-07-27 10:27
comments: true
categories: [ gopher, protocole, internet, ruby, d ]
---

Pour aller plus loin dans la compréhension du protocole Gopher nous pouvons écrire un
petit client texte, sans prétention.

Mais avant toutes choses, il faut pouvoir se connecter à un serveur, lui envoyer un
sélecteur, et récupérer les informations que va envoyer le serveur.
Il nous faut un langage qui
permet de créer et d'utiliser des sockets facilement. Beaucoup de langages
répondront à cette contrainte, donc en gros, choisissez celui avec lequel vous êtes le
plus à l'aise.

<!-- more -->

Voir l'article précédent : [Présentation de Gopher](/blog/2018/07/21/presentation-de-gopher/)

## Ruby

Voyons comment faire en Ruby.

D'abord on crée la connexion (1). Rappelez-vous,
le protocole Gopher prévoit que le serveur n'envoie rien du tout après une
connexion réussie.

Ensuite (2) nous envoyons un sélecteur vide au serveur.
Ce qui correspond en quelque sorte à demander le menu principal. Le
protocole Gopher explique qu'un sélecteur doit être terminé avec les caractères
de retour à la ligne CR suivi de LF. Ce qu'on écrira `"\r\n"` dans beaucoup de
langages.

Puis (3) nous consommons et affichons chaque ligne de la réponse du
serveur. Le protocole Gopher nous dit que le serveur termine lui aussi ses
lignes par CR + LF. Ruby gère cette situation, avec `gets`, en supprimant les
fin de ligne, c'est pourquoi nous devons utiliser `puts` ensuite pour afficher
`line` avec un retour à la ligne.

```ruby
# Fichier gopher.rb
require 'socket'

# 1
socket = TCPSocket.new 'gopher.quux.org', 70

# 2
socket.write "\r\n"

# 3
while line = socket.gets
  puts line
end

socket.close
```

Lancez le programme avec `ruby gopher.rb`.

## D

On pourra préférer un langage qui produira un binaire pour distribuer le programme plus
facilement. *(Ici les performances ne rentrent pas en ligne de compte.)* J'ai un
faible pour le langage D en ce moment, alors voici le même programme en D.
Vous le compilerez avec `dmd gopher.d` et le lancerez avec `./gopher`.

Ce programme D suit exactement le même principe que le programme Ruby. On
crée une connexion (1) ; on envoie un sélecteur vide (2) ; et on affiche la
réponse (3).

Pour ce qui est de la lecture, D est plus *low-level* que Ruby, et
on doit lire par tranche de X caractères, et non pas par lignes. Ici on lit
la réponse par tranches de 1024 caractères et les retours à la ligne ne sont
pas supprimés comme en Ruby, d'où l'utilisation de `write` et non pas `writeln`.

```d
// Fichier gopher.d
import std.stdio;
import std.socket;

void main()
{
    // 1
    auto socket = new TcpSocket(new InternetAddress("gopher.quux.org", 70));

    // 2
    socket.send("\r\n");

    char[1024] buffer;
    ptrdiff_t amountRead;

    // 3
    while((amountRead = socket.receive(buffer)) != 0) {
        write(buffer[0 .. amountRead]);
    }

    socket.close;
}
```

## Un point sur le point

Comme beaucoup de protocoles de la même époque et avant lui, Gopher indique
qu'une réponse du serveur doit se terminer par un point (le caractère `.`)
isolé sur une ligne. Dans les faits, très peu de serveurs se complique la
vie avec ça.

N'hésitez pas à poster dans un commentaire ce petit programme traduit dans votre
langage favori. À bientôt.
